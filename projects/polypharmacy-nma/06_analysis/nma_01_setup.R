# =============================================================================
# nma_01_setup.R — Environment Setup for Polypharmacy NMA
# =============================================================================
# Project : Polypharmacy interventions — Falls, Hospitalization, and PIMs
# Nodes   : Pharmacist, CDSS, MDT, Deprescribing, UC (reference)
# Primary : Bayesian NMA (gemtc) | Sensitivity: Frequentist (netmeta)
# Created : 2026-03-27
# =============================================================================

# --- 1. Install packages (skip if already installed) ---
pkgs <- c("gemtc", "rjags", "coda", "netmeta", "meta", "metafor",
          "ggplot2", "gt", "readr", "dplyr", "tidyr", "patchwork",
          "scales", "forcats", "stringr")

for (p in pkgs) {
  if (!requireNamespace(p, quietly = TRUE)) install.packages(p)
}

# --- 2. Verify JAGS ---
jags_ok <- tryCatch({
  library(rjags)
  cat("JAGS version:", .jags.version(), "\n")
  TRUE
}, error = function(e) {
  warning("JAGS not found. Install from: https://mcmc-jags.sourceforge.io/")
  FALSE
})

# --- 3. Global options ---
options(digits = 4, scipen = 999, warn = 1)

# MCMC defaults
MCMC_N_ADAPT  <- 5000
MCMC_N_ITER   <- 50000
MCMC_THIN     <- 10
MCMC_N_CHAINS <- 4

# Heterogeneity threshold for subgroup trigger
I2_SUBGROUP_THRESHOLD <- 0.50   # I² > 50% → run subgroup analysis

# Figure defaults
FIG_WIDTH  <- 10
FIG_HEIGHT <- 8
FIG_DPI    <- 300
FIG_DIR    <- "figures"
TBL_DIR    <- "tables"

if (!dir.exists(FIG_DIR)) dir.create(FIG_DIR, recursive = TRUE)
if (!dir.exists(TBL_DIR)) dir.create(TBL_DIR, recursive = TRUE)

# Treatment labels (used throughout)
TREATMENT_LABELS <- c(
  "Pharmacist"   = "Pharmacist-led Review",
  "CDSS"         = "CDSS",
  "MDT"          = "Multidisciplinary Team",
  "Deprescribing"= "Physician Deprescribing",
  "UC"           = "Usual Care"
)

TREATMENT_ORDER <- c("UC", "Deprescribing", "Pharmacist", "CDSS", "MDT")
REFERENCE_NODE  <- "UC"

# --- 4. Load libraries ---
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
library(patchwork)
library(scales)
library(forcats)

cat("=======================================================\n")
cat("Polypharmacy NMA — Environment Ready\n")
cat("gemtc   :", as.character(packageVersion("gemtc")), "\n")
cat("netmeta :", as.character(packageVersion("netmeta")), "\n")
cat("=======================================================\n")
