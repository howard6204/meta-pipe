library(dplyr)

# Basic consistency checks for extracted data
extraction_path <- "../05_extraction/extraction.csv"
stopifnot(
  "extraction.csv not found — run data extraction (Stage 05) first" =
    file.exists(extraction_path)
)

raw <- read.csv(extraction_path)

cat("=== Data Validation ===\n")
cat("Rows:", nrow(raw), "| Columns:", ncol(raw), "\n")
cat("Columns:", paste(names(raw), collapse = ", "), "\n\n")

# Track validation results
n_issues <- 0

# 1. study_id must not be missing
if ("study_id" %in% names(raw)) {
  na_study <- sum(is.na(raw$study_id))
  if (na_study > 0) {
    cat("FAIL: ", na_study, "rows with missing study_id\n")
    n_issues <- n_issues + 1
  } else {
    cat("PASS: No missing study_id\n")
  }
} else {
  cat("FAIL: study_id column not found\n")
  n_issues <- n_issues + 1
}

# 2. SD must be non-negative
if ("sd" %in% names(raw)) {
  bad_sd <- sum(raw$sd[!is.na(raw$sd)] < 0)
  if (bad_sd > 0) {
    cat("FAIL:", bad_sd, "rows with negative SD\n")
    n_issues <- n_issues + 1
  } else {
    cat("PASS: All SD values >= 0\n")
  }
}

# 3. N must be positive
if ("n" %in% names(raw)) {
  bad_n <- sum(raw$n[!is.na(raw$n)] <= 0)
  if (bad_n > 0) {
    cat("FAIL:", bad_n, "rows with n <= 0\n")
    n_issues <- n_issues + 1
  } else {
    cat("PASS: All n values > 0\n")
  }
}

# 4. Events must not exceed total
if (all(c("events", "total") %in% names(raw))) {
  both_present <- !is.na(raw$events) & !is.na(raw$total)
  bad_events <- sum(raw$events[both_present] > raw$total[both_present])
  if (bad_events > 0) {
    cat("FAIL:", bad_events, "rows with events > total\n")
    n_issues <- n_issues + 1
  } else {
    cat("PASS: All events <= total\n")
  }
}

# 5. Duplicate check
if ("study_id" %in% names(raw)) {
  dup_count <- sum(duplicated(raw[, intersect(c("study_id", "outcome_id", "arm_label"), names(raw))]))
  if (dup_count > 0) {
    cat("WARNING:", dup_count, "potential duplicate rows\n")
  } else {
    cat("PASS: No duplicate rows detected\n")
  }
}

cat("\n=== Validation Summary ===\n")
if (n_issues == 0) {
  cat("All checks passed.\n")
} else {
  cat(n_issues, "issue(s) found. Review extraction data before analysis.\n")
}
