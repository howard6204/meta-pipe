# Manuscript Outline & Checklist

> **Instructions**: Complete this outline BEFORE writing any manuscript sections.
> The agent MUST fill every section below — no blank bullets, no `{{PLACEHOLDERS}}` remaining.
> Review with the user. Do NOT proceed to writing until the user approves this outline.

---

## 1. Project Info

- **Topic**: {{TOPIC}}
- **Target journal**: {{JOURNAL}}
- **Word limit**: {{WORD_LIMIT}} (main text, excluding abstract/references/tables/figures)
- **Table/figure limits**: {{TABLE_LIMIT}} tables, {{FIGURE_LIMIT}} figures (check journal guidelines)
- **Date**: {{DATE}}
- **PROSPERO ID**: {{PROSPERO_ID}} (or "not registered")

---

## 2. Key Messages (define these FIRST — the manuscript serves these)

Write exactly 3-5 take-home messages. Every section of the manuscript must reinforce these.

1. {{KEY_MESSAGE_1}}
2. {{KEY_MESSAGE_2}}
3. {{KEY_MESSAGE_3}}
4. {{KEY_MESSAGE_4}} (optional)
5. {{KEY_MESSAGE_5}} (optional)

---

## 3. Narrative Arc

Define the story structure before writing. The manuscript should flow logically:

- **Opening hook** (Introduction paragraph 1): {{HOOK}} — why should the reader care?
- **Knowledge gap** (Introduction paragraph 3-4): {{GAP}} — what don't we know?
- **What we did** (Methods): {{APPROACH}} — how we addressed the gap
- **What we found** (Results): {{MAIN_FINDING}} — primary result in one sentence
- **What it means** (Discussion): {{SIGNIFICANCE}} — clinical/practical impact
- **Clinical bottom line** (Conclusions): {{BOTTOM_LINE}} — one sentence a clinician takes away

---

## 4. Section Outlines

### 4.1 Abstract (~250-400 words)

- [ ] **Background**: 1-2 sentences on disease burden / clinical context
- [ ] **Objectives**: Primary research question in PICO format
- [ ] **Methods**: Databases, inclusion criteria, effect measure, statistical model
- [ ] **Results**: k studies, N participants; primary + key secondary outcomes with estimates
- [ ] **Conclusions**: Clinical interpretation + certainty of evidence (GRADE)
- [ ] **Keywords**: 3-6 MeSH terms

**Data to embed** (fill from `evidence_map.md`):

| Field | Value |
|-------|-------|
| Studies included | k = {{K_STUDIES}} |
| Total participants | N = {{N_PARTICIPANTS}} |
| Primary outcome | {{PRIMARY_OUTCOME_NAME}} |
| Effect measure | {{EFFECT_MEASURE}} |
| Point estimate | {{ESTIMATE}} |
| 95% CI | {{CI}} |
| p-value | {{P_VALUE}} |
| Heterogeneity I² | {{I2}}% |
| GRADE certainty | {{GRADE}} |
| Key secondary 1 | {{SECONDARY_1_RESULT}} |
| Key secondary 2 | {{SECONDARY_2_RESULT}} |

**Consistency rule**: Every number in the Abstract MUST appear identically in Results.

---

### 4.2 Introduction (~400-600 words)

Paragraph-by-paragraph plan:

**Paragraph 1 — Clinical context**:
- [ ] Disease definition, epidemiology, burden
- Key fact: {{EPIDEMIOLOGY_FACT}}
- Citation: {{EPIDEMIOLOGY_CITATION}}

**Paragraph 2 — Current treatment landscape**:
- [ ] Standard of care, existing approaches, key drugs/strategies
- Key fact: {{TREATMENT_FACT}}
- Citation: {{TREATMENT_CITATION}}

**Paragraph 3 — Biological rationale / mechanistic basis**:
- [ ] Why the intervention might work (biological plausibility)
- Key fact: {{MECHANISM_FACT}}
- Citation: {{MECHANISM_CITATION}}

**Paragraph 4 — Prior evidence and its limitations**:
- [ ] Individual trials or prior reviews and what remains unknown
- Prior review A: {{PRIOR_REVIEW_A}} — found {{FINDING_A}}, limited by {{LIMITATION_A}}
- Prior review B: {{PRIOR_REVIEW_B}} — found {{FINDING_B}}, limited by {{LIMITATION_B}}
- (If no prior reviews exist, state this explicitly: "No prior systematic review has addressed...")

**Paragraph 5 — Knowledge gap and objectives**:
- [ ] Gap statement: what this meta-analysis uniquely addresses
- [ ] Objectives: "We aimed to..." (must mirror PICO and match Methods)
- Objective 1: {{OBJECTIVE_1}}
- Objective 2: {{OBJECTIVE_2}}
- Objective 3: {{OBJECTIVE_3}}

**Citations needed**: ~15-25 references for Introduction. List key BibTeX keys:
{{INTRO_CITATION_KEYS}}

---

### 4.3 Methods (~800-1200 words)

- [ ] **Protocol and registration**: PROSPERO ID, any deviations from registered protocol
- [ ] **Reporting guideline**: PRISMA 2020 (cite: Page 2021)
- [ ] **Eligibility criteria**:
  - Population: {{POPULATION}}
  - Intervention: {{INTERVENTION}}
  - Comparator: {{COMPARATOR}}
  - Outcomes: {{OUTCOMES}}
  - Study design: {{STUDY_DESIGN}}
  - Exclusion criteria: {{EXCLUSIONS}}
- [ ] **Information sources**: List all databases + grey literature sources
  - Databases: {{DATABASES}}
  - Date of last search: {{SEARCH_DATE}}
  - Language restrictions: {{LANGUAGE_RESTRICTIONS}}
- [ ] **Search strategy**: Reference full strategy in supplement
- [ ] **Study selection**: Dual independent screening, conflict resolution, agreement metric
  - Screening tool: {{SCREENING_TOOL}}
  - Kappa: {{KAPPA}}
- [ ] **Data extraction**: Items extracted, tool/form, dual extraction or verification
- [ ] **Risk of bias**: Tool (RoB 2 / ROBINS-I / NOS), domains, who assessed
  - Tool: {{ROB_TOOL}}
  - Assessed by: {{ROB_ASSESSORS}}
- [ ] **Statistical analysis** (each sub-item is required):
  - [ ] Effect measure: {{EFFECT_MEASURE_DETAIL}} (e.g., "risk ratio for dichotomous, hazard ratio for time-to-event")
  - [ ] Model: random-effects with REML estimator + Hartung-Knapp adjustment
  - [ ] Heterogeneity: I², Cochran's Q, tau², prediction intervals
  - [ ] Subgroup analyses (list each): {{SUBGROUPS}}
  - [ ] Sensitivity analyses (list each): {{SENSITIVITY_ANALYSES}}
  - [ ] Publication bias: funnel plot visual inspection, Egger's test (if k >= 10), trim-and-fill
  - [ ] Software: R version, packages (meta, metafor, dmetar, ggplot2)
  - [ ] Significance threshold: two-sided p < 0.05
- [ ] **Certainty of evidence**: GRADE approach, five domains
- [ ] **Traceability table**: Will be auto-inserted by `insert_traceability_table.py`

**Methods citations**: PRISMA 2020, Cochrane Handbook, Hartung-Knapp (IntHout 2014), GRADE (Guyatt 2008), R packages.
BibTeX keys: {{METHODS_CITATION_KEYS}}

---

### 4.4 Results (~1000-1500 words)

**Writing order**: Study selection → Characteristics → Risk of bias → Primary → Secondary → Subgroup → Sensitivity → Publication bias → Safety (if applicable)

#### Study selection
- [ ] PRISMA flow numbers: identified → duplicates removed → screened → excluded → assessed → included
  - Identified: {{N_IDENTIFIED}}
  - After dedup: {{N_DEDUPED}}
  - Screened: {{N_SCREENED}}
  - Excluded at screening: {{N_EXCLUDED_SCREENING}}
  - Full-text assessed: {{N_FULLTEXT}}
  - Excluded at full-text (with reasons): {{N_EXCLUDED_FULLTEXT}}
  - Included: {{N_INCLUDED}}
- [ ] Reference: Figure 1 (PRISMA flow) or `prisma_flow.svg`

#### Study characteristics
- [ ] Summary narrative: k studies, N participants, date range, countries, designs
- [ ] Key characteristics: population, intervention details, comparators, follow-up
- [ ] Reference: Table 1 (study characteristics)

#### Risk of bias
- [ ] Overall assessment (how many low/some concerns/high)
- [ ] Any specific concerns to flag
- [ ] Reference: Table/Supplementary Table (RoB summary)

#### Quantitative results — one block per outcome

**Outcome 1 (PRIMARY): {{PRIMARY_OUTCOME_NAME}}**
- [ ] claim_id: {{CLAIM_ID_1}}
- [ ] Effect estimate: {{ESTIMATE_1}} (95% CI {{CI_1}}), p = {{P_1}}
- [ ] Hartung-Knapp adjusted: yes/no
- [ ] Heterogeneity: I² = {{I2_1}}%, Q p = {{Q_P_1}}, tau² = {{TAU2_1}}
- [ ] Prediction interval: {{PI_1}}
- [ ] Individual study concordance: {{CONCORDANCE_1}}
- [ ] Clinical significance: absolute benefit {{ABS_1}}, NNT = {{NNT_1}}
- [ ] Figure ref: {{FIGURE_REF_1}} (forest plot)
- [ ] Table ref: {{TABLE_REF_1}}
- [ ] R script source: {{R_SCRIPT_1}}
- [ ] BibTeX keys for individual studies: {{STUDY_KEYS_1}}

**Outcome 2: {{SECONDARY_1_NAME}}**
- [ ] claim_id: {{CLAIM_ID_2}}
- [ ] Effect estimate: {{ESTIMATE_2}} (95% CI {{CI_2}}), p = {{P_2}}
- [ ] Heterogeneity: I² = {{I2_2}}%
- [ ] Prediction interval: {{PI_2}}
- [ ] Clinical significance: {{CLINICAL_SIG_2}}
- [ ] Figure ref: {{FIGURE_REF_2}}
- [ ] Table ref: {{TABLE_REF_2}}
- [ ] R script source: {{R_SCRIPT_2}}

**Outcome 3: {{SECONDARY_2_NAME}}**
- [ ] claim_id: {{CLAIM_ID_3}}
- [ ] Effect estimate: {{ESTIMATE_3}} (95% CI {{CI_3}}), p = {{P_3}}
- [ ] Heterogeneity: I² = {{I2_3}}%
- [ ] Clinical significance: {{CLINICAL_SIG_3}}
- [ ] Figure ref: {{FIGURE_REF_3}}
- [ ] Table ref: {{TABLE_REF_3}}
- [ ] R script source: {{R_SCRIPT_3}}

(Add more outcome blocks as needed. Delete unused blocks.)

**Safety outcomes** (if applicable):
- [ ] claim_id: {{CLAIM_ID_SAFETY}}
- [ ] Serious AEs: {{SAE_RESULT}}
- [ ] Specific AEs: {{SPECIFIC_AE_RESULT}}
- [ ] Fatal AEs: {{FATAL_AE_RESULT}}
- [ ] Figure/table ref: {{SAFETY_REF}}

#### Subgroup analyses
- [ ] Subgroup 1: {{SUBGROUP_1}} — interaction p = {{INTERACTION_P_1}}
- [ ] Subgroup 2: {{SUBGROUP_2}} — interaction p = {{INTERACTION_P_2}}
- [ ] Clinical interpretation of subgroup findings

#### Sensitivity analyses
- [ ] Leave-one-out: {{LOO_RESULT}}
- [ ] Model comparison (REML vs DL): {{MODEL_COMPARISON}}
- [ ] Influence diagnostics: {{INFLUENCE_RESULT}}
- [ ] Conclusion: results robust / not robust

#### Publication bias
- [ ] Funnel plot: visual assessment (symmetric / asymmetric)
- [ ] Egger's test: p = {{EGGER_P}} (if k >= 10; if k < 10, state "insufficient studies for formal testing")
- [ ] Trim-and-fill: {{TRIM_FILL}} (if funnel asymmetric)

---

### 4.5 Discussion (~1200-1800 words)

**Writing order**: Principal findings → unique interpretation(s) → comparison → limitations → implications → conclusions

Each subsection MUST have at least 3 specific points filled in below.

#### Principal findings (~200-300 words)
- [ ] Restate main results with clinical significance (NNT/NNH, absolute benefits)
- [ ] Certainty of evidence per GRADE
- [ ] What is new compared to individual trial reports?

Planned points (minimum 3):
1. {{PRINCIPAL_1}}
2. {{PRINCIPAL_2}}
3. {{PRINCIPAL_3}}
4. {{PRINCIPAL_4}} (optional)

#### Topic-specific interpretation (~200-400 words)

This section is UNIQUE to your meta-analysis. It covers interpretive insights that go beyond summarizing results. Examples from the ici-breast-cancer project:
- "Validation of pCR as surrogate endpoint" (proving short-term endpoint predicts long-term)
- "PD-L1 as prognostic, not predictive" (resolving a biomarker controversy)

Plan 1-3 interpretive subsections:

**Interpretation A: {{INTERPRETATION_A_TITLE}}**
- [ ] Key argument: {{INTERPRETATION_A_ARGUMENT}}
- [ ] Supporting evidence: {{INTERPRETATION_A_EVIDENCE}}
- [ ] Clinical implication: {{INTERPRETATION_A_IMPLICATION}}

**Interpretation B: {{INTERPRETATION_B_TITLE}}** (optional)
- [ ] Key argument: {{INTERPRETATION_B_ARGUMENT}}
- [ ] Supporting evidence: {{INTERPRETATION_B_EVIDENCE}}
- [ ] Clinical implication: {{INTERPRETATION_B_IMPLICATION}}

#### Comparison with prior work (~200-400 words)
- [ ] How findings align or diverge from previous reviews/studies
- [ ] Explanations for discrepancies (population, intervention, methods, timing)

Planned comparisons (minimum 2):
1. Prior review/study: {{PRIOR_A}} — their finding: {{PRIOR_A_FINDING}} — our finding: {{OUR_A_FINDING}} — reason for agreement/divergence: {{REASON_A}}
2. Prior review/study: {{PRIOR_B}} — their finding: {{PRIOR_B_FINDING}} — our finding: {{OUR_B_FINDING}} — reason for agreement/divergence: {{REASON_B}}
3. {{PRIOR_C}} (optional)

#### Limitations (~200-400 words)

Organize by level (all three levels MUST be addressed):

**Study-level limitations** (minimum 2):
1. {{STUDY_LIM_1}} (e.g., risk of bias, small sample, short follow-up, industry sponsorship)
2. {{STUDY_LIM_2}}
3. {{STUDY_LIM_3}} (optional)

**Review-level limitations** (minimum 2):
1. {{REVIEW_LIM_1}} (e.g., search scope, language restrictions, no IPD, unpublished data)
2. {{REVIEW_LIM_2}}
3. {{REVIEW_LIM_3}} (optional)

**Outcome-level limitations** (minimum 1):
1. {{OUTCOME_LIM_1}} (e.g., surrogate vs hard endpoints, measurement heterogeneity, reporting inconsistency)
2. {{OUTCOME_LIM_2}} (optional)

**Statistical limitations** (minimum 1):
1. {{STAT_LIM_1}} (e.g., few studies for subgroup/bias analyses, wide prediction intervals, Hartung-Knapp conservative)
2. {{STAT_LIM_2}} (optional)

#### Implications and future research (~200-300 words)

**Clinical implications** (minimum 3):
1. {{CLINICAL_IMPL_1}}
2. {{CLINICAL_IMPL_2}}
3. {{CLINICAL_IMPL_3}}

**Future research directions** (minimum 3, must be SPECIFIC):
1. {{FUTURE_1}} — study design: {{FUTURE_1_DESIGN}}, population: {{FUTURE_1_POP}}, outcome: {{FUTURE_1_OUTCOME}}
2. {{FUTURE_2}} — study design: {{FUTURE_2_DESIGN}}, population: {{FUTURE_2_POP}}, outcome: {{FUTURE_2_OUTCOME}}
3. {{FUTURE_3}} — study design: {{FUTURE_3_DESIGN}}, population: {{FUTURE_3_POP}}, outcome: {{FUTURE_3_OUTCOME}}

#### Conclusions (~50-100 words)
- [ ] 2-3 sentences: main finding, certainty, clinical bottom line
- [ ] Must reinforce key messages from Section 2
- Draft: {{CONCLUSION_DRAFT}}

---

## 5. Tables & Figures Plan

### Main Tables

| # | Title | Source file | Columns/content | Format | Status |
|---|-------|------------ |-----------------|--------|--------|
| 1 | {{TABLE_1_TITLE}} | {{TABLE_1_SOURCE}} | {{TABLE_1_COLS}} | PNG via gt | [ ] |
| 2 | {{TABLE_2_TITLE}} | {{TABLE_2_SOURCE}} | {{TABLE_2_COLS}} | PNG via gt | [ ] |
| 3 | {{TABLE_3_TITLE}} | {{TABLE_3_SOURCE}} | {{TABLE_3_COLS}} | PNG via gt | [ ] |

### Supplementary Tables

| # | Title | Source file | Status |
|---|-------|------------|--------|
| S1 | Full search strategy | 02_search/ | [ ] |
| S2 | Excluded studies with reasons | 03_screening/ | [ ] |
| S3 | Risk of bias assessment | 05_extraction/ | [ ] |
| S4 | GRADE evidence profile | 08_reviews/ | [ ] |
| S5 | {{SUPP_TABLE_5}} (optional) | {{SOURCE_S5}} | [ ] |

### Main Figures

| # | Title | Panels | Source files | 300 DPI | Status |
|---|-------|--------|-------------|---------|--------|
| 1 | PRISMA flow diagram | single | prisma_flow.svg | [ ] | [ ] |
| 2 | {{FIG_2_TITLE}} | {{FIG_2_PANELS}} | {{FIG_2_SOURCE}} | [ ] | [ ] |
| 3 | {{FIG_3_TITLE}} | {{FIG_3_PANELS}} | {{FIG_3_SOURCE}} | [ ] | [ ] |
| 4 | {{FIG_4_TITLE}} | {{FIG_4_PANELS}} | {{FIG_4_SOURCE}} | [ ] | [ ] |

### Supplementary Figures

| # | Title | Source files | Status |
|---|-------|-------------|--------|
| S1 | {{SUPP_FIG_1}} | {{SUPP_FIG_1_SOURCE}} | [ ] |
| S2 | {{SUPP_FIG_2}} | {{SUPP_FIG_2_SOURCE}} | [ ] |

**Figure legends** (draft key content for each figure):
- Figure 1: {{FIG_1_LEGEND}}
- Figure 2: {{FIG_2_LEGEND}}
- Figure 3: {{FIG_3_LEGEND}}
- Figure 4: {{FIG_4_LEGEND}}

---

## 6. References Plan

- [ ] Estimated total citations: ~{{N_REFS}}
- [ ] Methodological refs (must include): PRISMA 2020, Cochrane Handbook, Hartung-Knapp (IntHout 2014), GRADE (Guyatt 2008/2011), R meta package (Balduzzi 2019)
- [ ] Clinical refs: landmark trials, prior reviews, guidelines
- [ ] CSL style file: {{CSL_FILE}} (e.g., lancet.csl, jama.csl)
- [ ] DOI coverage target: >= 90%
- [ ] BibTeX key naming convention: `firstauthor_year` (e.g., `smith_2020`)

**Citation key inventory** (list ALL keys that will appear in the manuscript):
```
{{CITATION_KEY_LIST}}
```

---

## 7. Word Count Targets

| Section | Target | Actual | Status |
|---------|--------|--------|--------|
| Abstract | {{ABSTRACT_TARGET}} | — | [ ] |
| Introduction | {{INTRO_TARGET}} | — | [ ] |
| Methods | {{METHODS_TARGET}} | — | [ ] |
| Results | {{RESULTS_TARGET}} | — | [ ] |
| Discussion | {{DISCUSSION_TARGET}} | — | [ ] |
| **Total** | **{{TOTAL_TARGET}}** | — | [ ] |

Journal-specific notes: {{JOURNAL_NOTES}}

---

## 8. Supplementary Materials Plan

| Item | Content | File format | Status |
|------|---------|-------------|--------|
| Search strategies | Full database queries | PDF/DOCX | [ ] |
| PRISMA checklist | 27-item completed checklist | PDF | [ ] |
| Additional tables | S1-S{{N}} listed above | PNG + DOCX | [ ] |
| Additional figures | S1-S{{N}} listed above | PNG (300 DPI) | [ ] |
| R analysis code | Reproducible scripts | .R files | [ ] |

---

## 9. Pre-Writing Readiness Gate

**Hard requirements** — ALL must be checked before proceeding to Phase 2:

### Data readiness
- [ ] `evidence_map.md` exists and reviewed — all analysis outputs accounted for
- [ ] `result_claims.csv` exists — every quantitative result has a claim row with claim_id, effect estimate, CI, p-value, figure ref, table ref, and citation keys
- [ ] Every claim_id in `result_claims.csv` has a matching R script output that was verified

### Figures readiness
- [ ] All figure PNGs exist in `06_analysis/figures/` at 300 DPI
- [ ] Multi-panel assembly plan defined (which panels combine into which figure)
- [ ] Figure legends drafted (Section 5 above)

### Tables readiness
- [ ] All table PNGs exist in `06_analysis/tables/` (or R export script ready)
- [ ] Table content verified against `result_claims.csv` — numbers match

### References readiness
- [ ] `references.bib` exists with all citation keys listed in Section 6
- [ ] CSL style file present in `07_manuscript/`
- [ ] DOI coverage >= 90% (check with `grep -c "doi" references.bib`)

### Outline completeness
- [ ] NO `{{PLACEHOLDERS}}` remain in this file (search for `{{` — must return 0 hits)
- [ ] All Discussion subsections have >= 3 specific points filled in
- [ ] All Limitation levels have >= minimum points filled in
- [ ] Key messages (Section 2) are finalized
- [ ] Narrative arc (Section 3) is coherent

### User approval
- [ ] User has reviewed and approved this outline

---

## 10. Cross-Section Consistency Checks (verify after writing)

- [ ] Abstract numbers match Results numbers exactly
- [ ] Introduction objectives match Methods description match Results reporting order
- [ ] Every figure/table referenced in Results exists in the Tables/Figures sections
- [ ] Every claim in Discussion traces back to a result in Results
- [ ] Conclusions do not introduce new findings not reported in Results
- [ ] Word counts are within journal limits (Section 7 updated with actuals)
- [ ] Citation keys in all sections exist in `references.bib`
