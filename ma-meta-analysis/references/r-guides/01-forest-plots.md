# Forest Plots for Meta-Analysis

**When to use**: You have extracted data and need to visualize pooled effect sizes
**Time**: 15-30 minutes
**Stage**: 06 (Analysis)

**Packages**:

```r
library(forestplot)  # ⭐ RECOMMENDED - Medical journal standard
library(metafor)     # Meta-analysis calculations
library(dplyr)       # Data manipulation
library(grid)        # Graphics support
```

---

## ⭐ Quick Start: Professional Forest Plot (RECOMMENDED)

**Using forestplot package** - This is the medical journal standard (NEJM, Lancet, BMJ)

```r
library(forestplot)
library(metafor)
library(dplyr)
library(grid)

# Load and prepare data
extraction <- read.csv("05_extraction/extraction.csv")

# Calculate effect sizes (example: SMD for continuous outcomes)
extraction <- extraction %>%
  mutate(
    smd = (mean_intervention - mean_control) /
          sqrt((sd_intervention^2 + sd_control^2) / 2),
    se_smd = sqrt(1/n_intervention + 1/n_control + smd^2/(2*(n_intervention + n_control))),
    ci_lower = smd - 1.96 * se_smd,
    ci_upper = smd + 1.96 * se_smd
  ) %>%
  arrange(desc(n_total))

# Run meta-analysis
res <- rma(yi = smd, vi = se_smd^2, data = extraction, method = "DL")

# Prepare table text (Header + Studies + Summary)
tabletext <- list(
  c("Study", paste0(extraction$author, " ", extraction$year), "Overall Effect (RE)"),
  c("N", as.character(extraction$n_total), as.character(sum(extraction$n_total))),
  c("SMD [95% CI]",
    sprintf("%.2f [%.2f, %.2f]", extraction$smd, extraction$ci_lower, extraction$ci_upper),
    sprintf("%.2f [%.2f, %.2f]", res$beta[1], res$ci.lb, res$ci.ub))
)

# Prepare data arrays (NA for header row)
mean_values <- c(NA, extraction$smd, res$beta[1])
lower_values <- c(NA, extraction$ci_lower, res$ci.lb)
upper_values <- c(NA, extraction$ci_upper, res$ci.ub)

# Create professional forest plot (300 DPI)
png("figures/forest_plot.png", width=4200, height=3000, res=300)

forestplot(
  labeltext = tabletext,
  graph.pos = 3,  # Graph position (column 3)
  mean = mean_values,
  lower = lower_values,
  upper = upper_values,

  # Title and labels
  title = "Effect of Intervention on Outcome",
  xlab = "     <--- Favors Control ---     --- Favors Intervention --->",

  # Zebra stripes for readability
  hrzl_lines = list(
    "2" = gpar(lwd=1, col="#999999"),
    "4" = gpar(lwd=40, lineend="butt", columns=c(1:3), col="#F5F5F5"),
    "6" = gpar(lwd=40, lineend="butt", columns=c(1:3), col="#F5F5F5"),
    "8" = gpar(lwd=40, lineend="butt", columns=c(1:3), col="#F5F5F5"),
    # Add more rows as needed...
    sprintf("%d", nrow(extraction)+2) = gpar(lwd=60, lineend="butt", columns=c(1:3), col="#DDDDDD")
  ),

  # Text formatting
  txt_gp = fpTxtGp(
    label = gpar(cex=1.1),
    ticks = gpar(cex=1.0),
    xlab = gpar(cex=1.2),
    title = gpar(cex=1.4, fontface="bold")
  ),

  # Colors - BLACK LINES (not blue)
  col = fpColors(
    box = "black",           # Black boxes for studies
    lines = "black",         # Black CI lines
    zero = "gray50",         # Gray reference line
    summary = "black"        # Black summary diamond
  ),

  # Visual parameters
  zero = 0,
  cex = 1.0,
  lineheight = "auto",
  boxsize = 0.35,
  colgap = unit(5, "mm"),
  lwd.ci = 2.5,
  ci.vertices = TRUE,        # Diamond endpoints
  ci.vertices.height = 0.2,

  # Mark summary row
  is.summary = c(FALSE, rep(FALSE, nrow(extraction)), TRUE),

  # Grid lines
  grid = structure(c(-0.5, 0, 0.5, 1.0, 1.5), gp = gpar(lty=2, col="#CCCCCC"))
)

# Add heterogeneity stats
grid.text(
  sprintf("Random-effects model (DerSimonian-Laird) | I² = %.1f%% | τ² = %.3f | p = %.3f | N = %d studies",
          res$I2, res$tau2, res$pval, nrow(extraction)),
  x = 0.5, y = 0.03,
  gp = gpar(cex=0.95, col="#555555")
)

dev.off()
```

**Done!** You now have a professional medical journal-standard forest plot.

---

## Key Features of forestplot Package

### ✅ Why Use forestplot?

1. **Medical journal standard** - NEJM, Lancet, BMJ all use this style
2. **Zebra stripes** - Alternating backgrounds improve readability
3. **Diamond CI endpoints** - More professional than simple lines
4. **Table layout** - Clear, structured presentation
5. **Highly customizable** - Full control over appearance

### ❌ Why NOT Use metafor::forest()?

- No zebra stripes
- Basic styling only
- Less professional appearance
- Limited customization
- Not the journal standard

---

## Common Scenarios

### Scenario 1: Binary Outcomes (RR, OR)

**Data**: Events and totals for intervention and control groups

```r
library(forestplot)
library(metafor)
library(dplyr)

# Load data
data <- read.csv("05_extraction/extraction.csv")

# Calculate log risk ratios
data <- data %>%
  mutate(
    log_rr = log((events_intervention/n_intervention) / (events_control/n_control)),
    se_log_rr = sqrt(1/events_intervention - 1/n_intervention +
                     1/events_control - 1/n_control),
    rr = exp(log_rr),
    ci_lower = exp(log_rr - 1.96 * se_log_rr),
    ci_upper = exp(log_rr + 1.96 * se_log_rr)
  )

# Meta-analysis
res <- rma(yi = log_rr, sei = se_log_rr, data = data, method = "DL")

# Prepare table
tabletext <- list(
  c("Study", paste0(data$author, " ", data$year), "Overall (RE)"),
  c("Events/N (Int)", paste0(data$events_intervention, "/", data$n_intervention), ""),
  c("Events/N (Ctrl)", paste0(data$events_control, "/", data$n_control), ""),
  c("RR [95% CI]",
    sprintf("%.2f [%.2f, %.2f]", data$rr, data$ci_lower, data$ci_upper),
    sprintf("%.2f [%.2f, %.2f]", exp(res$beta[1]), exp(res$ci.lb), exp(res$ci.ub)))
)

mean_values <- c(NA, data$rr, exp(res$beta[1]))
lower_values <- c(NA, data$ci_lower, exp(res$ci.lb))
upper_values <- c(NA, data$ci_upper, exp(res$ci.ub))

# Create forest plot (note: use log scale for RR)
png("figures/forest_rr.png", width=4200, height=3000, res=300)

forestplot(
  labeltext = tabletext,
  graph.pos = 4,
  mean = mean_values,
  lower = lower_values,
  upper = upper_values,

  title = "Risk Ratio: Intervention vs Control",
  xlab = "     <--- Favors Control ---     --- Favors Intervention --->",

  # Black lines and boxes
  col = fpColors(box="black", lines="black", zero="gray50", summary="black"),

  zero = 1,  # Reference line at RR=1
  xlog = TRUE,  # Log scale for risk ratios

  # Other settings as above...
  ci.vertices = TRUE,
  ci.vertices.height = 0.2,
  lwd.ci = 2.5,
  is.summary = c(FALSE, rep(FALSE, nrow(data)), TRUE)
)

dev.off()
```

### Scenario 2: Survival Data (Hazard Ratios)

**Data**: Log hazard ratios and standard errors

```r
library(forestplot)
library(metafor)

# Load data with HR and SE
data <- read.csv("05_extraction/extraction.csv")

# Meta-analysis
res <- rma(yi = log_hr, sei = se_log_hr, data = data, method = "DL")

# Calculate HR and CI
data <- data %>%
  mutate(
    hr = exp(log_hr),
    ci_lower = exp(log_hr - 1.96 * se_log_hr),
    ci_upper = exp(log_hr + 1.96 * se_log_hr)
  )

# Prepare table
tabletext <- list(
  c("Study", paste0(data$study_id), "Overall (RE)"),
  c("Events", as.character(data$n_events), as.character(sum(data$n_events))),
  c("HR [95% CI]",
    sprintf("%.2f [%.2f, %.2f]", data$hr, data$ci_lower, data$ci_upper),
    sprintf("%.2f [%.2f, %.2f]", exp(res$beta[1]), exp(res$ci.lb), exp(res$ci.ub)))
)

mean_values <- c(NA, data$hr, exp(res$beta[1]))
lower_values <- c(NA, data$ci_lower, exp(res$ci.lb))
upper_values <- c(NA, data$ci_upper, exp(res$ci.ub))

# Create forest plot
png("figures/forest_hr.png", width=4200, height=3000, res=300)

forestplot(
  labeltext = tabletext,
  graph.pos = 3,
  mean = mean_values,
  lower = lower_values,
  upper = upper_values,

  title = "Hazard Ratio: Progression-Free Survival",
  xlab = "     <--- Favors Treatment ---     --- Favors Control --->",

  col = fpColors(box="black", lines="black", zero="gray50", summary="black"),

  zero = 1,
  xlog = TRUE,
  ci.vertices = TRUE,
  ci.vertices.height = 0.2,
  lwd.ci = 2.5
)

dev.off()
```

### Scenario 3: Continuous Outcomes (SMD, MD)

**Data**: Means, SDs, and sample sizes

```r
library(forestplot)
library(metafor)

# Calculate standardized mean differences
data <- data %>%
  mutate(
    smd = (mean_intervention - mean_control) /
          sqrt((sd_intervention^2 + sd_control^2) / 2),
    se_smd = sqrt(1/n_intervention + 1/n_control + smd^2/(2*(n_intervention + n_control))),
    ci_lower = smd - 1.96 * se_smd,
    ci_upper = smd + 1.96 * se_smd
  )

# Meta-analysis
res <- rma(yi = smd, vi = se_smd^2, data = data, method = "DL")

# Prepare table
tabletext <- list(
  c("Study", paste0(data$author, " ", data$year), "Overall (RE)"),
  c("N", as.character(data$n_total), as.character(sum(data$n_total))),
  c("SMD [95% CI]",
    sprintf("%.2f [%.2f, %.2f]", data$smd, data$ci_lower, data$ci_upper),
    sprintf("%.2f [%.2f, %.2f]", res$beta[1], res$ci.lb, res$ci.ub))
)

mean_values <- c(NA, data$smd, res$beta[1])
lower_values <- c(NA, data$ci_lower, res$ci.lb)
upper_values <- c(NA, data$ci_upper, res$ci.ub)

# Create forest plot
png("figures/forest_smd.png", width=4200, height=3000, res=300)

forestplot(
  labeltext = tabletext,
  graph.pos = 3,
  mean = mean_values,
  lower = lower_values,
  upper = upper_values,

  title = "Standardized Mean Difference",
  xlab = "     <--- Favors Control ---     --- Favors Intervention --->",

  col = fpColors(box="black", lines="black", zero="gray50", summary="black"),

  zero = 0,  # Reference line at SMD=0
  ci.vertices = TRUE,
  ci.vertices.height = 0.2,
  lwd.ci = 2.5
)

dev.off()
```

---

## Customization Options

### Zebra Stripes (Alternating Backgrounds)

**Purpose**: Improve readability by helping eyes track rows

```r
# For 15 studies (adjust row numbers accordingly)
hrzl_lines = list(
  "2" = gpar(lwd=1, col="#999999"),    # Header line
  "4" = gpar(lwd=40, lineend="butt", columns=c(1:3), col="#F5F5F5"),   # Row 1
  "6" = gpar(lwd=40, lineend="butt", columns=c(1:3), col="#F5F5F5"),   # Row 2
  "8" = gpar(lwd=40, lineend="butt", columns=c(1:3), col="#F5F5F5"),   # Row 3
  "10" = gpar(lwd=40, lineend="butt", columns=c(1:3), col="#F5F5F5"),  # Row 4
  "12" = gpar(lwd=40, lineend="butt", columns=c(1:3), col="#F5F5F5"),  # Row 5
  "14" = gpar(lwd=40, lineend="butt", columns=c(1:3), col="#F5F5F5"),  # Row 6
  "16" = gpar(lwd=40, lineend="butt", columns=c(1:3), col="#F5F5F5"),  # Row 7
  "17" = gpar(lwd=60, lineend="butt", columns=c(1:3), col="#DDDDDD"),  # Summary
  "18" = gpar(lwd=2, col="#444444")    # Bottom line
)
```

**Tips**:

- Every other row gets `col="#F5F5F5"` (light gray)
- Summary row gets `col="#DDDDDD"` (darker gray)
- Adjust row numbers based on your number of studies

### Color Schemes

**Standard (BLACK LINES - RECOMMENDED)**:

```r
col = fpColors(
  box = "black",      # Study boxes
  lines = "black",    # CI lines
  zero = "gray50",    # Reference line
  summary = "black"   # Summary diamond
)
```

**Alternative (Gray scale)**:

```r
col = fpColors(
  box = "#333333",      # Dark gray boxes
  lines = "#333333",    # Dark gray lines
  zero = "gray50",      # Medium gray reference
  summary = "#000000"   # Black summary
)
```

**NOT RECOMMENDED (Colored)**:

```r
# Only use colors if specifically requested
col = fpColors(
  box = "#00468B",     # Blue (Lancet)
  lines = "#00468B",
  zero = "gray50",
  summary = "#ED0000"  # Red (Lancet)
)
```

### Text Size and Formatting

```r
txt_gp = fpTxtGp(
  label = gpar(cex=1.1),           # Row labels
  ticks = gpar(cex=1.0),           # Axis ticks
  xlab = gpar(cex=1.2),            # X-axis label
  title = gpar(cex=1.4, fontface="bold")  # Title
)
```

### CI Endpoints

```r
# Diamond endpoints (professional)
ci.vertices = TRUE
ci.vertices.height = 0.2  # Height of diamonds

# Line width
lwd.ci = 2.5  # Thickness of CI lines
```

---

## Troubleshooting

### Problem: Row count mismatch

**Error**: "You have provided X rows in your mean argument while the labels have Y rows"

**Cause**: Mismatch between tabletext rows and data arrays

**Solution**: Ensure all have same length

```r
# Check lengths
length(tabletext[[1]])  # Should be: 1 (header) + n_studies + 1 (summary)
length(mean_values)     # Should match tabletext length

# Fix: Add NA for header row
mean_values <- c(NA, data$smd, res$beta[1])
lower_values <- c(NA, data$ci_lower, res$ci.lb)
upper_values <- c(NA, data$ci_upper, res$ci.ub)
```

### Problem: Zebra stripes not showing

**Cause**: Wrong row numbers in hrzl_lines

**Solution**: Calculate row numbers dynamically

```r
n_studies <- nrow(data)
summary_row <- n_studies + 2  # Header + studies + 1

# Create zebra stripes automatically
zebra_rows <- seq(4, n_studies*2, by=2)  # Every other row
hrzl_lines <- lapply(zebra_rows, function(i) {
  gpar(lwd=40, lineend="butt", columns=c(1:3), col="#F5F5F5")
})
names(hrzl_lines) <- as.character(zebra_rows)

# Add summary row
hrzl_lines[[as.character(summary_row)]] <- gpar(lwd=60, lineend="butt", columns=c(1:3), col="#DDDDDD")
```

### Problem: Text too small/large

**Solution**: Adjust cex values

```r
# Smaller text
txt_gp = fpTxtGp(label = gpar(cex=0.9))

# Larger text
txt_gp = fpTxtGp(label = gpar(cex=1.3))
```

---

## Export Formats

### PNG (Recommended)

```r
# High resolution (300 DPI)
png("forest_plot.png", width=4200, height=3000, res=300)
forestplot(...)
dev.off()

# Standard resolution (150 DPI)
png("forest_plot.png", width=1400, height=1000, res=150)
forestplot(...)
dev.off()
```

### TIFF (Some journals require)

```r
tiff("forest_plot.tif", width=4200, height=3000, res=300, compression="lzw")
forestplot(...)
dev.off()
```

### EPS (Vector format)

```r
setEPS()
postscript("forest_plot.eps", width=14, height=10)
forestplot(...)
dev.off()
```

---

## Complete Template

**Copy and adapt this template for your meta-analysis**:

```r
library(forestplot)
library(metafor)
library(dplyr)
library(grid)

# 1. Load data
data <- read.csv("05_extraction/extraction.csv")

# 2. Calculate effect sizes (adjust for your measure)
data <- data %>%
  mutate(
    # YOUR EFFECT SIZE CALCULATION HERE
    smd = ...,
    se_smd = ...,
    ci_lower = smd - 1.96 * se_smd,
    ci_upper = smd + 1.96 * se_smd
  ) %>%
  arrange(desc(n_total))  # Order by sample size

# 3. Meta-analysis
res <- rma(yi = smd, vi = se_smd^2, data = data, method = "DL")

# 4. Prepare table (adjust columns as needed)
tabletext <- list(
  c("Study", paste0(data$author, " ", data$year), "Overall Effect (RE)"),
  c("N", as.character(data$n_total), as.character(sum(data$n_total))),
  c("Effect [95% CI]",
    sprintf("%.2f [%.2f, %.2f]", data$smd, data$ci_lower, data$ci_upper),
    sprintf("%.2f [%.2f, %.2f]", res$beta[1], res$ci.lb, res$ci.ub))
)

# 5. Prepare data arrays
mean_values <- c(NA, data$smd, res$beta[1])
lower_values <- c(NA, data$ci_lower, res$ci.lb)
upper_values <- c(NA, data$ci_upper, res$ci.ub)

# 6. Create forest plot
png("figures/forest_plot.png", width=4200, height=3000, res=300)

forestplot(
  labeltext = tabletext,
  graph.pos = 3,
  mean = mean_values,
  lower = lower_values,
  upper = upper_values,

  title = "YOUR TITLE HERE",
  xlab = "     <--- Favors Control ---     --- Favors Intervention --->",

  # Zebra stripes (adjust for your number of studies)
  hrzl_lines = list(
    "2" = gpar(lwd=1, col="#999999"),
    # Add stripes here...
    sprintf("%d", nrow(data)+2) = gpar(lwd=60, lineend="butt", columns=c(1:3), col="#DDDDDD")
  ),

  txt_gp = fpTxtGp(
    label = gpar(cex=1.1),
    ticks = gpar(cex=1.0),
    xlab = gpar(cex=1.2),
    title = gpar(cex=1.4, fontface="bold")
  ),

  # BLACK LINES (standard)
  col = fpColors(box="black", lines="black", zero="gray50", summary="black"),

  zero = 0,  # Adjust for your measure (0 for SMD/MD, 1 for RR/OR/HR)
  cex = 1.0,
  lineheight = "auto",
  boxsize = 0.35,
  colgap = unit(5, "mm"),
  lwd.ci = 2.5,
  ci.vertices = TRUE,
  ci.vertices.height = 0.2,

  is.summary = c(FALSE, rep(FALSE, nrow(data)), TRUE),

  grid = structure(seq(-1, 2, 0.5), gp = gpar(lty=2, col="#CCCCCC"))
)

# 7. Add stats footer
grid.text(
  sprintf("Random-effects model | I² = %.1f%% | τ² = %.3f | p = %.3f | N = %d studies",
          res$I2, res$tau2, res$pval, nrow(data)),
  x = 0.5, y = 0.03,
  gp = gpar(cex=0.95, col="#555555")
)

dev.off()

cat("✅ Forest plot saved: figures/forest_plot.png\n")
```

---

## Package Documentation

- **forestplot**: https://cran.r-project.org/package=forestplot
- **metafor**: https://www.metafor-project.org/
- **grid**: https://www.rdocumentation.org/packages/grid/

**Installation**:

```r
install.packages("forestplot")
install.packages("metafor")
```

---

## See Also

- [02-funnel-plots.md](02-funnel-plots.md) - Publication bias assessment
- [03-subgroup-plots.md](03-subgroup-plots.md) - Subgroup analysis
- [04-multi-panel.md](04-multi-panel.md) - Combine multiple plots
- [09-package-selection.md](09-package-selection.md) - Choosing the right package

---

## Summary

**Key Points**:

1. ✅ **Use forestplot package** - Medical journal standard
2. ✅ **Black lines** - Professional, clean appearance
3. ✅ **Zebra stripes** - Improves readability
4. ✅ **Diamond endpoints** - Professional CI markers
5. ✅ **300 DPI** - Publication quality
6. ✅ **Complete table layout** - All key information visible

**NOT RECOMMENDED**:

- ❌ metafor::forest() - Too basic
- ❌ Blue/colored lines - Unless specifically requested
- ❌ No zebra stripes - Harder to read

**This is the meta-pipe standard for forest plots.**
