# =============================================================================
# nma_04_models.R — Fit Bayesian NMA Models (Primary Analysis)
# =============================================================================
# Purpose: Fit Bayesian NMA with gemtc (primary); frequentist netmeta (supplement)
# Input: nma_data from nma_02_data_prep.R
# Output: bayes_re (Bayesian random-effects, primary), net_re (frequentist, supplement)
# Priors: Turner/Rhodes empirical priors or vague priors
# =============================================================================

source("nma_02_data_prep.R")

# =============================================================================
# SECTION A: BAYESIAN NMA (PRIMARY ANALYSIS)
# =============================================================================

# --- 1. Prepare gemtc network ---
cat("=== Bayesian NMA (Primary Analysis) ===\n")

stopifnot(
  "nma_data not found — run nma_02_data_prep.R first" = exists("nma_data"),
  "nma_data has no rows" = nrow(nma_data) > 0
)

if (NMA_DATA_FORMAT == "contrast") {
  gemtc_data <- data.frame(
    study     = nma_data$studlab,
    treatment = nma_data$treat1,
    diff      = nma_data$TE,
    std.err   = nma_data$seTE
  )
  network <- mtc.network(data.re = gemtc_data)
} else {
  # Arm-based: read raw extraction for gemtc (needs arm-level data)
  extraction_arm <- read_csv("../05_extraction/extraction.csv", show_col_types = FALSE)
  gemtc_data <- data.frame(
    study      = extraction_arm[[NMA_COL_STUDY]],
    treatment  = extraction_arm[[NMA_COL_TREATMENT]],
    responders = extraction_arm[[NMA_COL_EVENTS]],
    sampleSize = extraction_arm[[NMA_COL_TOTALN]]
  )
  network <- mtc.network(data.ab = gemtc_data)
}
cat("Network summary:\n")
summary(network)

# --- 2. Fit consistency model (random effects) ---
cat("\nFitting Bayesian consistency model (random-effects)...\n")

# Prior selection driven by NMA_PRIOR_TYPE in nma_01_setup.R
cat("Prior type:", NMA_PRIOR_TYPE, "\n")

if (NMA_PRIOR_TYPE == "empirical" && !is.null(NMA_HY_PRIOR)) {
  model_re <- mtc.model(
    network,
    type         = "consistency",
    linearModel  = "random",
    n.chain      = MCMC_N_CHAINS,
    hy.prior     = NMA_HY_PRIOR
  )
} else {
  # Vague priors (default, results ≈ frequentist)
  model_re <- mtc.model(
    network,
    type         = "consistency",
    linearModel  = "random",
    n.chain      = MCMC_N_CHAINS
  )
}

# Run MCMC
bayes_re <- mtc.run(
  model_re,
  n.adapt = MCMC_N_ADAPT,
  n.iter  = MCMC_N_ITER,
  thin    = MCMC_THIN
)

# --- 3. Convergence diagnostics ---
cat("\n=== Convergence Diagnostics ===\n")

# Gelman-Rubin (Rhat)
gelman <- gelman.diag(bayes_re)
cat("Gelman-Rubin diagnostics:\n")
print(gelman)

max_rhat <- max(gelman$psrf[, "Point est."])
cat("\nMax Rhat:", round(max_rhat, 3), "\n")
if (max_rhat > 1.05) {
  warning("Rhat > 1.05 detected. Consider increasing n.iter or n.adapt.")
} else {
  cat("All Rhat < 1.05: convergence adequate.\n")
}

# Effective sample size
ess <- effectiveSize(bayes_re)
cat("\nEffective sample sizes:\n")
print(ess)
cat("Min ESS:", min(ess), "\n")

# Trace plots
png(file.path(FIG_DIR, "nma_trace_plots.png"),
    width = 12, height = 10, units = "in", res = FIG_DPI)
plot(bayes_re)
dev.off()
cat("Trace plots saved to", file.path(FIG_DIR, "nma_trace_plots.png"), "\n")

# --- 4. Model summary ---
cat("\n=== Bayesian NMA Results ===\n")
summary(bayes_re)

# --- 5. Fit fixed-effect model (for comparison) ---
cat("\nFitting Bayesian fixed-effect model...\n")
model_fe <- mtc.model(
  network,
  type        = "consistency",
  linearModel = "fixed",
  n.chain     = MCMC_N_CHAINS
)

bayes_fe <- mtc.run(
  model_fe,
  n.adapt = MCMC_N_ADAPT,
  n.iter  = MCMC_N_ITER,
  thin    = MCMC_THIN
)

# --- 6. Model comparison (DIC) ---
cat("\n=== Model Comparison (DIC) ===\n")
dic_re <- summary(bayes_re)$DIC
dic_fe <- summary(bayes_fe)$DIC
cat("Random-effects DIC:", dic_re, "\n")
cat("Fixed-effect DIC:", dic_fe, "\n")
cat("Difference (RE - FE):", dic_re - dic_fe, "\n")
if (dic_re < dic_fe) {
  cat("Random-effects model preferred (lower DIC).\n")
} else {
  cat("Fixed-effect model preferred (lower DIC).\n")
}

# =============================================================================
# SECTION B: FREQUENTIST NMA (SENSITIVITY / SUPPLEMENT)
# =============================================================================

cat("\n=== Frequentist NMA (Sensitivity Analysis for Supplement) ===\n")
net_re <- netmeta(
  TE, seTE, treat1, treat2, studlab,
  data       = nma_data,
  sm         = NMA_SM,
  random     = TRUE,
  fixed      = TRUE,
  method.tau = "REML",
  reference.group = NMA_REFERENCE
)

cat("Frequentist summary (for supplement):\n")
summary(net_re)

# --- 7. Save model summaries ---
sink("nma_model_summary.txt")
cat("========================================\n")
cat("PRIMARY ANALYSIS: Bayesian NMA (gemtc)\n")
cat("========================================\n\n")
summary(bayes_re)
cat("\n\nConvergence diagnostics:\n")
print(gelman.diag(bayes_re))
cat("\n\n========================================\n")
cat("SENSITIVITY: Frequentist NMA (netmeta)\n")
cat("========================================\n\n")
summary(net_re)
sink()
cat("\nModel summaries saved to nma_model_summary.txt\n")
