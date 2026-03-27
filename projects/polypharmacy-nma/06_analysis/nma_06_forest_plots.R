# =============================================================================
# nma_06_forest_plots.R — Forest Plots (Falls & Hospitalization)
# =============================================================================

source("nma_04_models.R")

plot_forest_outcome <- function(results, filename_prefix) {
  net_freq <- results$freq
  label    <- results$label

  cat("\n=== Forest plot:", label, "===\n")

  # --- netmeta forest plot ---
  png(file.path(FIG_DIR, paste0(filename_prefix, "_forest_all.png")),
      width = 12, height = 8, units = "in", res = FIG_DPI)

  forest(net_freq,
         reference.group = REFERENCE_NODE,
         sortvar         = TE,
         smlab           = "RR (95% CrI)",
         col.square      = "steelblue",
         col.diamond     = "firebrick",
         main            = paste0("Network Meta-Analysis — ", label,
                                  "\n(vs. Usual Care)"))
  dev.off()
  cat("Forest plot saved:", file.path(FIG_DIR, paste0(filename_prefix, "_forest_all.png")), "\n")

  # --- ggplot2 custom forest plot ---
  # Extract random-effects estimates vs reference
  comparisons <- net_freq$comparisons[
    grepl(paste0(":", REFERENCE_NODE, "|", REFERENCE_NODE, ":"),
          net_freq$comparisons$comparison), ]

  # Fallback: extract from netmeta result manually
  treats_not_ref <- TREATMENT_ORDER[TREATMENT_ORDER != REFERENCE_NODE]

  forest_df <- lapply(treats_not_ref, function(t) {
    tryCatch({
      idx <- which(net_freq$studlab == paste(t, ":", REFERENCE_NODE, sep = ""))
      if (length(idx) == 0) {
        # Try reverse
        idx2 <- which(net_freq$studlab == paste(REFERENCE_NODE, ":", t, sep = ""))
        if (length(idx2) == 0) return(NULL)
        data.frame(
          Treatment = t,
          RR   = exp(-net_freq$TE.random[idx2]),
          lRR  = exp(-net_freq$upper.random[idx2]),
          uRR  = exp(-net_freq$lower.random[idx2])
        )
      } else {
        data.frame(
          Treatment = t,
          RR  = exp(net_freq$TE.random[idx]),
          lRR = exp(net_freq$lower.random[idx]),
          uRR = exp(net_freq$upper.random[idx])
        )
      }
    }, error = function(e) NULL)
  })

  forest_df <- do.call(rbind, Filter(Negate(is.null), forest_df))

  if (!is.null(forest_df) && nrow(forest_df) > 0) {
    forest_df$label <- TREATMENT_LABELS[forest_df$Treatment]
    forest_df$label[is.na(forest_df$label)] <- forest_df$Treatment[is.na(forest_df$label)]

    p_forest <- ggplot(forest_df,
                       aes(x = RR, y = reorder(label, -RR))) +
      geom_vline(xintercept = 1, linetype = "dashed", colour = "grey50") +
      geom_point(size = 3.5, colour = "steelblue") +
      geom_errorbarh(aes(xmin = lRR, xmax = uRR),
                     height = 0.2, colour = "steelblue") +
      geom_text(aes(label = sprintf("%.2f (%.2f–%.2f)", RR, lRR, uRR)),
                hjust = -0.15, size = 3.5) +
      scale_x_continuous(
        limits = c(0, max(forest_df$uRR, na.rm = TRUE) * 1.4),
        trans  = "log10",
        labels = number_format(accuracy = 0.01)
      ) +
      labs(
        title    = paste0("NMA Results — ", label),
        subtitle = paste0("All interventions vs. Usual Care (RR, 95% CI)\n",
                          "Frequentist random-effects NMA (netmeta)"),
        x = "Risk Ratio (log scale)", y = NULL
      ) +
      theme_minimal(base_size = 12) +
      theme(panel.grid.major.y = element_blank(),
            axis.text.y = element_text(face = "bold"))

    ggsave(file.path(FIG_DIR, paste0(filename_prefix, "_forest_ggplot.png")),
           p_forest, width = 12, height = 6, dpi = FIG_DPI)
    cat("ggplot forest saved.\n")
  }
}

# --- Falls ---
plot_forest_outcome(results_falls, "falls")

# --- Hospitalization ---
plot_forest_outcome(results_hosp, "hosp")

cat("\nForest plots complete.\n")
