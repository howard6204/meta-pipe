# =============================================================================
# nma_00_run_all.R — Master Pipeline: Polypharmacy NMA
# =============================================================================
# Executes the full NMA pipeline in sequence.
# Run from: projects/polypharmacy-nma/06_analysis/
#   > setwd("path/to/06_analysis")
#   > source("nma_00_run_all.R")
# =============================================================================

start_time <- Sys.time()
cat("=======================================================\n")
cat("POLYPHARMACY NMA — FULL PIPELINE\n")
cat("Started:", format(start_time, "%Y-%m-%d %H:%M:%S"), "\n")
cat("=======================================================\n\n")

# ── Step 1: Environment ──────────────────────────────────────────────────────
cat("[1/7] Setup...\n")
source("nma_01_setup.R")

# ── Step 2: Data (Falls & Hospitalization) ───────────────────────────────────
cat("\n[2/7] Data preparation (Falls & Hospitalization)...\n")
source("nma_02_data_prep.R")
# IMPORTANT: Replace synthetic data in nma_02_data_prep.R with real extraction

# ── Step 3: Network plots ────────────────────────────────────────────────────
cat("\n[3/7] Network geometry plots...\n")
source("nma_03_network_graph.R")

# ── Step 4: NMA models ───────────────────────────────────────────────────────
cat("\n[4/7] Bayesian + Frequentist NMA models...\n")
source("nma_04_models.R")

# ── Step 5: Heterogeneity & subgroup (auto-triggered if I² > 50%) ────────────
cat("\n[5/7] Heterogeneity check → Subgroup analysis...\n")
source("nma_05_heterogeneity_subgroup.R")

# ── Step 6: Forest plots + SUCRA + League tables ─────────────────────────────
cat("\n[6/7] Forest plots, SUCRA rankings, league tables...\n")
source("nma_06_forest_plots.R")
source("nma_07_sucra_rankings.R")
source("nma_08_league_table.R")

# ── Step 7: PIMs NMA (NMA-2) ─────────────────────────────────────────────────
cat("\n[7/7] PIMs NMA (European vs. Asian stratification)...\n")
source("nma_09_pims_data_prep.R")
source("nma_10_pims_nma.R")

# ── Final summary ─────────────────────────────────────────────────────────────
end_time <- Sys.time()
elapsed  <- difftime(end_time, start_time, units = "mins")

cat("\n=======================================================\n")
cat("PIPELINE COMPLETE\n")
cat("Elapsed:", round(as.numeric(elapsed), 1), "minutes\n")
cat("=======================================================\n\n")

# List output files
cat("--- Generated figures ---\n")
figs <- list.files(FIG_DIR, full.names = FALSE)
for (f in figs) cat(" ", f, "\n")

cat("\n--- Generated tables ---\n")
tbls <- list.files(TBL_DIR, full.names = FALSE)
for (t in tbls) cat(" ", t, "\n")

cat("\n=======================================================\n")
cat("NEXT STEPS\n")
cat("=======================================================\n")
cat("1. Replace synthetic data in nma_02_data_prep.R and\n")
cat("   nma_09_pims_data_prep.R with real extracted data.\n")
cat("2. Re-run nma_00_run_all.R after data replacement.\n")
cat("3. Review subgroup trigger: I² threshold =",
    I2_SUBGROUP_THRESHOLD * 100, "%\n")
cat("4. Check network connectivity warnings if any.\n")
cat("5. Proceed to manuscript: 07_manuscript/\n")
cat("=======================================================\n")
