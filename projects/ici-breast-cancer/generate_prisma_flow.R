#!/usr/bin/env Rscript
# Generate PRISMA 2020 Flow Diagram for ICI-Breast-Cancer Meta-Analysis
# Usage: Rscript generate_prisma_flow.R

# Load required packages
if (!requireNamespace("PRISMA2020", quietly = TRUE)) {
  install.packages("PRISMA2020", repos = "https://cran.r-project.org")
}
library(PRISMA2020)

# Working directory is already set by caller
cat("Working directory:", getwd(), "\n")

# Read PRISMA flow data from CSV
csv_file <- "prisma_flow_data.csv"
if (!file.exists(csv_file)) {
  stop("Error: prisma_flow_data.csv not found in current directory")
}

cat("Reading PRISMA data from:", csv_file, "\n")
data <- read.csv(csv_file, stringsAsFactors = FALSE)

# Convert to PRISMA data format
prisma_data <- PRISMA_data(data)

cat("\nGenerating PRISMA flow diagrams...\n")

# Create output directory for figures
if (!dir.exists("figures")) {
  dir.create("figures", recursive = TRUE)
}

# 1. Interactive HTML version (for supplementary materials)
cat("1. Creating interactive HTML version...\n")
interactive_plot <- PRISMA_flowdiagram(
  prisma_data,
  fontsize = 12,
  interactive = TRUE,
  previous = FALSE,  # No previous studies
  other = FALSE      # No other sources
)

html_file <- "figures/prisma_flow_interactive.html"
PRISMA_save(interactive_plot, filename = html_file, filetype = "html")
cat("   Saved:", html_file, "\n")

# 2. Static PNG version (high-resolution for manuscript)
cat("2. Creating static PNG version (300 DPI)...\n")
static_plot <- PRISMA_flowdiagram(
  prisma_data,
  fontsize = 14,
  interactive = FALSE,
  previous = FALSE,
  other = FALSE
)

png_file <- "figures/prisma_flow_static.png"
PRISMA_save(static_plot, filename = png_file, filetype = "png")
cat("   Saved:", png_file, "\n")

# 3. PDF version (for publication)
cat("3. Creating PDF version...\n")
pdf_file <- "figures/prisma_flow_static.pdf"
PRISMA_save(static_plot, filename = pdf_file, filetype = "pdf")
cat("   Saved:", pdf_file, "\n")

# 4. SVG version (scalable for presentations)
cat("4. Creating SVG version...\n")
svg_file <- "figures/prisma_flow_static.svg"
PRISMA_save(static_plot, filename = svg_file, filetype = "svg")
cat("   Saved:", svg_file, "\n")

cat("\n✅ PRISMA flow diagram generation complete!\n")
cat("\nOutputs:\n")
cat("  - Interactive HTML: figures/prisma_flow_interactive.html\n")
cat("  - High-res PNG:     figures/prisma_flow_static.png\n")
cat("  - Publication PDF:  figures/prisma_flow_static.pdf\n")
cat("  - Scalable SVG:     figures/prisma_flow_static.svg\n")
cat("\nRecommendation:\n")
cat("  - Use PNG/PDF for manuscript Figure 1\n")
cat("  - Use HTML for supplementary materials (interactive)\n")
