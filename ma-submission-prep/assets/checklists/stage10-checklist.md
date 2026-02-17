# Stage 10: Pre-Submission Final Checklist

**When to use**: Manuscript at 95%+ readiness, planning to submit within 1-2 days

**Time**: 1-2 hours (5 steps)

**Prerequisites**:
- ✅ Phase 3 Quality Refinement complete
- ✅ Publication readiness score ≥95%
- ✅ Initial draft renders successfully (`make docx` works)

---

## 5-Step Workflow

### ☐ Step 1: PROSPERO Registration (30 min) ⚠️ MANDATORY

**URL**: https://www.crd.york.ac.uk/prospero/

**Quick Actions**:
- [ ] Navigate to PROSPERO website
- [ ] Click "Submit a new record"
- [ ] Choose "Post-hoc registration" (analysis already complete)
- [ ] Fill form using quick-fill guide below
- [ ] Submit and save PROSPERO ID (format: `CRD42026XXXXXX`)

**📖 Detailed guide**: [PROSPERO Registration Guide](../../references/prospero-registration-guide.md)

**Quick Fill Guide** (copy from your project):

```yaml
Title: [Copy from 07_manuscript/index.qmd front matter]
Review question: [Copy from 01_protocol/pico.yaml → research_question]
Review type:
  - Intervention
  - Network Meta-Analysis (or Pairwise Meta-Analysis)

Eligibility criteria:
  Population: [Copy from pico.yaml → population]
  Intervention: [Copy from pico.yaml → intervention]
  Comparator: [Copy from pico.yaml → comparator]
  Outcomes: [Copy from pico.yaml → outcomes]
  Study design: Randomized controlled trials (or Observational studies)

Information sources:
  - PubMed
  - Embase
  - Cochrane CENTRAL
  - Conference abstracts (ASCO, ESMO, WCLC)

Search dates: Inception to [YYYY from 02_search]

Data extraction: Dual independent review

Risk of bias: Cochrane RoB 2 (or ROBINS-I)

Synthesis methods:
  - Bayesian network meta-analysis using gemtc package in R (or)
  - Random-effects pairwise meta-analysis using metafor package in R

Stage: Completed (post-hoc registration)
Funding: None
Conflicts of interest: None declared
```

**Pass Criteria**:
- ✅ PROSPERO ID obtained (format: `CRD42026XXXXXX`)
- ✅ ID saved in secure location

---

### ☐ Step 2: Update 4 Files with PROSPERO ID (10 min)

**Actions**:
- [ ] **File 1**: `projects/<project-name>/01_protocol/pico.yaml`
  - Search for: `prospero_id:`
  - Replace with: `prospero_id: "CRD42026XXXXXX"`

- [ ] **File 2**: `projects/<project-name>/07_manuscript/02_methods.qmd`
  - Search for: `PROSPERO ID: [PENDING]`
  - Replace with: `PROSPERO ID: CRD42026XXXXXX`

- [ ] **File 3**: `projects/<project-name>/author_statements.md`
  - Search for: `PROSPERO ID: [PENDING]`
  - Replace with: `PROSPERO ID: CRD42026XXXXXX`

- [ ] **File 4**: `projects/<project-name>/09_qa/prisma_nma_checklist.md`
  - Search for item 24a
  - Replace with: `PROSPERO ID: CRD42026XXXXXX`

**Pass Criteria**:
- ✅ All 4 files updated
- ✅ No `[PENDING]` placeholders remain (search entire project)

**Command to verify**:
```bash
cd projects/<project-name>
grep -r "\[PENDING\]" . --exclude-dir=.git
# Should return no results
```

---

### ☐ Step 3: Final QA Validation (10 min)

**Actions**:
- [ ] Run publication readiness score:
  ```bash
  cd /Users/htlin/meta-pipe/tooling/python
  uv run ../../ma-end-to-end/scripts/publication_readiness_score.py \
    --root ../../projects/<project-name> \
    --out ../../projects/<project-name>/09_qa/readiness_score.md
  ```

- [ ] Run enhanced claim audit:
  ```bash
  uv run ../../ma-publication-quality/scripts/claim_audit.py \
    --abstract ../../projects/<project-name>/07_manuscript/00_abstract.qmd \
    --results ../../projects/<project-name>/07_manuscript/03_results.qmd \
    --discussion ../../projects/<project-name>/07_manuscript/04_discussion.qmd \
    --out ../../projects/<project-name>/09_qa/claim_audit.md
  ```

- [ ] Review outputs:
  ```bash
  cat ../../projects/<project-name>/09_qa/readiness_score.md
  cat ../../projects/<project-name>/09_qa/claim_audit.md
  ```

**Pass Criteria**:
- ✅ Readiness score ≥95%
- ✅ Zero CRITICAL severity overclaims
- ✅ Zero HIGH severity overclaims
- ✅ PRISMA checklist 27/27 (or 32/32 for NMA)

**If fails**:
- Review `claim_audit.md` for specific issues
- Fix issues in manuscript
- Re-run claim audit
- Repeat until pass criteria met

---

### ☐ Step 4: Final Rendering (5 min)

**Actions**:
- [ ] Render Word document:
  ```bash
  cd /Users/htlin/meta-pipe/projects/<project-name>/07_manuscript
  make docx
  ```

- [ ] Verify output file:
  ```bash
  ls -lh index.docx  # Should be 500-800KB
  ```

- [ ] Open and perform visual QA:
  ```bash
  open index.docx
  ```

**Visual QA Checklist**:
- [ ] All figures embedded (300 DPI, clear legends)
- [ ] All tables formatted correctly (PNG embedded or native Word tables)
- [ ] PROSPERO ID present in Methods section (not `[PENDING]`)
- [ ] References formatted per target journal style
- [ ] Word count within journal limit (see header comment in `index.qmd`)
- [ ] No obvious formatting errors (broken sections, missing content)

**📋 Detailed visual QA**: See [Visual QA Checklist](visual-qa-checklist.md)

**Pass Criteria**:
- ✅ `index.docx` generated successfully
- ✅ File size 500-800KB (indicates figures/tables embedded)
- ✅ All visual QA items pass

---

### ☐ Step 5: Prepare Cover Letter (30 min)

**Choose target journal template**:

**Option A: JAMA Oncology** (clinical impact, scenario-based guidance)
- [ ] Copy template: `ma-submission-prep/assets/templates/cover-letter-jama.md`
- [ ] Fill placeholders: `[TITLE]`, `[N]`, `[PRIMARY FINDING]`, `[SCENARIO COUNT]`

**Option B: Lancet Oncology** (high novelty, global health impact)
- [ ] Copy template: `ma-submission-prep/assets/templates/cover-letter-lancet.md`
- [ ] Fill placeholders: `[TITLE]`, `[N]`, `[NOVEL CONTRIBUTION]`

**Option C: Nature Medicine** (mechanistic insights)
- [ ] Copy template: `ma-submission-prep/assets/templates/cover-letter-nature.md`
- [ ] Fill placeholders: `[TITLE]`, `[MECHANISM]`, `[BIOLOGICAL INSIGHT]`

**General Template Structure** (5 paragraphs):

```markdown
Dear Editor,

[P1: Hook + Research Gap - 3-4 sentences]
We submit "[Title]" for consideration as [Article Type] in [Journal].
[State clinical problem and evidence gap]

[P2: Study Novelty - 3-4 sentences]
This is the first [network meta-analysis/systematic review] to [unique contribution].
Using [Bayesian/frequentist] methods on [N] RCTs (N=[total patients]), we demonstrate
[primary finding with effect size]. [Explain paradoxes if any].

[P3: Clinical Impact - 2-3 sentences]
Our [scenario-based/mechanistic] guidance translates findings into [X] actionable
[treatment pathways/recommendations]. This directly addresses [Journal]'s mission of
[clinical translation/mechanistic insight/evidence synthesis].

[P4: Journal Fit - 2-3 sentences]
This work aligns with recent [Journal] publications on [related topic] (Author et al. YYYY)
and extends the evidence base through [rigorous methods/novel comparison].

[P5: Compliance - 2 sentences]
This review was registered on PROSPERO (CRD42026XXXXXX). All authors approved the
manuscript. We declare no conflicts of interest or funding.

We believe this work will interest [Journal] readers and welcome peer review.

Sincerely,
[Your name, title, institution]
```

**Save as**: `projects/<project-name>/cover_letter_<journal>.md`

**Pass Criteria**:
- ✅ Cover letter saved
- ✅ All placeholders filled
- ✅ PROSPERO ID correct
- ✅ Journal-specific customization applied

---

## Submission Package Checklist

Before uploading to journal portal, verify all files ready:

### Required Files (9 items)

- [ ] **Manuscript**: `index.docx` (500-800KB)
- [ ] **Cover Letter**: `cover_letter_<journal>.md`
- [ ] **PRISMA-NMA Checklist**: `09_qa/prisma_nma_checklist.md` (or `prisma_checklist.md` for pairwise)
- [ ] **Supplementary Materials**: `07_manuscript/supplementary_materials.pdf`
- [ ] **Author Statements**: `author_statements.md`
- [ ] **Figure 1**: Network graph (NMA) or PRISMA flow (pairwise) - 300 DPI PNG
- [ ] **Figure 2**: Forest plots (EFS, OS) - 300 DPI PNG
- [ ] **Figure 3**: League table (NMA) or funnel plot (pairwise) - 300 DPI PNG
- [ ] **Figure 4**: SUCRA rankings (NMA) or sensitivity (pairwise) - 300 DPI PNG

### Optional Files (3 items - accelerates review)

- [ ] **Graphical Abstract**: Visual summary (if journal encourages)
- [ ] **Video Abstract**: 3-min explanation (JAMA Oncology encourages)
- [ ] **Plain Language Summary**: ≤150 words (Nature Medicine requires)

---

## Post-Submission Actions

After submitting to journal portal:

- [ ] **Save confirmation email** → `projects/<project-name>/10_submission/confirmation.eml`
- [ ] **Record submission date** → Update `pico.yaml` with `submission_date: "YYYY-MM-DD"`
- [ ] **Create response tracker** → `projects/<project-name>/10_submission/review_responses.md`

**Expected timeline**:
- Initial editorial decision: 1-2 weeks (desk accept/reject)
- Peer review: 4-8 weeks
- Revision: 2-4 weeks (minor) or 6-12 weeks (major)
- Final decision: 3-6 months from submission

---

## Troubleshooting

### "Readiness score <95%"

**Action**:
1. Review `09_qa/readiness_score.md` for specific failing components
2. Common issues:
   - PRISMA checklist incomplete → Fill missing items
   - GRADE assessment missing → Complete `08_reviews/grade_summary.csv`
   - Claim audit issues → Fix overclaims in manuscript
3. Re-run readiness score after fixes

### "PROSPERO registration rejected"

**Common rejection reasons**:
1. Duplicate registration (search PROSPERO first)
2. Protocol not detailed enough (add more methods detail)
3. Incomplete eligibility criteria (ensure PICO complete)

**Action**: Revise and resubmit, or register on OSF (Open Science Framework) as alternative

### "Cover letter too long"

**Action**:
- JAMA/Lancet: ≤1 page (500-600 words)
- Nature Medicine: ≤2 pages (800-1000 words)
- Trim P3-P4 if needed, keep P1-P2-P5 intact

---

**Checklist Version**: 1.0.0 (2026-02-17)
**Source**: early-immuno-timing-nma project (validated)
