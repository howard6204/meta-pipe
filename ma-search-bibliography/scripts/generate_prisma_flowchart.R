#!/usr/bin/env Rscript
# Generate PRISMA 2020 Flow Diagram (Simplified, Reliable Version)
#
# Usage:
#   Rscript generate_prisma_flowchart.R DB_RECORDS SCREENED EXCLUDED FULLTEXT INCLUDED [PARTICIPANTS] [OUTPUT_DIR]
#
# Example:
#   Rscript generate_prisma_flowchart.R 122 122 117 5 5 2402 figures/

# Load required packages
if (!requireNamespace("PRISMA2020", quietly = TRUE)) {
  install.packages("PRISMA2020", repos = "https://cran.r-project.org")
}
suppressPackageStartupMessages(library(PRISMA2020))

# Parse arguments
args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 5) {
  cat("\n")
  cat("PRISMA 2020 Flowchart Generator\n")
  cat("===============================\n\n")
  cat("Usage: Rscript generate_prisma_flowchart.R DB_RECORDS SCREENED EXCLUDED FULLTEXT INCLUDED [PARTICIPANTS] [OUTPUT_DIR]\n\n")
  cat("Arguments:\n")
  cat("  DB_RECORDS    : Number of records from database search\n")
  cat("  SCREENED      : Number of records screened\n")
  cat("  EXCLUDED      : Number of records excluded after screening\n")
  cat("  FULLTEXT      : Number of full-text articles assessed\n")
  cat("  INCLUDED      : Number of studies included in analysis\n")
  cat("  PARTICIPANTS  : Total participants (optional)\n")
  cat("  OUTPUT_DIR    : Output directory (optional, default: figures/)\n\n")
  cat("Example:\n")
  cat("  Rscript generate_prisma_flowchart.R 122 122 117 5 5 2402 figures/\n\n")
  quit(status = 1)
}

db_records <- as.numeric(args[1])
screened <- as.numeric(args[2])
excluded <- as.numeric(args[3])
fulltext <- as.numeric(args[4])
included <- as.numeric(args[5])
participants <- if (length(args) >= 6) as.numeric(args[6]) else NA
output_dir <- if (length(args) >= 7) args[7] else "figures"

# Create output directory
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

cat("\n")
cat("======================================\n")
cat("PRISMA 2020 Flowchart Generator\n")
cat("======================================\n\n")
cat("Database records:    ", db_records, "\n")
cat("Records screened:    ", screened, "\n")
cat("Records excluded:    ", excluded, "\n")
cat("Full-text assessed:  ", fulltext, "\n")
cat("Studies included:    ", included, "\n")
if (!is.na(participants)) {
  cat("Total participants:  ", format(participants, big.mark=","), "\n")
}
cat("Output directory:    ", output_dir, "\n\n")

# Load template from PRISMA2020 package
csvFile <- system.file("extdata", "PRISMA.csv", package = "PRISMA2020")
data <- read.csv(csvFile, stringsAsFactors = FALSE)

# Update numbers - keep it simple, only change the n column
data$n[data$data == "database_results"] <- db_records
data$n[data$data == "records_screened"] <- screened
data$n[data$data == "records_excluded"] <- excluded
data$n[data$data == "dbr_sought_reports"] <- fulltext
data$n[data$data == "dbr_assessed"] <- fulltext
data$n[data$data == "new_studies"] <- included
data$n[data$data == "new_reports"] <- included
data$n[data$data == "total_studies"] <- included
data$n[data$data == "total_reports"] <- included

# Convert to PRISMA data
prisma_data <- PRISMA_data(data)

cat("Generating flowcharts...\n")

# Static plot
cat("  [1/4] PNG...\n")
static_plot <- suppressWarnings(PRISMA_flowdiagram(
  prisma_data,
  fontsize = 12,
  interactive = FALSE,
  previous = FALSE,
  other = FALSE
))

png_file <- file.path(output_dir, "prisma_flowchart.png")
pdf_file <- file.path(output_dir, "prisma_flowchart.pdf")
svg_file <- file.path(output_dir, "prisma_flowchart.svg")

PRISMA_save(static_plot, filename = png_file, filetype = "png")
cat("  [2/4] PDF...\n")
PRISMA_save(static_plot, filename = pdf_file, filetype = "pdf")
cat("  [3/4] SVG...\n")
PRISMA_save(static_plot, filename = svg_file, filetype = "svg")

# Interactive plot
cat("  [4/4] HTML (interactive)...\n")
interactive_plot <- suppressWarnings(PRISMA_flowdiagram(
  prisma_data,
  fontsize = 12,
  interactive = TRUE,
  previous = FALSE,
  other = FALSE
))

html_file <- file.path(output_dir, "prisma_flowchart_interactive.html")
PRISMA_save(interactive_plot, filename = html_file, filetype = "html")

cat("\n✅ Complete!\n\n")
cat("Outputs:\n")
cat("  📄 PNG:  ", png_file, "\n")
cat("  📄 PDF:  ", pdf_file, "\n")
cat("  📄 SVG:  ", svg_file, "\n")
cat("  🌐 HTML: ", html_file, "\n\n")
cat("Use PNG/PDF for manuscript, HTML for supplementary materials.\n\n")
