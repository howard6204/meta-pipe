# ==============================================================================
# HIV PrEP Network Meta-Analysis
# Script 01: Environment Setup and Data Import
# Date: 2026-03-28
# ==============================================================================

# --- Package Installation (run once) -----------------------------------------
# if (!require("pacman")) install.packages("pacman")
# pacman::p_load(netmeta, gemtc, igraph, ggplot2, dplyr, tidyr,
#                readr, knitr, meta, metafor, BUGSnet, rjags)

library(netmeta)
library(dplyr)
library(tidyr)
library(readr)
library(ggplot2)

# --- Load Extraction Data -----------------------------------------------
dat <- read_csv("../05_extraction/extraction.csv")

# --- Prepare NMA-format data -------------------------------------------
# Each row = one study arm
# Required columns: study, treatment, HIV_events, person_years

nma_dat <- dat %>%
  filter(final_decision == "include" | is.na(final_decision)) %>%
  filter(!grepl("PREVENIR", trial_name)) %>%  # exclude observational
  select(
    study       = trial_name,
    study_id    = study_id,
    treatment   = intervention,
    events      = hiv_events,
    person_time = person_years,
    n           = n_analyzed,
    pop         = population,
    sensitivity = sensitivity_flag
  ) %>%
  mutate(
    # Harmonize treatment labels
    treatment = case_when(
      grepl("TDF/FTC daily", treatment, ignore.case = TRUE) ~ "TDF_FTC",
      grepl("TAF/FTC daily", treatment, ignore.case = TRUE) ~ "TAF_FTC",
      grepl("TDF daily", treatment, ignore.case = TRUE) & !grepl("FTC", treatment) ~ "TDF_mono",
      grepl("on-demand", treatment, ignore.case = TRUE) ~ "TDF_FTC_OD",
      grepl("CAB-LA|Cabotegravir", treatment, ignore.case = TRUE) ~ "CAB_LA",
      grepl("Lenacapavir|twice-yearly", treatment, ignore.case = TRUE) ~ "LEN",
      grepl("Dapivirine|vaginal ring", treatment, ignore.case = TRUE) ~ "DVR",
      grepl("Placebo|Deferred|standard care", treatment, ignore.case = TRUE) ~ "PBO",
      TRUE ~ treatment
    ),
    # Study name (short label)
    study_label = case_when(
      grepl("iPrEx", study) ~ "iPrEx 2010",
      grepl("Partners PrEP", study) ~ "Partners PrEP 2012",
      grepl("TDF2", study) ~ "TDF2 2012",
      grepl("FEM-PrEP", study) ~ "FEM-PrEP 2012",
      grepl("VOICE", study) ~ "VOICE 2015",
      grepl("IPERGAY", study) ~ "IPERGAY 2015",
      grepl("PROUD", study) ~ "PROUD 2016",
      grepl("ASPIRE", study) ~ "ASPIRE 2016",
      grepl("Ring Study", study) ~ "Ring Study 2016",
      grepl("DISCOVER", study) ~ "DISCOVER 2020",
      grepl("HPTN 083", study) ~ "HPTN 083 2021",
      grepl("HPTN 084", study) ~ "HPTN 084 2022",
      grepl("PURPOSE 1", study) ~ "PURPOSE 1 2024",
      grepl("PURPOSE 2", study) ~ "PURPOSE 2 2024",
      TRUE ~ study
    ),
    # Incidence rate (per 100 person-years)
    rate = (events / person_time) * 100,
    # Continuity correction for zero events (PURPOSE 1 LEN arm)
    events_cc = ifelse(events == 0, 0.5, events),
    person_time_cc = ifelse(events == 0, person_time + 0.5/rate_reference, person_time)
  )

# Save processed data
write_csv(nma_dat, "nma_dat_processed.csv")

cat("Data loaded:", nrow(nma_dat), "arms from", n_distinct(nma_dat$study_label), "trials\n")
cat("Treatments:", paste(sort(unique(nma_dat$treatment)), collapse = ", "), "\n")
