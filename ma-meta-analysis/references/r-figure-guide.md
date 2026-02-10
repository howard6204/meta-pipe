# R Figure Generation Guide for Meta-Analysis

**Purpose**: Generate publication-quality figures and tables at 300 DPI using R
**When to use**: Stage 06 (Analysis) and Stage 07 (Manuscript)

---

## 🚀 Quick Navigation

**New to R?** → Start with [r-guides/00-setup.md](r-guides/00-setup.md) (10 min setup)

**Need specific help?** → See task-based guides below

---

## 📖 Task-Based Guides

### I Need To...

| Task                       | Guide                                                       | Time      |
| -------------------------- | ----------------------------------------------------------- | --------- |
| **Set up R packages**      | [00-setup.md](r-guides/00-setup.md)                         | 10-15 min |
| **Choose R packages**      | [09-package-selection.md](r-guides/09-package-selection.md) | 10-15 min |
| **Make a forest plot**     | [01-forest-plots.md](r-guides/01-forest-plots.md)           | 15-30 min |
| **Create a funnel plot**   | [02-funnel-plots.md](r-guides/02-funnel-plots.md)           | 10-15 min |
| **Do subgroup analysis**   | [03-subgroup-plots.md](r-guides/03-subgroup-plots.md)       | 20-30 min |
| **Combine multiple plots** | [04-multi-panel.md](r-guides/04-multi-panel.md)             | 15-20 min |
| **Create Table 1**         | [05-table1-gtsummary.md](r-guides/05-table1-gtsummary.md)   | 30-60 min |
| **Make regression tables** | [06-regression-tables.md](r-guides/06-regression-tables.md) | 20-30 min |
| **Choose colors/themes**   | [07-themes-colors.md](r-guides/07-themes-colors.md)         | 10-15 min |
| **Learn ggplot2 basics**   | [08-ggplot2-patterns.md](r-guides/08-ggplot2-patterns.md)   | 30-45 min |

---

## 📦 Package Quick Reference

Each guide lists packages needed for that specific task. Here's the full list:

### Core Packages (Install Once)

```r
# Meta-analysis
install.packages(c("metafor", "meta", "dmetar"))

# Forest plots (REQUIRED - Medical journal standard)
install.packages("forestplot")

# Visualization
install.packages(c("ggplot2", "patchwork", "cowplot"))

# Tables
install.packages(c("gtsummary", "gt", "flextable"))

# Themes & Colors
install.packages(c("ggsci", "viridis"))
```

**Full setup guide**: [r-guides/00-setup.md](r-guides/00-setup.md)

---

## 🎯 By Project Stage

### Stage 06: Analysis

**Goal**: Generate statistical plots and perform meta-analysis

**Start here**:

0. [09-package-selection.md](r-guides/09-package-selection.md) - Choose meta vs metafor
1. [01-forest-plots.md](r-guides/01-forest-plots.md) - Primary outcome
2. [02-funnel-plots.md](r-guides/02-funnel-plots.md) - Publication bias
3. [03-subgroup-plots.md](r-guides/03-subgroup-plots.md) - Subgroup analysis

**Packages you'll need**:

```r
library(forestplot) # ⭐ REQUIRED - Professional forest plots (medical journal standard)
library(metafor)    # Meta-analysis calculations
library(ggplot2)    # Custom plots
library(grid)       # Graphics support (for forestplot)
```

### Stage 07: Manuscript

**Goal**: Assemble figures and create tables for manuscript

**Start here**:

1. [04-multi-panel.md](r-guides/04-multi-panel.md) - Combine plots into figures
2. [05-table1-gtsummary.md](r-guides/05-table1-gtsummary.md) - Study characteristics
3. [06-regression-tables.md](r-guides/06-regression-tables.md) - Statistical tables

**Packages you'll need**:

```r
library(patchwork)   # Multi-panel figures
library(gtsummary)   # Professional tables
library(gt)          # HTML export
library(flextable)   # Word export
```

---

## 📚 R Package Ecosystem

When you need more information about a package, consult these resources:

### Core Repositories

1. **[CRAN](https://cran.r-project.org/)** — Official R package repository
   - Search for packages
   - Read documentation
   - Example: https://cran.r-project.org/web/packages/meta/

2. **[Tidyverse](https://www.tidyverse.org/)** — ggplot2, dplyr, tidyr
   - Modern R packages
   - Consistent syntax
   - Example: https://ggplot2.tidyverse.org/

3. **[R-universe](https://r-universe.dev/)** — Package search engine
   - Search across all repositories
   - View dependencies
   - Example: https://r-universe.dev/search/

4. **[Bioconductor](https://bioconductor.org/)** — Bioinformatics packages
   - Specialized for biological data
   - Example: https://bioconductor.org/packages/

5. **[rOpenSci](https://ropensci.org/)** — Peer-reviewed scientific tools
   - High-quality packages
   - Example: https://ropensci.org/packages/

---

## 🔍 How to Use These Guides

### Progressive Disclosure Principle

**Don't read everything!** Only read what you need for your current task.

### Structure of Each Guide

```
# [Task Name]

**When to use**: [Specific scenario]
**Time**: [Estimated time]
**Packages**: [Only what you need]

## Quick Start
[Copy-paste example - gets you 80% there]

## Common Scenarios
[3-5 real-world use cases]

## Troubleshooting
[Common errors and fixes]

## See Also
[Related guides]
```

### Example Workflow

**Scenario**: "I need to create a forest plot and Table 1"

1. Read [01-forest-plots.md](r-guides/01-forest-plots.md) → Copy Quick Start code
2. Run the code → Get forest plot
3. Read [05-table1-gtsummary.md](r-guides/05-table1-gtsummary.md) → Copy Quick Start code
4. Run the code → Get Table 1
5. **Done!** (No need to read 700+ lines of documentation)

---

## 📝 Common Workflows

### Workflow 1: Complete Meta-Analysis Figures (2-3 hours)

```r
# Step 1: Set up (5 min)
source("r-guides/00-setup.md")  # Install packages

# Step 2: Forest plot (30 min)
source("r-guides/01-forest-plots.md")  # Primary outcome

# Step 3: Funnel plot (15 min)
source("r-guides/02-funnel-plots.md")  # Publication bias

# Step 4: Subgroup analysis (30 min)
source("r-guides/03-subgroup-plots.md")  # Heterogeneity

# Step 5: Combine (30 min)
source("r-guides/04-multi-panel.md")  # Multi-panel figure
```

### Workflow 2: Manuscript Tables (1-2 hours)

```r
# Step 1: Table 1 (60 min)
source("r-guides/05-table1-gtsummary.md")  # Study characteristics

# Step 2: Regression table (30 min)
source("r-guides/06-regression-tables.md")  # Statistical models

# Export to Word
# Done!
```

---

## 🎨 Design Philosophy

### Why Modular Guides?

**Before** (Single 780-line file):

- ❌ Overwhelming for beginners
- ❌ Hard to find what you need
- ❌ Mixes basics with advanced topics
- ❌ Copy-paste examples buried in text

**After** (9 task-based guides):

- ✅ Read only what you need (Progressive Disclosure)
- ✅ Quick start examples first
- ✅ Clear time estimates
- ✅ Minimal package dependencies per guide

### Principles Applied

1. **Task-Based**: "Make a forest plot" not "Learn meta package"
2. **Time-Bounded**: Each guide 10-60 minutes
3. **Copy-Paste Ready**: Quick Start section gets you 80% there
4. **Cross-Referenced**: Related guides linked at bottom
5. **Scenario-Driven**: Real examples from meta-analysis projects

---

## 🆘 Getting Help

### Within This Documentation

1. **Start with README**: [r-guides/README.md](r-guides/README.md)
2. **Find your task**: Use table above
3. **Read ONE guide**: Don't try to learn everything
4. **Follow Quick Start**: Copy-paste and modify

### External Resources

1. **Package website**: Click links in each guide
2. **R help system**: `?function_name` in R console
3. **Package vignettes**: `browseVignettes("package_name")`
4. **CRAN search**: https://cran.r-project.org/

---

## 📊 Quality Standards

All guides ensure:

- ✅ 300 DPI minimum for figures
- ✅ Colorblind-safe palettes (viridis, ggsci)
- ✅ Journal-quality themes (hrbrthemes)
- ✅ Reproducible workflows
- ✅ Clear variable labels
- ✅ Multi-format export (PNG, PDF, Word, HTML)

---

## 🔄 Maintenance

**These guides evolve**. When you discover a better pattern:

1. Create a new guide (copy template)
2. Update cross-references
3. Update this README

**Template**: See any existing guide for structure

---

**Last Updated**: 2024-02-07
**Maintainer**: See CLAUDE.md for project instructions
**Full guide list**: [r-guides/README.md](r-guides/README.md)
