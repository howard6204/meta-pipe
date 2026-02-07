# Project Start Plan

## Early TNBC Neoadjuvant Immunotherapy Meta-Analysis

**Date**: 2026-02-07
**Status**: ✅ Feasibility Confirmed (15/16, 94%) - READY TO START
**Expected Completion**: 2026-05-01 (2.5-4 months)

---

## ✅ Completed Preparatory Work

### 1. Feasibility Assessment (4 hours) ✅

- **Score**: 15/16 (94%) - EXCELLENT
- **Literature**: 95 studies identified, 5-8 RCTs expected
- **Pilot extraction**: 3 studies tested, average 17 min per study
- **Decision**: **GO** - Proceed with full systematic review

### 2. Topic Definition ✅

- **Focus**: TNBC-specific (differentiated from Villacampa 2024's pan-breast cancer analysis)
- **Primary outcome**: pCR (pathologic complete response)
- **Secondary outcomes**: EFS, OS, adverse events
- **Key studies identified**: KEYNOTE-522, IMpassion031, GeparNuevo, CamRelief, NeoPACT

### 3. Differentiation Strategy ✅

- TNBC-exclusive focus (vs Villacampa's all subtypes)
- Include 2025 data (CamRelief)
- TNBC-specific subgroups (PD-L1, TILs, AR status)
- Long-term survival emphasis (KEYNOTE-522 OS with 75-month follow-up)

---

## 📋 Phase 1: Protocol Development (Week 1-2)

### Week 1: Draft Protocol

#### Day 1-2: PICO Finalization and Protocol Outline

**Time**: 6-8 hours

**Tasks**:

1. ✅ Create `01_protocol/pico.yaml` (structured PICO definition)
2. ✅ Draft eligibility criteria (inclusion/exclusion)
3. ✅ Define all outcomes precisely
4. ✅ Specify subgroup analyses

**Output**:

- `01_protocol/pico.yaml` - Machine-readable PICO
- `01_protocol/eligibility.md` - Detailed eligibility criteria

**Commands**:

```bash
cd /Users/htlin/meta-pipe/01_protocol
# Create pico.yaml manually or use template
# Create eligibility.md
```

---

#### Day 3-4: Search Strategy Development

**Time**: 4-6 hours

**Tasks**:

1. Develop PubMed search strategy
2. Translate to Embase syntax
3. Develop Cochrane CENTRAL strategy
4. Plan conference abstract search

**Output**:

- `01_protocol/search_strategy.md` - Documented search strategies for all databases

**Key search components**:

- Population: TNBC terms (triple-negative, ER-negative + PR-negative + HER2-negative)
- Intervention: ICI terms (pembrolizumab, atezolizumab, durvalumab, immune checkpoint)
- Setting: neoadjuvant, preoperative
- Design: randomized, RCT, trial

---

#### Day 5: PROSPERO Registration Document

**Time**: 4-6 hours

**Tasks**:

1. Generate PROSPERO protocol using template
2. Complete all required sections
3. Review and finalize

**Output**:

- `01_protocol/prospero_registration.md` - Complete PROSPERO submission document

**Command**:

```bash
cd /Users/htlin/meta-pipe/tooling/python
uv add pyyaml
uv run generate_prospero_protocol.py \
  --pico ../../01_protocol/pico.yaml \
  --out ../../01_protocol/prospero_registration.md
```

**Manual sections to complete**:

- Review team members and affiliations
- Funding sources
- Conflicts of interest
- Timeline

---

### Week 2: Submit to PROSPERO

#### Day 6: Submit to PROSPERO

**Time**: 2 hours

**Tasks**:

1. Create PROSPERO account (if not exists): https://www.crd.york.ac.uk/prospero/
2. Copy content from `prospero_registration.md`
3. Submit online form
4. Save confirmation email and registration number

**Expected**: Registration number format: CRD42026XXXXX

**Output**:

- Update `01_protocol/pico.yaml` with PROSPERO ID once approved
- Save PDF of submitted protocol

---

#### Day 7-14: Wait for PROSPERO Approval (Parallel Work)

While waiting for PROSPERO approval (typically 5-10 days), begin:

**Parallel Task 1: Set Up Reference Management**

```bash
# Install Zotero or use existing
# Create collection: "TNBC Neoadjuvant Immunotherapy MA"
# Import pilot studies (KEYNOTE-522, IMpassion031, GeparNuevo)
```

**Parallel Task 2: Prepare Data Extraction Form**

- Draft `05_extraction/data-dictionary.md`
- List all variables to extract
- Define coding rules

**Parallel Task 3: Set Up Screening Tool**

- Create Rayyan account: https://www.rayyan.ai/
- Invite co-reviewer
- Prepare screening form

---

## 📋 Phase 2: Literature Search (Week 3)

### Week 3: Execute Full Search

#### Day 15-16: Multi-Database Search

**Time**: 6-8 hours

**Tasks**:

1. PubMed search and export
2. Embase search and export
3. Cochrane CENTRAL search
4. ClinicalTrials.gov search
5. Conference abstracts (ASCO, ESMO, SABCS)

**Commands**:

```bash
cd /Users/htlin/meta-pipe/tooling/python

# PubMed search
uv run ../../ma-search-bibliography/scripts/pubmed_fetch.py \
  --query "<query from protocol>" \
  --email "your@email.com" \
  --out-bib ../../02_search/round-01/pubmed.bib \
  --out-log ../../02_search/round-01/pubmed_log.md

# Scopus (if available)
uv run ../../ma-search-bibliography/scripts/scopus_fetch.py \
  --query "<query>" \
  --out-bib ../../02_search/round-01/scopus.bib

# Embase (if available)
uv run ../../ma-search-bibliography/scripts/embase_fetch.py \
  --query "<query>" \
  --out-bib ../../02_search/round-01/embase.bib

# Cochrane
uv run ../../ma-search-bibliography/scripts/cochrane_fetch.py \
  --query "<query>" \
  --out-bib ../../02_search/round-01/cochrane.bib
```

**Expected Results**:

- PubMed: ~95 results (from feasibility assessment)
- Embase: ~120-150 results (larger database)
- Cochrane: ~20-30 results
- Total: ~235-275 before deduplication

---

#### Day 17: Deduplication

**Time**: 2-3 hours

**Commands**:

```bash
cd /Users/htlin/meta-pipe/tooling/python

# Merge and deduplicate
uv run ../../ma-search-bibliography/scripts/multi_db_dedupe.py \
  --in-bib ../../02_search/round-01/pubmed.bib \
  --in-bib ../../02_search/round-01/scopus.bib \
  --in-bib ../../02_search/round-01/embase.bib \
  --in-bib ../../02_search/round-01/cochrane.bib \
  --out-merged ../../02_search/round-01/merged.bib \
  --out-bib ../../02_search/round-01/dedupe.bib \
  --out-log ../../02_search/round-01/dedupe_log.md
```

**Expected**: ~150-180 unique records after deduplication

---

#### Day 17: Convert to Screening Format

**Time**: 1 hour

**Command**:

```bash
cd /Users/htlin/meta-pipe/tooling/python

uv run bib_to_csv.py \
  --in-bib ../../02_search/round-01/dedupe.bib \
  --out-csv ../../03_screening/round-01/decisions.csv
```

**Output**: `03_screening/round-01/decisions.csv` with columns:

- record_id, title, authors, year, abstract, journal
- decision_r1, decision_r2, final_decision, exclusion_reason, notes

---

## 📋 Phase 3: Screening (Week 4-5)

### Week 4-5: Title/Abstract Screening

#### Day 18-25: Dual Independent Screening

**Time**: 15-20 hours total (split between 2 reviewers)

**Process**:

1. Import `decisions.csv` to Rayyan
2. Reviewer 1 and Reviewer 2 screen independently
3. Mark as: Include / Exclude / Uncertain
4. Export decisions back to CSV

**Decision criteria**:

- **Include**: RCT, neoadjuvant, TNBC, ICI + chemo vs chemo
- **Exclude**: Not RCT, metastatic, not TNBC, no control arm
- **Uncertain**: Unclear from abstract, need full text

**Expected screening rate**: ~20-30 records per hour
**Expected time**: 150-180 records ÷ 25 records/hour = 6-8 hours per reviewer

---

#### Day 26: Resolve Conflicts

**Time**: 2-3 hours

**Tasks**:

1. Identify discordant decisions (Reviewer 1 ≠ Reviewer 2)
2. Discuss and resolve each conflict
3. Update `final_decision` column
4. Calculate inter-rater agreement (Cohen's kappa)

**Command**:

```bash
cd /Users/htlin/meta-pipe/tooling/python

uv run ../../ma-screening-quality/scripts/dual_review_agreement.py \
  --file ../../03_screening/round-01/decisions.csv \
  --col-a decision_r1 \
  --col-b decision_r2 \
  --out ../../03_screening/round-01/agreement.md
```

**Expected kappa**: ≥0.60 (moderate agreement)
**Expected includes**: ~15-25 studies proceed to full-text

---

## 📋 Phase 4: Full-Text Review (Week 6-7)

### Week 6-7: Full-Text Retrieval and Review

#### Day 27-30: Retrieve Full Texts

**Time**: 6-8 hours

**Tasks**:

1. Extract included study IDs
2. Query Unpaywall for Open Access PDFs
3. Download OA PDFs automatically
4. Manually retrieve remaining PDFs via institutional access

**Commands**:

```bash
cd /Users/htlin/meta-pipe/tooling/python

# Extract subset
uv run ../../ma-search-bibliography/scripts/bib_subset_by_ids.py \
  --in-csv ../../03_screening/round-01/decisions.csv \
  --in-bib ../../02_search/round-01/dedupe.bib \
  --out-bib ../../04_fulltext/round-01/fulltext_subset.bib \
  --filter-column final_decision \
  --filter-value Include

# Query Unpaywall
uv run ../../ma-fulltext-management/scripts/unpaywall_fetch.py \
  --in-bib ../../04_fulltext/round-01/fulltext_subset.bib \
  --out-csv ../../04_fulltext/round-01/unpaywall_results.csv \
  --email "your@email.com"

# Download OA PDFs
uv run ../../ma-fulltext-management/scripts/download_oa_pdfs.py \
  --in-csv ../../04_fulltext/round-01/unpaywall_results.csv \
  --pdf-dir ../../04_fulltext/round-01/pdfs \
  --out-log ../../04_fulltext/round-01/pdf_download.log
```

**Expected**: 40-60% PDFs downloaded automatically, rest need manual retrieval

---

#### Day 31-35: Full-Text Screening Against Eligibility

**Time**: 8-10 hours

**Tasks**:

1. Read each full text
2. Verify meets all inclusion criteria
3. Document exclusion reasons for excluded studies
4. Create PRISMA flow diagram data

**Criteria verification**:

- [ ] Randomized controlled trial (confirmed in methods)
- [ ] Early or locally advanced TNBC (not metastatic)
- [ ] Neoadjuvant setting (pre-surgery)
- [ ] ICI + chemo vs chemo comparison
- [ ] pCR or survival outcomes reported
- [ ] ≥20 patients per arm

**Expected final inclusions**: 5-8 RCTs

---

## 📋 Phase 5: Data Extraction (Week 8-9)

### Week 8-9: Extract Data from Included Studies

#### Day 36-40: LLM-Assisted Data Extraction

**Time**: 5-8 hours

**Recommended: Use Claude CLI for extraction**

**Commands**:

```bash
cd /Users/htlin/meta-pipe/tooling/python

# Step 1: Extract PDF text
uv add pdfplumber
uv run extract_pdf_text.py \
  --pdf-dir ../../04_fulltext/round-01/pdfs \
  --out-jsonl ../../05_extraction/round-01/pdf_texts.jsonl

# Step 2: LLM extraction using Claude CLI
uv run llm_extract_cli.py \
  --pdf-jsonl ../../05_extraction/round-01/pdf_texts.jsonl \
  --data-dict ../../05_extraction/data-dictionary.md \
  --out-jsonl ../../05_extraction/round-01/llm_extracted_all.jsonl \
  --cli claude

# Step 3: Convert to CSV
uv run jsonl_to_extraction_csv.py \
  --jsonl ../../05_extraction/round-01/llm_extracted_all.jsonl \
  --data-dict ../../05_extraction/data-dictionary.md \
  --out-csv ../../05_extraction/round-01/extraction.csv

# Step 4: Validate
uv run validate_extraction.py \
  --csv ../../05_extraction/round-01/extraction.csv \
  --out-md ../../05_extraction/round-01/validation_report.md
```

**Expected time savings**: 65-70% vs manual extraction

---

#### Day 41-42: Manual Review and Correction

**Time**: 3-4 hours

**Tasks**:

1. Review LLM extraction output
2. Verify all data against PDFs
3. Correct any errors or missing data
4. Dual extraction for 20% of studies (quality check)

---

#### Day 43: Risk of Bias Assessment

**Time**: 4-5 hours

**Command**:

```bash
cd /Users/htlin/meta-pipe/tooling/python

uv run ../../ma-peer-review/scripts/init_rob2_assessment.py \
  --extraction ../../05_extraction/round-01/extraction.csv \
  --out-csv ../../03_screening/round-01/quality_rob2.csv \
  --out-md ../../03_screening/round-01/rob2_assessment.md
```

**RoB 2 domains**:

1. Randomization process
2. Deviations from intended interventions
3. Missing outcome data
4. Measurement of the outcome
5. Selection of reported result

**Rating per domain**: Low / Some concerns / High risk

---

## 📋 Phase 6: Meta-Analysis (Week 10-11)

### Week 10-11: Statistical Analysis in R

#### Day 44-48: Core Meta-Analyses

**Time**: 10-12 hours

**Setup**:

```r
# In 06_analysis/
# Copy R scripts from ma-meta-analysis/assets/r/
# Install packages
install.packages(c("meta", "metafor", "dmetar", "ggplot2"))
```

**Analysis sequence**:

1. `01_setup.R` - Load data, check structure
2. `02_effect_sizes.R` - Calculate RR for pCR, HR for survival
3. `03_models.R` - Random-effects meta-analysis
4. `04_subgroups_meta_regression.R` - Subgroup analyses
5. `05_plots.R` - Forest plots, funnel plots
6. `06_tables.R` - Summary tables
7. `07_sensitivity.R` - Sensitivity analyses
8. `08_bias.R` - Publication bias assessment

**Primary analysis**: pCR pooled RR
**Secondary analyses**: EFS HR, OS HR
**Subgroups**: PD-L1 status, ICI type, chemotherapy backbone

---

#### Day 49-50: Publication Quality Analyses

**Time**: 4-5 hours

**Additional R scripts**:

```r
# From ma-publication-quality/assets/r/
source("10_hakn_prediction.R")      # Hartung-Knapp prediction intervals
source("11_influence_diagnostics.R") # Leave-one-out analysis
source("12_sof_table.R")            # Summary of Findings table
```

---

## 📋 Phase 7: Manuscript Writing (Week 12-14)

### Week 12-13: Draft Manuscript

#### Day 51-55: PRISMA Flow and Evidence Tables

**Time**: 6-8 hours

**Commands**:

```bash
cd /Users/htlin/meta-pipe/tooling/python

# PRISMA flow diagram
uv run ../../ma-manuscript-quarto/scripts/prisma_flow.py \
  --root ../.. --round round-01 \
  --out ../../07_manuscript/prisma_flow.svg

# Study characteristics table
uv run ../../ma-manuscript-quarto/scripts/build_study_characteristics.py \
  --extraction ../../05_extraction/round-01/extraction.csv \
  --out-csv ../../07_manuscript/study_characteristics.csv \
  --out-md ../../07_manuscript/study_characteristics.md

# Evidence map
uv run ../../ma-manuscript-quarto/scripts/build_evidence_map.py \
  --root ../.. --round round-01 \
  --out ../../07_manuscript/evidence_map.md
```

---

#### Day 56-60: Write Manuscript Sections

**Time**: 15-20 hours

**Section order** (Quarto format):

1. `00_abstract.qmd` - Structured abstract (250 words)
2. `01_introduction.qmd` - Background, rationale, objectives
3. `02_methods.qmd` - PRISMA-compliant methods
4. `03_results.qmd` - Study selection, characteristics, meta-analysis results
5. `04_discussion.qmd` - Summary, interpretation, limitations
6. `05_references.qmd` - Bibliography

**Key writing tips**:

- Emphasize TNBC-specific findings (differentiation from Villacampa)
- Highlight 2025 data inclusion
- Discuss subgroup results (PD-L1, ICI type)
- Address heterogeneity explicitly
- Cite KEYNOTE-522 as landmark trial

---

#### Day 61: Render Manuscript

**Time**: 2 hours

**Command**:

```bash
cd /Users/htlin/meta-pipe/tooling/python

uv run ../../ma-manuscript-quarto/scripts/render_manuscript.py \
  --root ../.. \
  --index ../../07_manuscript/index.qmd
```

**Output**: `07_manuscript/manuscript.pdf` and `manuscript.docx`

---

### Week 14: Finalize and QA

#### Day 62-65: Quality Assurance Checks

**Time**: 6-8 hours

**Commands**:

```bash
cd /Users/htlin/meta-pipe/tooling/python

# Final QA report
uv run ../../ma-end-to-end/scripts/final_qa_report.py \
  --root ../.. --round round-01 \
  --out ../../09_qa/final_qa_report.md

# Claim audit (verify all claims have citations)
uv run ../../ma-publication-quality/scripts/claim_audit.py \
  --abstract ../../07_manuscript/00_abstract.qmd \
  --results ../../07_manuscript/03_results.qmd \
  --out ../../09_qa/claim_audit.md

# Cross-reference check (figures/tables mentioned in text)
uv run ../../ma-publication-quality/scripts/crossref_check.py \
  --manuscript-dir ../../07_manuscript \
  --figures-dir ../../06_analysis/figures \
  --out ../../09_qa/crossref_report.md

# GRADE evidence quality (optional but recommended)
uv run ../../ma-peer-review/scripts/init_grade_summary.py \
  --extraction ../../05_extraction/round-01/extraction.csv \
  --out-md ../../08_reviews/grade_summary.md
```

---

#### Day 66-68: Internal Review and Revision

**Time**: 8-10 hours

**Tasks**:

1. Co-author review (share draft with team)
2. Address comments and suggestions
3. Verify all references are correct
4. Check PRISMA checklist compliance
5. Finalize supplementary materials

---

## 📋 Phase 8: Submission (Week 15)

### Week 15: Prepare Submission Package

#### Day 69-70: Submission Preparation

**Time**: 4-6 hours

**Command**:

```bash
cd /Users/htlin/meta-pipe/tooling/python

# Generate submission checklist for target journal
uv run ../../ma-manuscript-quarto/scripts/init_submission_checklist.py \
  --journal "JAMA Oncology" \
  --out ../../07_manuscript/submission_checklist.md
```

**Submission package**:

- [ ] Cover letter (emphasize novelty: TNBC-specific, 2025 data)
- [ ] Manuscript (PDF and Word)
- [ ] Supplementary materials (forest plots, sensitivity analyses, PRISMA checklist)
- [ ] PRISMA checklist (filled)
- [ ] Conflict of interest forms
- [ ] Author contribution statements
- [ ] PROSPERO registration certificate

---

#### Day 71: Submit to Journal

**Target journals** (in order of preference):

1. **JAMA Oncology** (IF ~29)
2. **Lancet Oncology** (IF ~54)
3. **Journal of Clinical Oncology** (IF ~45)
4. **Annals of Oncology** (IF ~51)
5. **ESMO Open** (IF ~6, faster review)

**Submission platform**: ScholarOne or journal-specific system

---

## 📊 Timeline Summary

| Phase                         | Duration | Cumulative | Key Deliverable                      |
| ----------------------------- | -------- | ---------- | ------------------------------------ |
| **Preparation** (Feasibility) | 4 hours  | 4 hours    | ✅ Feasibility Report (15/16)        |
| **Phase 1: Protocol**         | 2 weeks  | 2 weeks    | PROSPERO registration                |
| **Phase 2: Search**           | 1 week   | 3 weeks    | Deduplicated bibliographic database  |
| **Phase 3: Screening**        | 2 weeks  | 5 weeks    | ~5-8 included studies                |
| **Phase 4: Full-text**        | 2 weeks  | 7 weeks    | PDFs + final inclusion decisions     |
| **Phase 5: Extraction**       | 2 weeks  | 9 weeks    | Extraction CSV + RoB assessment      |
| **Phase 6: Analysis**         | 2 weeks  | 11 weeks   | Forest plots + meta-analysis results |
| **Phase 7: Manuscript**       | 3 weeks  | 14 weeks   | Complete manuscript draft            |
| **Phase 8: Submission**       | 1 week   | 15 weeks   | Journal submission                   |

**Total duration**: **15 weeks (3.75 months)**
**Expected submission date**: **2026-05-20** (from 2026-02-07)

---

## 🎯 Success Metrics

**Process quality**:

- [ ] PROSPERO registered before screening
- [ ] Dual independent screening with kappa ≥0.60
- [ ] All studies with RoB 2 assessment
- [ ] PRISMA checklist 100% complete

**Analysis quality**:

- [ ] ≥5 RCTs included
- [ ] Total n ≥2000 participants
- [ ] I² <60% for primary outcome (pCR)
- [ ] Subgroup analyses for PD-L1, ICI type, chemo backbone

**Publication target**:

- [ ] Submit to Q1 oncology journal (IF >10)
- [ ] Acceptance within 3-6 months of submission
- [ ] Final publication within 12 months of starting project

---

## 🚧 Risk Mitigation

| Risk                             | Probability | Impact | Mitigation                                   |
| -------------------------------- | ----------- | ------ | -------------------------------------------- |
| PROSPERO rejection               | Low         | Medium | Have protocol ready to resubmit immediately  |
| Fewer studies than expected (<5) | Low         | High   | Broaden to include phase I/II if needed      |
| High heterogeneity (I²>70%)      | Medium      | Medium | Random effects, extensive subgroup analysis  |
| Missing data (PD-L1 subgroups)   | Medium      | Low    | Contact authors, analyze available data only |
| Journal rejection                | Medium      | Low    | Have 2-3 backup journals ready               |
| Co-author delays                 | Medium      | Medium | Set clear deadlines, start writing early     |

---

## 📞 Next Actions (TODAY)

### Immediate (Next 2 hours):

1. **Create pico.yaml** (30 min)
   - Structured PICO definition
   - Machine-readable format

2. **Draft eligibility criteria** (30 min)
   - Detailed inclusion/exclusion

3. **Start search strategy** (60 min)
   - Refine PubMed query
   - Prepare for multi-database search

**Command to start**:

```bash
cd /Users/htlin/meta-pipe/01_protocol
# Create files or let me help you generate them
```

---

## 📝 Notes

- **Communication**: Set up weekly team meetings (Mondays, 1 hour)
- **Version control**: Use git for all code and manuscripts
- **Backup**: Daily backup of all data files
- **Documentation**: Keep detailed log of all decisions and deviations from protocol

---

**Status**: ✅ READY TO START
**Confidence**: Very High (94% feasibility score)
**Expected outcome**: High-quality meta-analysis published in Q1 journal within 12 months

**Next milestone**: Complete pico.yaml and eligibility.md (today, 1 hour)

---

**Document version**: 1.0
**Last updated**: 2026-02-07
**Owner**: Meta-analysis team
