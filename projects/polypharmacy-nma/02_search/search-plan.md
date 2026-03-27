# Search Strategy — Polypharmacy NMA

## Databases
| Database    | Coverage                  | Interface         |
|-------------|---------------------------|-------------------|
| PubMed      | 1966–present              | NLM / PubMed.gov  |
| Embase      | 1947–present              | Elsevier          |
| Cochrane CENTRAL | All years            | Cochrane Library  |
| Scopus      | 1960–present              | Elsevier          |
| ClinicalTrials.gov | All registered trials | ct.gov       |

**Date range**: 2000–2026-03-27
**Language**: No restriction (translate as needed)

---

## PubMed Search String

```
(
  ("polypharmacy"[MeSH] OR "polypharmacy"[tiab] OR "inappropriate prescribing"[MeSH]
   OR "inappropriate medication"[tiab] OR "potentially inappropriate"[tiab]
   OR "multimorbidity"[tiab] OR "multiple medications"[tiab])
  AND
  ("aged"[MeSH] OR "elderly"[tiab] OR "older adult*"[tiab] OR "older people"[tiab]
   OR "geriatric*"[tiab] OR "nursing home"[tiab] OR "long-term care"[tiab])
  AND
  (
    "pharmacist*"[tiab] OR "medication review"[tiab] OR "drug review"[tiab]
    OR "clinical decision support"[tiab] OR "CDSS"[tiab] OR "computerized prescribing"[tiab]
    OR "multidisciplinary"[tiab] OR "interprofessional"[tiab] OR "team-based"[tiab]
    OR "deprescrib*"[tiab] OR "medication discontinuation"[tiab] OR "STOPP"[tiab]
    OR "Beers criteria"[tiab]
  )
  AND
  (
    "accidental falls"[MeSH] OR "fall*"[tiab] OR "hospitalization"[MeSH]
    OR "hospital admission*"[tiab] OR "emergency admission*"[tiab]
    OR "potentially inappropriate medication*"[tiab] OR "PIM"[tiab]
  )
  AND
  ("randomized controlled trial"[pt] OR "randomised controlled trial"[tiab]
   OR "cluster randomized"[tiab] OR "cluster randomised"[tiab]
   OR "RCT"[tiab])
)
```

---

## Embase Search String (Emtree terms)

```
('polypharmacy'/exp OR polypharmacy:ti,ab OR 'inappropriate drug use'/exp
 OR 'potentially inappropriate medication':ti,ab)
AND
('aged'/exp OR elderly:ti,ab OR 'older adult':ti,ab OR geriatric:ti,ab
 OR 'nursing home'/exp OR 'long term care'/exp)
AND
(pharmacist:ti,ab OR 'medication review':ti,ab OR 'clinical decision support'/exp
 OR CDSS:ti,ab OR 'multidisciplinary team':ti,ab OR deprescrib*:ti,ab
 OR 'medication discontinuation':ti,ab OR STOPP:ti,ab)
AND
('accidental fall'/exp OR fall*:ti,ab OR 'hospitalization'/exp
 OR 'hospital admission':ti,ab OR PIM:ti,ab)
AND
('randomized controlled trial'/exp OR 'cluster randomized trial'/exp)
```

---

## Key MeSH / Controlled Vocabulary Terms
- Polypharmacy [MeSH]
- Inappropriate Prescribing [MeSH]
- Aged [MeSH]; Aged, 80 and over [MeSH]
- Pharmacists [MeSH]; Medication Therapy Management [MeSH]
- Decision Support Systems, Clinical [MeSH]
- Patient Care Team [MeSH]
- Accidental Falls [MeSH]
- Hospitalization [MeSH]

---

## Expected Yield
- Initial hits: ~3,000–6,000 combined (after deduplication ~2,500)
- After title/abstract screening: ~150–300
- After full-text: ~25–45 included studies

---

## Grey Literature
- ClinicalTrials.gov: "polypharmacy" + "elderly" + interventional, completed
- WHO ICTRP
- Reference lists of included studies and recent systematic reviews
- Relevant SRs to hand-search: Rankin 2018 Cochrane, Johansson 2016 BMJ, Dills 2018 JAmerGerSoc
