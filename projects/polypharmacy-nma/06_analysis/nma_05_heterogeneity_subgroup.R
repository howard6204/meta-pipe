# =============================================================================
# nma_05_heterogeneity_subgroup.R — I² Check → Auto Subgroup Analysis
# =============================================================================
# Rule: If I² > 50%, automatically run subgroup NMA by setting:
#   - Subgroup A: Institutionalized (nursing home / LTCF)
#   - Subgroup B: Community-dwelling
# =============================================================================

source("nma_02_data_prep.R")

# =============================================================================
# Helper: check I² and conditionally run subgroup NMA
# =============================================================================

check_and_subgroup <- function(nma_data, outcome_label,
                                reference     = REFERENCE_NODE,
                                i2_threshold  = I2_SUBGROUP_THRESHOLD) {

  cat("\n", strrep("=", 60), "\n")
  cat("Heterogeneity check:", outcome_label, "\n")
  cat(strrep("=", 60), "\n")

  # Overall I² from frequentist model
  net_overall <- netmeta(TE, seTE, treat1, treat2, study,
                         data            = nma_data,
                         sm              = "RR",
                         random          = TRUE,
                         fixed           = FALSE,
                         method.tau      = "REML",
                         reference.group = reference)

  i2_overall <- net_overall$I2
  tau_overall <- net_overall$tau

  cat(sprintf("  Overall I²  = %.1f%%\n", i2_overall * 100))
  cat(sprintf("  Overall tau = %.4f\n",   tau_overall))

  run_subgroup <- i2_overall > i2_threshold

  if (!run_subgroup) {
    cat(sprintf("  I² = %.1f%% ≤ threshold (%.0f%%). Subgroup analysis NOT triggered.\n",
                i2_overall * 100, i2_threshold * 100))
    return(list(
      triggered = FALSE,
      overall   = net_overall,
      i2        = i2_overall,
      label     = outcome_label
    ))
  }

  # -------------------------------------------------------------------------
  cat(sprintf("\n  *** I² = %.1f%% > %.0f%% — SUBGROUP ANALYSIS TRIGGERED ***\n",
              i2_overall * 100, i2_threshold * 100))
  # -------------------------------------------------------------------------

  subgroup_results <- list()
  settings <- c("Institutionalized", "Community")

  for (sg in settings) {
    cat("\n--- Subgroup:", sg, "---\n")

    sg_data <- nma_data[nma_data$setting == sg, ]

    if (nrow(sg_data) == 0) {
      cat("  No data for subgroup:", sg, "— skipping.\n")
      next
    }

    # Check connectivity
    nc <- netconnection(sg_data$treat1, sg_data$treat2, sg_data$study)
    if (nc$n.subnets > 1) {
      cat("  Disconnected network in subgroup", sg,
          "— only", nc$n.subnets, "sub-networks. Skipping.\n")
      next
    }

    net_sg <- tryCatch(
      netmeta(TE, seTE, treat1, treat2, study,
              data            = sg_data,
              sm              = "RR",
              random          = TRUE,
              fixed           = FALSE,
              method.tau      = "REML",
              reference.group = reference),
      error = function(e) {
        cat("  netmeta error in subgroup", sg, ":", conditionMessage(e), "\n")
        NULL
      }
    )

    if (!is.null(net_sg)) {
      cat(sprintf("  I² = %.1f%% | tau = %.4f | n_studies = %d\n",
                  net_sg$I2 * 100, net_sg$tau, nrow(sg_data)))

      # Forest plot for subgroup
      png(file.path(FIG_DIR, paste0("subgroup_", tolower(sg), "_",
                                    tolower(gsub(" ", "_", outcome_label)),
                                    "_forest.png")),
          width = 12, height = 8, units = "in", res = FIG_DPI)

      forest(net_sg,
             reference.group = reference,
             sortvar         = TE,
             main            = paste0("NMA Forest — ", outcome_label,
                                      "\nSubgroup: ", sg))
      dev.off()
      cat("  Forest plot saved for subgroup:", sg, "\n")

      # SUCRA for subgroup
      pscore_sg <- netrank(net_sg, small.values = "desirable")
      cat("  P-scores (", sg, "):\n")
      print(round(pscore_sg$Pscore.random, 3))

      # Save subgroup results table
      sg_rank_df <- data.frame(
        Treatment = names(pscore_sg$Pscore.random),
        Pscore    = round(pscore_sg$Pscore.random, 4),
        Setting   = sg,
        Outcome   = outcome_label
      ) %>% arrange(desc(Pscore))

      write_csv(sg_rank_df,
                file.path(TBL_DIR, paste0("subgroup_ranking_",
                          tolower(sg), "_",
                          tolower(gsub(" ", "_", outcome_label)), ".csv")))

      subgroup_results[[sg]] <- net_sg
    }
  }

  # --- Comparison plot: Institutionalized vs Community ---
  if (length(subgroup_results) == 2) {
    cat("\n--- Generating subgroup comparison plot ---\n")

    sg_dfs <- lapply(names(subgroup_results), function(sg) {
      net <- subgroup_results[[sg]]
      pscore <- netrank(net, small.values = "desirable")
      data.frame(
        Treatment = names(pscore$Pscore.random),
        Pscore    = pscore$Pscore.random,
        Setting   = sg
      )
    })
    sg_combined <- do.call(rbind, sg_dfs)

    p_sg <- ggplot(sg_combined,
                   aes(x = reorder(Treatment, Pscore),
                       y = Pscore, fill = Setting)) +
      geom_col(position = "dodge", alpha = 0.8, width = 0.6) +
      geom_text(aes(label = sprintf("%.2f", Pscore)),
                position = position_dodge(0.6), hjust = -0.1, size = 3.5) +
      coord_flip() +
      scale_y_continuous(limits = c(0, 1.15)) +
      scale_fill_manual(values = c("Institutionalized" = "#2196F3",
                                    "Community"         = "#FF9800")) +
      labs(
        title    = paste0("Subgroup Analysis — ", outcome_label),
        subtitle = "P-scores by care setting (Institutionalized vs. Community)",
        x        = NULL, y = "P-score (higher = better ranking)",
        fill     = "Setting"
      ) +
      theme_minimal(base_size = 12) +
      theme(panel.grid.major.y = element_blank(),
            legend.position    = "bottom")

    ggsave(file.path(FIG_DIR, paste0("subgroup_comparison_",
                     tolower(gsub(" ", "_", outcome_label)), ".png")),
           p_sg, width = 10, height = 6, dpi = FIG_DPI)
    cat("Subgroup comparison plot saved.\n")
  }

  list(
    triggered        = TRUE,
    overall          = net_overall,
    subgroup_results = subgroup_results,
    i2               = i2_overall,
    label            = outcome_label
  )
}

# =============================================================================
# Run heterogeneity checks
# =============================================================================

sg_falls <- check_and_subgroup(nma_falls, "Falls")
sg_hosp  <- check_and_subgroup(nma_hosp,  "Hospitalization")

# --- Summary ---
cat("\n", strrep("=", 60), "\n")
cat("HETEROGENEITY SUMMARY\n")
cat(strrep("=", 60), "\n")
cat(sprintf("Falls          — I² = %.1f%% | Subgroup triggered: %s\n",
            sg_falls$i2 * 100, sg_falls$triggered))
cat(sprintf("Hospitalization — I² = %.1f%% | Subgroup triggered: %s\n",
            sg_hosp$i2 * 100,  sg_hosp$triggered))
