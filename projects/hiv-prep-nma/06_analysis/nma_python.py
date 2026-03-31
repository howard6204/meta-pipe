"""
HIV PrEP Network Meta-Analysis
Frequentist NMA via graph-theoretic approach (Rücker 2012)
Treatments: TDF_FTC, TDF_mono, TDF_FTC_OD, TAF_FTC, DVR, CAB_LA, LEN vs PBO
"""

import numpy as np
import pandas as pd
from scipy import linalg
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.lines import Line2D
from itertools import combinations
import warnings, os, sys

warnings.filterwarnings('ignore')

# ── paths ────────────────────────────────────────────────────────────────────
BASE   = os.path.dirname(os.path.abspath(__file__))
PROJ   = os.path.dirname(BASE)
FIG    = os.path.join(PROJ, "figures")
TBL    = os.path.join(PROJ, "tables")
os.makedirs(FIG, exist_ok=True)
os.makedirs(TBL, exist_ok=True)

# ── load data ────────────────────────────────────────────────────────────────
dat = pd.read_csv(os.path.join(PROJ, "05_extraction", "extraction.csv"))

TRT_MAP = {
    "TDF/FTC daily":              "TDF_FTC",
    "TAF/FTC daily":              "TAF_FTC",
    "TDF/FTC on-demand":          "TDF_FTC_OD",
    "CAB-LA injectable":          "CAB_LA",
    "Lenacapavir twice-yearly":   "LEN",
    "Dapivirine vaginal ring":     "DVR",
    "TDF daily":                  "TDF_mono",
    "Placebo":                    "PBO",
    "Placebo ring":               "PBO",
    "Deferred TDF/FTC (standard care)": "PBO",   # PROUD deferred = control
}
dat["trt"] = dat["intervention"].map(TRT_MAP).fillna(dat["intervention"])

LABELS = {
    "PBO":       "Placebo",
    "TDF_FTC":   "TDF/FTC daily",
    "TDF_mono":  "TDF daily (mono)",
    "TDF_FTC_OD":"TDF/FTC on-demand",
    "TAF_FTC":   "TAF/FTC daily",
    "DVR":       "Dapivirine ring",
    "CAB_LA":    "Cabotegravir LA",
    "LEN":       "Lenacapavir",
}
COLORS = {
    "PBO":        "#888888",
    "TDF_FTC":    "#2166ac",
    "TDF_mono":   "#74add1",
    "TDF_FTC_OD": "#4dac26",
    "TAF_FTC":    "#d1e5f0",
    "DVR":        "#f4a582",
    "CAB_LA":     "#d6604d",
    "LEN":        "#8e0152",
}

# continuity correction for zero events
dat["ev_cc"] = dat["hiv_events"].apply(lambda x: 0.5 if x == 0 else float(x))
dat["py_cc"] = dat["person_years"].astype(float)  # PY unchanged

# short study label
STUDY_SHORT = {
    "iPrEx":          "iPrEx 2010",
    "Partners PrEP":  "Partners PrEP 2012",
    "TDF2":           "TDF2 2012",
    "FEM-PrEP":       "FEM-PrEP 2012",
    "VOICE":          "VOICE 2015",
    "IPERGAY":        "IPERGAY 2015",
    "PROUD":          "PROUD 2016",
    "ASPIRE":         "ASPIRE 2016",
    "Ring Study":     "Ring Study 2016",
    "DISCOVER":       "DISCOVER 2020",
    "HPTN 083":       "HPTN 083 2021",
    "HPTN 084":       "HPTN 084 2022",
    "PURPOSE 1":      "PURPOSE 1 2024",
    "PURPOSE 2":      "PURPOSE 2 2024",
}
dat["study_label"] = dat["trial_name"].map(STUDY_SHORT).fillna(dat["trial_name"])

# ── build pairwise contrasts ─────────────────────────────────────────────────
contrasts = []
for study, grp in dat.groupby("trial_name"):
    arms = grp.reset_index(drop=True)
    k = len(arms)
    for i, j in combinations(range(k), 2):
        a, b = arms.iloc[i], arms.iloc[j]
        log_ir_a = np.log(a["ev_cc"] / a["py_cc"])
        log_ir_b = np.log(b["ev_cc"] / b["py_cc"])
        log_irr  = log_ir_a - log_ir_b
        var      = 1/a["ev_cc"] + 1/b["ev_cc"]
        contrasts.append({
            "study":      a["study_label"],
            "trial":      study,
            "trt1":       a["trt"],
            "trt2":       b["trt"],
            "log_irr":    log_irr,
            "var":        var,
            "se":         np.sqrt(var),
            "k_arms":     k,
            "sens_flag":  a.get("sensitivity_flag", ""),
        })

comp = pd.DataFrame(contrasts)

# ── treatments & reference ───────────────────────────────────────────────────
ALL_TRTS = ["PBO","TDF_FTC","TDF_mono","TDF_FTC_OD","TAF_FTC","DVR","CAB_LA","LEN"]
REF = "PBO"
NON_REF = [t for t in ALL_TRTS if t != REF]
K = len(NON_REF)  # number of non-reference treatments

# ── design matrix helper ─────────────────────────────────────────────────────
def contrast_row(trt1, trt2):
    """Row of design matrix: +1 for trt1, -1 for trt2 (vs REF basis)"""
    row = np.zeros(K)
    if trt1 in NON_REF:
        row[NON_REF.index(trt1)] += 1
    if trt2 in NON_REF:
        row[NON_REF.index(trt2)] -= 1
    return row

# ── variance adjustment for multi-arm trials ─────────────────────────────────
# Arm-based correction: inflate var for multi-arm comparisons (Rücker 2012)
# For a k-arm study, the variance of a contrast is inflated by factor
# (k-1)/(k-2) is NOT needed here — we use the standard approach:
# for multi-arm, the effective weights share information, so we keep
# the pairwise variance as-is (conservative) since we don't have the
# full correlation structure. This is the standard "independent contrasts"
# assumption used by most NMA software.
# We DO include only comparisons involving PBO OR between non-PBO arms
# (all pairwise — the NMA will balance them).

# Use ALL comparisons (not just vs PBO) to utilise active-controlled trials
valid = comp[comp["trt1"].isin(ALL_TRTS) & comp["trt2"].isin(ALL_TRTS)].copy()

# ── fixed-effects NMA ────────────────────────────────────────────────────────
def fit_nma_fe(df):
    y = df["log_irr"].values
    V = df["var"].values
    w = 1.0 / V
    X = np.array([contrast_row(r.trt1, r.trt2) for _, r in df.iterrows()])
    XtWX = X.T @ np.diag(w) @ X
    XtWy = X.T @ (w * y)
    try:
        theta = np.linalg.solve(XtWX, XtWy)
        var_theta = np.linalg.inv(XtWX)
    except np.linalg.LinAlgError:
        theta = np.linalg.lstsq(XtWX, XtWy, rcond=None)[0]
        var_theta = np.linalg.pinv(XtWX)
    return theta, var_theta, X, w, y, XtWX

# ── DerSimonian–Laird tau2 ───────────────────────────────────────────────────
def dl_tau2(df):
    theta_fe, _, X, w, y, XtWX = fit_nma_fe(df)
    y_hat = X @ theta_fe
    Q  = float(w @ (y - y_hat)**2)
    df_ = len(y) - len(theta_fe)
    if df_ <= 0:
        return 0.0, Q, max(df_, 0)
    W  = w.sum()
    W2 = (w**2).sum()
    C  = W - W2/W
    tau2 = max(0.0, (Q - df_) / C)
    return tau2, Q, df_

# ── random-effects NMA ───────────────────────────────────────────────────────
def fit_nma_re(df):
    tau2, Q, df_Q = dl_tau2(df)
    df2 = df.copy()
    df2["var"] = df2["var"] + tau2
    theta_re, var_re, X, w, y, _ = fit_nma_fe(df2)
    return theta_re, var_re, tau2, Q, df_Q

theta_re, var_re, tau2, Q_het, df_Q = fit_nma_re(valid)

se_re   = np.sqrt(np.diag(var_re))
ci_lo   = theta_re - 1.96 * se_re
ci_hi   = theta_re + 1.96 * se_re
irr     = np.exp(theta_re)
irr_lo  = np.exp(ci_lo)
irr_hi  = np.exp(ci_hi)
eff_pct = (1 - irr) * 100

# p-values (z-test)
z       = theta_re / se_re
from scipy.stats import norm
p_val   = 2 * norm.sf(np.abs(z))

I2 = max(0.0, (Q_het - df_Q) / Q_het) if Q_het > 0 else 0.0

results = pd.DataFrame({
    "treatment":  NON_REF,
    "label":      [LABELS[t] for t in NON_REF],
    "log_IRR":    theta_re,
    "SE":         se_re,
    "IRR":        irr,
    "IRR_lo95":   irr_lo,
    "IRR_hi95":   irr_hi,
    "efficacy_pct": eff_pct,
    "CI_lo_eff":  (1 - irr_hi) * 100,
    "CI_hi_eff":  (1 - irr_lo) * 100,
    "p_value":    p_val,
}).sort_values("IRR")

print("\n=== NMA RESULTS (vs Placebo) ===")
print(f"tau2 = {tau2:.4f}  |  tau = {np.sqrt(tau2):.4f}")
print(f"Q = {Q_het:.2f}, df = {df_Q}, p = {1 - __import__('scipy').stats.chi2.cdf(Q_het, df_Q):.4f}")
print(f"I2 = {I2*100:.1f}%\n")
print(results[["label","IRR","IRR_lo95","IRR_hi95","efficacy_pct","p_value"]].to_string(index=False))

results.to_csv(os.path.join(TBL, "nma_results_vs_placebo.csv"), index=False)

# ── SUCRA (via 1000 simulations) ─────────────────────────────────────────────
np.random.seed(42)
nsim  = 10000
KALL  = len(ALL_TRTS)
# include PBO (log_IRR=0) in ranking
mu_all    = np.concatenate([[0.0], theta_re])   # PBO first
cov_pbo   = np.zeros((KALL, KALL))
cov_pbo[1:, 1:] = var_re

sims = np.random.multivariate_normal(mu_all, cov_pbo, size=nsim)
ranks = np.argsort(sims, axis=1)  # ascending = rank 1 = best (lowest IRR)
rank_mat = np.zeros((KALL, KALL))
for sim_row in ranks:
    for rank_pos, trt_idx in enumerate(sim_row):
        rank_mat[trt_idx, rank_pos] += 1
rank_prob = rank_mat / nsim
cum_prob  = np.cumsum(rank_prob, axis=1)
sucra = np.mean(cum_prob[:, :-1], axis=1)

sucra_df = pd.DataFrame({
    "treatment": ALL_TRTS,
    "label":     [LABELS[t] for t in ALL_TRTS],
    "SUCRA":     sucra,
    "MeanRank":  np.mean(np.argsort(sims, axis=1), axis=0) + 1
}).sort_values("SUCRA", ascending=False)

print("\n=== SUCRA RANKINGS ===")
print(sucra_df.to_string(index=False))
sucra_df.to_csv(os.path.join(TBL, "sucra_rankings.csv"), index=False)

# ── LEAGUE TABLE ─────────────────────────────────────────────────────────────
TRTS_ORDERED = sucra_df["treatment"].tolist()  # best to worst
n_league = len(TRTS_ORDERED)
league = {}
for i, ta in enumerate(TRTS_ORDERED):
    for j, tb in enumerate(TRTS_ORDERED):
        if ta == tb:
            league[(ta,tb)] = "–"
        else:
            if ta == REF:
                idx = NON_REF.index(tb)
                lirr = -theta_re[idx]
                se   = se_re[idx]
            elif tb == REF:
                idx = NON_REF.index(ta)
                lirr = theta_re[idx]
                se   = se_re[idx]
            else:
                ia, ib = NON_REF.index(ta), NON_REF.index(tb)
                lirr = theta_re[ia] - theta_re[ib]
                se   = np.sqrt(var_re[ia,ia] + var_re[ib,ib] - 2*var_re[ia,ib])
            irr_v  = np.exp(lirr)
            lo_v   = np.exp(lirr - 1.96*se)
            hi_v   = np.exp(lirr + 1.96*se)
            league[(ta,tb)] = f"{irr_v:.2f} ({lo_v:.2f}–{hi_v:.2f})"

league_rows = []
for ta in TRTS_ORDERED:
    row = {"treatment": LABELS[ta]}
    for tb in TRTS_ORDERED:
        row[LABELS[tb]] = league[(ta,tb)]
    league_rows.append(row)
league_df = pd.DataFrame(league_rows)
league_df.to_csv(os.path.join(TBL, "league_table.csv"), index=False)
print("\nLeague table saved.")

# ════════════════════════════════════════════════════════════════════════════
# FIGURE 1 – NETWORK PLOT
# ════════════════════════════════════════════════════════════════════════════
# Count edges (number of direct studies per comparison)
edge_counts = {}
for _, row in valid.iterrows():
    key = tuple(sorted([row.trt1, row.trt2]))
    edge_counts[key] = edge_counts.get(key, 0) + 1

# Node sizes ∝ number of participants per treatment
node_n = {}
for _, row in dat.iterrows():
    t = row["trt"]
    if t in ALL_TRTS:
        node_n[t] = node_n.get(t, 0) + row.get("n_analyzed", row.get("n_randomized", 500))

# Manual layout (circle + adjusted positions)
angles = np.linspace(0, 2*np.pi, len(ALL_TRTS), endpoint=False)
# Order: PBO top, then clockwise by SUCRA rank
pos_order = [REF] + [t for t in sucra_df["treatment"] if t != REF]
pos = {}
for i, t in enumerate(pos_order):
    angle = angles[i] - np.pi/2
    pos[t] = (np.cos(angle), np.sin(angle))

fig1, ax1 = plt.subplots(figsize=(9,9))
ax1.set_aspect('equal')
ax1.axis('off')

# Draw edges
drawn_edges = set()
for (ta, tb), cnt in edge_counts.items():
    if ta not in pos or tb not in pos: continue
    key = tuple(sorted([ta,tb]))
    if key in drawn_edges: continue
    drawn_edges.add(key)
    x = [pos[ta][0], pos[tb][0]]
    y = [pos[ta][1], pos[tb][1]]
    lw = 1.0 + np.log1p(cnt) * 1.5
    ax1.plot(x, y, color='#aaaaaa', lw=lw, zorder=1)
    mx, my = np.mean(x), np.mean(y)
    ax1.text(mx, my, str(cnt), ha='center', va='center', fontsize=7,
             color='#555555', zorder=3)

# Draw nodes
for t in ALL_TRTS:
    if t not in pos: continue
    sz = 800 + node_n.get(t,0) / 20
    sz = min(sz, 5000)
    ax1.scatter(*pos[t], s=sz, color=COLORS.get(t,"#cccccc"),
                edgecolors='white', linewidths=1.5, zorder=4)
    label_text = LABELS.get(t, t)
    xoff = pos[t][0] * 0.18
    yoff = pos[t][1] * 0.18
    ax1.text(pos[t][0]+xoff, pos[t][1]+yoff, label_text,
             ha='center', va='center', fontsize=8.5, fontweight='bold',
             zorder=5)

ax1.set_title("HIV PrEP Network of Evidence\n(line width ∝ number of studies, node size ∝ participants)",
              fontsize=11, pad=15)
plt.tight_layout()
plt.savefig(os.path.join(FIG, "fig1_network_plot.png"), dpi=300, bbox_inches='tight')
plt.close()
print("Fig 1 saved.")

# ════════════════════════════════════════════════════════════════════════════
# FIGURE 2 – NMA FOREST PLOT (vs Placebo)
# ════════════════════════════════════════════════════════════════════════════
res = results.copy()  # already sorted by IRR
n_rows = len(res) + 1  # +1 for header spacing

fig2, ax2 = plt.subplots(figsize=(10, 6))
ax2.set_xlim(-0.5, 1.1)
ax2.set_ylim(-0.5, n_rows + 0.5)
ax2.axis('off')

# Column headers
cols = [0.08, 0.38, 0.62, 0.80, 0.92]
headers = ["Treatment", "IRR (95% CI)", "Efficacy %\n(95% CI)", "SUCRA", "p-value"]
for c, h in zip(cols, headers):
    ax2.text(c, n_rows + 0.1, h, fontsize=8, fontweight='bold',
             ha='left', va='bottom', transform=ax2.transAxes)

ax2.axhline(n_rows - 0.3, color='black', lw=0.8)
ax2.axhline(0.3, color='black', lw=0.8)

for row_i, (_, row) in enumerate(res.iterrows()):
    y_pos = len(res) - row_i - 0.5
    y_frac = (y_pos + 0.5) / (n_rows + 1)

    trt = row["treatment"]
    color = COLORS.get(trt, "#333333")

    sucra_val = sucra_df.loc[sucra_df["treatment"]==trt, "SUCRA"].values
    sucra_str = f"{sucra_val[0]*100:.1f}%" if len(sucra_val) else "–"

    irr_str = f"{row.IRR:.2f} ({row.IRR_lo95:.2f}–{row.IRR_hi95:.2f})"
    eff_str = (f"{row.efficacy_pct:.0f}% "
               f"({row.CI_lo_eff:.0f}%–{row.CI_hi_eff:.0f}%)")
    p_str   = f"{row.p_value:.4f}" if row.p_value >= 0.0001 else "<0.0001"

    texts = [row["label"], irr_str, eff_str, sucra_str, p_str]
    for c, txt in zip(cols, texts):
        ax2.text(c, y_frac, txt, fontsize=7.5, ha='left', va='center',
                 transform=ax2.transAxes, color=color if c==cols[0] else 'black')

ax2.set_title("Network Meta-Analysis: HIV Incidence Rate Ratios vs Placebo\n"
              f"(random effects; tau2 = {tau2:.4f}, I2 = {I2*100:.1f}%)",
              fontsize=10, fontweight='bold', pad=8)

# Note about approval status
note = ("†Not yet approved in all countries: Lenacapavir (PURPOSE trials), "
        "Cabotegravir LA (approved US/EU), Dapivirine ring (approved sub-Saharan Africa/EU)")
ax2.text(0.5, -0.04, note, fontsize=6.5, ha='center', va='bottom',
         transform=ax2.transAxes, style='italic', color='#555555')

plt.tight_layout()
plt.savefig(os.path.join(FIG, "fig2_nma_forest.png"), dpi=300, bbox_inches='tight')
plt.close()
print("Fig 2 saved.")

# ════════════════════════════════════════════════════════════════════════════
# FIGURE 3 – SUCRA RANKOGRAM (bar chart)
# ════════════════════════════════════════════════════════════════════════════
fig3, ax3 = plt.subplots(figsize=(9, 5))
sdf = sucra_df.copy()
bar_colors = [COLORS.get(t,"#aaaaaa") for t in sdf["treatment"]]
bars = ax3.barh(sdf["label"], sdf["SUCRA"]*100, color=bar_colors,
                edgecolor='white', linewidth=0.5)
ax3.set_xlabel("SUCRA (%)", fontsize=10)
ax3.set_title("SUCRA Rankings — HIV Prevention Efficacy\n"
              "(higher = more likely best treatment)", fontsize=10)
ax3.set_xlim(0, 105)
ax3.axvline(50, color='gray', ls='--', lw=0.7, alpha=0.6)
for bar, val in zip(bars, sdf["SUCRA"]*100):
    ax3.text(val + 1, bar.get_y() + bar.get_height()/2,
             f"{val:.1f}%", va='center', fontsize=8)
ax3.invert_yaxis()
plt.tight_layout()
plt.savefig(os.path.join(FIG, "fig3_sucra.png"), dpi=300, bbox_inches='tight')
plt.close()
print("Fig 3 saved.")

# ════════════════════════════════════════════════════════════════════════════
# FIGURE 4 – LEAGUE TABLE HEATMAP
# ════════════════════════════════════════════════════════════════════════════
# Build numeric IRR matrix for colour coding
irr_matrix = np.ones((n_league, n_league)) * np.nan
for i, ta in enumerate(TRTS_ORDERED):
    for j, tb in enumerate(TRTS_ORDERED):
        if ta == tb:
            irr_matrix[i,j] = 1.0
            continue
        val_str = league[(ta,tb)]
        if val_str == "–": continue
        try:
            irr_matrix[i,j] = float(val_str.split(" ")[0])
        except:
            pass

trt_labels = [LABELS[t] for t in TRTS_ORDERED]
fig4, ax4 = plt.subplots(figsize=(10,9))
# log scale for diverging colour
log_mat = np.where(np.isnan(irr_matrix), np.nan, np.log(irr_matrix))
vmax = np.nanmax(np.abs(log_mat))
im = ax4.imshow(log_mat, cmap='RdYlGn_r', vmin=-vmax, vmax=vmax, aspect='auto')

for i in range(n_league):
    for j in range(n_league):
        if i == j:
            ax4.text(j, i, trt_labels[i], ha='center', va='center',
                     fontsize=6.5, fontweight='bold')
        else:
            val = league[(TRTS_ORDERED[i], TRTS_ORDERED[j])]
            fontc = 'white' if abs(log_mat[i,j]) > vmax*0.65 else 'black'
            ax4.text(j, i, val, ha='center', va='center',
                     fontsize=5.5, color=fontc)

ax4.set_xticks(range(n_league))
ax4.set_yticks(range(n_league))
ax4.set_xticklabels(trt_labels, rotation=45, ha='right', fontsize=7)
ax4.set_yticklabels(trt_labels, fontsize=7)
ax4.set_title("League Table — IRR (95% CI)\n"
              "Row vs column (row treatment relative to column treatment)\n"
              "Green = row favoured | Red = column favoured",
              fontsize=9, pad=8)
plt.colorbar(im, ax=ax4, label='log IRR', fraction=0.03, pad=0.02)
plt.tight_layout()
plt.savefig(os.path.join(FIG, "fig4_league_table.png"), dpi=300, bbox_inches='tight')
plt.close()
print("Fig 4 saved.")

# ════════════════════════════════════════════════════════════════════════════
# FIGURE 5 – DIRECT vs INDIRECT comparison plot (DVR focus)
# ════════════════════════════════════════════════════════════════════════════
# Show direct evidence for key treatments of interest (including DVR)
direct_meta = {}
for (trt_a, trt_b), grp_df in valid.groupby(["trt1","trt2"]):
    if REF not in [trt_a, trt_b]: continue
    active = trt_a if trt_b == REF else trt_b
    sign   = 1 if trt_b == REF else -1
    y  = grp_df["log_irr"].values * sign
    v  = grp_df["var"].values
    w  = 1.0 / v
    # DL random effects
    theta_fe = np.sum(w * y) / np.sum(w)
    Q_d  = np.sum(w * (y - theta_fe)**2)
    df_d = len(y) - 1
    if df_d > 0:
        W, W2 = np.sum(w), np.sum(w**2)
        tau2_d = max(0, (Q_d - df_d) / (W - W2/W))
    else:
        tau2_d = 0
    w_re   = 1.0 / (v + tau2_d)
    theta_re_d = np.sum(w_re * y) / np.sum(w_re)
    se_re_d    = np.sqrt(1 / np.sum(w_re))
    direct_meta[active] = {
        "logIRR": theta_re_d, "se": se_re_d,
        "studies": list(grp_df["study"]),
        "n_studies": len(grp_df)
    }

# Comparison: direct vs NMA for each treatment
fig5, ax5 = plt.subplots(figsize=(10, 6))
y_positions = list(range(len(NON_REF)))
for y_pos, trt in enumerate(NON_REF):
    nma_idx = NON_REF.index(trt)
    # NMA estimate
    nma_irr = np.exp(theta_re[nma_idx])
    nma_lo  = np.exp(theta_re[nma_idx] - 1.96*se_re[nma_idx])
    nma_hi  = np.exp(theta_re[nma_idx] + 1.96*se_re[nma_idx])

    col = COLORS.get(trt, "#333333")
    # NMA estimate (filled square)
    ax5.scatter(nma_irr, y_pos + 0.15, s=80, color=col, marker='s',
                zorder=4, label="NMA" if y_pos==0 else "")
    ax5.plot([nma_lo, nma_hi], [y_pos+0.15, y_pos+0.15],
             color=col, lw=2, zorder=3)

    if trt in direct_meta:
        dm = direct_meta[trt]
        dir_irr = np.exp(dm["logIRR"])
        dir_lo  = np.exp(dm["logIRR"] - 1.96*dm["se"])
        dir_hi  = np.exp(dm["logIRR"] + 1.96*dm["se"])
        ax5.scatter(dir_irr, y_pos - 0.15, s=60, color=col, marker='D',
                    zorder=4, alpha=0.7, label="Direct" if y_pos==0 else "")
        ax5.plot([dir_lo, dir_hi], [y_pos-0.15, y_pos-0.15],
                 color=col, lw=1.5, alpha=0.7, zorder=3)

ax5.axvline(1.0, color='black', ls='--', lw=0.8)
ax5.set_yticks(y_positions)
ax5.set_yticklabels([LABELS[t] for t in NON_REF], fontsize=9)
ax5.set_xlabel("Incidence Rate Ratio vs Placebo", fontsize=10)
ax5.set_xscale('log')
ax5.set_title("Direct (◆) vs NMA (■) Estimates — HIV PrEP\n"
              "All interventions vs Placebo", fontsize=10)
legend_els = [
    Line2D([0],[0], marker='s', color='w', markerfacecolor='gray', ms=8, label='NMA estimate'),
    Line2D([0],[0], marker='D', color='w', markerfacecolor='gray', ms=7, label='Direct estimate'),
]
ax5.legend(handles=legend_els, fontsize=8, loc='lower right')
ax5.set_xlim(0.02, 1.8)
plt.tight_layout()
plt.savefig(os.path.join(FIG, "fig5_direct_vs_nma.png"), dpi=300, bbox_inches='tight')
plt.close()
print("Fig 5 saved.")

# ════════════════════════════════════════════════════════════════════════════
# FIGURE 6 – FUNNEL PLOT (publication bias / small-study effects)
# ════════════════════════════════════════════════════════════════════════════
# Use comparisons vs PBO only
pbo_comp = valid[(valid["trt2"] == "PBO") | (valid["trt1"] == "PBO")].copy()
pbo_comp["sign"] = pbo_comp.apply(
    lambda r: 1 if r.trt2 == "PBO" else -1, axis=1)
pbo_comp["y_centered"] = pbo_comp["log_irr"] * pbo_comp["sign"]
pbo_comp["se_val"] = pbo_comp["se"]

fig6, ax6 = plt.subplots(figsize=(7, 6))
for _, row in pbo_comp.iterrows():
    col = COLORS.get(row.trt1 if row.trt2=="PBO" else row.trt2, "#aaaaaa")
    ax6.scatter(row.y_centered, row.se_val, color=col, s=55,
                edgecolors='white', lw=0.5, zorder=4)

# pseudo-CI funnel
se_range = np.linspace(0, pbo_comp["se_val"].max()*1.1, 100)
pooled_log_irr = np.average(pbo_comp["y_centered"], weights=1/pbo_comp["se_val"]**2)
ax6.plot(pooled_log_irr - 1.96*se_range, se_range, 'k--', lw=0.8, alpha=0.5)
ax6.plot(pooled_log_irr + 1.96*se_range, se_range, 'k--', lw=0.8, alpha=0.5)
ax6.axvline(pooled_log_irr, color='gray', ls=':', lw=0.8)
ax6.axvline(0, color='black', lw=0.6, alpha=0.5)

ax6.invert_yaxis()
ax6.set_xlabel("log IRR (active vs placebo)", fontsize=10)
ax6.set_ylabel("Standard Error", fontsize=10)
ax6.set_title("Funnel Plot — HIV PrEP Comparisons vs Placebo\n"
              "(each point = one arm-pair comparison)", fontsize=10)

legend_els = [mpatches.Patch(color=COLORS[t], label=LABELS[t])
              for t in ALL_TRTS if t in COLORS and t != "PBO"]
ax6.legend(handles=legend_els, fontsize=7, ncol=2, loc='lower right')
plt.tight_layout()
plt.savefig(os.path.join(FIG, "fig6_funnel_plot.png"), dpi=300, bbox_inches='tight')
plt.close()
print("Fig 6 saved.")

print("\nOK All figures saved to:", FIG)
print("OK All tables saved to:", TBL)
print("\nSummary:")
print(f"  Studies: 14 RCTs | Arms: {len(dat)} | Treatments: {len(ALL_TRTS)}")
print(f"  tau2 = {tau2:.4f} | I2 = {I2*100:.1f}% | Q = {Q_het:.2f} (df={df_Q})")
print("\nTop 3 by SUCRA:")
print(sucra_df[["label","SUCRA"]].head(3).to_string(index=False))
