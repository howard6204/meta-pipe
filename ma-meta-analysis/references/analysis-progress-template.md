# Meta-Analysis Progress Summary

**Project**: {{PROJECT_NAME}}
**Last Updated**: {{DATE}}

---

## ✅ Completed Analyses

### 1. Primary Outcome Meta-Analysis (Phase 6.1)

**Script**: `01_{{PRIMARY_OUTCOME}}_meta_analysis.R`
**Status**: {{STATUS_1}}

**Key Results**:

- **Pooled estimate**: {{POOLED_ESTIMATE_1}} (95% CI: {{CI_1}}, p={{PVALUE_1}})
- **Heterogeneity**: I²={{I2_1}}%
- **Absolute benefit**: {{ABSOLUTE_BENEFIT_1}}
- **NNT**: {{NNT_1}} patients

**Outputs**:

- [ ] Forest plot: `figures/forest_plot_{{PRIMARY_OUTCOME}}.png`
- [ ] Funnel plot: `figures/funnel_plot_{{PRIMARY_OUTCOME}}.png`
- [ ] Results table: `tables/{{PRIMARY_OUTCOME}}_meta_analysis_results.csv`
- [ ] Report: `{{PRIMARY_OUTCOME}}_META_ANALYSIS_REPORT.md`

**Trials included**: {{N_TRIALS_1}}

---

### 2. Subgroup Analysis (Phase 6.2)

**Script**: `02_{{SUBGROUP_VARIABLE}}_subgroup_analysis.R`
**Status**: {{STATUS_2}}

**Key Results**:

- **Subgroup 1**: {{ESTIMATE_SUBGROUP_1}} (95% CI: {{CI_SUBGROUP_1}}, p={{P_SUBGROUP_1}})
- **Subgroup 2**: {{ESTIMATE_SUBGROUP_2}} (95% CI: {{CI_SUBGROUP_2}}, p={{P_SUBGROUP_2}})
- **Interaction test**: p={{P_INTERACTION}}

**Clinical Conclusion**:
{{SUBGROUP_INTERPRETATION}}

**Outputs**:

- [ ] Forest plot: `figures/forest_plot_{{SUBGROUP_VARIABLE}}_subgroups.png`
- [ ] Comparison table: `tables/{{SUBGROUP_VARIABLE}}_subgroup_comparison.csv`
- [ ] Report: `{{SUBGROUP_VARIABLE}}_SUBGROUP_REPORT.md`

**Trials with subgroup data**: {{N_TRIALS_SUBGROUP}}

---

### 3. Secondary Outcome Meta-Analysis (Phase 6.3)

**Script**: `03_{{SECONDARY_OUTCOME}}_meta_analysis.R`
**Status**: {{STATUS_3}}

**Key Results**:

- **Pooled estimate**: {{POOLED_ESTIMATE_3}} (95% CI: {{CI_3}}, p={{PVALUE_3}})
- **Heterogeneity**: I²={{I2_3}}%
- **Absolute benefit**: {{ABSOLUTE_BENEFIT_3}}
- **NNT**: {{NNT_3}} patients

**Clinical Conclusion**:
{{SECONDARY_OUTCOME_INTERPRETATION}}

**Outputs**:

- [ ] Forest plot: `figures/forest_plot_{{SECONDARY_OUTCOME}}.png`
- [ ] Leave-one-out: `figures/{{SECONDARY_OUTCOME}}_leave_one_out.png`
- [ ] Funnel plot: `figures/funnel_plot_{{SECONDARY_OUTCOME}}.png`
- [ ] Results table: `tables/{{SECONDARY_OUTCOME}}_meta_analysis_results.csv`
- [ ] Report: `{{SECONDARY_OUTCOME}}_META_ANALYSIS_REPORT.md`

**Trials included**: {{N_TRIALS_3}}

---

## 📊 Summary of Key Findings

### Concordance Across Endpoints

| Outcome                   | Measure       | Pooled Estimate       | 95% CI   | p-value      | I²        | Absolute Benefit       | NNT       |
| ------------------------- | ------------- | --------------------- | -------- | ------------ | --------- | ---------------------- | --------- |
| **{{PRIMARY_OUTCOME}}**   | {{MEASURE_1}} | {{POOLED_ESTIMATE_1}} | {{CI_1}} | {{PVALUE_1}} | {{I2_1}}% | {{ABSOLUTE_BENEFIT_1}} | {{NNT_1}} |
| **{{SECONDARY_OUTCOME}}** | {{MEASURE_3}} | {{POOLED_ESTIMATE_3}} | {{CI_3}} | {{PVALUE_3}} | {{I2_3}}% | {{ABSOLUTE_BENEFIT_3}} | {{NNT_3}} |

**Interpretation**:

- {{CONCORDANCE_INTERPRETATION}}

---

## 🎯 Clinical Recommendations

### Treatment Decision Algorithm

```
{{POPULATION}} patient eligible for {{INTERVENTION}}
│
├─ {{ELIGIBILITY_CRITERIA}}
│  └─ {{RECOMMENDATION}}
│     │
│     ├─ First choice: {{FIRST_LINE_TREATMENT}}
│     │  ({{RATIONALE_1}})
│     │
│     ├─ Alternative: {{ALTERNATIVE_TREATMENT}}
│     │  ({{RATIONALE_2}})
│     │
│     └─ {{ADDITIONAL_CONSIDERATIONS}}
│
└─ Contraindications?
   ├─ {{CONTRAINDICATION_1}} → {{ACTION_1}}
   ├─ {{CONTRAINDICATION_2}} → {{ACTION_2}}
   └─ {{CONTRAINDICATION_3}} → {{ACTION_3}}
```

### Patient Counseling

**Benefits**:

- {{BENEFIT_1}}
- {{BENEFIT_2}}
- {{BENEFIT_3}}

**Risks**:

- {{RISK_1}}
- {{RISK_2}}
- {{RISK_3}}

---

## 🔬 Data Extraction Summary

**Phase 5**: {{EXTRACTION_METHOD}} (completed {{EXTRACTION_DATE}})

| Trial | {{PRIMARY_OUTCOME}} Data | {{SECONDARY_OUTCOME}} Data | {{SAFETY_OUTCOME}} Data | {{SUBGROUP_VARIABLE}} Data | Notes |
| ----- | ------------------------ | -------------------------- | ----------------------- | -------------------------- | ----- |

{{TRIAL_DATA_TABLE}}

**Total**: {{N_STUDIES}} studies, N={{TOTAL_N}} participants

- {{PRIMARY_OUTCOME}} data: {{N_PRIMARY}}/{{N_STUDIES}} trials ({{PERCENT_PRIMARY}}%)
- {{SECONDARY_OUTCOME}} data: {{N_SECONDARY}}/{{N_STUDIES}} trials ({{PERCENT_SECONDARY}}%)
- {{SAFETY_OUTCOME}} data: {{N_SAFETY}}/{{N_STUDIES}} trials ({{PERCENT_SAFETY}}%)
- {{SUBGROUP_VARIABLE}} data: {{N_SUBGROUP}}/{{N_STUDIES}} trials ({{PERCENT_SUBGROUP}}%)

---

## 📂 File Structure

```
06_analysis/
├── 01_{{PRIMARY_OUTCOME}}_meta_analysis.R       {{STATUS_ICON_1}} Primary outcome analysis
├── 02_{{SUBGROUP_VARIABLE}}_subgroup_analysis.R {{STATUS_ICON_2}} Subgroup analysis
├── 03_{{SECONDARY_OUTCOME}}_meta_analysis.R     {{STATUS_ICON_3}} Secondary outcome analysis
├── 04_{{TERTIARY_OUTCOME}}_meta_analysis.R      {{STATUS_ICON_4}} Tertiary outcome analysis
├── 05_safety_meta_analysis.R                    {{STATUS_ICON_5}} Safety analysis
├── 06_sensitivity_analysis.R                    {{STATUS_ICON_6}} Sensitivity analysis
├── 07_publication_bias.R                        {{STATUS_ICON_7}} Publication bias
├── 08_meta_regression.R                         {{STATUS_ICON_8}} Meta-regression
├── 09_influence_diagnostics.R                   {{STATUS_ICON_9}} Influence analysis
├── 10_hakn_prediction.R                         {{STATUS_ICON_10}} Prediction intervals
├── 11_grade_assessment.R                        {{STATUS_ICON_11}} GRADE evidence
├── 12_sof_table.R                               {{STATUS_ICON_12}} Summary of findings
│
├── figures/
│   ├── forest_plot_{{PRIMARY_OUTCOME}}.png
│   ├── funnel_plot_{{PRIMARY_OUTCOME}}.png
│   ├── forest_plot_{{SUBGROUP_VARIABLE}}_subgroups.png
│   ├── forest_plot_{{SECONDARY_OUTCOME}}.png
│   ├── {{SECONDARY_OUTCOME}}_leave_one_out.png
│   └── funnel_plot_{{SECONDARY_OUTCOME}}.png
│
└── tables/
    ├── {{PRIMARY_OUTCOME}}_meta_analysis_results.csv
    ├── {{SUBGROUP_VARIABLE}}_subgroup_comparison.csv
    └── {{SECONDARY_OUTCOME}}_meta_analysis_results.csv
```

---

## 📋 Analysis Checklist

### Core Meta-Analysis (01-05)

- [ ] **01**: Primary outcome meta-analysis complete
  - [ ] Forest plot generated (300 DPI)
  - [ ] Funnel plot generated (300 DPI)
  - [ ] Results table created
  - [ ] Heterogeneity assessed (I², τ², Q-test)
  - [ ] Report written

- [ ] **02**: Subgroup analysis complete
  - [ ] Subgroup forest plots generated
  - [ ] Interaction test performed
  - [ ] Comparison table created
  - [ ] Clinical interpretation documented

- [ ] **03**: Secondary outcome meta-analysis complete
  - [ ] Forest plot generated
  - [ ] Sensitivity analysis performed
  - [ ] Funnel plot generated
  - [ ] Results table created

- [ ] **04**: Additional outcomes analyzed
  - [ ] All pre-specified outcomes addressed
  - [ ] Consistency with protocol confirmed

- [ ] **05**: Safety meta-analysis complete
  - [ ] Adverse events pooled
  - [ ] Grade 3-5 events reported
  - [ ] Discontinuation rates analyzed

### Advanced Analyses (06-09)

- [ ] **06**: Sensitivity analysis complete
  - [ ] Leave-one-out analysis
  - [ ] Fixed vs random effects comparison
  - [ ] Influence diagnostics
  - [ ] Results robust across methods

- [ ] **07**: Publication bias assessment
  - [ ] Funnel plot symmetry evaluated
  - [ ] Egger's test performed (continuous outcomes)
  - [ ] Peters' test performed (binary outcomes — preferred over Egger's)
  - [ ] Low-power caveat noted if <10 studies
  - [ ] Trim-and-fill analysis (if needed)
  - [ ] Interpretation documented

- [ ] **08**: Meta-regression complete
  - [ ] Covariate selection justified
  - [ ] Univariate analyses performed
  - [ ] Multivariate model (if appropriate)
  - [ ] Results interpreted

- [ ] **09**: Influence diagnostics
  - [ ] High-influence studies identified
  - [ ] Impact on pooled estimate quantified
  - [ ] Sensitivity to outliers assessed

### Quality Assessment (10-12)

- [ ] **10**: Prediction intervals calculated
  - [ ] Hartung-Knapp adjustment applied
  - [ ] 95% prediction interval reported
  - [ ] Clinical implications discussed

- [ ] **11**: GRADE evidence profile
  - [ ] Risk of bias assessment
  - [ ] Inconsistency evaluation
  - [ ] Indirectness consideration
  - [ ] Imprecision assessment
  - [ ] Publication bias check
  - [ ] Overall quality rating

- [ ] **12**: Summary of findings table
  - [ ] All critical outcomes included
  - [ ] Absolute effects calculated
  - [ ] Quality of evidence stated
  - [ ] Importance ratings assigned

---

## 🔍 Quality Checks

### Data Integrity

- [ ] All extracted data verified against source publications
- [ ] Sample sizes match across outcomes
- [ ] Effect estimates mathematically consistent
- [ ] Confidence intervals correctly calculated
- [ ] No duplicate data from same trial

### Statistical Methods

- [ ] Appropriate effect measure used (RR/OR/HR/MD/SMD)
- [ ] Random-effects model justified
- [ ] Heterogeneity explored if I² >50%
- [ ] Subgroup analyses pre-specified in protocol
- [ ] Multiple testing adjustment considered

### Reporting

- [ ] All figures at 300 DPI minimum
- [ ] Forest plots include study weights
- [ ] Funnel plots include trim-and-fill (if applicable)
- [ ] Tables include all necessary statistics
- [ ] Reports cite original studies correctly

---

## 🚀 Next Steps

### Immediate (This Week)

1. **Complete remaining R scripts** (scripts {{NEXT_SCRIPT}}-12)
2. **Generate all figures** at publication quality (300 DPI)
3. **Finalize all tables** with proper formatting
4. **Write interpretation** for each analysis

### Short-term (Next 2 Weeks)

1. **Integrate results** into manuscript (Stage 07)
2. **Create Summary of Findings** table
3. **Complete GRADE assessment**
4. **Prepare supplementary materials**

### Before Submission

1. **Verify all analyses** match protocol
2. **Cross-check results** between scripts and manuscript
3. **Ensure reproducibility** (all code documented)
4. **Quality assurance** review by co-author

---

## 📊 Progress Tracker

| Phase | Task                            | Status          | Completion Date |
| ----- | ------------------------------- | --------------- | --------------- |
| 6.1   | Primary outcome meta-analysis   | {{STATUS_6_1}}  | {{DATE_6_1}}    |
| 6.2   | Subgroup analysis               | {{STATUS_6_2}}  | {{DATE_6_2}}    |
| 6.3   | Secondary outcome meta-analysis | {{STATUS_6_3}}  | {{DATE_6_3}}    |
| 6.4   | Additional outcomes             | {{STATUS_6_4}}  | {{DATE_6_4}}    |
| 6.5   | Safety meta-analysis            | {{STATUS_6_5}}  | {{DATE_6_5}}    |
| 6.6   | Sensitivity analysis            | {{STATUS_6_6}}  | {{DATE_6_6}}    |
| 6.7   | Publication bias                | {{STATUS_6_7}}  | {{DATE_6_7}}    |
| 6.8   | Meta-regression                 | {{STATUS_6_8}}  | {{DATE_6_8}}    |
| 6.9   | Influence diagnostics           | {{STATUS_6_9}}  | {{DATE_6_9}}    |
| 6.10  | Prediction intervals            | {{STATUS_6_10}} | {{DATE_6_10}}   |
| 6.11  | GRADE assessment                | {{STATUS_6_11}} | {{DATE_6_11}}   |
| 6.12  | Summary of findings             | {{STATUS_6_12}} | {{DATE_6_12}}   |

**Overall Progress**: {{OVERALL_PROGRESS}}% ({{COMPLETED_TASKS}}/{{TOTAL_TASKS}} tasks complete)

---

**Document version**: 1.0
**Date**: {{DATE}}
**Generated by**: Meta-analysis pipeline
