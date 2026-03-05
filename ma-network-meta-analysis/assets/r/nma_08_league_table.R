# =============================================================================
# nma_08_league_table.R — League Table: All Pairwise Comparisons
# =============================================================================
# Purpose: Build the full n×n league table from Bayesian (primary) and
#          frequentist (sensitivity) NMA models. Export as CSV, PNG, HTML.
# Input:   bayes_re from nma_04_models.R (gemtc), net_re (netmeta)
# Output:  tables/league_table.csv, tables/league_table.png,
#          tables/league_table.html, tables/league_table_frequentist.csv
# =============================================================================

source("nma_04_models.R")

library(gt)

# =============================================================================
# SECTION A: BAYESIAN LEAGUE TABLE (PRIMARY — gemtc)
# =============================================================================

cat("=== Building Bayesian League Table ===\n")

treatments <- sort(network$treatments$id)
n_treat    <- length(treatments)

# Build n×n matrix: cell [i, j] = effect of treatment i vs treatment j
league_matrix <- matrix(NA_character_,
                        nrow = n_treat, ncol = n_treat,
                        dimnames = list(treatments, treatments))

for (ref in treatments) {
  rel <- relative.effect(bayes_re, t1 = ref)
  rel_summary <- summary(rel)

  # Extract posterior quantiles (median, 2.5%, 97.5%)
  stats <- rel_summary$summaries$quantiles

  for (comp in treatments) {
    if (comp == ref) next
    row_name <- paste0("d.", ref, ".", comp)
    if (!(row_name %in% rownames(stats))) next

    median_val <- stats[row_name, "50%"]
    lower_val  <- stats[row_name, "2.5%"]
    upper_val  <- stats[row_name, "97.5%"]

    # Exponentiate if ratio measure (RR, OR, HR)
    sm <- net_re$sm
    if (sm %in% c("RR", "OR", "HR")) {
      league_matrix[comp, ref] <- sprintf("%.2f (%.2f-%.2f)",
                                          exp(median_val),
                                          exp(lower_val),
                                          exp(upper_val))
    } else {
      league_matrix[comp, ref] <- sprintf("%.2f (%.2f-%.2f)",
                                          median_val, lower_val, upper_val)
    }
  }
}

# Diagonal: treatment names
diag(league_matrix) <- treatments

cat("Bayesian league table (", n_treat, "×", n_treat, "):\n")
print(league_matrix)

# Convert to data frame for export
league_df <- as.data.frame(league_matrix)

write.csv(league_df, file.path(TBL_DIR, "league_table.csv"), row.names = TRUE)
cat("League table CSV saved to", file.path(TBL_DIR, "league_table.csv"), "\n")

# --- Export as gt table (PNG + HTML) ---
league_gt <- league_df %>%
  tibble::rownames_to_column("Treatment") %>%
  gt() %>%
  tab_header(
    title = "League Table: All Pairwise Comparisons",
    subtitle = paste("Bayesian NMA —", sm, "(95% CrI)")
  ) %>%
  tab_footnote(
    footnote = paste0(
      "Read across rows vs column headers. ",
      if (sm %in% c("RR", "OR", "HR"))
        paste0(sm, " > 1 favours column treatment. ")
      else
        paste0("Positive values favour column treatment. "),
      "Posterior medians with 95% credible intervals."
    )
  ) %>%
  tab_style(
    style = cell_fill(color = "#f0f0f0"),
    locations = cells_body(
      columns = everything(),
      rows = seq(1, n_treat, 2)
    )
  ) %>%
  tab_style(
    style = cell_text(weight = "bold"),
    locations = cells_body(
      columns = everything(),
      rows = sapply(seq_len(n_treat), function(i) {
        league_df[i, i] == treatments[i]
      })
    )
  )

gtsave(league_gt, file.path(TBL_DIR, "league_table.png"), expand = 10)
gtsave(league_gt, file.path(TBL_DIR, "league_table.html"))
cat("League table PNG saved to", file.path(TBL_DIR, "league_table.png"), "\n")
cat("League table HTML saved to", file.path(TBL_DIR, "league_table.html"), "\n")

# =============================================================================
# SECTION B: FREQUENTIST LEAGUE TABLE (SENSITIVITY — netmeta)
# =============================================================================

cat("\n=== Building Frequentist League Table (Sensitivity) ===\n")

ranking_freq <- netrank(net_re, small.values = "undesirable")
league_freq  <- netleague(net_re, random = TRUE, seq = ranking_freq, digits = 2)

league_freq_df <- as.data.frame(league_freq$random)
write.csv(league_freq_df, file.path(TBL_DIR, "league_table_frequentist.csv"),
          row.names = TRUE)
cat("Frequentist league table saved to",
    file.path(TBL_DIR, "league_table_frequentist.csv"), "\n")

# =============================================================================
# SECTION C: CONCORDANCE CHECK
# =============================================================================

cat("\n=== Bayesian vs Frequentist Concordance ===\n")
cat("Compare league_table.csv (Bayesian) with league_table_frequentist.csv.\n")
cat("If rankings and effect directions agree, report concordance in manuscript.\n")
cat("If they disagree, investigate and report both in sensitivity analysis.\n")

cat("\nLeague table generation complete.\n")
