# ==============================================================================
# HIV PrEP Network Meta-Analysis
# Script 04: Subgroup and Sensitivity Analyses
# Date: 2026-03-28
# ==============================================================================

library(netmeta)
library(dplyr)
library(readr)

source("nma_02_network_plot.R")  # loads pairs

# === SENSITIVITY 1: Exclude adherence-confounded trials (FEM-PrEP, VOICE) ===
pairs_sens1 <- pairs %>%
  filter(!grepl("FEM-PrEP|VOICE", studlab))

net_sens1 <- netmeta(
  TE = TE, seTE = seTE, treat1 = treat1, treat2 = treat2,
  studlab = studlab, data = pairs_sens1,
  reference.group = "PBO", sm = "IRR", random = TRUE
)
cat("\n=== SENSITIVITY 1: Exclude FEM-PrEP and VOICE ===\n")
print(netrank(net_sens1, small.values = "good"))

# === SENSITIVITY 2: MSM/TGW subgroup only ===
pairs_msm <- pairs %>%
  filter(grepl("MSM|TGW|transgender", population, ignore.case = TRUE))

if (nrow(pairs_msm) >= 2) {
  net_msm <- netmeta(
    TE = TE, seTE = seTE, treat1 = treat1, treat2 = treat2,
    studlab = studlab, data = pairs_msm,
    reference.group = "PBO", sm = "IRR", random = TRUE
  )
  cat("\n=== SUBGROUP: MSM/TGW population ===\n")
  print(netrank(net_msm, small.values = "good"))
}

# === SENSITIVITY 3: Women subgroup only ===
pairs_women <- pairs %>%
  filter(grepl("women|cisgender women", population, ignore.case = TRUE))

if (nrow(pairs_women) >= 2) {
  net_women <- netmeta(
    TE = TE, seTE = seTE, treat1 = treat1, treat2 = treat2,
    studlab = studlab, data = pairs_women,
    reference.group = "PBO", sm = "IRR", random = TRUE
  )
  cat("\n=== SUBGROUP: Cisgender women population ===\n")
  print(netrank(net_women, small.values = "good"))
}

# === INCONSISTENCY: Node-splitting ==========================================
cat("\n=== INCONSISTENCY (node-splitting) ===\n")
nsplit <- netsplit(net)
print(nsplit, digits = 2)
png("../figures/nma_inconsistency.png", width = 2400, height = 2400, res = 300)
plot(nsplit, main = "Node-splitting: Direct vs Indirect Estimates")
dev.off()

# === FUNNEL PLOT (comparison-adjusted) =====================================
png("../figures/nma_funnel.png", width = 2400, height = 1800, res = 300)
funnel(net,
  order    = c("PBO", "TDF_FTC", "TAF_FTC", "TDF_mono",
               "TDF_FTC_OD", "DVR", "CAB_LA", "LEN"),
  col.fixed  = "grey60",
  col.random = "steelblue4",
  main = "Comparison-Adjusted Funnel Plot"
)
dev.off()

cat("\nSubgroup and sensitivity analyses complete.\n")
