# =============================================================================
# nma_09_pims_data_prep.R — Data Preparation for PIMs Outcome (NMA-2)
# =============================================================================
# Outcome : Potentially Inappropriate Medications (PIMs) reduction
# Measure : RR (proportion of patients with ≥1 PIM reduced)
# Subgroup: European vs. Asian studies
# PIM criteria tracked: Beers, STOPP/START, EU(7)-PIM, Japanese, Taiwan
# =============================================================================

source("nma_01_setup.R")

# =============================================================================
# SECTION A: Synthetic placeholder PIMs data — REPLACE with real extraction
# =============================================================================
# Columns:
#   study       — AuthorYear
#   treatment   — node label
#   responders  — patients achieving ≥1 PIM reduction (or PIM count reduction)
#   sampleSize  — arm total
#   setting     — "Institutionalized" or "Community"
#   region      — "European" or "Asian" (primary stratification for NMA-2)
#   pim_criteria— Beers / STOPP-START / EU7-PIM / Japanese / Taiwan / Other

raw_pims <- data.frame(
  study = c(
    # --- European studies ---
    "Schmidt2017",   "Schmidt2017",    # Pharmacist vs UC (EU)
    "Mueller2018",   "Mueller2018",    # MDT vs UC (EU)
    "Verdoorn2019",  "Verdoorn2019",   # CDSS vs UC (EU)
    "Sevilla2020",   "Sevilla2020",    # Deprescribing vs UC (EU)
    "Renom2021",     "Renom2021",      # MDT vs Pharmacist (EU)
    "Patterson2022", "Patterson2022",  # CDSS vs UC (EU)
    "Dills2018",     "Dills2018",      # Pharmacist vs UC (EU)
    # --- Asian studies ---
    "Lim2018",       "Lim2018",        # Pharmacist vs UC (AS)
    "Zhang2019",     "Zhang2019",      # MDT vs UC (AS)
    "Huang2020",     "Huang2020",      # CDSS vs UC (AS)
    "Park2021",      "Park2021",       # Deprescribing vs UC (AS)
    "Nakamura2019",  "Nakamura2019",   # Pharmacist vs UC (AS)
    "Chen2022",      "Chen2022"        # MDT vs UC (AS)
  ),
  treatment = c(
    "Pharmacist",    "UC",
    "MDT",           "UC",
    "CDSS",          "UC",
    "Deprescribing", "UC",
    "MDT",           "Pharmacist",
    "CDSS",          "UC",
    "Pharmacist",    "UC",
    "Pharmacist",    "UC",
    "MDT",           "UC",
    "CDSS",          "UC",
    "Deprescribing", "UC",
    "Pharmacist",    "UC",
    "MDT",           "UC"
  ),
  responders = c(
    # European — REPLACE with extracted counts
    60, 40,   # Schmidt2017
    55, 35,   # Mueller2018
    48, 30,   # Verdoorn2019
    50, 38,   # Sevilla2020
    62, 52,   # Renom2021
    45, 28,   # Patterson2022
    58, 42,   # Dills2018
    # Asian — REPLACE with extracted counts
    52, 38,   # Lim2018
    58, 40,   # Zhang2019
    44, 30,   # Huang2020
    46, 35,   # Park2021
    50, 36,   # Nakamura2019
    60, 42    # Chen2022
  ),
  sampleSize = c(
    100, 98,
    110, 112,
    105, 100,
    120, 118,
    115, 110,
    108, 105,
    125, 122,
    102, 100,
    118, 115,
    112, 110,
    125, 120,
    108, 105,
    130, 128
  ),
  setting = c(
    "Community",         "Community",
    "Institutionalized", "Institutionalized",
    "Community",         "Community",
    "Community",         "Community",
    "Institutionalized", "Institutionalized",
    "Community",         "Community",
    "Community",         "Community",
    "Community",         "Community",
    "Institutionalized", "Institutionalized",
    "Community",         "Community",
    "Community",         "Community",
    "Community",         "Community",
    "Institutionalized", "Institutionalized"
  ),
  region = c(
    "European", "European",
    "European", "European",
    "European", "European",
    "European", "European",
    "European", "European",
    "European", "European",
    "European", "European",
    "Asian",    "Asian",
    "Asian",    "Asian",
    "Asian",    "Asian",
    "Asian",    "Asian",
    "Asian",    "Asian",
    "Asian",    "Asian"
  ),
  pim_criteria = c(
    "STOPP-START", "STOPP-START",
    "STOPP-START", "STOPP-START",
    "EU7-PIM",     "EU7-PIM",
    "STOPP-START", "STOPP-START",
    "STOPP-START", "STOPP-START",
    "EU7-PIM",     "EU7-PIM",
    "STOPP-START", "STOPP-START",
    "Beers",       "Beers",
    "Beers",       "Beers",
    "Japanese",    "Japanese",
    "Beers",       "Beers",
    "Japanese",    "Japanese",
    "Taiwan",      "Taiwan"
  ),
  stringsAsFactors = FALSE
)

# =============================================================================
# SECTION B: Contrast-based data for NMA
# =============================================================================

arm_to_contrast_pims <- function(df_arm) {
  studies <- unique(df_arm$study)
  rows <- lapply(studies, function(s) {
    arms <- df_arm[df_arm$study == s, ]
    if (nrow(arms) < 2) return(NULL)

    ref_arm <- if ("UC" %in% arms$treatment) {
      arms[arms$treatment == "UC", ]
    } else {
      arms[1, , drop = FALSE]
    }

    act_arms <- arms[arms$treatment != ref_arm$treatment, ]

    lapply(seq_len(nrow(act_arms)), function(i) {
      a <- act_arms[i, ]
      r <- ref_arm

      p1   <- (a$responders + 0.5) / (a$sampleSize + 0.5)
      p2   <- (r$responders + 0.5) / (r$sampleSize + 0.5)
      logRR <- log(p1 / p2)
      seRR  <- sqrt(1/a$responders - 1/a$sampleSize +
                    1/r$responders - 1/r$sampleSize)

      data.frame(
        study        = s,
        treat1       = a$treatment,
        treat2       = r$treatment,
        TE           = logRR,
        seTE         = seRR,
        setting      = a$setting,
        region       = a$region,
        pim_criteria = a$pim_criteria,
        stringsAsFactors = FALSE
      )
    })
  })

  do.call(rbind, Filter(Negate(is.null), unlist(rows, recursive = FALSE)))
}

nma_pims_all      <- arm_to_contrast_pims(raw_pims)
nma_pims_european <- nma_pims_all[nma_pims_all$region == "European", ]
nma_pims_asian    <- nma_pims_all[nma_pims_all$region == "Asian",    ]

cat("\n--- PIMs NMA: All studies ---\n")
print(nma_pims_all[, c("study","treat1","treat2","TE","seTE","region","pim_criteria")])
cat("\n--- PIMs NMA: European ---\n")
print(nma_pims_european[, c("study","treat1","treat2","TE","seTE","pim_criteria")])
cat("\n--- PIMs NMA: Asian ---\n")
print(nma_pims_asian[, c("study","treat1","treat2","TE","seTE","pim_criteria")])

# Save
write_csv(nma_pims_all,      file.path(TBL_DIR, "nma_pims_all_contrast.csv"))
write_csv(nma_pims_european, file.path(TBL_DIR, "nma_pims_european_contrast.csv"))
write_csv(nma_pims_asian,    file.path(TBL_DIR, "nma_pims_asian_contrast.csv"))
write_csv(raw_pims,          file.path(TBL_DIR, "raw_pims_arm_data.csv"))

cat("\nPIMs data preparation complete.\n")
