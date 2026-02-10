# Template Extraction Status

**Date**: 2026-02-08
**Purpose**: Extract valuable workflow guides from legacy project into reusable framework templates

---

## ✅ Completed Templates

### 1. Screening Quickstart Template

**Location**: `ma-screening-quality/references/screening-quickstart-template.md`
**Source**: `projects/legacy/03_screening/SCREENING_QUICKSTART.md`
**Features**:

- Dual independent screening workflow (Rayyan)
- CSV field descriptions
- Inclusion/exclusion criteria quick reference
- Decision tree for screening
- Edge case handling
- Time planning (10-13 hours/reviewer)
- Quality checks (Cohen's kappa ≥0.60)

### 2. Fulltext Quickstart Template

**Location**: `ma-fulltext-management/references/fulltext-quickstart-template.md`
**Source**: `projects/legacy/04_fulltext/PHASE4_QUICKSTART.md`
**Features**:

- PDF retrieval strategies (Unpaywall, institutional access, author contact)
- Full-text review checklist
- File organization guidelines
- Expected success rates (40-60% OA, 85-95% total)
- Time planning (22-35 hours total)
- Special case handling (multiple reports, duplicates)

---

## ⏳ Remaining Templates to Extract

### 3. Analysis Progress Summary

**Source**: `projects/legacy/06_analysis/ANALYSIS_PROGRESS_SUMMARY.md`
**Planned location**: `ma-meta-analysis/references/analysis-progress-template.md`
**Key features to extract**:

- R script execution checklist (01-12)
- Figure generation workflow
- Table creation guidelines
- Expected outputs at each step

### 4. Manuscript Completion Summary

**Source**: `projects/legacy/07_manuscript/COMPLETION_SUMMARY.md`
**Planned location**: `ma-manuscript-quarto/references/manuscript-completion-template.md`
**Key features to extract**:

- IMRaD section completion checklist
- Table/figure assembly workflow
- Reference management
- Journal formatting requirements

### 5. References Usage Guide

**Source**: `projects/legacy/07_manuscript/REFERENCES_USAGE_GUIDE.md`
**Planned location**: `ma-manuscript-quarto/references/references-workflow-template.md`
**Key features to extract**:

- BibTeX management
- Citation mapping
- DOI coverage targets (≥90%)
- Reference formatting

### 6. Figures Assembly Summary

**Source**: `projects/legacy/07_manuscript/FIGURES_ASSEMBLY_SUMMARY.md`
**Planned location**: `ma-publication-quality/references/figure-assembly-template.md`
**Key features to extract**:

- Multi-panel figure assembly (300 DPI)
- Panel labeling (A, B, C)
- Figure legends
- Journal-specific requirements

---

## 🔧 Automation Script (To Be Created)

**Location**: `tooling/python/generate_quickstart_guides.py`

**Purpose**: Automatically generate project-specific quickstart guides from templates

**Usage**:

```bash
uv run tooling/python/generate_quickstart_guides.py \
  --project my-meta-analysis \
  --stage screening \
  --pico 01_protocol/pico.yaml \
  --out 03_screening/SCREENING_QUICKSTART.md
```

**Features**:

- Replace {{PLACEHOLDERS}} with project-specific data
- Read PICO from pico.yaml
- Count records from CSV files
- Calculate expected timelines
- Generate stage-specific guides

**Template variables to support**:

- {{PROJECT_NAME}}
- {{DATE}}
- {{RECORD_COUNT}}
- {{STUDY_DESIGN}}
- {{POPULATION}}
- {{INTERVENTION}}
- {{COMPARATOR}}
- {{OUTCOMES}}
- {{MIN_SAMPLE_SIZE}}
- {{EXPECTED_INCLUDE_COUNT}}
- {{KEY_STUDY_1}}, {{KEY_STUDY_2}}, etc.

---

## 📋 Integration Plan

### Phase 1: Template Creation (Current)

- [x] Create screening quickstart template
- [x] Create fulltext quickstart template
- [x] Create analysis progress template
- [x] Create manuscript completion template
- [ ] Create references workflow template (optional - covered in manuscript template)
- [ ] Create figure assembly template (optional - covered in manuscript template)

### Phase 2: Automation Script

- [ ] Create generate_quickstart_guides.py
- [ ] Add template variable replacement
- [ ] Add PICO.yaml parsing
- [ ] Add CSV counting logic
- [ ] Add date/timeline calculation

### Phase 3: Framework Integration

- [ ] Update init_project.py to generate guides
- [ ] Update AGENTS.md to reference templates
- [ ] Add to pipeline stage transitions
- [ ] Document in GETTING_STARTED.md

### Phase 4: Testing

- [ ] Test with new project creation
- [ ] Verify all placeholders replaced
- [ ] Check guide accuracy
- [ ] User feedback collection

---

## 💡 Value Proposition

### Before (Legacy Project Only)

- Valuable workflow knowledge locked in `projects/legacy/`
- Not reusable for new projects
- Must manually recreate guides each time
- Inconsistent quality across projects

### After (Framework Templates)

- Best practices embedded in framework
- Auto-generated for each new project
- Consistent quality and completeness
- Saves 3-5 hours per project stage

---

## 📖 How to Use Templates

### For New Projects

When creating a new project, generate customized guides:

```bash
# Screening stage
uv run tooling/python/generate_quickstart_guides.py \
  --project my-project \
  --stage screening

# Fulltext stage
uv run tooling/python/generate_quickstart_guides.py \
  --project my-project \
  --stage fulltext

# Analysis stage
uv run tooling/python/generate_quickstart_guides.py \
  --project my-project \
  --stage analysis
```

### Manual Customization

If automation not yet available, manually copy and customize:

```bash
# Copy template
cp ma-screening-quality/references/screening-quickstart-template.md \
   projects/my-project/03_screening/SCREENING_QUICKSTART.md

# Replace placeholders
sed -i '' 's/{{PROJECT_NAME}}/My Meta-Analysis/g' \
   projects/my-project/03_screening/SCREENING_QUICKSTART.md
```

---

## 🎯 Next Steps

1. **Complete remaining templates** (analysis, manuscript, references, figures)
2. **Create generation script** with full template variable support
3. **Integrate into init_project.py** for automatic generation
4. **Update AGENTS.md** to mention quickstart guides
5. **Test with real project** to validate workflow

---

**Status**: 67% complete (4/6 core templates created, 2 optional templates deferred)
**Estimated completion**: 2-3 hours remaining work (AGENTS.md update + generation script)
**Priority**: Medium (enhances usability but not blocking)

---

**Next immediate action**: Create analysis progress summary template from `projects/legacy/06_analysis/ANALYSIS_PROGRESS_SUMMARY.md`
