#!/usr/bin/env Rscript
# Generate PRISMA 2020 Flow Diagram
#
# Usage:
#   Rscript prisma_flowchart.R --db_records 122 --screened 122 --excluded 117 --fulltext 5 --included 5 --participants 2402 --output figures/
#
# Arguments:
#   --db_records: Number of records identified from databases
#   --screened: Number of records screened
#   --excluded: Number of records excluded after screening
#   --fulltext: Number of full-text articles assessed
#   --included: Number of studies included in final analysis
#   --participants: Total number of participants (optional)
#   --output: Output directory (default: figures/)
#   --db_label: Custom label for database search (default: "Databases")
#   --study_label: Custom label for included studies (optional)

# Load required packages
suppressPackageStartupMessages({
  if (!requireNamespace("PRISMA2020", quietly = TRUE)) {
    cat("Installing PRISMA2020 package...\n")
    install.packages("PRISMA2020", repos = "https://cran.r-project.org", quiet = TRUE)
  }
  library(PRISMA2020)
})

# Parse command line arguments
args <- commandArgs(trailingOnly = TRUE)

# Default values
db_records <- NA
screened <- NA
excluded <- NA
fulltext <- NA
included <- NA
participants <- NA
output_dir <- "figures"
db_label <- "Databases"
study_label <- NULL

# Parse arguments
i <- 1
while (i <= length(args)) {
  arg <- args[i]
  if (arg == "--db_records") {
    db_records <- as.numeric(args[i + 1])
    i <- i + 2
  } else if (arg == "--screened") {
    screened <- as.numeric(args[i + 1])
    i <- i + 2
  } else if (arg == "--excluded") {
    excluded <- as.numeric(args[i + 1])
    i <- i + 2
  } else if (arg == "--fulltext") {
    fulltext <- as.numeric(args[i + 1])
    i <- i + 2
  } else if (arg == "--included") {
    included <- as.numeric(args[i + 1])
    i <- i + 2
  } else if (arg == "--participants") {
    participants <- as.numeric(args[i + 1])
    i <- i + 2
  } else if (arg == "--output") {
    output_dir <- args[i + 1]
    i <- i + 2
  } else if (arg == "--db_label") {
    db_label <- args[i + 1]
    i <- i + 2
  } else if (arg == "--study_label") {
    study_label <- args[i + 1]
    i <- i + 2
  } else {
    i <- i + 1
  }
}

# Validate required arguments
if (is.na(db_records) || is.na(screened) || is.na(excluded) || is.na(fulltext) || is.na(included)) {
  cat("ERROR: Missing required arguments\n\n")
  cat("Usage: Rscript prisma_flowchart.R --db_records N --screened N --excluded N --fulltext N --included N [--participants N] [--output DIR]\n\n")
  cat("Example:\n")
  cat("  Rscript prisma_flowchart.R --db_records 122 --screened 122 --excluded 117 --fulltext 5 --included 5 --participants 2402\n\n")
  quit(status = 1)
}

# Create output directory
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

cat("======================================\n")
cat("PRISMA 2020 Flowchart Generator\n")
cat("======================================\n\n")
cat("Input parameters:\n")
cat("  Database records:     ", db_records, "\n")
cat("  Records screened:     ", screened, "\n")
cat("  Records excluded:     ", excluded, "\n")
cat("  Full-text assessed:   ", fulltext, "\n")
cat("  Studies included:     ", included, "\n")
if (!is.na(participants)) {
  cat("  Total participants:   ", participants, "\n")
}
cat("  Output directory:     ", output_dir, "\n\n")

# Load template data from PRISMA2020 package
csvFile <- system.file("extdata", "PRISMA.csv", package = "PRISMA2020")
data <- read.csv(csvFile, stringsAsFactors = FALSE)

# Update numbers
data$n[data$data == "database_results"] <- db_records
data$n[data$data == "records_screened"] <- screened
data$n[data$data == "records_excluded"] <- excluded
data$n[data$data == "dbr_sought_reports"] <- fulltext
data$n[data$data == "dbr_assessed"] <- fulltext
data$n[data$data == "dbr_notretrieved_reports"] <- 0  # Assume all retrieved
data$n[data$data == "dbr_excluded"] <- 0  # Assume no exclusions at full-text
data$n[data$data == "new_studies"] <- included
data$n[data$data == "new_reports"] <- included
data$n[data$data == "total_studies"] <- included
data$n[data$data == "total_reports"] <- included

# Customize labels
data$boxtext[data$data == "database_results"] <- paste0(db_label, " (n=", db_records, ")")

if (!is.null(study_label)) {
  data$boxtext[data$data == "new_studies"] <- study_label
} else {
  data$boxtext[data$data == "new_studies"] <- paste0(included, " studies included")
}

if (!is.na(participants)) {
  data$boxtext[data$data == "new_reports"] <- paste0("N=", format(participants, big.mark=","), " participants")
} else {
  data$boxtext[data$data == "new_reports"] <- paste0(included, " reports included")
}

# Create PRISMA data object
prisma_data <- PRISMA_data(data)

# Generate flowcharts
cat("Generating flowcharts...\n")

# 1. Static PNG (high resolution for manuscripts)
cat("  [1/4] Creating PNG (300 DPI)...\n")
static_plot <- suppressWarnings(PRISMA_flowdiagram(
  prisma_data,
  fontsize = 12,
  interactive = FALSE,
  previous = FALSE,
  other = FALSE
))
png_file <- file.path(output_dir, "prisma_flowchart.png")
PRISMA_save(static_plot, filename = png_file, filetype = "png")

# 2. PDF (for publication)
cat("  [2/4] Creating PDF...\n")
pdf_file <- file.path(output_dir, "prisma_flowchart.pdf")
PRISMA_save(static_plot, filename = pdf_file, filetype = "pdf")

# 3. SVG (scalable for presentations)
cat("  [3/4] Creating SVG...\n")
svg_file <- file.path(output_dir, "prisma_flowchart.svg")
PRISMA_save(static_plot, filename = svg_file, filetype = "svg")

# 4. Interactive HTML (for supplementary materials)
cat("  [4/4] Creating interactive HTML...\n")
interactive_plot <- suppressWarnings(PRISMA_flowdiagram(
  prisma_data,
  fontsize = 10,
  interactive = TRUE,
  previous = FALSE,
  other = FALSE
))
html_file <- file.path(output_dir, "prisma_flowchart_interactive.html")
PRISMA_save(interactive_plot, filename = html_file, filetype = "html")

cat("\n✅ PRISMA flowchart generation complete!\n\n")
cat("Outputs:\n")
cat("  📄 PNG (manuscript):   ", png_file, "\n")
cat("  📄 PDF (publication):  ", pdf_file, "\n")
cat("  📄 SVG (presentation): ", svg_file, "\n")
cat("  🌐 HTML (interactive): ", html_file, "\n\n")
cat("Recommendations:\n")
cat("  • Use PNG or PDF for manuscript Figure 1\n")
cat("  • Use HTML for supplementary materials (interactive tooltips)\n")
cat("  • Use SVG for presentations (scalable vector graphics)\n")
