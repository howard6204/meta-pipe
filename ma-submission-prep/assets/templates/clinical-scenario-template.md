# Clinical Scenario Template

**Usage**: Copy this template for each clinical scenario in Phase 3 Step 1

**Target**: 3-4 scenarios total (optimal for cognitive clarity)

---

## Scenario [N]: [Descriptive Name - e.g., "Maximizing Early Disease Control"]

**Target patients**: [Who this applies to - use specific clinical criteria]

- Examples:
  - "High-risk N2 disease, PD-L1 ≥50%, bulky tumors, patient anxiety about early relapse"
  - "Surgical emergencies (impending SVC syndrome, hemoptysis risk), urgent resection needed"
  - "Elderly patients (≥75 years), ECOG 2, multiple comorbidities, prefer shorter treatment"

---

**Preferred strategy**: [Explicit recommendation - name the treatment]

- Examples:
  - "Perioperative ICI (neoadjuvant 3-4 cycles + adjuvant up to 12 months)"
  - "Adjuvant ICI only (12 months post-surgery)"
  - "Neoadjuvant-only ICI (3-4 cycles, 9-12 weeks)"

---

**NMA evidence**: [HR/RR with 95% CI, P-score/SUCRA, NNT]

- **Format**: `HR [X.XXX] (95% CI [X.XX]-[X.XX]), [XX.X]% probability best for [outcome], NNT [X]-[Y]`
- **Example**: `HR 0.565 (95% CI 0.48-0.66), 87.8% probability best for EFS, NNT 5-6`
- ⚠️ **Must trace to Results Table 2** (exact match, no rounding)

---

**Supporting data**: [pCR rates, I² heterogeneity, subgroup analyses, secondary outcomes]

- Examples:
  - "pCR rates 18-49% across trials (vs <3% with chemotherapy alone)"
  - "I²=47.3% (moderate heterogeneity, consistent effect)"
  - "Subgroup analysis: Benefit maintained in PD-L1 ≥1% (HR 0.52) and <1% (HR 0.68)"

---

**Rationale**: [Why this strategy for this scenario - biological/clinical logic]

- **Good example**: "Maximizes tumor downstaging via neoadjuvant component (enabling complete resection), while adjuvant component eradicates micrometastatic disease. Early biomarker (pCR) predicts long-term benefit."
- ❌ **Bad example** (speculative): "Likely works by immune priming" (no preclinical data cited)

---

**Alternative/Caveat**: [Secondary option OR warning about limitations]

- Examples:
  - **Alternative**: "Neoadjuvant-only if adjuvant compliance concerns (elderly, long travel distance)"
  - **Caveat**: "OS data immature (median not reached at 25-38 months); rankings may change with longer follow-up"
  - **Warning**: "Direct comparison not available (no head-to-head trial); based on indirect NMA comparison"

---

## Checklist Before Moving to Next Scenario

- [ ] **Target patients** uses specific clinical criteria (not vague "high-risk")
- [ ] **Preferred strategy** is explicit recommendation (not "consider X or Y")
- [ ] **NMA evidence** traces to Results Table 2 (exact HR, CI match)
- [ ] **NMA evidence** includes P-score/SUCRA and NNT (if available)
- [ ] **Supporting data** provides context beyond primary outcome
- [ ] **Rationale** explains biological/clinical mechanism (not just "data shows")
- [ ] **Alternative/Caveat** addresses limitations or secondary options
- [ ] Zero speculative biology without preclinical data citations

---

## Example (from early-immuno-timing-nma)

### Scenario 1: Maximizing early disease control

**Target patients**: High-risk N2 disease, PD-L1 ≥50%, bulky tumors (≥5 cm), patient anxiety about early relapse

**Preferred strategy**: Perioperative ICI (neoadjuvant pembrolizumab 200mg Q3W × 4 cycles + adjuvant pembrolizumab 200mg Q3W × 13 cycles)

**NMA evidence**: HR 0.565 (95% CI 0.48-0.66) for EFS, 87.8% probability best for EFS (SUCRA rank 1/4), NNT 5-6 based on 15% absolute risk reduction at 3 years

**Supporting data**: pCR rates 18-49% across KEYNOTE-671 (18%), AEGEAN (33%), Neotorch (49%) vs <3% with chemotherapy alone, I²=47.3% (moderate heterogeneity, consistent direction of effect). Subgroup analysis: Benefit maintained across PD-L1 subgroups (≥50%: HR 0.48, 1-49%: HR 0.60, <1%: HR 0.68, p_interaction=0.15).

**Rationale**: Maximizes tumor downstaging via neoadjuvant component (median tumor shrinkage 30-40%, enabling complete resection in borderline-resectable cases), while adjuvant component eradicates micrometastatic disease post-surgery. Early biomarker (pCR at surgery) predicts long-term benefit (5-year EFS 85% in pCR patients vs 55% in non-pCR). Addresses patient anxiety by demonstrating objective tumor response before surgery (visible on imaging, pathology-confirmed at resection).

**Alternative**: Neoadjuvant-only ICI (3-4 cycles, 9-12 weeks total) if adjuvant compliance concerns (elderly patients preferring shorter treatment, limited transportation access to treatment center, financial constraints for 12-month therapy)

**Caveat**: OS data immature (median OS not reached at 25-38 months follow-up in perioperative trials, vs 5-year follow-up in adjuvant IMpower010). Perioperative's OS ranking (currently 2nd, P-score 67.3%) may improve as data mature based on typical OS maturation timelines in early-stage NSCLC (4-6 years from trial initiation). Updated OS analyses anticipated when KEYNOTE-671 and AEGEAN reach 5-year median follow-up.

---

**Copy this template 3-4 times for each scenario**

**Save to**: `projects/<project-name>/07_manuscript/clinical_scenarios_draft.md` (working file)

**Final location**: Embed in `04_discussion.qmd` under "Clinical Implications" subsection

---

**Version**: 1.0.0 (2026-02-18)
**Source**: early-immuno-timing-nma project
