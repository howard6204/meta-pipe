# R Figure Generation Guide for Meta-Analysis

**Purpose**: Generate publication-quality figures at 300 DPI using R
**When to use**: Stage 06 (Analysis) and Stage 07 (Manuscript)

---

## R Package Ecosystem

When generating figures, consult these authoritative sources for package documentation:

### Core Package Repositories

1. **[CRAN](https://cran.r-project.org/)** — The Comprehensive R Archive Network
   - Official R package repository (19,000+ packages)
   - All packages peer-reviewed and tested
   - Use: `install.packages("package_name")`
   - Browse: https://cran.r-project.org/web/packages/available_packages_by_name.html

2. **[Bioconductor](https://bioconductor.org/)** — Bioinformatics & Genomics
   - Specialized packages for biological data analysis
   - Use: `BiocManager::install("package_name")`
   - Browse: https://bioconductor.org/packages/release/BiocViews.html

3. **[Tidyverse](https://www.tidyverse.org/)** — Modern Data Science
   - Core packages: ggplot2, dplyr, tidyr, readr
   - Consistent API design
   - Use: `install.packages("tidyverse")`
   - Learn: https://www.tidyverse.org/learn/

4. **[rOpenSci](https://ropensci.org/)** — Peer-Reviewed Scientific Tools
   - Community-driven, open peer review
   - High-quality packages for reproducible research
   - Browse: https://ropensci.org/packages/

5. **[R-universe](https://r-universe.dev/)** — Next-Gen Package Discovery
   - Search across CRAN, Bioconductor, GitHub
   - View dependencies and reverse dependencies
   - Browse: https://r-universe.dev/search/

---

## Essential Packages for Meta-Analysis Figures

### Meta-Analysis Core

```r
# Install meta-analysis packages
install.packages(c("meta", "metafor", "dmetar"))

# Load packages
library(meta)      # Simple interface for meta-analysis
library(metafor)   # Comprehensive meta-analysis tools
library(dmetar)    # Companion to "Doing Meta-Analysis in R"
```

**Documentation**:
- meta: https://cran.r-project.org/web/packages/meta/
- metafor: https://www.metafor-project.org/
- dmetar: https://dmetar.protectlab.org/

### Plotting & Visualization

```r
# Install core visualization packages
install.packages(c(
  "ggplot2",      # Grammar of graphics
  "patchwork",    # Combine multiple plots
  "cowplot",      # Publication-ready themes
  "ggpubr",       # Publication-ready plots
  "forestplot"    # Specialized forest plots
))

# Install professional theme packages
install.packages(c(
  "ggthemes",     # Professional themes (Economist, WSJ, etc.)
  "hrbrthemes",   # Typography-focused themes
  "tvthemes",     # TV show inspired themes
  "viridis",      # Colorblind-friendly palettes
  "scico",        # Scientific color maps
  "ggsci",        # Scientific journal color palettes
  "ggthemr"       # Easy theme switching (from GitHub)
))

# ggthemr requires installation from GitHub
# install.packages("devtools")
# devtools::install_github("Mikata-Project/ggthemr")
```

**Key packages**:

1. **ggplot2** — Grammar of Graphics
   - Flexible, publication-quality plots
   - [Documentation](https://ggplot2.tidyverse.org/)
   - [Gallery](https://r-graph-gallery.com/ggplot2-package.html)

2. **patchwork** — Multi-Panel Figures
   - Intuitive syntax: `plot1 + plot2`
   - [Documentation](https://patchwork.data-imaginist.com/)
   - Perfect for journal submissions

3. **cowplot** — Publication Themes
   - Clean themes for publications
   - [Documentation](https://wilkelab.org/cowplot/)
   - Panel labeling: `plot_grid(labels="AUTO")`

4. **forestplot** — Specialized Forest Plots
   - High-level forest plot interface
   - [Documentation](https://cran.r-project.org/web/packages/forestplot/)

---

## Figure Generation Workflow

### 1. Forest Plots (Primary Outcome)

**Using metafor package**:

```r
library(metafor)
library(meta)

# Load extraction data
data <- read.csv("05_extraction/extraction.csv")

# Calculate risk ratios
res <- metabin(
  event.e = events_ici,
  n.e = total_ici,
  event.c = events_control,
  n.c = total_control,
  data = data,
  studlab = study_id,
  sm = "RR",
  method = "MH",
  fixed = FALSE,
  random = TRUE
)

# Create forest plot
png("07_manuscript/figures/figure1_forest.png",
    width = 10, height = 8, units = "in", res = 300)

forest(res,
       xlim = c(0.5, 2.0),
       xlab = "Risk Ratio",
       slab = data$study_id,
       col.square = "blue",
       col.diamond = "red",
       comb.fixed = FALSE,
       comb.random = TRUE,
       print.I2 = TRUE,
       print.pval.Q = TRUE)

dev.off()
```

**Using forest() from meta package**:

```r
# Alternative: Simpler interface
library(meta)

res <- metabin(
  event.e, n.e, event.c, n.c,
  data = data,
  studlab = study_id,
  sm = "RR"
)

# Export forest plot
png("07_manuscript/figures/figure1_forest.png",
    width = 10, height = 8, units = "in", res = 300)
forest(res)
dev.off()
```

### 2. Multi-Panel Figures with patchwork

**Combine efficacy outcomes (pCR, EFS, OS)**:

```r
library(ggplot2)
library(patchwork)

# Create individual plots
p1 <- forest(res_pcr) + ggtitle("A. Pathologic Complete Response")
p2 <- forest(res_efs) + ggtitle("B. Event-Free Survival")
p3 <- forest(res_os) + ggtitle("C. Overall Survival")

# Combine with patchwork
combined <- p1 / p2 / p3

# Export at 300 DPI
ggsave("07_manuscript/figures/figure1_efficacy.png",
       plot = combined,
       width = 10, height = 12, dpi = 300)
```

**Using cowplot for panel labels**:

```r
library(cowplot)

# Combine with automatic panel labels
combined <- plot_grid(
  p1, p2, p3,
  labels = c("A", "B", "C"),
  ncol = 1,
  rel_heights = c(1, 1, 1)
)

# Export
ggsave("07_manuscript/figures/figure1_efficacy.png",
       plot = combined,
       width = 10, height = 12, dpi = 300)
```

### 3. Subgroup Analysis

```r
# Subgroup forest plot
res_subgroup <- metabin(
  event.e, n.e, event.c, n.c,
  data = data,
  studlab = study_id,
  subgroup = pdl1_status,
  sm = "RR"
)

png("07_manuscript/figures/figure2_subgroup.png",
    width = 12, height = 10, units = "in", res = 300)

forest(res_subgroup,
       overall = TRUE,
       overall.hetstat = TRUE,
       test.subgroup = TRUE,
       print.subgroup.name = TRUE)

dev.off()
```

### 4. Funnel Plots (Publication Bias)

```r
# Create funnel plot
png("07_manuscript/figures/figure3_funnel.png",
    width = 8, height = 8, units = "in", res = 300)

funnel(res,
       xlab = "Risk Ratio (log scale)",
       studlab = TRUE)

dev.off()

# Enhanced funnel plot with contour
library(metafor)
funnel(res,
       level = c(90, 95, 99),
       shade = c("white", "gray", "darkgray"),
       refline = 0)
```

### 5. Risk of Bias Summary

```r
library(ggplot2)
library(tidyr)

# Load RoB data
rob_data <- read.csv("03_screening/quality_rob2.csv")

# Reshape for plotting
rob_long <- rob_data %>%
  pivot_longer(
    cols = starts_with("domain"),
    names_to = "domain",
    values_to = "judgement"
  )

# Create RoB plot
p <- ggplot(rob_long, aes(x = domain, fill = judgement)) +
  geom_bar(position = "fill") +
  scale_fill_manual(
    values = c("Low" = "green", "Some concerns" = "yellow", "High" = "red")
  ) +
  labs(y = "Proportion", x = "Risk of Bias Domain") +
  theme_minimal() +
  coord_flip()

ggsave("07_manuscript/figures/figure4_rob.png",
       plot = p, width = 10, height = 6, dpi = 300)
```

---

## Best Practices

### Export Settings

**Always use these settings**:

```r
# For ggplot2
ggsave("filename.png",
       width = 10,        # inches
       height = 8,        # inches
       dpi = 300,         # publication quality
       units = "in")

# For base R / meta package
png("filename.png",
    width = 10,           # inches
    height = 8,           # inches
    units = "in",
    res = 300)           # resolution

# Your plotting code here

dev.off()
```

### File Organization

```
06_analysis/
├── scripts/
│   ├── 01_forest_pcr.R          # Primary outcome
│   ├── 02_forest_secondary.R    # Secondary outcomes
│   ├── 03_subgroup.R            # Subgroup analysis
│   ├── 04_funnel.R              # Publication bias
│   └── 05_assemble_panels.R     # Multi-panel figures
└── figures/
    ├── figure1_pcr.png          # Individual plots
    ├── figure2_efs.png
    ├── figure3_os.png
    └── combined_efficacy.png    # Multi-panel

07_manuscript/
└── figures/                     # Final publication figures
    ├── figure1_efficacy.png     # 3-panel: pCR + EFS + OS
    ├── figure2_subgroup.png     # Subgroup forest plot
    ├── figure3_funnel.png       # Funnel plot
    └── figure4_rob.png          # Risk of bias summary
```

### Reproducibility

**Create master script**:

```r
# 06_analysis/generate_all_figures.R

# Set working directory
setwd("/Users/htlin/meta-pipe/06_analysis")

# Load data
source("scripts/00_load_data.R")

# Generate figures in order
source("scripts/01_forest_pcr.R")
source("scripts/02_forest_secondary.R")
source("scripts/03_subgroup.R")
source("scripts/04_funnel.R")
source("scripts/05_assemble_panels.R")

# Copy to manuscript folder
file.copy(
  list.files("figures", pattern = "^figure.*\\.png$", full.names = TRUE),
  "../07_manuscript/figures/",
  overwrite = TRUE
)

cat("All figures generated successfully!\n")
```

**Run from command line**:

```bash
cd /Users/htlin/meta-pipe/06_analysis
Rscript generate_all_figures.R
```

---

## Common Issues & Solutions

### Issue 1: Package Not Found

```r
# Error: package 'meta' not found

# Solution: Install from CRAN
install.packages("meta")

# Or check CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org/"))
install.packages("meta")
```

### Issue 2: Font Issues in PDF Export

```r
# Error: font family not found

# Solution: Use cairo device
ggsave("figure.png", device = "png", type = "cairo")

# Or for PDF
cairo_pdf("figure.pdf", width = 10, height = 8)
# Your plot here
dev.off()
```

### Issue 3: Figure Too Small / Text Unreadable

```r
# Problem: Text too small in exported figure

# Solution: Increase base_size in theme
library(ggplot2)

p <- ggplot(data, aes(x, y)) +
  geom_point() +
  theme_minimal(base_size = 14)  # Increase from default 11

ggsave("figure.png", width = 10, height = 8, dpi = 300)
```

### Issue 4: Multi-Panel Alignment

```r
# Problem: Panels misaligned in cowplot

# Solution: Use align and axis parameters
library(cowplot)

plot_grid(
  p1, p2, p3,
  labels = c("A", "B", "C"),
  align = "v",        # Align vertically
  axis = "l",         # Align on left axis
  ncol = 1
)
```

---

## Journal-Specific Requirements

### Nature/Lancet/NEJM

- **DPI**: 300-600 for line art, 300 for photos
- **Format**: TIFF or PNG (not JPEG)
- **Fonts**: Arial or Helvetica, 6-8pt minimum
- **Width**: Single column (89mm) or double (183mm)

**R code for Lancet-style figures**:

```r
library(ggplot2)

# Lancet theme
theme_lancet <- theme_minimal(base_size = 10) +
  theme(
    text = element_text(family = "Arial"),
    axis.line = element_line(size = 0.5),
    panel.grid.minor = element_blank()
  )

# Apply to plot
p <- ggplot(data, aes(x, y)) +
  geom_point() +
  theme_lancet

# Export at journal width
ggsave("figure.png",
       width = 183, height = 150,  # mm
       units = "mm", dpi = 300)
```

### JAMA

- **DPI**: 300-600
- **Format**: TIFF preferred
- **Fonts**: Arial, 8-10pt
- **File size**: <10 MB per figure

### PLoS ONE

- **DPI**: 300-600
- **Format**: PNG, TIFF, or EPS
- **Dimensions**: Width ≤ 6.83 inches (single) or 10.05 inches (double)

---

## Quick Reference

### Package Installation

```r
# Core meta-analysis
install.packages(c("meta", "metafor", "dmetar"))

# Visualization
install.packages(c("ggplot2", "patchwork", "cowplot", "ggpubr"))

# Utilities
install.packages(c("tidyverse", "scales", "RColorBrewer"))
```

### Template: Basic Forest Plot

```r
library(meta)

# Read data
data <- read.csv("05_extraction/extraction.csv")

# Meta-analysis
res <- metabin(
  event.e, n.e, event.c, n.c,
  data = data,
  studlab = study_id,
  sm = "RR"
)

# Export forest plot
png("figure.png", width=10, height=8, units="in", res=300)
forest(res)
dev.off()
```

### Template: Multi-Panel with patchwork

```r
library(patchwork)

# Combine plots
combined <- p1 / p2 / p3 +
  plot_annotation(
    title = "Efficacy Outcomes",
    tag_levels = "A"
  )

# Export
ggsave("combined.png", width=10, height=12, dpi=300)
```

---

## Additional Resources

### Tutorials

1. **Doing Meta-Analysis in R** (Harrer et al.)
   - https://bookdown.org/MathiasHarrer/Doing_Meta_Analysis_in_R/
   - Comprehensive guide for meta-analysis in R

2. **R Graphics Cookbook** (Chang)
   - https://r-graphics.org/
   - ggplot2 examples for publication

3. **Data Visualization with R** (Kabacoff)
   - https://rkabacoff.github.io/datavis/
   - Modern visualization techniques

### Getting Help

When searching for R packages or help:

1. **Search CRAN**: https://cran.r-project.org/web/packages/
2. **Search R-universe**: https://r-universe.dev/search/
3. **Stack Overflow**: Tag questions with `[r]` and `[meta-analysis]`
4. **RStudio Community**: https://community.rstudio.com/

### Package Documentation

```r
# View package help
help(package = "meta")

# View function help
?forest

# View vignettes
vignette(package = "meta")
browseVignettes("meta")
```

---

**Last Updated**: 2024-02-07
**Maintainer**: See CLAUDE.md for project instructions
