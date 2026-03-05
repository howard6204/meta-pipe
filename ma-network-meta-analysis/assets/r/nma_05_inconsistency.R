# =============================================================================
# nma_05_inconsistency.R — Transitivity & Consistency Assessment
# =============================================================================
# Purpose: Assess NMA assumptions via design decomposition, heat plot,
#          and node-splitting
# Input: net_re from nma_04_models.R
# Output: figures/netheat.png, inconsistency test results
# =============================================================================

source("nma_04_models.R")

# =============================================================================
# VALIDATION
# =============================================================================
stopifnot(
  "net_re not found — run nma_04_models.R first" = exists("net_re"),
  "nma_data not found" = exists("nma_data")
)

n_designs <- length(unique(nma_data$studlab))
n_treatments <- length(unique(c(nma_data$treat1, nma_data$treat2)))
cat("Studies:", n_designs, "| Treatments:", n_treatments, "\n")

# --- 1. Global inconsistency test (Q decomposition) ---
cat("=== Design Decomposition (Consistency Assessment) ===\n")

dd <- tryCatch(
  decomp.design(net_re),
  error = function(e) {
    cat("Warning: decomp.design() failed:", e$message, "\n")
    cat("This can happen with simple networks (e.g., star-shaped).\n")
    NULL
  }
)

if (!is.null(dd)) {
  print(dd)

  if (!is.null(dd$Q.decomp) && nrow(dd$Q.decomp) >= 3) {
    cat("\nQ_total:", dd$Q.decomp$Q[1], "(p =", dd$Q.decomp$pval[1], ")\n")
    cat("Q_between-designs:", dd$Q.decomp$Q[2], "(p =", dd$Q.decomp$pval[2], ")\n")
    cat("Q_within-designs:", dd$Q.decomp$Q[3], "(p =", dd$Q.decomp$pval[3], ")\n")

    if (dd$Q.decomp$pval[2] < 0.05) {
      warning("Significant between-designs inconsistency detected (p < 0.05).")
      cat("Consider investigating sources of inconsistency.\n")
    } else {
      cat("No significant between-designs inconsistency detected.\n")
    }
  } else {
    cat("Q decomposition not available (may require multi-arm or closed-loop designs).\n")
  }
} else {
  cat("Skipping Q decomposition — not applicable to this network structure.\n")
}

# --- 2. Net heat plot ---
cat("\nGenerating net heat plot...\n")

heat_ok <- tryCatch({
  png(file.path(FIG_DIR, "netheat.png"),
      width = FIG_WIDTH, height = FIG_HEIGHT, units = "in", res = FIG_DPI)
  netheat(net_re, random = TRUE)
  dev.off()
  cat("Net heat plot saved to", file.path(FIG_DIR, "netheat.png"), "\n")
  TRUE
}, error = function(e) {
  tryCatch(dev.off(), error = function(x) NULL)  # close device on error
  cat("Warning: netheat() failed:", e$message, "\n")
  cat("Net heat plots require closed loops in the network.\n")
  FALSE
})

# --- 3. Node-splitting (direct vs indirect evidence) ---
cat("\n=== Node-Splitting (Local Inconsistency) ===\n")

ns <- tryCatch(
  netsplit(net_re),
  error = function(e) {
    cat("Warning: netsplit() failed:", e$message, "\n")
    cat("Node-splitting requires at least one comparison with both direct and indirect evidence.\n")
    NULL
  }
)

ns_df <- NULL
if (!is.null(ns)) {
  print(ns)

  # Identify comparisons with significant inconsistency
  cat("\n--- Comparisons with significant inconsistency (p < 0.10) ---\n")
  ns_df <- tryCatch(as.data.frame(ns), error = function(e) NULL)
  if (!is.null(ns_df) && "p.value" %in% names(ns_df)) {
    sig_inconsistency <- ns_df[!is.na(ns_df$p.value) & ns_df$p.value < 0.10, ]
    if (nrow(sig_inconsistency) > 0) {
      print(sig_inconsistency)
    } else {
      cat("No comparisons with significant local inconsistency.\n")
    }
  }

  # --- 4. Forest plot of node-splitting results ---
  tryCatch({
    plot_height <- if (!is.null(ns_df)) max(8, nrow(ns_df) * 0.5) else 8
    png(file.path(FIG_DIR, "netsplit_forest.png"),
        width = 12, height = plot_height, units = "in", res = FIG_DPI)
    forest(ns)
    dev.off()
    cat("Node-splitting forest plot saved to", file.path(FIG_DIR, "netsplit_forest.png"), "\n")
  }, error = function(e) {
    tryCatch(dev.off(), error = function(x) NULL)
    cat("Warning: netsplit forest plot failed:", e$message, "\n")
  })
}

# --- 5. Save inconsistency report ---
sink("nma_inconsistency_report.txt")
cat("=== NMA Inconsistency Assessment ===\n\n")
cat("--- Design Decomposition ---\n")
if (!is.null(dd)) print(dd) else cat("Not available for this network.\n")
cat("\n--- Node-Splitting ---\n")
if (!is.null(ns)) print(ns) else cat("Not available for this network.\n")
sink()
cat("\nInconsistency report saved to nma_inconsistency_report.txt\n")
