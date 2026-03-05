library(dplyr)
library(readr)
library(gtsummary)

extraction_path <- "../05_extraction/extraction.csv"
stopifnot(
  "extraction.csv not found — run data extraction (Stage 05) first" =
    file.exists(extraction_path)
)

raw <- read_csv(extraction_path, show_col_types = FALSE)

# Select columns that exist in the data
available_cols <- intersect(c("study_id", "outcome_id", "outcome_type", "n"), names(raw))
if (length(available_cols) < 2) {
  stop("Too few usable columns for summary table. Available: ",
       paste(names(raw), collapse = ", "))
}

study_table <- raw %>%
  distinct(across(all_of(available_cols))) %>%
  select(all_of(available_cols))

if (!dir.exists("tables")) dir.create("tables", recursive = TRUE)

if ("outcome_type" %in% names(study_table)) {
  summary_tbl <- study_table %>%
    tbl_summary(by = outcome_type) %>%
    bold_labels()
} else {
  summary_tbl <- study_table %>%
    tbl_summary() %>%
    bold_labels()
}

gtsave(summary_tbl, "tables/study_summary.html")
cat("Study summary table saved to tables/study_summary.html\n")
