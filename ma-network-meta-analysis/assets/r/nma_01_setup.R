# =============================================================================
# nma_01_setup.R — Environment Setup for Network Meta-Analysis
# =============================================================================
# Purpose: Initialize renv, install NMA packages, set global options
# Paradigm: Bayesian (gemtc) = PRIMARY, Frequentist (netmeta) = SENSITIVITY
# Packages: renv, gemtc, rjags, netmeta, meta, metafor, ggplot2, gt, flextable
# Output: renv.lock with pinned package versions
# Note: Requires JAGS installed on system (https://mcmc-jags.sourceforge.io/)
# =============================================================================

# --- 1. Initialize renv ---
if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv")
}
renv::init()

# --- 2. Install core NMA packages ---
install.packages(c(
  # Primary: Bayesian NMA
  "gemtc",         # Bayesian NMA via JAGS (primary analysis)
  "rjags",         # R interface to JAGS
  "coda",          # MCMC diagnostics (trace plots, Rhat, ESS)

  # Sensitivity: Frequentist NMA
  "netmeta",       # Frequentist NMA (sensitivity analysis / supplement)

  # Shared utilities
  "meta",          # Forest plots, pairwise helpers, pairwise()
  "metafor",       # Effect size calculation
  "dmetar",        # Meta-analysis helpers
  "ggplot2",       # Visualization
  "gt",            # Publication-quality tables
  "flextable",     # Word-compatible tables
  "readr",         # CSV reading
  "dplyr",         # Data manipulation
  "tidyr",         # Data reshaping
  "webshot2",      # PNG export for gt tables
  "patchwork"      # Multi-panel figures
))

# --- 3. Verify JAGS installation ---
jags_ok <- tryCatch({
  library(rjags)
  cat("JAGS version:", .jags.version(), "\n")
  TRUE
}, error = function(e) {
  warning("JAGS not found. Install from: https://mcmc-jags.sourceforge.io/")
  warning("Bayesian NMA (gemtc) requires JAGS. Falling back to netmeta only.")
  FALSE
})

# --- 4. Snapshot renv ---
renv::snapshot()

# --- 5. Global options ---
options(
  digits = 4,
  scipen = 999,
  warn = 1
)

# --- 6. MCMC defaults ---
MCMC_N_ADAPT  <- 5000    # Adaptation iterations
MCMC_N_ITER   <- 50000   # Sampling iterations (increase if poor convergence)
MCMC_THIN     <- 10      # Thinning interval
MCMC_N_CHAINS <- 4       # Number of MCMC chains

# --- 7. Figure export defaults ---
FIG_WIDTH  <- 10
FIG_HEIGHT <- 8
FIG_DPI    <- 300
FIG_DIR    <- "figures"
TBL_DIR    <- "tables"

# =============================================================================
# PROJECT-SPECIFIC NMA CONFIGURATION
# =============================================================================
# IMPORTANT: Edit these values ONCE before running the pipeline.
# All downstream scripts (nma_02 through nma_10) read from here.
# =============================================================================

# Effect measure: "RR", "OR", "HR" (ratio), or "MD", "SMD" (difference)
NMA_SM <- "RR"

# Reference/control treatment name (must match extraction data exactly)
# Set to NULL to auto-select alphabetically first treatment
NMA_REFERENCE <- NULL

# Data format in extraction CSV:
#   "contrast" = columns: study_id, treatment_1, treatment_2, effect_estimate, standard_error
#   "arm"      = columns: study_id, treatment, events, total_n
NMA_DATA_FORMAT <- "contrast"

# Column mapping — adapt names to match your extraction CSV
NMA_COL_STUDY     <- "study_id"
NMA_COL_TREAT1    <- "treatment_1"   # contrast format only
NMA_COL_TREAT2    <- "treatment_2"   # contrast format only
NMA_COL_TE        <- "effect_estimate"  # contrast format: log-scale for RR/OR/HR
NMA_COL_SETE      <- "standard_error"   # contrast format
NMA_COL_TREATMENT <- "treatment"     # arm format only
NMA_COL_EVENTS    <- "events"        # arm format only
NMA_COL_TOTALN    <- "total_n"       # arm format only

# Prior specification: "vague" (default, results ≈ frequentist) or "empirical"
# If "empirical", set NMA_HY_PRIOR below (Turner/Rhodes)
NMA_PRIOR_TYPE <- "vague"
# Example empirical prior (Turner 2012, log-OR, pharmacological vs placebo, mortality):
#   NMA_HY_PRIOR <- mtc.hy.prior("dlnorm", -3.95, 1.79^(-2))
NMA_HY_PRIOR <- NULL

# Direction for ranking: "undesirable" (higher = worse, e.g. mortality)
# or "desirable" (higher = better, e.g. response rate)
NMA_SMALL_VALUES <- "undesirable"

if (!dir.exists(FIG_DIR)) dir.create(FIG_DIR, recursive = TRUE)
if (!dir.exists(TBL_DIR)) dir.create(TBL_DIR, recursive = TRUE)

# --- 8. Load libraries ---
library(gemtc)
library(coda)
library(netmeta)
library(meta)
library(metafor)
library(ggplot2)
library(gt)
library(readr)
library(dplyr)
library(tidyr)

cat("NMA environment setup complete.\n")
cat("Primary: gemtc (Bayesian) | Sensitivity: netmeta (frequentist)\n")
cat("gemtc version:", as.character(packageVersion("gemtc")), "\n")
cat("netmeta version:", as.character(packageVersion("netmeta")), "\n")
if (jags_ok) cat("JAGS: OK\n") else cat("JAGS: NOT FOUND\n")
