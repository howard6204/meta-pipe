library(dplyr)
library(readr)
library(metafor)

# Expected columns in extraction.csv
# study_id, outcome_id, arm_label, n, mean, sd, events, total, outcome_type

extraction_path <- "../05_extraction/extraction.csv"
stopifnot(
  "extraction.csv not found — run data extraction (Stage 05) first" =
    file.exists(extraction_path)
)

raw <- read_csv(extraction_path, show_col_types = FALSE)

# Validate required columns
required_cols <- c("study_id", "outcome_type")
missing_cols <- setdiff(required_cols, names(raw))
if (length(missing_cols) > 0) {
  stop("Missing required columns: ", paste(missing_cols, collapse = ", "),
       "\nExpected: study_id, outcome_id, arm_label, n, mean, sd, events, total, outcome_type")
}

cat("Extraction loaded:", nrow(raw), "rows,", length(unique(raw$study_id)), "studies\n")
cat("Outcome types:", paste(unique(raw$outcome_type), collapse = ", "), "\n")

continuous <- raw %>%
  filter(outcome_type == "continuous") %>%
  group_by(study_id, outcome_id) %>%
  mutate(arm_order = row_number()) %>%
  ungroup()

if (nrow(continuous) > 0) {
  # Validate continuous-specific columns
  cont_required <- c("mean", "sd", "n")
  cont_missing <- setdiff(cont_required, names(continuous))
  if (length(cont_missing) > 0) {
    warning("Missing columns for continuous outcomes: ",
            paste(cont_missing, collapse = ", "), " — skipping continuous ES.")
  } else {
    cont_pairs <- continuous %>%
      group_by(study_id, outcome_id) %>%
      filter(n() == 2) %>%
      ungroup()

    if (nrow(cont_pairs) > 0) {
      cont_es <- escalc(
        measure = "SMD",
        m1i = cont_pairs$mean[cont_pairs$arm_order == 1],
        sd1i = cont_pairs$sd[cont_pairs$arm_order == 1],
        n1i = cont_pairs$n[cont_pairs$arm_order == 1],
        m2i = cont_pairs$mean[cont_pairs$arm_order == 2],
        sd2i = cont_pairs$sd[cont_pairs$arm_order == 2],
        n2i = cont_pairs$n[cont_pairs$arm_order == 2],
        slab = cont_pairs$study_id[cont_pairs$arm_order == 1]
      )
      cat("Continuous effect sizes computed:", nrow(cont_es), "comparisons (SMD)\n")
    } else {
      cat("No paired continuous data found (need exactly 2 arms per study/outcome).\n")
    }
  }
} else {
  cat("No continuous outcomes in extraction data.\n")
}

binary <- raw %>%
  filter(outcome_type == "binary") %>%
  group_by(study_id, outcome_id) %>%
  mutate(arm_order = row_number()) %>%
  ungroup()

if (nrow(binary) > 0) {
  # Validate binary-specific columns
  bin_required <- c("events", "total")
  bin_missing <- setdiff(bin_required, names(binary))
  if (length(bin_missing) > 0) {
    warning("Missing columns for binary outcomes: ",
            paste(bin_missing, collapse = ", "), " — skipping binary ES.")
  } else {
    bin_pairs <- binary %>%
      group_by(study_id, outcome_id) %>%
      filter(n() == 2) %>%
      ungroup()

    if (nrow(bin_pairs) > 0) {
      bin_es <- escalc(
        measure = "RR",
        ai = bin_pairs$events[bin_pairs$arm_order == 1],
        n1i = bin_pairs$total[bin_pairs$arm_order == 1],
        ci = bin_pairs$events[bin_pairs$arm_order == 2],
        n2i = bin_pairs$total[bin_pairs$arm_order == 2],
        slab = bin_pairs$study_id[bin_pairs$arm_order == 1]
      )
      cat("Binary effect sizes computed:", nrow(bin_es), "comparisons (RR)\n")
    } else {
      cat("No paired binary data found (need exactly 2 arms per study/outcome).\n")
    }
  }
} else {
  cat("No binary outcomes in extraction data.\n")
}

# Summary
if (!exists("cont_es") && !exists("bin_es")) {
  warning("No effect sizes computed. Check extraction.csv format and outcome_type values.")
}
