#!/usr/bin/env Rscript
# Automated R environment setup for meta-analysis pipeline

cat("\n")
cat("============================================================\n")
cat("📊 R ENVIRONMENT SETUP FOR META-ANALYSIS PIPELINE\n")
cat("============================================================\n")
cat("\n")

# Step 1: Install renv
cat("Step 1/3: Installing renv...\n")
if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv", repos = "https://cloud.r-project.org")
  cat("✅ renv installed\n")
} else {
  cat("✅ renv already installed\n")
}
cat("\n")

# Step 2: Initialize renv (if not already initialized)
cat("Step 2/3: Initializing renv...\n")
if (!file.exists("renv.lock")) {
  renv::init()
  cat("✅ renv initialized\n")
} else {
  cat("✅ renv already initialized (renv.lock exists)\n")
  cat("   Restoring packages from renv.lock...\n")
  renv::restore()
}
cat("\n")

# Step 3: Install core packages
cat("Step 3/3: Installing core meta-analysis packages...\n")

core_packages <- c(
  # Data manipulation
  "dplyr",
  "readr",
  "tidyr",
  "stringr",

  # Meta-analysis
  "meta",
  "metafor",

  # Visualization
  "ggplot2",
  "forestplot",

  # Tables
  "gtsummary",
  "gt",
  "flextable"
)

cat("Installing", length(core_packages), "core packages...\n")
install.packages(core_packages, repos = "https://cloud.r-project.org")

cat("\n")
cat("Checking installation...\n")
all_ok <- TRUE
for (pkg in core_packages) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    cat(sprintf("✅ %s\n", pkg))
  } else {
    cat(sprintf("❌ %s failed to install\n", pkg))
    all_ok <- FALSE
  }
}

cat("\n")

# Step 4: Create snapshot
cat("Creating renv snapshot...\n")
renv::snapshot()
cat("✅ renv.lock updated\n")

cat("\n")
cat("============================================================\n")

if (all_ok) {
  cat("✅ R ENVIRONMENT SETUP COMPLETE\n")
  cat("\n")
  cat("Core packages installed:\n")
  cat("  - Data manipulation: dplyr, readr, tidyr, stringr\n")
  cat("  - Meta-analysis: meta, metafor\n")
  cat("  - Visualization: ggplot2, forestplot\n")
  cat("  - Tables: gtsummary, gt, flextable\n")
  cat("\n")
  cat("Optional packages (install if needed):\n")
  cat("  - Network Meta-Analysis: gemtc, rjags, netmeta, coda\n")
  cat("  - Install with:\n")
  cat("    install.packages(c('gemtc', 'rjags', 'netmeta', 'coda'))\n")
  cat("    renv::snapshot()\n")
  cat("\n")
  cat("Note: gemtc requires JAGS to be installed on your system\n")
  cat("      Download from: https://mcmc-jags.sourceforge.io/\n")
} else {
  cat("⚠️  SOME PACKAGES FAILED TO INSTALL\n")
  cat("\n")
  cat("Please check error messages above and:\n")
  cat("  1. Ensure you have build tools installed\n")
  cat("  2. Check system dependencies (libcurl, libssl, etc.)\n")
  cat("  3. Retry failed packages manually\n")
}

cat("\n")
cat("============================================================\n")
cat("\n")
