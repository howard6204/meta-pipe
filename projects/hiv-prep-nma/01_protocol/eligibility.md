# Eligibility Criteria

## Project: HIV PrEP Network Meta-Analysis
**Date:** 2026-03-28

---

## Inclusion Criteria

### Population (P)
- Adults aged ≥18 years who are HIV-uninfected at enrollment
- At elevated risk of HIV-1 acquisition (defined per trial, e.g., MSM, TGW,
  high-prevalence setting women, serodiscordant couples)
- Any geographic setting (high- or low/middle-income country)

### Intervention (I)
At least one arm must include:
- Daily oral TDF/FTC or TAF/FTC
- Daily oral TDF monotherapy
- Event-driven oral TDF/FTC (2-1-1 dosing)
- Long-acting injectable cabotegravir (CAB-LA)
- Twice-yearly injectable lenacapavir
- Monthly dapivirine intravaginal ring (any dose)
- Other investigational oral, injectable, or topical PrEP agent (broadened for future)

### Comparator (C)
- Placebo (oral, injectable, or intravaginal)
- Standard of care (risk counseling + condoms without active PrEP)
- Active comparator (another PrEP agent from the list above)
- Deferred initiation arm (e.g., PROUD) — included but flagged

### Outcome (O)
- Must report HIV-1 incidence (number of confirmed new infections) AND
  person-time at risk to calculate rates

### Study Design (S)
- Randomized controlled trial (RCT)
- Phase 2b, Phase 3, Phase 3b/4
- Duration ≥24 weeks

---

## Exclusion Criteria

1. **Wrong population**: HIV-positive individuals; pediatric-only trials (<18 years);
   pregnant women as sole population (PMTCT context)
2. **Wrong intervention**: Post-exposure prophylaxis (PEP); vaccine trials;
   behavioural-only interventions; generic or compounded versions not equivalent
3. **Wrong outcome**: Does not report confirmed HIV infections; only reports
   behaviour or surrogate outcomes without incidence data
4. **Wrong design**: Non-randomized studies; case-control; cohort; cross-sectional;
   pilot feasibility trials (n<50 per arm)
5. **Duplicates**: Superseded by larger definitive trial reporting same population
   (retain most complete publication; note interim reports)

---

## Special Handling

| Trial | Issue | Decision |
|-------|-------|----------|
| FEM-PrEP | Stopped early for futility (non-adherence) | INCLUDE; flag in sensitivity analysis |
| VOICE | Stopped early for futility (non-adherence) | INCLUDE; flag in sensitivity analysis |
| PROUD | Open-label; deferred control (not placebo) | INCLUDE as separate node; note in limitations |
| HPTN 083/084 | Active comparator (TDF/FTC), open-label | INCLUDE |
| PURPOSE 1 | 0 events in lenacapavir arm | INCLUDE; use continuity correction or IRR |
| DREAM/HOPE | Open-label extension of ASPIRE/Ring Study | EXCLUDE (OLE, not RCT) |
| CHAPS | Adherence intervention within TDF/FTC | EXCLUDE (not efficacy trial) |

---

## Analysis-Type Decision

**Decision: NMA confirmed**

Rationale:
- ≥8 distinct intervention nodes identified
- Network is connected via TDF/FTC (central hub)
- Transitivity assumption reasonable (similar populations at risk of HIV)
- Documented in: `01_protocol/analysis-type-decision.md`
