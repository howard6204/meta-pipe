# R Guides for Meta-Analysis

**Purpose**: Modular, scenario-based guides for R figure and table generation
**Principle**: Progressive Disclosure - read only what you need, when you need it

---

## 📖 How to Use These Guides

### By Stage

| Stage    | Your Goal              | Read This                                          |
| -------- | ---------------------- | -------------------------------------------------- |
| Stage 06 | Choose R packages      | [09-package-selection.md](09-package-selection.md) |
| Stage 06 | Generate forest plots  | [01-forest-plots.md](01-forest-plots.md)           |
| Stage 06 | Create funnel plots    | [02-funnel-plots.md](02-funnel-plots.md)           |
| Stage 06 | Subgroup analysis      | [03-subgroup-plots.md](03-subgroup-plots.md)       |
| Stage 07 | Combine multiple plots | [04-multi-panel.md](04-multi-panel.md)             |
| Stage 07 | Create Table 1         | [05-table1-gtsummary.md](05-table1-gtsummary.md)   |
| Stage 07 | Regression tables      | [06-regression-tables.md](06-regression-tables.md) |
| Any      | Choose colors/themes   | [07-themes-colors.md](07-themes-colors.md)         |
| Any      | ggplot2 best practices | [08-ggplot2-patterns.md](08-ggplot2-patterns.md)   |

### By Task

**"Which R package should I use?"** → [09-package-selection.md](09-package-selection.md)
**"I need to make a forest plot"** → [01-forest-plots.md](01-forest-plots.md)
**"I need to combine 3 plots into one figure"** → [04-multi-panel.md](04-multi-panel.md)
**"I need Table 1 for my manuscript"** → [05-table1-gtsummary.md](05-table1-gtsummary.md)
**"My colors look bad"** → [07-themes-colors.md](07-themes-colors.md)
**"I'm new to ggplot2"** → [08-ggplot2-patterns.md](08-ggplot2-patterns.md)

---

## 📦 Package Quick Reference

Each guide lists required packages at the top. Here's the master list:

### Core Meta-Analysis

```r
install.packages(c("meta", "metafor", "dmetar"))
```

### Visualization

```r
install.packages(c("ggplot2", "patchwork", "cowplot"))
```

### Tables

```r
install.packages(c("gtsummary", "gt", "flextable"))
```

### Themes & Colors

```r
install.packages(c("hrbrthemes", "ggsci", "viridis"))
```

**Full installation script**: [00-setup.md](00-setup.md)

---

## 🎯 Design Principles

### 1. Scenario-Based

Each guide starts with: "**When to use this**: You need to..."

### 2. Minimal Dependencies

Only lists packages you actually need for that specific task.

### 3. Copy-Paste Ready

All examples are complete, runnable scripts.

### 4. Cross-Referenced

Links to related guides at the bottom of each file.

---

## 📚 Guide Structure

Each guide follows this template:

```markdown
# [Task Name]

**When to use**: [Specific scenario]
**Time**: [Estimated time]
**Packages**: [List of required packages]

## Quick Start

[Minimal working example - copy & paste]

## Step-by-Step

[Detailed explanation]

## Common Variations

[Different use cases]

## Troubleshooting

[Common errors and fixes]

## See Also

[Related guides]
```

---

## 🔗 External Resources

When you need more information about a package:

- **CRAN**: https://cran.r-project.org/ (official repository)
- **Tidyverse**: https://www.tidyverse.org/ (ggplot2, dplyr)
- **R-universe**: https://r-universe.dev/ (search all packages)

---

**Last Updated**: 2024-02-07
**Maintainer**: See CLAUDE.md for project instructions
