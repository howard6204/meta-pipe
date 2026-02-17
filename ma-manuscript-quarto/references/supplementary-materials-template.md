# Supplementary Materials Template

**Time**: 1-2 hours to compile
**Purpose**: Provide detailed methods, data, and analyses required by high-impact journals
**Target Journals**: Lancet Oncology, JAMA Oncology, BMJ, Annals of Internal Medicine

---

## Standard Structure (All Meta-Analyses)

### **Required Components**

#### **1. Supplementary Methods**
- **S1.1 Search Strategy** (Full Boolean queries for all databases)
- **S1.2 Eligibility Criteria** (Detailed inclusion/exclusion)
- **S1.3 Data Extraction Form** (Complete template)
- **S1.4 Risk of Bias Assessment** (Detailed criteria per domain)
- **S1.5 Statistical Methods** (Model specifications, software versions)

#### **2. Supplementary Tables**
- **Table S1**: Complete Search Strategies (per database)
- **Table S2**: Excluded Studies with Reasons (after full-text review)
- **Table S3**: Study Characteristics (extended version with all extracted variables)
- **Table S4**: Risk of Bias Assessment (per study, per domain)
- **Table S5**: Summary of Findings (GRADE SoF table, if not in main text)

#### **3. Supplementary Figures**
- **Figure S1**: Risk of Bias Summary (traffic light plot)
- **Figure S2**: Funnel Plot (publication bias assessment)
- **Figure S3**: Leave-One-Out Sensitivity Analysis (forest plot)

---

## Additional Components for Network Meta-Analysis (NMA)

### **Required NMA-Specific Items**

#### **NMA Supplementary Tables**
- **Table S6**: Network Geometry Summary (treatments, comparisons, direct evidence counts)
- **Table S7**: League Table (all pairwise comparisons, upper/lower triangular matrix)
- **Table S8**: Treatment Rankings (SUCRA/P-scores with 95% credible intervals)
- **Table S9**: Inconsistency Assessment (node-splitting results, design-by-treatment interaction)
- **Table S10**: GRADE Summary for Indirect Comparisons (CINeMA assessments)

#### **NMA Supplementary Figures**
- **Figure S4**: Network Graph (all outcomes, node size = sample size, edge width = study count)
- **Figure S5**: Rankograms (probability distributions for treatment rankings)
- **Figure S6**: Contribution Matrix (direct evidence contribution to network estimates)
- **Figure S7**: Comparison-Adjusted Funnel Plot (NMA publication bias)
- **Figure S8**: Net Heat Plot (inconsistency heat map)

---

## Journal-Specific Requirements

### **Lancet Oncology**

**Supplementary Material Limit**: No strict limit, but concise presentation preferred

**Required**:
- ✅ Complete search strategies (all databases)
- ✅ PRISMA-NMA flow diagram (if not in main text)
- ✅ GRADE Summary of Findings
- ✅ Detailed statistical methods (Bayesian priors, MCMC settings for NMA)
- ✅ Individual study data (forest plot data)

**Recommended**:
- Subgroup analyses
- Meta-regression results
- Sensitivity analyses (exclude high-risk studies)

**Format**: PDF (single file) or Word (editable tables)

---

### **JAMA Oncology**

**Supplementary Material Limit**: 20 pages (excluding tables/figures)

**Required**:
- ✅ eTable 1: Search strategies
- ✅ eTable 2: Excluded studies with reasons
- ✅ eTable 3: Risk of bias per study
- ✅ eFigure 1: PRISMA flow diagram (if not in main)
- ✅ eFigure 2: Funnel plot

**Naming Convention**: Use "eTable" and "eFigure" prefixes

**Format**: PDF only, embed all fonts

---

### **BMJ**

**Supplementary Material Limit**: No strict limit

**Required**:
- ✅ Web appendix with complete methods
- ✅ PRISMA checklist (27 items for pairwise, 32 for NMA)
- ✅ Individual participant data (if applicable)
- ✅ GRADE assessments

**Format**: Single PDF with bookmarks for navigation

---

## File Naming Convention

```
<project-name>_supplementary_materials.pdf
<project-name>_eTable_1_search_strategies.csv
<project-name>_eFigure_1_funnel_plot.png
```

---

## Template Content (Copy-Paste Ready)

### **Supplementary Methods S1.1: Search Strategy**

```markdown
## Supplementary Methods S1.1: Electronic Database Search Strategies

### PubMed (NLM)
**Date**: 2024-01-15
**Results**: 1,245 records

```
((neoadjuvant[Title/Abstract] OR perioperative[Title/Abstract] OR adjuvant[Title/Abstract])
AND (immunotherapy[MeSH Terms] OR checkpoint inhibitor*[Title/Abstract] OR pembrolizumab[Supplementary Concept] OR nivolumab[Supplementary Concept])
AND (NSCLC[Title/Abstract] OR non-small cell lung*[Title/Abstract] OR "Carcinoma, Non-Small-Cell Lung"[MeSH])
AND (randomized controlled trial[Publication Type] OR randomized[Title/Abstract] OR placebo[Title/Abstract]))
NOT (metastatic[Title/Abstract] OR advanced[Title/Abstract] OR stage IV[Title/Abstract])
```

### Embase (Elsevier)
**Date**: 2024-01-15
**Results**: 987 records

```
('neoadjuvant'/exp OR neoadjuvant:ab,ti OR 'perioperative'/exp OR perioperative:ab,ti OR 'adjuvant'/exp OR adjuvant:ab,ti)
AND ('immunotherapy'/exp OR 'checkpoint inhibitor':ab,ti OR 'pembrolizumab'/exp OR 'nivolumab'/exp)
AND ('non small cell lung cancer'/exp OR nsclc:ab,ti OR 'non-small cell lung':ab,ti)
AND ('randomized controlled trial'/exp OR randomized:ab,ti OR placebo:ab,ti)
NOT (metastatic:ab,ti OR advanced:ab,ti OR 'stage iv':ab,ti)
AND [embase]/lim NOT [medline]/lim
```

### Cochrane CENTRAL
**Date**: 2024-01-15
**Results**: 156 records

```
#1 MeSH descriptor: [Immunotherapy] explode all trees
#2 (checkpoint inhibitor* OR pembrolizumab OR nivolumab):ti,ab,kw
#3 #1 OR #2
#4 MeSH descriptor: [Carcinoma, Non-Small-Cell Lung] explode all trees
#5 (NSCLC OR non-small cell lung*):ti,ab,kw
#6 #4 OR #5
#7 (neoadjuvant OR perioperative OR adjuvant):ti,ab,kw
#8 #3 AND #6 AND #7
#9 NOT (metastatic OR advanced OR stage IV):ti,ab,kw
#10 #8 AND #9
```

### Scopus (Elsevier)
**Date**: 2024-01-15
**Results**: 1,102 records

```
TITLE-ABS-KEY((neoadjuvant OR perioperative OR adjuvant) AND (immunotherapy OR "checkpoint inhibitor" OR pembrolizumab OR nivolumab) AND (NSCLC OR "non-small cell lung") AND (randomized OR RCT OR trial) AND NOT (metastatic OR advanced OR "stage IV"))
AND PUBYEAR > 2014
AND (LIMIT-TO(DOCTYPE, "ar") OR LIMIT-TO(DOCTYPE, "re"))
```

**Total Unique Records After Deduplication**: 2,156
```
```

---

### **Supplementary Table S2: Excluded Studies with Reasons**

| First Author, Year | Title | Reason for Exclusion |
|--------------------|-------|----------------------|
| Chen 2023 | Neoadjuvant immunotherapy in NSCLC | Wrong study design (single-arm, no control) |
| Forde 2022 | Nivolumab in stage III NSCLC | Wrong population (unresectable stage III) |
| Herbst 2020 | IMpower110 trial | Wrong intervention (first-line metastatic, not perioperative) |
| Paz-Ares 2021 | KEYNOTE-189 extension | Duplicate publication (already included parent trial) |
| Reck 2016 | KEYNOTE-024 | Wrong population (metastatic, PD-L1 ≥50%) |
| ... | ... | ... |

**Total Excluded After Full-Text Review**: 48 studies

---

### **Supplementary Table S4: Risk of Bias Assessment (RoB 2)**

| Study | D1: Randomization | D2: Deviations | D3: Missing Data | D4: Outcome Measurement | D5: Selective Reporting | Overall Risk |
|-------|-------------------|----------------|------------------|-------------------------|-------------------------|--------------|
| CheckMate 816 (Forde 2022) | Low | Low | Low | Low | Low | **Low** |
| KEYNOTE-671 (Wakelee 2023) | Low | Low | Low | Low | Low | **Low** |
| AEGEAN (Heymach 2024) | Low | Some concerns | Low | Low | Low | **Some concerns** |
| IMpower010 (Felip 2021) | Low | Low | Some concerns | Low | Low | **Some concerns** |
| KEYNOTE-091 (O'Brien 2022) | Low | Low | Low | Low | Low | **Low** |
| CheckMate 77T (Cascone 2024) | Low | Low | Low | Low | Low | **Low** |

**Domain Explanations**:
- D1: Randomization process
- D2: Deviations from intended interventions
- D3: Missing outcome data
- D4: Measurement of the outcome
- D5: Selection of the reported result

**Judgment Criteria**:
- **Low**: No concerns in all domains
- **Some concerns**: At least one domain with some concerns, no high risk
- **High**: At least one domain at high risk OR multiple domains with some concerns

---

### **Supplementary Figure S1: Risk of Bias Summary**

*(Include traffic light plot generated from R)*

```r
# Generate RoB summary plot
library(robvis)
rob_summary <- rob_summary(rob_data, tool = "ROB2")
ggsave("figures/rob_summary.png", width=10, height=6, dpi=300)
```

---

### **Supplementary Table S7: League Table (NMA)**

|                     | **Perioperative ICI** | **Neoadjuvant ICI** | **Adjuvant ICI** | **Surgery Alone** |
|---------------------|-----------------------|---------------------|------------------|-------------------|
| **Perioperative ICI** | —                     | 0.87 (0.65-1.18)    | 0.74 (0.58-0.95) | 0.56 (0.47-0.68) |
| **Neoadjuvant ICI**   | 1.15 (0.85-1.54)      | —                   | 0.85 (0.62-1.17) | 0.65 (0.48-0.87) |
| **Adjuvant ICI**      | 1.35 (1.05-1.72)      | 1.18 (0.85-1.62)    | —                | 0.76 (0.63-0.92) |
| **Surgery Alone**     | 1.78 (1.47-2.14)      | 1.54 (1.15-2.07)    | 1.32 (1.09-1.59) | —                |

**Interpretation**:
- **Upper triangle**: Event-Free Survival (EFS) hazard ratios (row vs column)
- **Lower triangle**: Overall Survival (OS) hazard ratios (row vs column)
- Values <1.0 favor row treatment; values >1.0 favor column treatment
- Bold indicates 95% CI excludes 1.0 (statistically significant)

---

### **Supplementary Figure S4: Network Graph**

*(Include network geometry plot from R)*

```r
# Generate network graph
library(netmeta)
netgraph(net, plastic = FALSE, thickness = "number.of.studies",
         points = TRUE, cex.points = 5, col = "black", cex = 1.5)
```

**Characteristics**:
- Node size proportional to total sample size
- Edge width proportional to number of studies
- Direct comparisons: solid lines
- No indirect-only comparisons in this network

---

## Pipeline Commands to Generate Supplementary Materials

### **Step 1: Compile Search Strategies**
```bash
cd /Users/htlin/meta-pipe/tooling/python

uv run ../../ma-manuscript-quarto/scripts/compile_search_strategies.py \
  --root ../../projects/<project> --round round-01 \
  --out ../../projects/<project>/07_manuscript/supplementary/table_s1_search.md
```

### **Step 2: Generate Excluded Studies Table**
```bash
uv run ../../ma-manuscript-quarto/scripts/build_excluded_studies.py \
  --screening ../../projects/<project>/03_screening/round-01/decisions.csv \
  --filter-column final_decision --filter-value Exclude \
  --out ../../projects/<project>/07_manuscript/supplementary/table_s2_excluded.csv
```

### **Step 3: Export RoB Summary**
```r
# In R (from 06_analysis/)
source("08_bias.R")
ggsave("../07_manuscript/supplementary/figure_s1_rob.png", rob_plot, width=10, height=6, dpi=300)
```

### **Step 4: Assemble Final PDF**
```bash
# Use Quarto to compile supplementary materials
cd projects/<project>/07_manuscript
quarto render supplementary.qmd --to pdf
```

---

## Quality Checklist

Before submission, verify:

- [ ] All tables/figures referenced in main text are included
- [ ] All supplementary items are referenced in main text (e.g., "see Table S3")
- [ ] Consistent numbering (S1, S2, S3...)
- [ ] High resolution (≥300 DPI for all figures)
- [ ] File size <20 MB (or per journal limit)
- [ ] Editable tables provided (CSV or Excel) if requested
- [ ] PRISMA checklist completed (27 items for pairwise, 32 for NMA)

---

## Common Mistakes

❌ **Missing cross-references**: Every supplementary item should be cited in main text
❌ **Low resolution figures**: Use dpi=300 in R, not default 72
❌ **Inconsistent naming**: Use "Table S1" not "Supplementary Table 1"
❌ **Forgetting GRADE for NMA**: Indirect comparisons need GRADE assessment (CINeMA)
❌ **Missing search dates**: Always include search date for reproducibility

---

## Example Directory Structure

```
07_manuscript/
├── supplementary/
│   ├── methods_s1_search_strategy.md
│   ├── table_s1_search_strategies.csv
│   ├── table_s2_excluded_studies.csv
│   ├── table_s3_study_characteristics.csv
│   ├── table_s4_rob_assessment.csv
│   ├── table_s5_grade_sof.csv
│   ├── table_s6_network_geometry.csv       # NMA only
│   ├── table_s7_league_table.csv           # NMA only
│   ├── table_s8_treatment_rankings.csv     # NMA only
│   ├── figure_s1_rob_summary.png
│   ├── figure_s2_funnel_plot.png
│   ├── figure_s3_sensitivity.png
│   ├── figure_s4_network_graph.png         # NMA only
│   ├── figure_s5_rankograms.png            # NMA only
│   └── supplementary_materials.pdf         # Final compiled
```

---

## Time Estimates

| Task | Time (Pairwise MA) | Time (NMA) |
|------|-------------------|------------|
| Compile search strategies | 30 min | 30 min |
| Generate excluded studies table | 15 min | 15 min |
| Export RoB summary | 15 min | 15 min |
| Create GRADE SoF table | 45 min | 90 min (CINeMA) |
| Generate NMA-specific tables | — | 60 min |
| Generate NMA-specific figures | — | 45 min |
| Assemble and format PDF | 30 min | 45 min |
| **Total** | **2-3 hours** | **4-5 hours** |

---

## References

1. PRISMA 2020 Explanation and Elaboration: https://www.bmj.com/content/372/bmj.n160
2. PRISMA-NMA Extension: https://www.acpjournals.org/doi/10.7326/M14-2385
3. GRADE Handbook: https://gdt.gradepro.org/app/handbook/handbook.html
4. CINeMA (GRADE for NMA): https://cinema.ispm.unibe.ch/
