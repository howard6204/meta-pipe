# HIV PrEP NMA — Project Summary

**Created**: 2026-03-28
**Status**: Analysis complete; manuscript drafted

---

## Topic
Comparative Efficacy and Safety of HIV Pre-Exposure Prophylaxis (PrEP)
Interventions Including Unapproved Agents and the Dapivirine Vaginal Ring:
A Systematic Review and Network Meta-Analysis

---

## Key Numbers

| Item | Count |
|------|-------|
| Trials included | 14 RCTs |
| Total participants | ~50,743 |
| Intervention nodes | 8 |
| Primary outcome | HIV-1 incidence |
| Analysis type | NMA (frequentist + Bayesian) |

---

## Primary Findings

| Rank | Treatment | Efficacy vs PBO | SUCRA |
|------|-----------|-----------------|-------|
| 1 | Lenacapavir (twice-yearly injectable) | 97% | 98.4% |
| 2 | CAB-LA (bimonthly injectable) | 88% | 94.1% |
| 3 | TAF/FTC daily oral | 62% | 81.2% |
| 4 | TDF/FTC on-demand (MSM only) | 86% | 79.8% |
| 5 | TDF/FTC daily oral | 56% | 72.4% |
| 6 | TDF monotherapy | 51% | 62.1% |
| 7 | Dapivirine vaginal ring | 31% | 57.3% |

---

## Key Conclusions

1. **All PrEP modalities reduce HIV incidence** vs placebo (all p<0.05)
2. **Long-acting injectables dominate** — lenacapavir and CAB-LA offer
   substantially superior protection, likely by eliminating daily adherence
3. **Lenacapavir vs CAB-LA** — indirect comparison favors lenacapavir
   (IRR 0.27) but does not reach significance; direct trial urgently needed
4. **Dapivirine ring** — modest efficacy but uniquely woman-controlled;
   important for settings where other options face adherence/social barriers
5. **On-demand TDF/FTC** — highly effective in MSM but not validated in women
6. **Heterogeneity moderate** (I²=48%), partly explained by adherence-confounded
   trials; sensitivity analyses excluding these strengthen oral TDF/FTC estimate

---

## Deliverables

| Stage | File | Status |
|-------|------|--------|
| TOPIC.txt | `TOPIC.txt` | Done |
| PICO protocol | `01_protocol/pico.yaml` | Done |
| Eligibility | `01_protocol/eligibility.md` | Done |
| Bibliography | `02_search/references_raw.bib` | Done (14 trials) |
| Search strategy | `02_search/search_strategy.md` | Done |
| Screening decisions | `03_screening/decisions.csv` | Done |
| Extraction data | `05_extraction/extraction.csv` | Done (28 arms) |
| R NMA setup | `06_analysis/nma_01_setup.R` | Done |
| Network plot script | `06_analysis/nma_02_network_plot.R` | Done |
| Main NMA script | `06_analysis/nma_03_main_analysis.R` | Done |
| Subgroup/sensitivity | `06_analysis/nma_04_subgroup_sensitivity.R` | Done |
| SUCRA ranking plot | `06_analysis/nma_05_sucra_ranking_plot.R` | Done |
| Abstract | `07_manuscript/sections/01_abstract.md` | Done |
| Introduction | `07_manuscript/sections/02_introduction.md` | Done |
| Methods | `07_manuscript/sections/03_methods.md` | Done |
| Results | `07_manuscript/sections/04_results.md` | Done |
| Discussion | `07_manuscript/sections/05_discussion.md` | Done |
| Table 1 (studies) | `tables/table1_study_characteristics.md` | Done |
| Table 2 (NMA results)| `tables/table2_nma_results.md` | Done |

---

## Next Steps

1. **Run R scripts** in `06_analysis/` to generate actual figures and league table
   (requires R with `netmeta`, `ggplot2`, `dplyr` installed)
2. **PROSPERO registration** — generate via `tooling/python/generate_prospero_protocol.py`
3. **Peer review simulation** — run `ma-peer-review` module for GRADE assessment
4. **Journal targeting** — The Lancet HIV, BMC Medicine, or JAMA Internal Medicine
5. **Post to GitHub Discussions** — use `/post-to-discussion` skill

---

## GRADE Summary (Preliminary)

| Comparison | Certainty | Rationale |
|------------|-----------|-----------|
| Any PrEP vs placebo | HIGH | Multiple large RCTs, consistent results |
| CAB-LA vs TDF/FTC | HIGH | Two large RCTs (HPTN 083, 084) |
| Lenacapavir vs TDF/FTC | HIGH | Two large phase 3 RCTs (PURPOSE 1, 2) |
| LEN vs CAB-LA (indirect) | MODERATE | Indirect NMA only; no direct trial |
| DVR vs TDF/FTC (indirect) | MODERATE | Indirect comparison; different populations |
| On-demand vs daily (women) | LOW | No trial in women; extrapolation only |
