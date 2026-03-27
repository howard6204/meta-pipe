# =============================================================================
# nma_02_data_prep.R — Data Preparation (Falls & Hospitalization)
# =============================================================================
# Replace the synthetic placeholder data with real extracted data before
# running analyses. Each row = one study arm.
# =============================================================================

source("nma_01_setup.R")

# =============================================================================
# SECTION A: Synthetic placeholder data (replace with real extraction)
# =============================================================================
# Format: arm-based, binary events
# Columns:
#   study     — unique study identifier (AuthorYear format)
#   treatment — node label (must match TREATMENT_LABELS keys)
#   responders— number of events (falls or hospitalizations)
#   sampleSize— total participants in that arm
#   setting   — "Institutionalized" or "Community" (for subgroup)
#   region    — "European", "Asian", "NorthAmerican", etc.

raw_falls <- data.frame(
  study      = c(
    # --- Study 1: Pharmacist vs UC (Community) ---
    "Smith2018",    "Smith2018",
    # --- Study 2: MDT vs UC (Institutionalized) ---
    "Jones2019",    "Jones2019",
    # --- Study 3: CDSS vs UC (Community) ---
    "Lee2020",      "Lee2020",
    # --- Study 4: Deprescribing vs UC (Community) ---
    "Brown2021",    "Brown2021",
    # --- Study 5: MDT vs Pharmacist (Institutionalized) ---
    "Garcia2017",   "Garcia2017",
    # --- Study 6: Pharmacist vs UC (Institutionalized) ---
    "Wang2022",     "Wang2022",
    # --- Study 7: CDSS vs UC (Institutionalized) ---
    "Kim2020",      "Kim2020",
    # --- Study 8: Deprescribing vs UC (Institutionalized) ---
    "Chen2019",     "Chen2019",
    # --- Study 9: MDT vs UC (Community) ---
    "Taylor2021",   "Taylor2021",
    # --- Study 10: CDSS vs Deprescribing (Community) ---
    "Wilson2023",   "Wilson2023"
  ),
  treatment  = c(
    "Pharmacist", "UC",
    "MDT",        "UC",
    "CDSS",       "UC",
    "Deprescribing","UC",
    "MDT",        "Pharmacist",
    "Pharmacist", "UC",
    "CDSS",       "UC",
    "Deprescribing","UC",
    "MDT",        "UC",
    "CDSS",       "Deprescribing"
  ),
  responders = c(
    # REPLACE with real extracted data
    35, 55,
    28, 52,
    40, 58,
    22, 48,
    25, 38,
    18, 40,
    30, 50,
    15, 35,
    33, 55,
    42, 38
  ),
  sampleSize = c(
    120, 118,
    100, 102,
    130, 128,
    115, 112,
    110, 108,
     95,  98,
    125, 122,
    105, 100,
    140, 138,
    115, 118
  ),
  setting = c(
    "Community",       "Community",
    "Institutionalized","Institutionalized",
    "Community",       "Community",
    "Community",       "Community",
    "Institutionalized","Institutionalized",
    "Institutionalized","Institutionalized",
    "Institutionalized","Institutionalized",
    "Institutionalized","Institutionalized",
    "Community",       "Community",
    "Community",       "Community"
  ),
  region = c(
    "European", "European",
    "European", "European",
    "Asian",    "Asian",
    "NorthAmerican","NorthAmerican",
    "European", "European",
    "Asian",    "Asian",
    "Asian",    "Asian",
    "Asian",    "Asian",
    "European", "European",
    "NorthAmerican","NorthAmerican"
  ),
  stringsAsFactors = FALSE
)

# =============================================================================
# SECTION B: Same structure for Hospitalization outcome
# =============================================================================
# (Replace responders/sampleSize with hospitalization-specific extraction)

raw_hosp <- raw_falls  # Placeholder — replace with hospitalization event counts
raw_hosp$responders <- c(
  20, 38, 15, 35, 22, 40, 12, 30,
  18, 28, 10, 25, 17, 32,  8, 20,
  21, 38, 25, 22
)

# =============================================================================
# SECTION C: Compute contrast-based data (log RR ± SE)
# =============================================================================

arm_to_contrast <- function(df_arm, label = "outcome") {
  studies <- unique(df_arm$study)
  rows <- lapply(studies, function(s) {
    arms <- df_arm[df_arm$study == s, ]
    if (nrow(arms) < 2) return(NULL)

    # Reference arm: UC if present, otherwise first arm
    ref_arm <- if ("UC" %in% arms$treatment) {
      arms[arms$treatment == "UC", ]
    } else {
      arms[1, , drop = FALSE]
    }

    # Active arms
    act_arms <- arms[arms$treatment != ref_arm$treatment, ]

    lapply(seq_len(nrow(act_arms)), function(i) {
      a <- act_arms[i, ]
      r <- ref_arm

      # Log RR
      p1 <- (a$responders + 0.5) / (a$sampleSize + 0.5)
      p2 <- (r$responders + 0.5) / (r$sampleSize + 0.5)
      logRR <- log(p1 / p2)
      seRR  <- sqrt(1/a$responders - 1/a$sampleSize +
                    1/r$responders - 1/r$sampleSize)

      data.frame(
        study    = s,
        treat1   = a$treatment,
        treat2   = r$treatment,
        TE       = logRR,
        seTE     = seRR,
        setting  = a$setting,
        region   = a$region,
        outcome  = label,
        stringsAsFactors = FALSE
      )
    })
  })

  do.call(rbind, Filter(Negate(is.null), unlist(rows, recursive = FALSE)))
}

nma_falls <- arm_to_contrast(raw_falls, "falls")
nma_hosp  <- arm_to_contrast(raw_hosp,  "hospitalization")

# Validate
stopifnot(nrow(nma_falls) > 0, nrow(nma_hosp) > 0)

cat("\n--- Falls contrast data ---\n")
print(nma_falls[, c("study","treat1","treat2","TE","seTE","setting")])

cat("\n--- Hospitalization contrast data ---\n")
print(nma_hosp[, c("study","treat1","treat2","TE","seTE","setting")])

# Save
write_csv(nma_falls, file.path(TBL_DIR, "nma_falls_contrast_data.csv"))
write_csv(nma_hosp,  file.path(TBL_DIR, "nma_hosp_contrast_data.csv"))
write_csv(raw_falls, file.path(TBL_DIR, "raw_falls_arm_data.csv"))
write_csv(raw_hosp,  file.path(TBL_DIR, "raw_hosp_arm_data.csv"))

cat("\nData preparation complete.\n")
