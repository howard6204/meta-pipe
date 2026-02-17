# NMA for Oncology Time-to-Event Outcomes

**Time**: 15 minutes
**Purpose**: Handle survival endpoints (OS, PFS) in NMA when proportional hazards may not hold

---

## When This Guide Applies

- Your NMA compares oncology treatments using **time-to-event** outcomes (OS, PFS, DFS)
- Hazard ratios (HR) are the primary effect measure
- The **proportional hazards (PH) assumption may be violated** (common with immunotherapy)

---

## The PH Problem in Oncology NMA

Standard NMA assumes a constant treatment effect over time (proportional hazards). This is frequently violated in oncology, especially with:

- **Immune checkpoint inhibitors** — delayed separation of KM curves
- **Targeted therapies** — early benefit that wanes over time
- **Combination regimens** — crossing survival curves

If PH is violated, HR-based NMA may produce biased estimates.

---

## Recommended Approach (2025-2026)

### Step 1: Test PH Assumption

For each included study, assess PH:

```r
# Schoenfeld residuals test (if IPD available)
cox_model <- coxph(Surv(time, event) ~ treatment, data = study_data)
cox.zph(cox_model)

# Visual: log-log plot
plot(survfit(Surv(time, event) ~ treatment, data = study_data),
     fun = "cloglog")

# If only published KM curves available:
# Check if HR changes over time (early vs late)
# Look for crossing or converging KM curves
```

### Step 2: Choose Method Based on PH Assessment

| PH Status | Method | Package |
|-----------|--------|---------|
| PH holds (most comparisons) | Standard NMA with log-HR | gemtc / netmeta |
| PH violated (some comparisons) | Report limitations + sensitivity | gemtc + RMST |
| PH violated (systematic) | M-spline time-varying NMA | multinma (Stan) |

---

## IPD Reconstruction from KM Curves (Guyot Algorithm)

When individual patient data (IPD) is not available from trial publications, reconstruct pseudo-IPD from published KM curves:

### Using the Guyot Algorithm

```r
# Install IPDfromKM package
install.packages("IPDfromKM")
library(IPDfromKM)

# Step 1: Digitize KM curves using WebPlotDigitizer or DigitizeIt
# Export time-survival coordinate pairs

# Step 2: Reconstruct IPD
ipd <- getIPD(
  time = digitized_time,         # From digitized KM curve
  survival = digitized_surv,     # From digitized KM curve
  nrisk = at_risk_table,         # Number at risk (from paper)
  nrisk.time = at_risk_times,    # Timepoints for at-risk numbers
  tot.events = total_events,     # Total events (from paper)
  arm.id = "Treatment A"
)

# Step 3: Validate reconstruction
# Compare reconstructed KM with published KM
# Compare reconstructed HR with reported HR
```

### Key References

- Guyot P, et al. Enhanced secondary analysis of survival data: reconstructing the data from published Kaplan-Meier survival curves. *BMC Med Res Methodol.* 2012;12:9.
- Wei Y, Royston P. Reconstructing time-to-event data from published Kaplan-Meier curves. *Stata J.* 2017;17(4):786-802.

---

## multinma: Time-Varying NMA Without PH

The `multinma` package (Phillippo et al., 2025) supports M-spline models that do not assume proportional hazards:

```r
library(multinma)

# Prepare survival data (reconstructed IPD or original IPD)
surv_data <- combine_network(
  data_list,
  outcomes = "survival",
  treatments = treatment_labels
)

# Fit M-spline NMA (no PH assumption)
fit <- nma(
  surv_data,
  likelihood = "mspline",
  prior_intercept = normal(0, 10),
  prior_trt = normal(0, 10),
  prior_aux = half_normal(1)
)

# Compare with standard PH model
fit_ph <- nma(
  surv_data,
  likelihood = "cox",   # Standard PH
  prior_trt = normal(0, 10)
)

# Model comparison
loo_compare(loo(fit), loo(fit_ph))
```

### When to Use multinma

- Systematic PH violations across the network
- IPD available (or reconstructed via Guyot)
- Reviewers specifically request non-PH analysis
- HTA submission requiring flexible survival extrapolation

### When NOT to Use multinma

- PH holds across most comparisons (standard HR-based NMA is fine)
- No IPD or KM curves available for reconstruction
- Simple network with few treatments

---

## RMST as Supplementary Measure

Restricted Mean Survival Time (RMST) is a PH-free alternative measure:

```r
library(survRM2)

# RMST difference (does not require PH)
rmst_result <- rmst2(
  time = study_data$time,
  status = study_data$event,
  arm = study_data$treatment,
  tau = 24  # Restriction time (months)
)
print(rmst_result)
```

Report RMST difference alongside HR, especially when PH is questionable.

---

## Parametric Survival Models for Extrapolation

For HTA submissions, fit parametric models and compare:

```r
# Fit multiple parametric distributions
library(flexsurv)

models <- list(
  exponential = flexsurvreg(Surv(time, event) ~ treatment, data = ipd, dist = "exp"),
  weibull     = flexsurvreg(Surv(time, event) ~ treatment, data = ipd, dist = "weibull"),
  lognormal   = flexsurvreg(Surv(time, event) ~ treatment, data = ipd, dist = "lognormal"),
  loglogistic = flexsurvreg(Surv(time, event) ~ treatment, data = ipd, dist = "llogis"),
  gompertz    = flexsurvreg(Surv(time, event) ~ treatment, data = ipd, dist = "gompertz"),
  gengamma    = flexsurvreg(Surv(time, event) ~ treatment, data = ipd, dist = "gengamma")
)

# Compare AIC/BIC
sapply(models, function(m) c(AIC = AIC(m), BIC = BIC(m)))
```

---

## Oncology NMA Publication Patterns (2024-2025)

Based on recent literature, ~60-70% of oncology NMA publications use Bayesian methods, especially for immunotherapy comparisons:

| Context | Typical Method | Typical Tool |
|---------|---------------|--------------|
| Immunotherapy comparison | Bayesian | gemtc / R+JAGS |
| CDK4/6 inhibitor comparison | Either | gemtc or netmeta |
| Perioperative regimens | Bayesian | gemtc |
| HTA/reimbursement dossier | Bayesian (mandatory) | gemtc / multinma |
| Quick academic publication | Either works | netmeta (faster) |

---

## Checklist for Oncology TTE NMA

- [ ] PH assumption tested for each comparison (Schoenfeld, log-log plot)
- [ ] PH violations documented and discussed
- [ ] If PH violated: sensitivity analysis or M-spline model
- [ ] RMST reported as supplementary measure
- [ ] If IPD reconstructed: Guyot method described, validation shown
- [ ] Parametric model comparison if extrapolation needed
- [ ] CINeMA assessment completed

---

## See Also

- [NMA R Guide](nma-r-guide.md) — Standard NMA workflow
- [NMA Package Comparison](nma-package-comparison.md) — multinma details
- [NMA Assumptions](nma-assumptions.md) — Transitivity and consistency
