# =============================================================================
# nma_04_models.R — Bayesian & Frequentist NMA Models (Falls & Hospitalization)
# =============================================================================

source("nma_02_data_prep.R")

# =============================================================================
# Helper: run full NMA for one outcome dataset
# =============================================================================

run_nma <- function(nma_data, outcome_label, reference = REFERENCE_NODE) {
  cat("\n", strrep("=", 60), "\n")
  cat("NMA:", outcome_label, "\n")
  cat(strrep("=", 60), "\n")

  # --- A. Frequentist (netmeta) ---
  cat("\n[A] Frequentist NMA (netmeta)\n")

  net_re <- netmeta(TE, seTE, treat1, treat2, study,
                    data            = nma_data,
                    sm              = "RR",
                    random          = TRUE,
                    fixed           = FALSE,
                    method.tau      = "REML",
                    reference.group = reference)

  cat("  tau² (between-study variance):", round(net_re$tau^2, 4), "\n")
  cat("  I² (between-design):", round(net_re$I2, 3), "\n")

  # --- B. Bayesian (gemtc) ---
  cat("\n[B] Bayesian NMA (gemtc)\n")

  # Build gemtc network from arm-level data
  # Re-create arm data structure for gemtc
  # gemtc needs: study, treatment, diff, std.err (contrast format)
  gemtc_data <- nma_data %>%
    rename(diff    = TE,
           std.err = seTE) %>%
    select(study, treatment = treat1, diff, std.err)

  # Add NA rows for reference arm (gemtc convention)
  ref_rows <- nma_data %>%
    distinct(study) %>%
    mutate(treatment = reference, diff = NA_real_, std.err = NA_real_)

  gemtc_df <- bind_rows(gemtc_data, ref_rows) %>%
    arrange(study, treatment)

  network <- mtc.network(data.re = gemtc_df,
                         description = paste("Polypharmacy NMA —", outcome_label))

  # Consistency model (random effects)
  model_re <- mtc.model(network,
                        type        = "consistency",
                        linearModel = "random",
                        n.chain     = MCMC_N_CHAINS)

  cat("  Running MCMC (this may take a few minutes)...\n")
  results_re <- mtc.run(model_re,
                        n.adapt = MCMC_N_ADAPT,
                        n.iter  = MCMC_N_ITER,
                        thin    = MCMC_THIN)

  cat("  MCMC complete. Summary:\n")
  sum_re <- summary(results_re)
  print(sum_re)

  # Save model summary
  capture.output(sum_re,
    file = file.path(TBL_DIR, paste0("nma_", tolower(gsub(" ", "_", outcome_label)),
                                     "_model_summary.txt")))

  list(
    freq = net_re,
    bayes = results_re,
    network = network,
    label = outcome_label
  )
}

# =============================================================================
# Run models
# =============================================================================

results_falls <- run_nma(nma_falls, "Falls")
results_hosp  <- run_nma(nma_hosp,  "Hospitalization")

cat("\nAll NMA models complete.\n")
