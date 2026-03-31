# ==============================================================================
# HIV PrEP Network Meta-Analysis
# Script 05: SUCRA Ranking Plot (Rankogram)
# Date: 2026-03-28
# ==============================================================================

library(netmeta)
library(ggplot2)
library(dplyr)

source("nma_02_network_plot.R")  # loads `net`

# --- SUCRA -------------------------------------------------------------------
ranks <- netrank(net, small.values = "good")

sucra_df <- data.frame(
  treatment = names(ranks$ranking.random),
  SUCRA     = ranks$ranking.random
) %>%
  mutate(
    label = case_when(
      treatment == "PBO"        ~ "Placebo",
      treatment == "TDF_FTC"    ~ "TDF/FTC daily",
      treatment == "TAF_FTC"    ~ "TAF/FTC daily",
      treatment == "TDF_mono"   ~ "TDF monotherapy",
      treatment == "TDF_FTC_OD" ~ "TDF/FTC on-demand",
      treatment == "CAB_LA"     ~ "CAB-LA (injectable)",
      treatment == "LEN"        ~ "Lenacapavir (6-monthly)",
      treatment == "DVR"        ~ "Dapivirine ring",
      TRUE ~ treatment
    ),
    category = case_when(
      treatment == "LEN"     ~ "Long-acting injectable",
      treatment == "CAB_LA"  ~ "Long-acting injectable",
      treatment == "TAF_FTC" ~ "Daily oral",
      treatment == "TDF_FTC" ~ "Daily oral",
      treatment == "TDF_mono"~ "Daily oral",
      treatment == "TDF_FTC_OD" ~ "Event-driven oral",
      treatment == "DVR"     ~ "Vaginal ring",
      treatment == "PBO"     ~ "Control",
      TRUE ~ "Other"
    )
  ) %>%
  arrange(desc(SUCRA))

# Bar plot
p_sucra <- ggplot(sucra_df, aes(x = reorder(label, SUCRA), y = SUCRA,
                                 fill = category)) +
  geom_col(width = 0.7) +
  geom_text(aes(label = paste0(round(SUCRA * 100, 1), "%")),
            hjust = -0.1, size = 3.5) +
  coord_flip() +
  scale_fill_manual(values = c(
    "Long-acting injectable" = "#1b7837",
    "Daily oral"             = "#4393c3",
    "Event-driven oral"      = "#74add1",
    "Vaginal ring"           = "#d6604d",
    "Control"                = "grey70"
  )) +
  scale_y_continuous(limits = c(0, 1.1), labels = scales::percent) +
  labs(
    title    = "SUCRA Rankings: HIV PrEP Efficacy",
    subtitle = "Surface Under Cumulative Ranking curve (higher = better HIV prevention)",
    x        = NULL,
    y        = "SUCRA",
    fill     = "Modality"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title   = element_text(face = "bold"),
    legend.position = "bottom"
  )

ggsave("../figures/sucra_ranking.png", p_sucra,
       width = 10, height = 7, dpi = 300, bg = "white")
cat("SUCRA plot saved.\n")
print(sucra_df %>% select(label, SUCRA, category))
