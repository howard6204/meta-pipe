# =============================================================================
# nma_08_league_table.R — League Tables (all pairwise comparisons)
# =============================================================================

source("nma_04_models.R")

make_league_table <- function(results, filename_prefix) {
  net_re <- results$freq
  label  <- results$label

  cat("\n=== League Table:", label, "===\n")

  # --- netleague (frequentist) ---
  league <- netleague(net_re,
                      digits    = 2,
                      bracket   = "(")

  # Print to console
  cat("Upper triangle: treatment in row vs treatment in column\n")
  cat("Lower triangle: treatment in column vs treatment in row\n")

  # Save as CSV
  league_mat <- as.matrix(league$upper)  # RR upper triangle
  write_csv(as.data.frame(league_mat),
            file.path(TBL_DIR, paste0(filename_prefix, "_league_upper.csv")))

  # --- ggplot2 heatmap league table ---
  treats  <- TREATMENT_ORDER
  n_treat <- length(treats)

  # Extract all pairwise RR from netmeta
  pairs_df <- expand.grid(row_t = treats, col_t = treats,
                          stringsAsFactors = FALSE) %>%
    filter(row_t != col_t)

  pairs_df$RR  <- NA_real_
  pairs_df$lCI <- NA_real_
  pairs_df$uCI <- NA_real_

  for (i in seq_len(nrow(pairs_df))) {
    t1 <- pairs_df$row_t[i]
    t2 <- pairs_df$col_t[i]

    idx <- which(net_re$treat1 == t1 & net_re$treat2 == t2)
    if (length(idx) > 0) {
      pairs_df$RR[i]  <- exp(net_re$TE.random[idx])
      pairs_df$lCI[i] <- exp(net_re$lower.random[idx])
      pairs_df$uCI[i] <- exp(net_re$upper.random[idx])
    } else {
      idx2 <- which(net_re$treat1 == t2 & net_re$treat2 == t1)
      if (length(idx2) > 0) {
        pairs_df$RR[i]  <- exp(-net_re$TE.random[idx2])
        pairs_df$lCI[i] <- exp(-net_re$upper.random[idx2])
        pairs_df$uCI[i] <- exp(-net_re$lower.random[idx2])
      }
    }
  }

  pairs_df <- pairs_df %>%
    filter(!is.na(RR)) %>%
    mutate(
      label_row = factor(TREATMENT_LABELS[row_t], levels = rev(TREATMENT_LABELS[treats])),
      label_col = factor(TREATMENT_LABELS[col_t], levels = TREATMENT_LABELS[treats]),
      cell_text = sprintf("%.2f\n(%.2f–%.2f)", RR, lCI, uCI),
      favours   = case_when(
        uCI < 1 ~ "row favoured",
        lCI > 1 ~ "col favoured",
        TRUE    ~ "no significant difference"
      )
    )

  p_league <- ggplot(pairs_df,
                     aes(x = label_col, y = label_row, fill = log(RR))) +
    geom_tile(colour = "white", linewidth = 0.5) +
    geom_text(aes(label = cell_text), size = 3, lineheight = 0.9) +
    scale_fill_gradient2(
      low      = "#1565C0",
      mid      = "white",
      high     = "#C62828",
      midpoint = 0,
      name     = "log(RR)",
      limits   = c(-1.5, 1.5)
    ) +
    labs(
      title    = paste0("League Table — ", label),
      subtitle = "RR (95% CI): row treatment vs. column treatment\nBlue = row favoured, Red = column favoured",
      x = NULL, y = NULL
    ) +
    theme_minimal(base_size = 11) +
    theme(
      axis.text.x  = element_text(angle = 30, hjust = 1, face = "bold"),
      axis.text.y  = element_text(face = "bold"),
      legend.position = "right"
    )

  ggsave(file.path(FIG_DIR, paste0(filename_prefix, "_league_table.png")),
         p_league, width = 10, height = 8, dpi = FIG_DPI)
  cat("League table heatmap saved.\n")

  invisible(pairs_df)
}

make_league_table(results_falls, "falls")
make_league_table(results_hosp,  "hosp")

cat("\nLeague tables complete.\n")
