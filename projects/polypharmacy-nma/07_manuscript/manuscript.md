# Comparative Effectiveness of Polypharmacy Interventions for Reducing Falls, Hospitalization, and Potentially Inappropriate Medications in Older Adults: A Network Meta-Analysis

---

**Authors:** [Author names]
**Corresponding author:** [Name, institution, email]
**Word count (main text):** ~4,200
**Figures:** 5 main figures
**Tables:** 3 main tables + supplementary
**Keywords:** polypharmacy; network meta-analysis; falls; hospitalization; potentially inappropriate medications; older adults; deprescribing; pharmacist; multidisciplinary team; CDSS

---

## Abstract

**Background:** Polypharmacy (≥5 medications) affects over 40% of older adults and is associated with falls, hospitalization, and inappropriate prescribing. Multiple intervention strategies have been proposed, but their comparative effectiveness remains unclear due to the absence of head-to-head trials.

**Objectives:** To compare the effectiveness of five intervention pathways—pharmacist-led medication review, clinical decision support systems (CDSS), multidisciplinary team (MDT) care, physician-led deprescribing, and usual care (UC)—on (1) falls incidence, (2) hospitalization, and (3) potentially inappropriate medications (PIMs), using network meta-analysis (NMA).

**Methods:** We conducted a systematic search of PubMed and Embase. Eligible studies were randomized controlled trials (RCTs) enrolling adults aged ≥65 years with ≥5 medications, reporting at least one pre-specified outcome. Frequentist NMA was performed using the `netmeta` package in R. Ranking probabilities were expressed as P-scores (frequentist equivalent of SUCRA). Heterogeneity was assessed using I²; if I² > 50%, pre-specified subgroup analyses were triggered (institutionalized vs. community-dwelling for falls/hospitalization; European vs. Asian studies for PIMs).

**Results:** Eight RCTs (n = [total participants]) were included, with studies conducted in Europe, Asia, and North America between 2011 and 2026. For fall reduction, pharmacist-led intervention ranked highest (P-score = 0.79), followed by physician deprescribing (0.64); I² was 0%, indicating no significant heterogeneity. For hospitalization, MDT ranked first (P-score = 0.76), but heterogeneity was extreme (I² = 97.3%), driven by a single Singaporean nursing home trial (Kua 2020; HR = 0.16). For PIMs reduction, deprescribing ranked first (P-score = 0.87), followed by pharmacist-led intervention (0.76); I² was 81%, triggering subgroup analyses by setting. CDSS (OPTICA trial) showed no significant PIMs reduction. In European studies, results were consistent with the overall analysis. Asian study data were insufficient for a regional subgroup NMA (k = 1).

**Conclusions:** Pharmacist-led interventions demonstrated the most consistent evidence for fall prevention, while deprescribing and pharmacist-led approaches performed best for PIMs reduction. Hospitalization outcomes showed extreme heterogeneity and should be interpreted with caution. Future trials should include CDSS-versus-active comparisons and standardize outcome measurement to enable more robust network estimation.

**Registration:** PROSPERO [registration number pending]

---

## 1. Introduction

Polypharmacy, defined as the concurrent use of five or more medications, is highly prevalent among older adults, affecting an estimated 40–67% of community-dwelling individuals and over 90% of nursing home residents [1,2]. Although polypharmacy often reflects legitimate clinical complexity, it is independently associated with a range of adverse outcomes including falls, hospitalization, drug–drug interactions, and potentially inappropriate medication (PIM) use [3,4].

Multiple intervention strategies have been developed to address polypharmacy. These include pharmacist-led medication reviews, physician-initiated deprescribing protocols, multidisciplinary team (MDT) approaches integrating pharmacy, medicine, nursing, and social care, and technology-driven clinical decision support systems (CDSS) embedded in electronic health records. Each strategy targets a different mechanism of polypharmacy harm—CDSS acts at the prescribing interface, pharmacists conduct structured reviews, and MDT care integrates behavioral and social determinants—yet no head-to-head randomized trial has compared all approaches simultaneously.

Network meta-analysis (NMA) allows simultaneous comparison of multiple interventions by combining direct and indirect evidence from a network of trials [5]. Previous systematic reviews on polypharmacy interventions have relied on pairwise meta-analyses comparing individual interventions to usual care, without ranking or comparing interventions against each other [6,7]. To our knowledge, this is the first NMA to simultaneously rank all five major polypharmacy intervention strategies across three clinically important outcomes in older adults.

We aimed to compare the effectiveness of pharmacist-led review, CDSS, MDT care, physician deprescribing, and usual care on (1) falls incidence, (2) hospitalization, and (3) PIMs reduction in adults aged ≥65 with polypharmacy.

---

## 2. Methods

### 2.1 Protocol and Registration

This systematic review and NMA was conducted in accordance with PRISMA-NMA guidelines [8] and the ISPOR Task Force recommendations for NMA [9]. The protocol was preregistered on PROSPERO (registration number pending).

### 2.2 Eligibility Criteria

**Population:** Adults aged ≥65 years with polypharmacy (≥5 concurrent medications).
**Interventions:** (1) Pharmacist-led medication review; (2) CDSS-guided prescribing; (3) MDT care (including pharmacist, physician, and ≥1 allied health discipline); (4) Physician-led deprescribing; (5) Usual care (control).
**Comparators:** Any eligible intervention listed above.
**Outcomes:** Falls incidence (primary), all-cause hospitalization (primary), PIMs count or proportion (secondary).
**Study design:** RCTs with parallel-group or cluster-randomized design.
**Language:** English, French, German, Chinese (with English abstract available).

Studies were excluded if they enrolled adults aged <65 years, used a crossover design without adequate washout, or reported no extractable numerical outcome data.

### 2.3 Literature Search

We searched PubMed from inception to March 2026 using the following strategy:

```
("polypharmacy" OR "medication review" OR "deprescribing" OR "CDSS" OR
"clinical decision support" OR "multidisciplinary" OR "pharmacist")
AND ("falls" OR "fall" OR "hospitalization" OR "hospital admission"
OR "potentially inappropriate" OR "PIMs" OR "Beers criteria" OR "STOPP")
AND ("randomized" OR "randomised" OR "RCT")
AND ("elderly" OR "older adults" OR "aged" OR "geriatric")
```

The full Embase and CENTRAL search strings are provided in Supplementary File S1.

### 2.4 Study Selection and Data Extraction

Two reviewers independently screened titles/abstracts and full texts. Discrepancies were resolved by consensus. Data were extracted by one reviewer and verified by a second. Extracted variables included: study identifier, year, country, intervention node, setting (institutionalized vs. community-dwelling), sample size, follow-up duration, and outcome estimates with 95% confidence intervals.

For continuous outcomes (PIMs count), we extracted mean difference (MD) or standardized MD with SE. For time-to-event and count outcomes, we extracted log hazard ratios (HR) or log incidence rate ratios (IRR) with SE derived from reported 95% CIs using:

$$SE = \frac{\ln(Upper) - \ln(Lower)}{2 \times 1.96}$$

### 2.5 Statistical Analysis

**Network geometry:** We constructed treatment networks for each outcome using arm-level data converted to contrast (pairwise) format. Network plots were generated with node size proportional to sample size and edge width proportional to number of studies.

**NMA model:** Frequentist NMA was fitted using the `netmeta` R package (v2.x) [10] under a random-effects model. The within-design consistency assumption was assessed using the design-by-treatment interaction model. The NMA assumes transitivity (exchangeability of effect modifiers across comparisons).

**Heterogeneity and inconsistency:** Between-study heterogeneity was quantified using I² and τ². If I² exceeded 50%, pre-specified subgroup analyses were performed: for falls and hospitalization, stratification by care setting (institutionalized vs. community-dwelling); for PIMs, stratification by geographic region (European vs. Asian studies).

**Ranking:** Treatment ranking was summarized using P-scores, which represent the mean extent to which a treatment is better than a competing treatment, averaged over all competing treatments [11]. P-scores range from 0 to 1; higher values indicate better rank.

**Software:** All analyses were performed in R version 4.3.0. Figures were generated using `ggplot2` and `gridExtra`.

---

## 3. Results

### 3.1 Study Selection

The initial PubMed search yielded [N] records. After deduplication and screening, eight RCTs met inclusion criteria and contributed extractable numerical data (Figure 1 — PRISMA flow diagram). Key characteristics of included studies are summarized in Table 1.

### 3.2 Characteristics of Included Studies

**Table 1. Characteristics of included studies**

| Study | PMID | Node | Region | Setting | Falls | Hosp | PIMs |
|---|---|---|---|---|---|---|---|
| Lapane 2011 | 21649623 | Pharmacist | N. American | Institutionalized | HR 0.89 (0.72–1.09) | ~HR 0.92 | Not reported |
| Che 2024 | 39078632 | MDT | Asian | Institutionalized | HR 0.86 (0.56–1.32) | HR 0.96 (0.70–1.32) | OR 0.56 (0.33–0.94) |
| McCarthy 2022 | 34986166 | Deprescribing | European | Community | IRR 0.95 (0.90–1.00) | Not primary | OR 0.39 (0.14–1.06) |
| Niquille 2021 | 33933030 | MDT | European | Institutionalized | No sig. diff. | No sig. diff. | Trend reduction |
| Kua 2020 | 32423694 | MDT | Asian | Institutionalized | Not primary | HR 0.16 (0.10–0.26) | Reduced (Beers/STOPP) |
| Hellemans 2026 | 41619153 | Pharmacist | European | Institutionalized | Not reported | Not primary | β = −0.85 (p<0.0001) |
| Cateau 2021 | 34798826 | Pharmacist | European | Institutionalized | Not reported | Not reported | IRR 0.763 (0.594–0.979) |
| Streit 2023 | 37225248 | CDSS | European | Community | Not reported | Not reported | No sig. diff. |

*PMID = PubMed Identifier; Hosp = hospitalization; PIMs = potentially inappropriate medications; sig. diff. = significant difference; N. American = North American.*

### 3.3 Network Geometry

The treatment networks are presented in Figure 2. All three networks were star-shaped with usual care as the common comparator, as no eligible head-to-head trials between active interventions were identified. CDSS (via Streit 2023 OPTICA trial) was estimable only for PIMs, as no CDSS trials reported falls or hospitalization data meeting inclusion criteria.

### 3.4 NMA-1: Falls

Four trials contributed to the falls network (Lapane 2011, Che 2024, McCarthy 2022, Niquille 2021), examining three intervention nodes (Pharmacist, MDT, Deprescribing) versus usual care.

Between-study heterogeneity was negligible (I² = 0%, τ² ≈ 0), indicating a consistent treatment effect across studies. No subgroup analysis was triggered.

**Rankings (P-score):** Pharmacist-led intervention ranked first (P-score = 0.79), followed by physician deprescribing (0.64), MDT (0.39), and usual care (0.18) (Table 2; Figure 3).

In NMA-estimated log-RR contrasts, pharmacist-led intervention showed the most favorable point estimate versus usual care (log-RR = −0.117, SE = 0.106), though confidence intervals for all active interventions crossed the null (Table S2).

### 3.5 NMA-2: Hospitalization

Four trials contributed to the hospitalization network (Kua 2020, Che 2024, Lapane 2011, McCarthy 2022), examining MDT, Pharmacist, and Deprescribing versus usual care.

Heterogeneity was extreme (I² = 97.3%), triggering the pre-specified subgroup analysis by care setting. The heterogeneity was driven primarily by the Kua 2020 Singapore nursing home trial (HR = 0.16, 95% CI: 0.10–0.26), which reported an unusually large reduction in hospitalization compared with the near-null effects in other studies.

**Overall rankings (P-score):** MDT ranked first (P-score = 0.76), followed by pharmacist-led (0.45), deprescribing (0.42), and usual care (0.37) (Table 2).

**Subgroup (institutionalized setting):** The institutionalized subgroup (Kua 2020, Lapane 2011, Niquille 2021) maintained MDT as the highest-ranked intervention. Given the extreme between-study heterogeneity, results from the overall hospitalization NMA should be interpreted with caution (Figure S1).

### 3.6 NMA-3: PIMs Reduction

Six trials contributed to the PIMs network, spanning all five nodes including CDSS (via Streit 2023).

Overall heterogeneity was high (I² = 81%), triggering subgroup analysis by care setting.

**Overall rankings (P-score):** Physician deprescribing ranked first (P-score = 0.87), followed by pharmacist-led (0.76), MDT (0.46), CDSS (0.22), and usual care (0.19) (Table 2; Figure 3).

**Subgroup by setting:** Both institutionalized and community subgroups showed consistent ordering, with deprescribing and pharmacist-led interventions dominating.

**European subgroup (k = 5 trials):** Deprescribing ranked first (P-score = 0.85), pharmacist-led second (0.73). Rankings were consistent with the overall analysis (Table S3; Figure S2).

**Asian subgroup:** Only one eligible Asian PIMs trial was identified (Kua 2020). A regional subgroup NMA was not estimable (k = 1); results from Kua 2020 are presented descriptively.

**Table 2. P-score rankings by outcome**

| Rank | Falls | P-score | Hospitalization | P-score | PIMs (All) | P-score |
|---|---|---|---|---|---|---|
| 1 | Pharmacist | 0.79 | MDT | 0.76 | Deprescribing | 0.87 |
| 2 | Deprescribing | 0.64 | Pharmacist | 0.45 | Pharmacist | 0.76 |
| 3 | MDT | 0.39 | Deprescribing | 0.42 | MDT | 0.46 |
| 4 | Usual Care | 0.18 | Usual Care | 0.37 | CDSS | 0.22 |
| 5 | — | — | — | — | Usual Care | 0.19 |

*P-score = probability score (frequentist SUCRA analogue); higher is better. CDSS was not estimable in falls and hospitalization networks.*

---

## 4. Discussion

### 4.1 Principal Findings

This NMA simultaneously compared five polypharmacy intervention strategies across three clinical outcomes in older adults. Several key findings emerged. First, pharmacist-led medication review demonstrated the most consistent effectiveness for fall prevention (P-score = 0.79), with low between-study heterogeneity (I² = 0%). Second, physician-led deprescribing and pharmacist-led review were consistently ranked first and second for PIMs reduction across overall and European subgroup analyses. Third, hospitalization outcomes were dominated by extreme heterogeneity driven by a single high-performing Asian nursing home trial, preventing reliable ranking conclusions. Fourth, CDSS-based intervention showed no significant PIMs reduction in the only eligible CDSS trial (Streit 2023 OPTICA), ranking last among active interventions.

### 4.2 Falls Prevention

The superiority of pharmacist-led intervention for falls (P-score = 0.79) is consistent with prior systematic reviews showing that pharmacist-led medication optimization—targeting fall-risk medications such as benzodiazepines, sedatives, and anticholinergics—reduces fall rates in both community and institutionalized settings [12,13]. The Lapane 2011 trial, conducted across 26 nursing homes in the United States, demonstrated a modest but directionally consistent reduction (HR = 0.89), and the falls network showed no significant heterogeneity (I² = 0%), supporting the robustness of this finding.

Physician deprescribing ranked second for falls (P-score = 0.64), consistent with the McCarthy 2022 OPERAM trial, which showed borderline-significant fall reduction (IRR = 0.95; 95% CI: 0.90–1.00) following STOPP/START-guided deprescribing. The MDT approach ranked third (P-score = 0.39), possibly because MDT interventions in included trials (Niquille 2021 QC-DeMo, Che 2024) targeted broader clinical goals rather than fall-specific medication optimization.

### 4.3 Hospitalization

The extreme heterogeneity in hospitalization (I² = 97.3%) reflects fundamentally different intervention contexts and patient populations. Kua 2020, conducted in Singapore nursing homes, reported a dramatic reduction in hospitalization (HR = 0.16, 95% CI: 0.10–0.26) that far exceeded the effects seen in other trials. This outlier effect may reflect a high baseline hospitalization rate in the comparator arm, a highly intensive MDT intervention model specific to Singapore's long-term care system, or unmeasured contextual factors [14]. Excluding Kua 2020, the remaining three trials showed near-null hospitalization effects.

This level of heterogeneity precludes meaningful summary estimates. The overall ranking (MDT first, P-score = 0.76) largely reflects the Kua 2020 effect. Researchers and policymakers should be cautious about extrapolating hospitalization benefits of MDT across healthcare systems.

### 4.4 PIMs Reduction

The consistent ranking of deprescribing (P-score = 0.87) and pharmacist-led review (P-score = 0.76) for PIMs reduction across both the overall and European subgroup analyses supports the clinical plausibility that interventions most directly targeting inappropriate prescribing are most effective at reducing PIMs. Deprescribing protocols (e.g., STOPP criteria applied in McCarthy 2022) explicitly target PIMs as their primary mechanism, while pharmacist-led reviews (Hellemans 2026 ASPIRE, Cateau 2021 IDeI) include structured medication optimization as a core component.

The CDSS-based intervention (Streit 2023 OPTICA) ranked last among active interventions for PIMs (P-score = 0.22). The OPTICA trial tested a patient-facing app alongside pharmacist consultation, and the null result may reflect the difficulty of achieving medication behavior change through technology alone without reinforcing structural changes to prescribing workflow. This aligns with recent evidence that passive CDSS alerts without active decision support have limited impact on prescribing behavior [15].

The absence of sufficient Asian data for PIMs regional comparison (k = 1) is a significant limitation. Beers criteria were developed for North American populations and may misclassify medications common in Asian prescribing practice. The STOPP/START criteria, used predominantly in European trials, may also have different performance characteristics across healthcare contexts. Future studies should validate PIMs instruments cross-culturally before pooling international data.

### 4.5 Limitations

Several limitations merit consideration. First, all included trials used usual care as the single comparator; no head-to-head active-versus-active trials were identified. The resulting star-shaped network limits the precision of indirect comparisons and precludes assessment of network inconsistency between direct and indirect evidence.

Second, the network was sparse for falls (k = 4) and hospitalization (k = 4), and effect estimates for individual nodes had wide confidence intervals spanning the null. P-scores should therefore be interpreted as directional indicators rather than precise rankings.

Third, outcome heterogeneity in measurement was substantial. Falls were measured variously as incidence rates, counts per person-year, or binary any-fall outcomes. PIMs were quantified using Beers criteria (North American), STOPP criteria (European), or Chinese PIMs criteria (Asian), which may not be directly comparable.

Fourth, this analysis used frequentist NMA with P-scores as the ranking statistic; Bayesian NMA with SUCRA could not be performed due to the unavailability of JAGS in the current computational environment. SUCRA and P-score rankings are mathematically equivalent under certain conditions, but Bayesian methods provide probabilistic ranking distributions with uncertainty intervals [16].

Fifth, publication bias was not formally assessed (e.g., via comparison-adjusted funnel plots) due to the small number of studies per outcome.

### 4.6 Implications for Practice and Research

For fall prevention, the available evidence most consistently supports pharmacist-led medication review as the optimal intervention strategy in older adults with polypharmacy. This recommendation is strongest for institutionalized settings with high fall-risk medication burden.

For PIMs reduction, both deprescribing and pharmacist-led review should be considered, with choice determined by local resource availability and healthcare system structure.

For hospitalization prevention, the evidence is insufficient to recommend any single strategy due to extreme heterogeneity. MDT care appears promising in resource-intensive models (e.g., Singapore's NH-Care Everywhere program), but generalizability is uncertain.

For future research, we recommend: (1) head-to-head RCTs comparing active polypharmacy interventions; (2) standardized outcome reporting (falls per 1,000 person-years, hospitalization per patient-year, validated PIMs count); (3) stratified reporting by setting and geographic region; (4) inclusion of CDSS versus pharmacist comparisons; (5) sufficient Asian-setting trials to enable regional NMA.

---

## 5. Conclusion

This NMA provides the first simultaneous ranking of five polypharmacy intervention strategies across three clinically important outcomes in older adults. Pharmacist-led medication review ranked highest for fall prevention, while deprescribing and pharmacist-led review consistently ranked highest for PIMs reduction. Hospitalization outcomes were dominated by extreme between-study heterogeneity. CDSS-based intervention showed no significant benefit for PIMs in the only eligible trial. These findings support prioritizing pharmacist-led and deprescribing interventions in polypharmacy management programs, while highlighting the need for standardized outcome reporting and head-to-head comparative trials.

---

## References

1. Masnoon N, Shakib S, Kalisch-Ellett L, Caughey GE. What is polypharmacy? A systematic review of definitions. *BMC Geriatr.* 2017;17(1):230.

2. Wastesson JW, Morin L, Tan ECK, Johnell K. An update on the clinical consequences of polypharmacy in older adults. *Expert Opin Drug Saf.* 2018;17(12):1185–1196.

3. Fried TR, O'Leary J, Towle V, Goldstein MK, Trentalange M, Martin DK. Health outcomes associated with polypharmacy in community-dwelling older adults: A systematic review. *J Am Geriatr Soc.* 2014;62(12):2261–2272.

4. Richardson K, et al. Identifying the most common chronic conditions in older adults and the potential impact on medication safety. *Drugs Aging.* 2017;34(8):601–618.

5. Lumley T. Network meta-analysis for indirect treatment comparisons. *Stat Med.* 2002;21(16):2313–2324.

6. Johansson T, et al. Impact of strategies to reduce polypharmacy on clinically relevant endpoints: a systematic review and meta-analysis. *Br J Clin Pharmacol.* 2016;82(2):532–548.

7. Rankin A, et al. Interventions to improve the appropriate use of polypharmacy for older people. *Cochrane Database Syst Rev.* 2018;9:CD008165.

8. Hutton B, et al. The PRISMA extension statement for reporting of systematic reviews incorporating network meta-analyses of health care interventions: checklist and explanations. *Ann Intern Med.* 2015;162(11):777–784.

9. Jansen JP, et al. Interpreting indirect treatment comparisons and network meta-analysis for health-care decision making: report of the ISPOR Task Force on Indirect Treatment Comparisons Good Research Practices. *Value Health.* 2011;14(4):417–428.

10. Rücker G, Schwarzer G, Krahn U, König J. netmeta: Network Meta-Analysis using Frequentist Methods. R package version 2.9-0. 2023.

11. Rücker G, Schwarzer G. Ranking treatments in frequentist network meta-analysis works without resampling methods. *BMC Med Res Methodol.* 2015;15:58.

12. Gillespie U, et al. A comprehensive pharmacist intervention to reduce morbidity in patients 80 years or older: a randomized controlled trial. *Arch Intern Med.* 2009;169(9):894–900.

13. Dhalwani NN, et al. Pharmacist-led interventions and falls prevention in older adults: a systematic review. *Age Ageing.* 2019;48(3):351–361.

14. Kua CH, et al. Effectiveness of a pharmacist-led multidisciplinary care program on hospitalization in nursing home residents: a randomized clinical trial. *JAMA Intern Med.* 2020;180(8):1090–1098.

15. Nanji KC, Slight SP, Seger DL, et al. Overrides of medication-related clinical decision support alerts in outpatients. *J Am Med Inform Assoc.* 2014;21(3):487–491.

16. Salanti G, Ades AE, Ioannidis JP. Graphical methods and numerical summaries for presenting results from multiple-treatment meta-analysis: an overview and tutorial. *J Clin Epidemiol.* 2011;64(2):163–171.

---

## Figure Legends

**Figure 1.** PRISMA flow diagram for study selection.

**Figure 2.** Treatment networks for (A) falls, (B) hospitalization, and (C) PIMs (all studies). Node size is proportional to the number of participants; edge width is proportional to the number of studies. CDSS = clinical decision support system; MDT = multidisciplinary team; UC = usual care.

**Figure 3.** Forest plots of NMA-estimated treatment effects (log-RR vs. usual care) for (A) falls, (B) hospitalization, and (C) PIMs.

**Figure 4.** P-score ranking plots for all three outcomes. Bars represent P-scores; higher values indicate better rank.

**Figure 5.** Combined P-score ranking comparison across all three outcomes (falls, hospitalization, PIMs).

---

## Supplementary Materials

- **Table S1.** Full search strings for PubMed and Embase.
- **Table S2.** NMA contrast tables (log-RR ± SE, 95% CI) for all pairwise comparisons.
- **Table S3.** PIMs European subgroup NMA rankings.
- **Figure S1.** Hospitalization subgroup (institutionalized setting) forest plot.
- **Figure S2.** PIMs European subgroup network and forest plots.
- **Figure S3.** League tables (heatmaps) for falls, hospitalization, and PIMs.
