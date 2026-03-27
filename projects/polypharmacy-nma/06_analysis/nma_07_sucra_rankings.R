# =============================================================================
# nma_07_sucra_rankings.R — SUCRA Rankings & Rankograms
# =============================================================================

source("nma_04_models.R")

compute_rankings <- function(results, filename_prefix, small_is_better = TRUE) {
  label    <- results$label
  bayes_re <- results$bayes
  net_re   <- results$freq

  cat("\n", strrep("=", 60), "\n")
  cat("SUCRA Rankings:", label, "\n")
  cat(strrep("=", 60), "\n")

  # --- A. Bayesian SUCRA (gemtc) ---
  cat("\n[A] Bayesian SUCRA (gemtc)\n")

  pref_dir <- if (small_is_better) -1 else 1
  ranks    <- rank.probability(bayes_re, preferredDirection = pref_dir)

  sucra_vals <- sucra(ranks)
  cat("SUCRA values:\n")
  print(round(sucra_vals, 4))

  rank_df <- data.frame(
    Treatment = names(sucra_vals),
    SUCRA     = round(as.numeric(sucra_vals), 4)
  ) %>%
    mutate(Label = TREATMENT_LABELS[Treatment],
           Label = ifelse(is.na(Label), Treatment, Label)) %>%
    arrange(desc(SUCRA)) %>%
    mutate(Rank = row_number())

  write_csv(rank_df, file.path(TBL_DIR,
            paste0(filename_prefix, "_nma_rankings.csv")))

  # --- Rankogram ---
  ranks_matrix <- as.matrix(ranks)
  ranks_long <- data.frame(
    Treatment   = rep(rownames(ranks_matrix), each = ncol(ranks_matrix)),
    Rank        = rep(seq_len(ncol(ranks_matrix)), nrow(ranks_matrix)),
    Probability = as.vector(t(ranks_matrix))
  ) %>%
    mutate(Label = TREATMENT_LABELS[Treatment],
           Label = ifelse(is.na(Label), Treatment, Label))

  p_rankogram <- ggplot(ranks_long,
                        aes(x = Rank, y = Probability, fill = Label)) +
    geom_col(position = "dodge", alpha = 0.8) +
    facet_wrap(~Label, scales = "free_y") +
    scale_x_continuous(breaks = seq_len(nrow(ranks_matrix))) +
    scale_y_continuous(limits = c(0, 1)) +
    scale_fill_brewer(palette = "Set2") +
    labs(
      title    = paste0("Rankograms — ", label),
      subtitle = "Posterior rank probabilities (Bayesian NMA, gemtc)",
      x        = paste0("Rank (1 = best for ", label, ")"),
      y        = "Probability"
    ) +
    theme_minimal(base_size = 11) +
    theme(legend.position = "none",
          strip.text      = element_text(face = "bold"))

  ggsave(file.path(FIG_DIR, paste0(filename_prefix, "_rankogram.png")),
         p_rankogram, width = 14, height = 10, dpi = FIG_DPI)

  # --- SUCRA bar plot ---
  p_sucra <- ggplot(rank_df,
                    aes(x = reorder(Label, SUCRA), y = SUCRA,
                        fill = SUCRA)) +
    geom_col(alpha = 0.85) +
    geom_text(aes(label = sprintf("%.1f%%", SUCRA * 100)),
              hjust = -0.1, size = 4) +
    coord_flip() +
    scale_y_continuous(limits = c(0, 1.15),
                       labels = percent_format(1)) +
    scale_fill_gradient(low = "#cce5ff", high = "#004085",
                        guide = "none") +
    labs(
      title    = paste0("Treatment Ranking — ", label),
      subtitle = "SUCRA from Bayesian NMA (gemtc)\nHigher SUCRA = better outcome",
      x        = NULL, y = "SUCRA"
    ) +
    theme_minimal(base_size = 12) +
    theme(panel.grid.major.y = element_blank())

  ggsave(file.path(FIG_DIR, paste0(filename_prefix, "_sucra_plot.png")),
         p_sucra, width = 10, height = 6, dpi = FIG_DPI)

  # --- B. Frequentist P-scores ---
  cat("\n[B] Frequentist P-scores (netmeta)\n")
  pscore_ranking <- netrank(net_re,
                            small.values = if (small_is_better) "desirable" else "undesirable")

  comparison_df <- data.frame(
    Treatment = names(pscore_ranking$Pscore.random),
    Pscore    = round(pscore_ranking$Pscore.random, 4)
  ) %>%
    left_join(rank_df[, c("Treatment", "SUCRA")], by = "Treatment") %>%
    arrange(desc(SUCRA))

  cat("\nSUCRA vs P-score:\n")
  print(comparison_df)
  write_csv(comparison_df,
            file.path(TBL_DIR, paste0(filename_prefix, "_ranking_comparison.csv")))

  # --- gt table ---
  rank_gt <- comparison_df %>%
    mutate(Label = TREATMENT_LABELS[Treatment],
           Label = ifelse(is.na(Label), Treatment, Label)) %>%
    select(Rank_Treatment = Label, SUCRA, Pscore) %>%
    gt() %>%
    tab_header(
      title    = paste0("Treatment Rankings — ", label),
      subtitle = "SUCRA (Bayesian) vs. P-score (Frequentist)"
    ) %>%
    fmt_number(columns = c(SUCRA, Pscore), decimals = 3) %>%
    tab_style(style     = cell_fill(color = "#d4edda"),
              locations = cells_body(rows = 1)) %>%
    tab_footnote("SUCRA/P-score: higher = better rank. Lower RR = better outcome.",
                 locations = cells_column_labels(columns = SUCRA))

  gtsave(rank_gt,
         file.path(TBL_DIR, paste0(filename_prefix, "_rankings_table.png")),
         expand = 10)

  cat("All ranking outputs saved for:", label, "\n")
  invisible(list(rank_df = rank_df, comparison_df = comparison_df))
}

# --- Falls ---
rankings_falls <- compute_rankings(results_falls, "falls", small_is_better = TRUE)

# --- Hospitalization ---
rankings_hosp  <- compute_rankings(results_hosp,  "hosp",  small_is_better = TRUE)

# --- Combined SUCRA comparison figure ---
cat("\n--- Combined SUCRA figure (Falls + Hospitalization) ---\n")

combined_sucra <- bind_rows(
  rankings_falls$rank_df %>% mutate(Outcome = "Falls"),
  rankings_hosp$rank_df  %>% mutate(Outcome = "Hospitalization")
) %>%
  mutate(Label = TREATMENT_LABELS[Treatment],
         Label = ifelse(is.na(Label), Treatment, Label))

p_combined <- ggplot(combined_sucra,
                     aes(x = reorder(Label, SUCRA),
                         y = SUCRA, fill = Outcome)) +
  geom_col(position = "dodge", alpha = 0.85, width = 0.6) +
  geom_text(aes(label = sprintf("%.0f%%", SUCRA * 100)),
            position = position_dodge(0.6), hjust = -0.1, size = 3.3) +
  coord_flip() +
  scale_y_continuous(limits = c(0, 1.2), labels = percent_format(1)) +
  scale_fill_manual(values = c("Falls" = "#1976D2", "Hospitalization" = "#388E3C")) +
  labs(
    title    = "SUCRA Rankings — Polypharmacy Interventions",
    subtitle = "Falls vs. Hospitalization outcomes",
    x = NULL, y = "SUCRA (higher = better ranking)",
    fill = "Outcome"
  ) +
  theme_minimal(base_size = 12) +
  theme(panel.grid.major.y = element_blank(),
        legend.position    = "bottom")

ggsave(file.path(FIG_DIR, "combined_sucra_falls_hosp.png"),
       p_combined, width = 11, height = 6, dpi = FIG_DPI)
cat("Combined SUCRA plot saved.\n")
