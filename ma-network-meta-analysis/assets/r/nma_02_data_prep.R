# =============================================================================
# nma_02_data_prep.R — Data Preparation for Network Meta-Analysis
# =============================================================================
# Purpose: Read extraction CSV, reshape to NMA format, validate network data
# Input: 05_extraction/extraction.csv
# Output: nma_data (contrast-based data frame ready for netmeta)
# =============================================================================

source("nma_01_setup.R")

# --- 1. Read extraction data ---
extraction_path <- "../05_extraction/extraction.csv"
stopifnot(
  "extraction.csv not found — run data extraction (Stage 05) first" =
    file.exists(extraction_path)
)

extraction <- read_csv(extraction_path, show_col_types = FALSE)

cat("Studies loaded:", nrow(extraction), "\n")
cat("Columns:", paste(names(extraction), collapse = ", "), "\n")

# --- 2. Prepare NMA data (driven by NMA_DATA_FORMAT from nma_01_setup.R) ---
cat("\nData format:", NMA_DATA_FORMAT, "\n")
cat("Effect measure:", NMA_SM, "\n")

if (NMA_DATA_FORMAT == "contrast") {
  # Contrast-based: columns map to TE, seTE, treat1, treat2
  required_cols <- c(NMA_COL_STUDY, NMA_COL_TREAT1, NMA_COL_TREAT2,
                     NMA_COL_TE, NMA_COL_SETE)
  missing_cols <- setdiff(required_cols, names(extraction))
  if (length(missing_cols) > 0) {
    stop("Missing columns for contrast format: ",
         paste(missing_cols, collapse = ", "),
         "\nUpdate NMA_COL_* in nma_01_setup.R to match your extraction CSV.")
  }

  nma_data <- extraction %>%
    select(
      studlab = !!sym(NMA_COL_STUDY),
      treat1  = !!sym(NMA_COL_TREAT1),
      treat2  = !!sym(NMA_COL_TREAT2),
      TE      = !!sym(NMA_COL_TE),
      seTE    = !!sym(NMA_COL_SETE)
    ) %>%
    filter(!is.na(TE), !is.na(seTE))

} else if (NMA_DATA_FORMAT == "arm") {
  # Arm-based: use pairwise() to convert to contrast format
  required_cols <- c(NMA_COL_STUDY, NMA_COL_TREATMENT, NMA_COL_EVENTS, NMA_COL_TOTALN)
  missing_cols <- setdiff(required_cols, names(extraction))
  if (length(missing_cols) > 0) {
    stop("Missing columns for arm format: ",
         paste(missing_cols, collapse = ", "),
         "\nUpdate NMA_COL_* in nma_01_setup.R to match your extraction CSV.")
  }

  nma_data <- pairwise(
    treat   = extraction[[NMA_COL_TREATMENT]],
    event   = extraction[[NMA_COL_EVENTS]],
    n       = extraction[[NMA_COL_TOTALN]],
    studlab = extraction[[NMA_COL_STUDY]],
    data    = extraction,
    sm      = NMA_SM
  )

} else {
  stop("Invalid NMA_DATA_FORMAT: '", NMA_DATA_FORMAT,
       "'. Set to 'contrast' or 'arm' in nma_01_setup.R.")
}

# --- 3. Validate data ---
stopifnot("No contrasts after filtering — check extraction data" = nrow(nma_data) > 0)

cat("\n--- Data Summary ---\n")
cat("Number of contrasts:", nrow(nma_data), "\n")
cat("Unique studies:", length(unique(nma_data$studlab)), "\n")
cat("Unique treatments:", length(unique(c(nma_data$treat1, nma_data$treat2))), "\n")
cat("Treatments:", paste(sort(unique(c(nma_data$treat1, nma_data$treat2))), collapse = ", "), "\n")

# --- 4. Check for missing data ---
missing_te   <- sum(is.na(nma_data$TE))
missing_se   <- sum(is.na(nma_data$seTE))
cat("\nMissing TE:", missing_te, "\n")
cat("Missing seTE:", missing_se, "\n")

if (missing_te > 0 || missing_se > 0) {
  warning("Missing effect estimates detected. Review extraction data.")
}

# --- 5. Save prepared data ---
write_csv(nma_data, "nma_prepared_data.csv")
cat("\nPrepared data saved to nma_prepared_data.csv\n")
