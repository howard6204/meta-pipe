# Analysis Type Decision

**Project**: HIV PrEP Network Meta-Analysis
**Date**: 2026-03-28
**Decision**: NMA (Network Meta-Analysis)

---

## Stage 1: Preliminary Assessment

**Intervention count from TOPIC.txt**: 8 nodes
1. Placebo / Standard of care
2. TDF/FTC daily oral
3. TAF/FTC daily oral
4. TDF monotherapy daily oral
5. TDF/FTC on-demand (event-driven)
6. CAB-LA (injectable cabotegravir)
7. Lenacapavir (twice-yearly injectable)
8. Dapivirine vaginal ring

**Threshold**: ≥3 treatments → NMA candidate ✅

---

## Stage 2: Post-Screening Confirmation

### Network Connectivity
```
PBO ─── TDF/FTC ─── TAF/FTC
 │           │
 ├── TDF     ├── CAB-LA
 │           │
 │           ├── LEN (via TAF/FTC in PURPOSE 1)
 │
 └── DVR
TDF/FTC_OD ── PBO (IPERGAY)
```

Key edges:
- PBO ↔ TDF/FTC: iPrEx, TDF2, FEM-PrEP, VOICE, Partners PrEP
- TDF/FTC ↔ CAB-LA: HPTN 083, HPTN 084
- TDF/FTC ↔ LEN: PURPOSE 2; TAF/FTC ↔ LEN: PURPOSE 1
- PBO ↔ DVR: ASPIRE, Ring Study
- TDF/FTC ↔ TAF/FTC: DISCOVER
- PBO ↔ TDF: Partners PrEP, VOICE

**Connectivity assessment**: Connected network ✅

### Transitivity
- Common treatment population: Adults at risk of HIV, enrolled in RCTs
  with concurrent HIV prevention services (counseling, condoms)
- Potential effect modifiers to investigate: population sex/risk-group,
  adherence level, income setting
- Transitivity assessment: Plausible, with pre-specified subgroup analyses ✅

### Single-arm / Unanchored Studies
- No single-arm studies to include as main analysis nodes
- HOPE/DREAM (OLE studies) → excluded

---

## Final Decision

**Analysis type**: NMA (Bayesian random-effects + frequentist cross-validation)
**Reference node**: Placebo
**Primary ranking metric**: SUCRA for HIV incidence

**Confirmed**: 2026-03-28
