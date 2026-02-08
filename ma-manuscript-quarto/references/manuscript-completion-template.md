# Manuscript Completion Summary

**Project**: {{PROJECT_NAME}}
**Date**: {{DATE}}
**Session**: {{CURRENT_SESSION}}

---

## ✅ COMPLETED THIS SESSION

### Main Text Tables ({{N_MAIN_TABLES}}/{{TOTAL_MAIN_TABLES}})

{{#MAIN_TABLES}}
{{TABLE_NUMBER}}. **{{TABLE_TITLE}}**

- File: `tables/{{TABLE_FILE}}`
- Content: {{TABLE_CONTENT_DESCRIPTION}}
- {{TABLE_DETAILS}}
  {{/MAIN_TABLES}}

### Supplementary Tables ({{N_SUPP_TABLES}}/{{TOTAL_SUPP_TABLES}})

{{#SUPP_TABLES}}
{{TABLE_NUMBER}}. **{{TABLE_TITLE}}**

- File: `tables/{{TABLE_FILE}}`
- Content: {{TABLE_CONTENT_DESCRIPTION}}
- {{TABLE_DETAILS}}
  {{/SUPP_TABLES}}

---

## 📊 PROJECT STATUS

### Manuscript Components

| Component        | Status                      | Word Count        | Files                      |
| ---------------- | --------------------------- | ----------------- | -------------------------- |
| Abstract         | {{STATUS_ABSTRACT}}         | {{WC_ABSTRACT}}   | 00_abstract.md             |
| Introduction     | {{STATUS_INTRO}}            | {{WC_INTRO}}      | 01_introduction.md         |
| Methods          | {{STATUS_METHODS}}          | {{WC_METHODS}}    | 02_methods.md              |
| Results          | {{STATUS_RESULTS}}          | {{WC_RESULTS}}    | 03_results.md              |
| Discussion       | {{STATUS_DISCUSSION}}       | {{WC_DISCUSSION}} | 04_discussion.md           |
| **Total Text**   | **{{STATUS_TOTAL_TEXT}}**   | **{{WC_TOTAL}}**  | —                          |
| Main Tables      | {{STATUS_MAIN_TABLES}}      | —                 | {{N_MAIN_TABLES}} files    |
| Supp Tables      | {{STATUS_SUPP_TABLES}}      | —                 | {{N_SUPP_TABLES}} files    |
| **Total Tables** | **{{STATUS_TOTAL_TABLES}}** | —                 | **{{TOTAL_TABLES}} files** |

### Word Count Targets

**Target Journal**: {{TARGET_JOURNAL}}

| Section    | Current          | Target                | Status                 |
| ---------- | ---------------- | --------------------- | ---------------------- |
| Abstract   | {{WC_ABSTRACT}}  | {{TARGET_ABSTRACT}}   | {{STATUS_WC_ABSTRACT}} |
| Main Text  | {{WC_TOTAL}}     | {{TARGET_MAIN_TEXT}}  | {{STATUS_WC_MAIN}}     |
| References | {{N_REFERENCES}} | {{TARGET_REFERENCES}} | {{STATUS_WC_REF}}      |
| Tables     | {{N_TABLES}}     | {{TARGET_TABLES}}     | {{STATUS_N_TABLES}}    |
| Figures    | {{N_FIGURES}}    | {{TARGET_FIGURES}}    | {{STATUS_N_FIGURES}}   |

### Figures Status

| Type | Available | Assembly Status |
| ---- | --------- | --------------- |

{{#FIGURE_TYPES}}
| {{FIGURE_TYPE}} | {{AVAILABLE_COUNT}} | {{ASSEMBLY_STATUS}} |
{{/FIGURE_TYPES}}
| **Total** | **{{TOTAL_INDIVIDUAL_FIGURES}}** | **{{TOTAL_ASSEMBLED_FIGURES}}** |

---

## 🎯 REMAINING WORK

### Priority 1: Figure Assembly ({{TIME_FIGURES}} hours)

{{#FIGURE_ASSEMBLY_TASKS}}

- {{FIGURE_NAME}}: {{FIGURE_DESCRIPTION}}
  {{/FIGURE_ASSEMBLY_TASKS}}

**Tools**:

- R: `cowplot::plot_grid()` or `patchwork`
- Python: `matplotlib.pyplot.subplot()` or Pillow
- See: [R Figure Generation Guide](../docs/R_FIGURE_GUIDE.md)

### Priority 2: References ({{TIME_REFERENCES}} hours)

- [ ] Extract citation placeholders from manuscript
- [ ] Create BibTeX file with all references
- [ ] Verify DOI coverage (≥90% target)
- [ ] Format according to {{TARGET_JOURNAL}} style
- [ ] Insert citations into manuscript sections
- [ ] Cross-check all in-text citations match reference list

**Tools**:

- Zotero for reference management
- See: [References Workflow Guide](references-workflow-template.md)

### Priority 3: Figure Legends ({{TIME_LEGENDS}} hours)

- [ ] Write detailed legends for all figures
- [ ] Define all abbreviations in each legend
- [ ] Include statistical methods in legends
- [ ] Specify sample sizes and time points
- [ ] Add panel labels (A, B, C) to legends

**Template**: See `FIGURE_LEGENDS.md` template

### Priority 4: Journal Formatting ({{TIME_FORMATTING}} hours)

- [ ] Convert markdown to {{TARGET_FORMAT}} (Word/LaTeX)
- [ ] Insert tables and figures at appropriate locations
- [ ] Apply {{TARGET_JOURNAL}} style guide
- [ ] Format references according to journal
- [ ] Create title page with author affiliations
- [ ] Write cover letter
- [ ] Complete PRISMA 2020 checklist (27 items)
- [ ] Complete journal-specific checklist

**Tools**:

- Pandoc for format conversion
- Quarto for rendering
- See: [Journal Formatting Guide](../docs/JOURNAL_FORMATTING.md)

---

## 📈 COMPLETION METRICS

- **Overall Project**: {{OVERALL_PERCENT}}% complete
- **Manuscript Text**: {{TEXT_PERCENT}}% {{STATUS_ICON_TEXT}}
- **Tables**: {{TABLES_PERCENT}}% {{STATUS_ICON_TABLES}}
- **Individual Figures**: {{INDIVIDUAL_FIGURES_PERCENT}}% {{STATUS_ICON_IND_FIG}}
- **Figure Assembly**: {{ASSEMBLY_PERCENT}}% {{STATUS_ICON_ASSEMBLY}}
- **Figure Legends**: {{LEGENDS_PERCENT}}% {{STATUS_ICON_LEGENDS}}
- **References**: {{REFERENCES_PERCENT}}% {{STATUS_ICON_REFERENCES}}
- **Journal Formatting**: {{FORMATTING_PERCENT}}% {{STATUS_ICON_FORMATTING}}

**Estimated time to submission**: {{ETA_HOURS}} hours

---

## 🔑 KEY FINDINGS (For Reference)

### Primary Outcome

- **{{PRIMARY_OUTCOME}}**: {{PRIMARY_ESTIMATE}} ({{PRIMARY_CI}}), p={{PRIMARY_P}}, I²={{PRIMARY_I2}}%, {{PRIMARY_ABSOLUTE_BENEFIT}}, NNT={{PRIMARY_NNT}} ({{PRIMARY_GRADE}} certainty)

### Secondary Outcomes

{{#SECONDARY_OUTCOMES}}

- **{{OUTCOME_NAME}}**: {{ESTIMATE}} ({{CI}}), p={{P_VALUE}}, I²={{I2}}%, {{ABSOLUTE_BENEFIT}}, NNT={{NNT}} ({{GRADE}} certainty)
  {{/SECONDARY_OUTCOMES}}

### Safety Outcomes

{{#SAFETY_OUTCOMES}}

- **{{OUTCOME_NAME}}**: {{ESTIMATE}}, {{ABSOLUTE_RISK}}, NNH={{NNH}}
  {{/SAFETY_OUTCOMES}}

### Clinical Implications

- **Benefit-Risk**: {{BENEFIT_RISK_SUMMARY}}
- **Surrogate Validation**: {{SURROGATE_VALIDATION}}
- **Subgroup Effects**: {{SUBGROUP_SUMMARY}}
- **Guideline Recommendations**: {{GUIDELINE_STATUS}}

---

## 📁 FILES CREATED THIS SESSION

```
07_manuscript/
├── 00_abstract.md                    {{STATUS_ICON_ABSTRACT}}
├── 01_introduction.md                {{STATUS_ICON_INTRO}}
├── 02_methods.md                     {{STATUS_ICON_METHODS}}
├── 03_results.md                     {{STATUS_ICON_RESULTS}}
├── 04_discussion.md                  {{STATUS_ICON_DISCUSSION}}
├── prisma_flow.md                    {{STATUS_ICON_PRISMA}}
├── prisma_flow.svg                   {{STATUS_ICON_PRISMA_SVG}}
├── FIGURE_LEGENDS.md                 {{STATUS_ICON_LEGENDS}}
├── references.bib                    {{STATUS_ICON_REFERENCES}}
│
├── tables/
{{#ALL_TABLES}}
│   ├── {{TABLE_FILE}}                {{STATUS_ICON}}
{{/ALL_TABLES}}
│
├── figures/
{{#ALL_FIGURES}}
│   ├── {{FIGURE_FILE}}               {{STATUS_ICON}}
{{/ALL_FIGURES}}
│
└── COMPLETION_SUMMARY.md             ✅ This file
```

---

## 🚀 NEXT RECOMMENDED ACTION

**Choose one to start**:

**Option A**: Assemble multi-panel figures

- Use R `cowplot` or Python `PIL`
- Expected time: {{TIME_FIGURES}} hours
- Command: See [Multi-Panel Figure Guide](../docs/r-guides/04-multi-panel.md)

**Option B**: Create references file

- Export from Zotero or create manually
- Expected time: {{TIME_REFERENCES}} hours
- Target: {{N_REFERENCES}} references with ≥90% DOI coverage

**Option C**: Write figure legends

- Use template in `FIGURE_LEGENDS.md`
- Expected time: {{TIME_LEGENDS}} hours
- Include panel descriptions, statistics, abbreviations

**Option D**: Journal formatting

- Convert to {{TARGET_FORMAT}}
- Expected time: {{TIME_FORMATTING}} hours
- Apply {{TARGET_JOURNAL}} style guide

**Recommended sequence**: A → C → B → D (most logical workflow)

Total estimated time: {{TOTAL_REMAINING_HOURS}} hours for submission-ready manuscript.

---

## 📋 Pre-Submission Checklist

### Content Completeness

- [ ] Abstract structured (Background, Methods, Results, Conclusions)
- [ ] Introduction provides clear rationale and objectives
- [ ] Methods sufficiently detailed for reproducibility
- [ ] Results presented logically with all outcomes
- [ ] Discussion interprets findings with limitations
- [ ] All tables and figures referenced in text
- [ ] All references cited in text

### Quality Assurance

- [ ] No duplicate data or inconsistencies
- [ ] All numbers match between text, tables, and figures
- [ ] All p-values correctly formatted
- [ ] All confidence intervals match estimates
- [ ] All abbreviations defined at first use
- [ ] Statistical methods clearly described

### Journal Requirements

- [ ] Word count within {{TARGET_JOURNAL}} limits
- [ ] Number of tables ≤ {{TARGET_TABLES}}
- [ ] Number of figures ≤ {{TARGET_FIGURES}}
- [ ] Number of references ≤ {{TARGET_REFERENCES}}
- [ ] Abstract ≤ {{TARGET_ABSTRACT}} words
- [ ] PRISMA 2020 checklist completed (27/27 items)
- [ ] Journal-specific checklist completed

### Figures and Tables

- [ ] All figures at 300 DPI minimum
- [ ] Multi-panel figures have A, B, C labels
- [ ] Figure legends comprehensive and self-contained
- [ ] Tables formatted according to journal style
- [ ] Supplementary materials organized

### References

- [ ] All in-text citations in reference list
- [ ] All references cited in text
- [ ] DOI coverage ≥90%
- [ ] References formatted per journal style
- [ ] No duplicate references

### Authorship and Ethics

- [ ] Author list complete with affiliations
- [ ] Author contributions stated
- [ ] Funding sources disclosed
- [ ] Conflicts of interest declared
- [ ] Ethics approval (if applicable)
- [ ] Data availability statement
- [ ] Protocol registration (PROSPERO) cited

---

## 🎯 Timeline to Submission

| Milestone                       | Estimated Time       | Status             |
| ------------------------------- | -------------------- | ------------------ |
| **Phase 1**: Figure assembly    | {{TIME_FIGURES}}h    | {{STATUS_PHASE_1}} |
| **Phase 2**: Figure legends     | {{TIME_LEGENDS}}h    | {{STATUS_PHASE_2}} |
| **Phase 3**: References         | {{TIME_REFERENCES}}h | {{STATUS_PHASE_3}} |
| **Phase 4**: Journal formatting | {{TIME_FORMATTING}}h | {{STATUS_PHASE_4}} |
| **Phase 5**: Internal review    | 2-4h                 | {{STATUS_PHASE_5}} |
| **Phase 6**: Revisions          | 2-3h                 | {{STATUS_PHASE_6}} |
| **Phase 7**: Final QA           | 1-2h                 | {{STATUS_PHASE_7}} |
| **TOTAL**                       | **{{TOTAL_HOURS}}h** | —                  |

**Target submission date**: {{TARGET_SUBMISSION_DATE}}

---

**Status**: {{CURRENT_STATUS}}. Ready to proceed with {{NEXT_ACTION}}.

**Document version**: 1.0
**Date**: {{DATE}}
**Generated by**: Meta-analysis pipeline
