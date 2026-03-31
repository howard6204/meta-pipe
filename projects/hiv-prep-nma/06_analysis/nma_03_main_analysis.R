# ==============================================================================
# HIV PrEP Network Meta-Analysis
# Script 03: Main NMA and League Table
# Date: 2026-03-28
# ==============================================================================

library(netmeta)
library(dplyr)
library(readr)
library(ggplot2)
library(knitr)

source("nma_02_network_plot.R")  # loads `net` and `pairs`

# --- Main NMA Results --------------------------------------------------------

# Summary of NMA
cat("\n=== MAIN NMA RESULTS (vs Placebo) ===\n")
results_vs_pbo <- data.frame(
  treatment     = rownames(net$TE.random),
  logIRR        = net$TE.random[, "PBO"],
  lower         = net$lower.random[, "PBO"],
  upper         = net$upper.random[, "PBO"],
  p_value       = net$pval.random[, "PBO"]
) %>%
  filter(treatment != "PBO") %>%
  mutate(
    IRR       = exp(logIRR),
    IRR_lower = exp(lower),
    IRR_upper = exp(upper),
    efficacy  = paste0(round((1 - IRR) * 100, 0), "%"),
    ci_95     = paste0(round((1 - IRR_upper) * 100, 0), "% to ",
                       round((1 - IRR_lower) * 100, 0), "%")
  ) %>%
  arrange(IRR)

print(results_vs_pbo %>%
  select(treatment, IRR, IRR_lower, IRR_upper, efficacy, ci_95, p_value),
  digits = 3)

# --- League Table -----------------------------------------------------------
cat("\n=== LEAGUE TABLE ===\n")
league <- netleague(net, digits = 2, bracket = "(", separator = " to ")
print(league)

# Save league table
capture.output(print(league), file = "../tables/league_table.txt")

# --- SUCRA Rankings ---------------------------------------------------------
rank_results <- netrank(net, small.values = "good")
cat("\n=== SUCRA RANKINGS (HIV incidence; higher SUCRA = better) ===\n")
print(rank_results)

# --- Forest Plot (NMA estimates vs Placebo) ---------------------------------
png("../figures/nma_forest_vs_placebo.png", width = 3000, height = 2000, res = 300)
forest(
  net,
  reference.group = "PBO",
  sortvar         = "TE",
  smlab           = "Incidence Rate Ratio (vs Placebo)",
  leftcols        = c("studlab"),
  rightcols       = c("effect", "ci"),
  col.square      = "steelblue4",
  col.inside      = "white",
  digits          = 2,
  xlab            = "IRR (< 1 favors intervention)"
)
dev.off()

# --- Heterogeneity Summary -------------------------------------------------
cat("\n=== HETEROGENEITY ===\n")
cat("tau (between-study SD):", round(net$tau, 4), "\n")
cat("I^2 (%):", round(net$I2 * 100, 1), "\n")
cat("Q statistic:", round(net$Q, 2), "df =", net$df.Q, "p =", round(net$pval.Q, 4), "\n")

# Save results table
write_csv(results_vs_pbo, "../tables/nma_results_vs_placebo.csv")
cat("\nResults saved to ../tables/nma_results_vs_placebo.csv\n")
