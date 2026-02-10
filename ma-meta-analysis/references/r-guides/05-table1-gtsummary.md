# Table 1: Study Characteristics with gtsummary

**When to use**: You need to create Table 1 for your manuscript
**Time**: 30-60 minutes
**Stage**: 07 (Manuscript)

**Packages**:

```r
library(gtsummary)   # Summary tables
library(dplyr)       # Data manipulation
library(gt)          # HTML export
library(flextable)   # Word export
```

---

## Quick Start: Basic Table 1

```r
library(gtsummary)
library(dplyr)

# Read extraction data
data <- read.csv("05_extraction/extraction.csv")

# Create Table 1
table1 <- data %>%
  select(age_mean, female_pct, stage_iii_pct) %>%
  tbl_summary(
    label = list(
      age_mean ~ "Age (years)",
      female_pct ~ "Female (%)",
      stage_iii_pct ~ "Stage III (%)"
    ),
    statistic = list(
      all_continuous() ~ "{mean} ({sd})",
      all_categorical() ~ "{n} ({p}%)"
    )
  ) %>%
  bold_labels()

# View in RStudio
table1

# Export to Word
table1 %>%
  as_flex_table() %>%
  flextable::save_as_docx(path = "07_manuscript/tables/table1.docx")
```

**Done!** You now have a professional Table 1 in Word format.

---

## Common Scenarios

### Scenario 1: Study Characteristics (Meta-Analysis)

**Data**: Study-level characteristics from extraction

```r
library(gtsummary)
library(dplyr)

# Select study characteristics
studies <- read.csv("05_extraction/extraction.csv") %>%
  select(
    study_id,
    publication_year,
    n_total,
    age_median,
    female_pct,
    stage_iii_pct,
    ici_type,
    follow_up_months
  )

# Create comprehensive Table 1
table1 <- studies %>%
  tbl_summary(
    label = list(
      publication_year ~ "Publication Year",
      n_total ~ "Sample Size",
      age_median ~ "Median Age (years)",
      female_pct ~ "Female (%)",
      stage_iii_pct ~ "Stage III (%)",
      ici_type ~ "ICI Type",
      follow_up_months ~ "Follow-up (months)"
    ),
    type = list(
      age_median ~ "continuous2",        # Multi-line summary
      follow_up_months ~ "continuous2"
    ),
    statistic = list(
      all_continuous() ~ c("{median} ({p25}, {p75})", "{min} - {max}"),
      all_categorical() ~ "{n} ({p}%)"
    ),
    digits = list(
      age_median ~ 1,
      follow_up_months ~ 1
    ),
    missing = "no"  # Don't show missing row
  ) %>%
  bold_labels() %>%
  modify_header(label ~ "**Characteristic**") %>%
  modify_caption("**Table 1. Characteristics of Included Studies (N = 5)**")

# Print to console
print(table1)

# Export to Word
table1 %>%
  as_flex_table() %>%
  flextable::save_as_docx(path = "07_manuscript/tables/table1.docx")

# Export to HTML (for Quarto)
table1 %>%
  as_gt() %>%
  gt::gtsave("07_manuscript/tables/table1.html")
```

### Scenario 2: Baseline Comparison by Treatment

**Data**: Patient-level data comparing treatment arms

```r
library(gtsummary)

# Read patient data
patients <- read.csv("05_extraction/patient_level.csv")

# Compare ICI vs Control
table1_comparison <- patients %>%
  select(treatment_arm, age, sex, stage, pdl1_status) %>%
  tbl_summary(
    by = treatment_arm,  # Stratify by treatment
    label = list(
      age ~ "Age (years)",
      sex ~ "Sex",
      stage ~ "Disease Stage",
      pdl1_status ~ "PD-L1 Status"
    ),
    statistic = list(
      all_continuous() ~ "{mean} ({sd})",
      all_categorical() ~ "{n} ({p}%)"
    )
  ) %>%
  add_p(
    test = list(
      all_continuous() ~ "t.test",
      all_categorical() ~ "chisq.test"
    )
  ) %>%
  add_overall() %>%      # Add overall column
  add_n() %>%            # Add sample size
  bold_labels() %>%
  italicize_levels() %>%
  modify_spanning_header(c("stat_1", "stat_2") ~ "**Treatment Arm**")

# Export
table1_comparison %>%
  as_flex_table() %>%
  flextable::save_as_docx(path = "07_manuscript/tables/table1_comparison.docx")
```

### Scenario 3: Apply Journal Style

**When**: Submitting to specific journal

```r
library(gtsummary)

# Create table
table1 <- data %>%
  select(age, sex, stage) %>%
  tbl_summary() %>%
  bold_labels()

# Apply JAMA style
table1_jama <- table1 %>%
  theme_gtsummary_journal(journal = "jama")

# Apply Lancet style
table1_lancet <- table1 %>%
  theme_gtsummary_journal(journal = "lancet")

# Apply NEJM style
table1_nejm <- table1 %>%
  theme_gtsummary_journal(journal = "nejm")
```

---

## Customization Options

### Statistics Format

```r
tbl_summary(
  statistic = list(
    all_continuous() ~ "{mean} ({sd})",           # Mean (SD)
    all_continuous() ~ "{median} ({p25}, {p75})", # Median (IQR)
    all_continuous() ~ "{min} - {max}",           # Range
    all_categorical() ~ "{n} ({p}%)"              # Count (%)
  )
)
```

### Multi-Line Summaries

```r
tbl_summary(
  type = list(age ~ "continuous2"),  # Enable multi-line
  statistic = list(
    age ~ c("{mean} ({sd})", "{median} ({p25}, {p75})")
  )
)
```

### Decimal Places

```r
tbl_summary(
  digits = list(
    age ~ 1,              # 1 decimal place
    bmi ~ 2,              # 2 decimal places
    all_categorical() ~ 0  # No decimals for percentages
  )
)
```

### Custom Labels

```r
tbl_summary(
  label = list(
    age_yrs ~ "Age (years)",
    bmi_kgm2 ~ "BMI (kg/m²)",
    tx_duration_days ~ "Treatment Duration (days)"
  )
)
```

---

## P-Value Options

### Auto-Selected Tests

```r
tbl_summary(by = treatment_arm) %>%
  add_p()  # Automatically chooses appropriate test
```

### Manual Test Selection

```r
tbl_summary(by = treatment_arm) %>%
  add_p(
    test = list(
      all_continuous() ~ "wilcox.test",   # Non-parametric
      all_categorical() ~ "fisher.test"   # Exact test
    )
  )
```

### Available Tests

- `"t.test"` - Student's t-test
- `"wilcox.test"` - Wilcoxon rank-sum test
- `"chisq.test"` - Chi-squared test
- `"fisher.test"` - Fisher's exact test
- `"aov"` - ANOVA (>2 groups)
- `"kruskal.test"` - Kruskal-Wallis test

---

## Export Formats

### Word (Most Common)

```r
table1 %>%
  as_flex_table() %>%
  flextable::save_as_docx(path = "table1.docx")
```

### HTML (For Quarto)

```r
table1 %>%
  as_gt() %>%
  gt::gtsave("table1.html")
```

### LaTeX

```r
table1 %>%
  as_kable_extra() %>%
  kableExtra::save_kable("table1.tex")
```

### Copy-Paste

```r
# View in RStudio Viewer, then copy directly
print(table1)
```

---

## Troubleshooting

### Problem: "Error: x must be class <tbl_summary>"

**Cause**: Trying to use add_p() on wrong object type

**Solution**: Make sure you call tbl_summary() first

```r
# ❌ Wrong
data %>% add_p()

# ✅ Correct
data %>% tbl_summary() %>% add_p()
```

### Problem: Table shows raw variable names

**Solution**: Add labels

```r
tbl_summary(
  label = list(
    age_yrs ~ "Age (years)",
    female_pct ~ "Female (%)"
  )
)
```

### Problem: P-values fail with "too few observations"

**Solution**: Use exact tests

```r
add_p(
  test = list(all_categorical() ~ "fisher.test")
)
```

### Problem: Missing data shown as separate row

**Solution**: Set missing option

```r
tbl_summary(missing = "no")  # Don't show missing row
# OR
tbl_summary(missing_text = "Missing")  # Custom text
```

---

## Best Practices

### ✅ Do This

```r
# Select only analytic variables
data %>%
  select(age, sex, stage) %>%  # Only what you need
  tbl_summary()

# Provide clear labels
tbl_summary(
  label = list(
    age_yrs ~ "Age (years)",
    bmi ~ "BMI (kg/m²)"
  )
)

# Specify statistics explicitly
tbl_summary(
  statistic = list(
    all_continuous() ~ "{median} ({p25}, {p75})"
  )
)
```

### ❌ Don't Do This

```r
# Don't include ID columns
data %>%
  tbl_summary()  # Includes patient_id, date_enrolled, etc.

# Don't rely on default labels
tbl_summary()  # Shows "age_yrs", "bmi_kgm2"

# Don't forget to specify tests for small samples
add_p()  # May use inappropriate test
```

---

## Package Documentation

- **gtsummary**: https://www.danieldsjoberg.com/gtsummary/
- **gt**: https://gt.rstudio.com/
- **flextable**: https://ardata-fr.github.io/flextable-book/

---

## See Also

- [06-regression-tables.md](06-regression-tables.md) - Create regression tables
- [08-ggplot2-patterns.md](08-ggplot2-patterns.md) - Best practices for data prep
