# =============================================================================
# nma_10_tables.R — Export League Table & Rankings as Publication Tables
# =============================================================================
# Purpose: Create gt/PNG tables for manuscript inclusion
# Input: net_re from nma_04_models.R, rankings from nma_07_ranking.R
# Output: tables/league_table.png, tables/league_table_heatmap.png,
#         tables/nma_summary.png
# =============================================================================

source("nma_04_models.R")

library(gt)
library(flextable)
library(ggplot2)
library(tidyr)

# --- 1. League table (full pairwise comparisons) ---
cat("Building league table...\n")
ranking <- netrank(net_re, small.values = "undesirable")
league <- netleague(net_re, random = TRUE, seq = ranking, digits = 2)

# Convert to data frame for gt
league_matrix <- league$random
league_df <- as.data.frame(league_matrix)

# Save as CSV
write_csv(league_df, file.path(TBL_DIR, "nma_league_table_full.csv"))

# --- 1b. League table heatmap (color-coded by effect size) ---
cat("Generating league table heatmap...\n")

# Order treatments by P-score ranking
treat_order <- names(sort(ranking$Pscore.random, decreasing = TRUE))
n_treats <- length(treat_order)
sm <- net_re$sm
is_ratio <- sm %in% c("RR", "OR", "HR")

# Build long-format data from the league matrix
heatmap_rows <- list()
for (i in seq_len(n_treats)) {
  for (j in seq_len(n_treats)) {
    if (i == j) next
    cell_text <- league_matrix[i, j]
    if (is.na(cell_text) || cell_text == "") next

    # Parse "estimate [lower, upper]" or "estimate (lower, upper)"
    m <- regmatches(cell_text, regexec(
      "([0-9.-]+)\\s*[\\[\\(]([0-9.-]+)[,;]\\s*([0-9.-]+)[\\]\\)]", cell_text
    ))[[1]]

    if (length(m) == 4) {
      est <- as.numeric(m[2])
      lo  <- as.numeric(m[3])
      hi  <- as.numeric(m[4])

      # Determine statistical significance (CI excludes null)
      null_val <- if (is_ratio) 1 else 0
      sig <- (lo > null_val) || (hi < null_val)

      heatmap_rows[[length(heatmap_rows) + 1]] <- data.frame(
        row_treat = rownames(league_matrix)[i],
        col_treat = colnames(league_matrix)[j],
        estimate  = est,
        lower     = lo,
        upper     = hi,
        sig       = sig,
        label     = trimws(cell_text),
        stringsAsFactors = FALSE
      )
    }
  }
}

if (length(heatmap_rows) > 0) {
  heatmap_df <- do.call(rbind, heatmap_rows)

  # Factor levels ordered by P-score ranking
  heatmap_df$row_treat <- factor(heatmap_df$row_treat, levels = treat_order)
  heatmap_df$col_treat <- factor(heatmap_df$col_treat, levels = treat_order)

  # Color scale: centered on null effect (1 for ratios, 0 for differences)
  if (is_ratio) {
    # Log-transform ratios so color scale is symmetric around 1
    heatmap_df$fill_val <- log(heatmap_df$estimate)
  } else {
    heatmap_df$fill_val <- heatmap_df$estimate
  }
  fill_limit <- max(abs(heatmap_df$fill_val), na.rm = TRUE)

  # Font size scales with number of treatments
  cell_font_size <- if (n_treats <= 5) 3.2 else if (n_treats <= 8) 2.8 else 2.2

  p_heatmap <- ggplot(heatmap_df, aes(x = col_treat, y = row_treat)) +
    geom_tile(aes(fill = fill_val), color = "white", linewidth = 0.8) +
    geom_text(
      aes(label = label, fontface = ifelse(sig, "bold", "plain")),
      size = cell_font_size, color = "black"
    ) +
    scale_fill_gradient2(
      low = "#2166AC", mid = "white", high = "#B2182B",
      midpoint = 0,
      limits = c(-fill_limit, fill_limit),
      name = if (is_ratio) paste0("log(", sm, ")") else sm
    ) +
    scale_x_discrete(position = "top") +
    labs(
      title = "League Table Heatmap",
      subtitle = paste0(
        "Effect estimates (", sm, " with 95% CI). ",
        "Bold = statistically significant. ",
        "Blue = favors row; Red = favors column."
      ),
      x = NULL, y = NULL
    ) +
    theme_minimal(base_size = 12) +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 0, face = "bold"),
      axis.text.y = element_text(face = "bold"),
      panel.grid   = element_blank(),
      plot.title   = element_text(face = "bold", size = 14),
      plot.subtitle = element_text(size = 9, color = "grey40"),
      legend.position = "right"
    )

  # Scale figure dimensions to treatment count
  fig_size <- max(6, n_treats * 1.4)
  ggsave(
    file.path(TBL_DIR, "league_table_heatmap.png"),
    plot = p_heatmap, width = fig_size, height = fig_size * 0.85,
    dpi = FIG_DPI, bg = "white"
  )
  cat("League table heatmap saved to", file.path(TBL_DIR, "league_table_heatmap.png"), "\n")
} else {
  cat("⚠️ Could not parse league matrix cells — heatmap skipped.\n")
}

# --- 2. Summary table: all treatments vs reference ---
ref_treat <- net_re$reference.group
if (is.null(ref_treat)) {
  ref_treat <- sort(net_re$trts)[1]
}

# Extract pairwise estimates vs reference
treatments <- sort(net_re$trts)
treatments <- treatments[treatments != ref_treat]

summary_data <- data.frame(
  Treatment = treatments,
  stringsAsFactors = FALSE
)

for (i in seq_along(treatments)) {
  idx <- which(net_re$trts == treatments[i])
  ref_idx <- which(net_re$trts == ref_treat)

  # Random-effects estimates
  te <- net_re$TE.random[idx, ref_idx]
  lower <- net_re$lower.random[idx, ref_idx]
  upper <- net_re$upper.random[idx, ref_idx]

  sm <- net_re$sm
  if (sm %in% c("RR", "OR", "HR")) {
    summary_data$Estimate[i] <- sprintf("%.2f (%.2f-%.2f)", exp(te), exp(lower), exp(upper))
  } else {
    summary_data$Estimate[i] <- sprintf("%.2f (%.2f-%.2f)", te, lower, upper)
  }
}

# Add P-scores
pscore <- ranking$Pscore.random
summary_data$P_score <- sapply(treatments, function(t) round(pscore[t], 3))
summary_data$Rank <- rank(-summary_data$P_score)

# Sort by rank
summary_data <- summary_data[order(summary_data$Rank), ]

cat("\n--- NMA Summary Table ---\n")
print(summary_data)

# --- 3. Export as gt table (PNG) ---
summary_gt <- summary_data %>%
  gt() %>%
  tab_header(
    title = "Network Meta-Analysis Summary",
    subtitle = paste("All treatments vs", ref_treat, "(random-effects model)")
  ) %>%
  cols_label(
    Treatment = "Treatment",
    Estimate  = paste0(net_re$sm, " (95% CI)"),
    P_score   = "P-score",
    Rank      = "Rank"
  ) %>%
  tab_style(
    style = cell_fill(color = "#e8f4f8"),
    locations = cells_body(rows = Rank == 1)
  ) %>%
  tab_footnote(
    footnote = paste("Random-effects model (REML). Effect measure:", net_re$sm),
    locations = cells_column_labels(columns = Estimate)
  ) %>%
  tab_footnote(
    footnote = "P-score: probability of being the best treatment (0-1)",
    locations = cells_column_labels(columns = P_score)
  )

gtsave(summary_gt, file.path(TBL_DIR, "nma_summary.png"), expand = 10)
cat("Summary table saved to", file.path(TBL_DIR, "nma_summary.png"), "\n")

# --- 4. Export as flextable (DOCX-compatible) ---
summary_ft <- flextable(summary_data) %>%
  set_header_labels(
    Treatment = "Treatment",
    Estimate  = paste0(net_re$sm, " (95% CI)"),
    P_score   = "P-score",
    Rank      = "Rank"
  ) %>%
  theme_vanilla() %>%
  autofit()

save_as_image(summary_ft, file.path(TBL_DIR, "nma_summary_ft.png"), res = FIG_DPI)
cat("Flextable version saved to", file.path(TBL_DIR, "nma_summary_ft.png"), "\n")

# --- 5. Save all tables as CSV ---
write_csv(summary_data, file.path(TBL_DIR, "nma_summary.csv"))
cat("\nAll NMA tables exported to", TBL_DIR, "\n")
