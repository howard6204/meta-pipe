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
cat("Running MCMC (", MCMC_N_CHAINS, "chains,", MCMC_N_ITER, "iterations)...\n")
bayes_re <- tryCatch(
  mtc.run(
    model_re,
    n.adapt = MCMC_N_ADAPT,
    n.iter  = MCMC_N_ITER,
    thin    = MCMC_THIN
  ),
  error = function(e) {
    stop("MCMC sampling failed: ", e$message,
         "\nCheck JAGS installation and network data validity.")
  }
)

# --- 3. Convergence diagnostics ---
cat("\n=== Convergence Diagnostics ===\n")

# Gelman-Rubin (Rhat)
gelman <- tryCatch(
  gelman.diag(bayes_re),
  error = function(e) {
    cat("Warning: Gelman-Rubin diagnostic failed:", e$message, "\n")
    NULL
  }
)

if (!is.null(gelman)) {
  cat("Gelman-Rubin diagnostics:\n")
  print(gelman)

  max_rhat <- max(gelman$psrf[, "Point est."])
  cat("\nMax Rhat:", round(max_rhat, 3), "\n")
  if (max_rhat > 1.05) {
    warning("Rhat > 1.05 detected. Consider increasing n.iter or n.adapt.")
  } else {
    cat("All Rhat < 1.05: convergence adequate.\n")
  }
}

# Effective sample size
ess <- tryCatch(effectiveSize(bayes_re), error = function(e) NULL)
if (!is.null(ess)) {
  cat("\nEffective sample sizes:\n")
  print(ess)
  cat("Min ESS:", min(ess), "\n")
}

# Trace plots
tryCatch({
  png(file.path(FIG_DIR, "nma_trace_plots.png"),
      width = 12, height = 10, units = "in", res = FIG_DPI)
  plot(bayes_re)
  dev.off()
  cat("Trace plots saved to", file.path(FIG_DIR, "nma_trace_plots.png"), "\n")
}, error = function(e) {
  tryCatch(dev.off(), error = function(x) NULL)
  cat("Warning: Trace plot generation failed:", e$message, "\n")
})

# --- 4. Model summary ---
cat("\n=== Bayesian NMA Results ===\n")
summary(bayes_re)

# --- 5. Fit fixed-effect model (for comparison) ---
cat("\nFitting Bayesian fixed-effect model...\n")
bayes_fe <- tryCatch({
  model_fe <- mtc.model(
    network,
    type        = "consistency",
    linearModel = "fixed",
    n.chain     = MCMC_N_CHAINS
  )

  mtc.run(
    model_fe,
    n.adapt = MCMC_N_ADAPT,
    n.iter  = MCMC_N_ITER,
    thin    = MCMC_THIN
  )
}, error = function(e) {
  cat("Warning: Fixed-effect model failed:", e$message, "\n")
  NULL
})

# --- 6. Model comparison (DIC) ---
if (!is.null(bayes_fe)) {
  cat("\n=== Model Comparison (DIC) ===\n")
  dic_re <- tryCatch(summary(bayes_re)$DIC, error = function(e) NA)
  dic_fe <- tryCatch(summary(bayes_fe)$DIC, error = function(e) NA)
  if (!is.na(dic_re) && !is.na(dic_fe)) {
    cat("Random-effects DIC:", dic_re, "\n")
    cat("Fixed-effect DIC:", dic_fe, "\n")
    cat("Difference (RE - FE):", dic_re - dic_fe, "\n")
    if (dic_re < dic_fe) {
      cat("Random-effects model preferred (lower DIC).\n")
    } else {
      cat("Fixed-effect model preferred (lower DIC).\n")
    }
  } else {
    cat("DIC extraction failed. Check model summaries manually.\n")
  }
} else {
  cat("Skipping DIC comparison — fixed-effect model not available.\n")
}

# =============================================================================
# SECTION B: FREQUENTIST NMA (SENSITIVITY / SUPPLEMENT)
# =============================================================================

cat("\n=== Frequentist NMA (Sensitivity Analysis for Supplement) ===\n")
net_re <- tryCatch(
  netmeta(
    TE, seTE, treat1, treat2, studlab,
    data       = nma_data,
    sm         = NMA_SM,
    random     = TRUE,
    fixed      = TRUE,
    method.tau = "REML",
    reference.group = NMA_REFERENCE
  ),
  error = function(e) {
    stop("Frequentist netmeta() failed: ", e$message,
         "\nCheck that the network is connected and data are valid.")
  }
)

cat("Frequentist summary (for supplement):\n")
summary(net_re)

# --- 7. Save model summaries ---
tryCatch({
  sink("nma_model_summary.txt")
  cat("========================================\n")
  cat("PRIMARY ANALYSIS: Bayesian NMA (gemtc)\n")
  cat("========================================\n\n")
  summary(bayes_re)
  if (!is.null(gelman)) {
    cat("\n\nConvergence diagnostics:\n")
    print(gelman)
  }
  cat("\n\n========================================\n")
  cat("SENSITIVITY: Frequentist NMA (netmeta)\n")
  cat("========================================\n\n")
  summary(net_re)
  sink()
  cat("\nModel summaries saved to nma_model_summary.txt\n")
}, error = function(e) {
  tryCatch(sink(), error = function(x) NULL)  # close sink on error
  cat("Warning: Failed to save model summary:", e$message, "\n")
})
