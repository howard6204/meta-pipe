# ==============================================================================
# HIV PrEP Network Meta-Analysis
# Script 02: Network Geometry Plot
# Date: 2026-03-28
# ==============================================================================

library(netmeta)
library(ggplot2)
library(dplyr)
library(readr)

# Load processed data
nma_dat <- read_csv("nma_dat_processed.csv")

# --- Prepare pairwise comparison data for netmeta ----------------------------
# netmeta requires pairwise contrasts
# Use incidence rate ratio (IRR) approach

# For rate data, compute log(IRR) and SE for each pair within studies
# Using Poisson approximation: log(rate1/rate2), SE = sqrt(1/e1 + 1/e2)

pair_dat <- nma_dat %>%
  group_by(study_label) %>%
  arrange(study_label, treatment) %>%
  mutate(arm_index = row_number()) %>%
  ungroup()

# Create all pairwise combinations within studies
pairs <- pair_dat %>%
  group_by(study_label) %>%
  do({
    arms <- .
    if (nrow(arms) >= 2) {
      combns <- combn(nrow(arms), 2, simplify = FALSE)
      lapply(combns, function(idx) {
        a <- arms[idx[1], ]
        b <- arms[idx[2], ]
        # log IRR: log(rate_a / rate_b), using continuity-corrected events
        e_a <- pmax(a$events, 0.5)
        e_b <- pmax(b$events, 0.5)
        log_irr <- log(e_a / a$person_time) - log(e_b / b$person_time)
        se_log_irr <- sqrt(1/e_a + 1/e_b)
        data.frame(
          studlab  = a$study_label,
          treat1   = a$treatment,
          treat2   = b$treatment,
          TE       = log_irr,       # log(IRR): positive = treat1 worse
          seTE     = se_log_irr,
          population = a$pop,
          sensitivity = a$sensitivity,
          stringsAsFactors = FALSE
        )
      }) %>% bind_rows()
    } else {
      NULL
    }
  }) %>%
  ungroup()

# Run network meta-analysis
net <- netmeta(
  TE       = TE,
  seTE     = seTE,
  treat1   = treat1,
  treat2   = treat2,
  studlab  = studlab,
  data     = pairs,
  reference.group = "PBO",
  sm       = "IRR",
  random   = TRUE,
  fixed    = FALSE,
  details.chkmultiarm = FALSE
)

# --- Network Geometry Plot ---------------------------------------------------
png("../figures/network_plot.png", width = 2400, height = 2400, res = 300)
netgraph(
  net,
  plastic     = FALSE,
  thickness   = "number.of.studies",
  col         = "steelblue4",
  col.highlight = "firebrick",
  highlight   = "PBO",
  cex         = 1.4,
  cex.points  = 5,
  labels      = c(
    "PBO"       = "Placebo",
    "TDF_FTC"   = "TDF/FTC\n(daily)",
    "TAF_FTC"   = "TAF/FTC\n(daily)",
    "TDF_mono"  = "TDF\n(mono)",
    "TDF_FTC_OD"= "TDF/FTC\n(on-demand)",
    "CAB_LA"    = "CAB-LA",
    "LEN"       = "Lenacapavir",
    "DVR"       = "Dapivirine\nRing"
  ),
  main        = "Network of HIV PrEP Interventions\n(node size = studies; edge width = comparisons)"
)
dev.off()
cat("Network plot saved to ../figures/network_plot.png\n")

# Print network summary
print(net, digits = 2)
