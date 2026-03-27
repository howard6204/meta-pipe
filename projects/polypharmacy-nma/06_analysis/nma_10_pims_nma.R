# =============================================================================
# nma_10_pims_nma.R — NMA-2: PIMs Reduction + Region Stratified Analysis
# =============================================================================
# Primary: All-studies NMA for PIMs outcome
# Stratified: European studies vs. Asian studies
# Auto heterogeneity check: I² > 50% → subgroup by setting
# =============================================================================

source("nma_09_pims_data_prep.R")

# =============================================================================
# Helper: run PIMs NMA for a given subset
# =============================================================================

run_pims_nma <- function(nma_data, subset_label,
                          filename_prefix,
                          reference = REFERENCE_NODE) {

  cat("\n", strrep("=", 60), "\n")
  cat("PIMs NMA:", subset_label, "(n =", nrow(nma_data), "comparisons)\n")
  cat(strrep("=", 60), "\n")

  if (nrow(nma_data) == 0) {
    cat("  No data — skipping.\n")
    return(NULL)
  }

  # Check connectivity
  nc <- netconnection(nma_data$treat1, nma_data$treat2, nma_data$study)
  if (nc$n.subnets > 1) {
    warning("Disconnected network in PIMs subset: ", subset_label)
  }

  # --- Frequentist ---
  net_pims <- tryCatch(
    netmeta(TE, seTE, treat1, treat2, study,
            data            = nma_data,
            sm              = "RR",
            random          = TRUE,
            fixed           = FALSE,
            method.tau      = "REML",
            reference.group = reference),
    error = function(e) { cat("netmeta error:", conditionMessage(e), "\n"); NULL }
  )
  if (is.null(net_pims)) return(NULL)

  i2 <- net_pims$I2
  cat(sprintf("  I² = %.1f%% | tau = %.4f\n", i2 * 100, net_pims$tau))

  # --- P-scores ---
  pscore_pims <- netrank(net_pims, small.values = "desirable")

  rank_df <- data.frame(
    Treatment = names(pscore_pims$Pscore.random),
    Pscore    = round(pscore_pims$Pscore.random, 4),
    Subset    = subset_label
  ) %>%
    mutate(Label = TREATMENT_LABELS[Treatment],
           Label = ifelse(is.na(Label), Treatment, Label)) %>%
    arrange(desc(Pscore))

  cat("P-scores:\n")
  print(rank_df)
  write_csv(rank_df,
            file.path(TBL_DIR, paste0(filename_prefix, "_pims_rankings.csv")))

  # --- Network plot ---
  png(file.path(FIG_DIR, paste0(filename_prefix, "_pims_network.png")),
      width = 10, height = 10, units = "in", res = FIG_DPI)
  netgraph(net_pims,
           number.of.studies = TRUE,
           cex.points        = 5,
           col.points        = "darkorange",
           col               = "grey40",
           plastic           = FALSE,
           thickness         = "number.of.studies",
           points            = TRUE,
           offset            = 0.05,
           main              = paste0("PIMs Network — ", subset_label))
  dev.off()

  # --- Forest plot ---
  png(file.path(FIG_DIR, paste0(filename_prefix, "_pims_forest.png")),
      width = 12, height = 8, units = "in", res = FIG_DPI)
  forest(net_pims,
         reference.group = reference,
         sortvar         = TE,
         smlab           = "RR (95% CI)",
         col.square      = "darkorange",
         col.diamond     = "firebrick",
         main            = paste0("PIMs — ", subset_label,
                                  "\n(vs. Usual Care)"))
  dev.off()

  # --- SUCRA bar ---
  p_pscore <- ggplot(rank_df,
                     aes(x = reorder(Label, Pscore), y = Pscore, fill = Pscore)) +
    geom_col(alpha = 0.85) +
    geom_text(aes(label = sprintf("%.2f", Pscore)),
              hjust = -0.1, size = 4) +
    coord_flip() +
    scale_y_continuous(limits = c(0, 1.2)) +
    scale_fill_gradient(low = "#ffe0b2", high = "#e65100", guide = "none") +
    labs(
      title    = paste0("PIMs Ranking — ", subset_label),
      subtitle = "P-score from frequentist NMA (netmeta)\nHigher = better PIMs reduction",
      x = NULL, y = "P-score"
    ) +
    theme_minimal(base_size = 12) +
    theme(panel.grid.major.y = element_blank())

  ggsave(file.path(FIG_DIR, paste0(filename_prefix, "_pims_pscore.png")),
         p_pscore, width = 10, height = 6, dpi = FIG_DPI)

  # --- Auto subgroup by setting if I² > threshold ---
  if (i2 > I2_SUBGROUP_THRESHOLD) {
    cat(sprintf("\n  *** I² = %.1f%% > 50%% in %s — triggering setting subgroup ***\n",
                i2 * 100, subset_label))

    for (sg in c("Institutionalized", "Community")) {
      sg_d <- nma_data[nma_data$setting == sg, ]
      if (nrow(sg_d) < 2) next

      nc_sg <- netconnection(sg_d$treat1, sg_d$treat2, sg_d$study)
      if (nc_sg$n.subnets > 1) next

      net_sg <- tryCatch(
        netmeta(TE, seTE, treat1, treat2, study,
                data = sg_d, sm = "RR",
                random = TRUE, fixed = FALSE,
                method.tau = "REML",
                reference.group = reference),
        error = function(e) NULL
      )
      if (is.null(net_sg)) next

      cat(sprintf("  [%s | %s] I² = %.1f%% | tau = %.4f\n",
                  subset_label, sg, net_sg$I2 * 100, net_sg$tau))

      png(file.path(FIG_DIR, paste0(filename_prefix, "_pims_", tolower(sg), "_forest.png")),
          width = 12, height = 7, units = "in", res = FIG_DPI)
      forest(net_sg, reference.group = reference, sortvar = TE,
             main = paste0("PIMs — ", subset_label, " | ", sg))
      dev.off()
    }
  }

  list(net = net_pims, rank_df = rank_df, i2 = i2, label = subset_label)
}

# =============================================================================
# Run PIMs NMA
# =============================================================================

pims_all      <- run_pims_nma(nma_pims_all,      "All Regions",  "all")
pims_european <- run_pims_nma(nma_pims_european, "European",     "eu")
pims_asian    <- run_pims_nma(nma_pims_asian,    "Asian",        "as")

# =============================================================================
# Head-to-head comparison: European vs Asian P-scores
# =============================================================================

if (!is.null(pims_european) && !is.null(pims_asian)) {
  cat("\n--- European vs. Asian P-score Comparison ---\n")

  eu_ranks <- pims_european$rank_df %>% mutate(Region = "European")
  as_ranks <- pims_asian$rank_df    %>% mutate(Region = "Asian")
  region_combined <- bind_rows(eu_ranks, as_ranks)

  cat("\nRegional P-scores:\n")
  print(region_combined[, c("Label", "Pscore", "Region")])
  write_csv(region_combined,
            file.path(TBL_DIR, "pims_regional_comparison.csv"))

  # Comparison bar plot
  p_region <- ggplot(region_combined,
                     aes(x = reorder(Label, Pscore),
                         y = Pscore, fill = Region)) +
    geom_col(position = "dodge", alpha = 0.85, width = 0.6) +
    geom_text(aes(label = sprintf("%.2f", Pscore)),
              position = position_dodge(0.6),
              hjust = -0.1, size = 3.5) +
    coord_flip() +
    scale_y_continuous(limits = c(0, 1.2)) +
    scale_fill_manual(values = c("European" = "#1565C0", "Asian" = "#B71C1C")) +
    labs(
      title    = "PIMs Reduction — Regional Stratified Analysis",
      subtitle = "P-scores: European vs. Asian studies\n(Higher P-score = better ranking for PIMs reduction)",
      x = NULL, y = "P-score",
      fill = "Region"
    ) +
    theme_minimal(base_size = 12) +
    theme(panel.grid.major.y = element_blank(),
          legend.position    = "bottom")

  ggsave(file.path(FIG_DIR, "pims_regional_comparison.png"),
         p_region, width = 10, height = 6, dpi = FIG_DPI)
  cat("Regional comparison plot saved.\n")

  # --- gt summary table ---
  summary_tbl <- region_combined %>%
    select(Label, Region, Pscore) %>%
    pivot_wider(names_from = Region, values_from = Pscore,
                names_prefix = "Pscore_") %>%
    mutate(across(starts_with("Pscore"), ~round(.x, 3)))

  gt_region <- summary_tbl %>%
    gt() %>%
    tab_header(
      title    = "PIMs Reduction — P-scores by Region",
      subtitle = "European vs. Asian studies (frequentist NMA)"
    ) %>%
    fmt_number(columns = starts_with("Pscore"), decimals = 3) %>%
    tab_footnote("P-score: 0–1, higher = better PIMs reduction rank.",
                 locations = cells_column_labels(columns = 2))

  gtsave(gt_region,
         file.path(TBL_DIR, "pims_regional_summary_table.png"),
         expand = 10)
  cat("Regional summary table saved.\n")
}

# =============================================================================
# Summary report
# =============================================================================

cat("\n", strrep("=", 60), "\n")
cat("PIMs NMA SUMMARY\n")
cat(strrep("=", 60), "\n")
if (!is.null(pims_all))
  cat(sprintf("All regions  — I² = %.1f%% | n comparisons = %d\n",
              pims_all$i2 * 100, nrow(nma_pims_all)))
if (!is.null(pims_european))
  cat(sprintf("European     — I² = %.1f%% | n comparisons = %d\n",
              pims_european$i2 * 100, nrow(nma_pims_european)))
if (!is.null(pims_asian))
  cat(sprintf("Asian        — I² = %.1f%% | n comparisons = %d\n",
              pims_asian$i2 * 100, nrow(nma_pims_asian)))
