# Academic Writing Style Guide

**Reference**: This file is referenced from `ma-manuscript-quarto/SKILL.md`
**When to use**: During Phase 2 (writing from outline) and all manuscript editing

---

## Quick Rules

| # | Rule | Key Prohibitions | Detail |
|---|------|-----------------|--------|
| 1 | [No AI Casual Writing](style-no-ai-casual.md) | No contractions, no vague language, no imperative mood, no fragments | Replacement tables for each pattern |
| 2 | [Professional Register](style-professional-register.md) | No informal terms, no casual connectors, no incomplete statistics | Passive/active voice guide, transition table, terminology table |
| 3 | [AMA Style](style-ama-guide.md) | No author-date citations, no brand drug names, no sentence-initial numerals | Citations, bibliography, numbers, abbreviations, punctuation |

---

## Rule 1 Summary: No AI Casual Writing

**Detail**: [style-no-ai-casual.md](style-no-ai-casual.md)

- **No contractions**: "do not" not "don't"; "cannot" not "can't"
- **No vague language**: "determine" not "figure out"; "possibly" not "maybe"
- **No imperative mood**: "The analysis was performed" not "Run the analysis"
- **No sentence fragments**: "No data were available" not "No data."

---

## Rule 2 Summary: Professional Academic Register

**Detail**: [style-professional-register.md](style-professional-register.md)

- **Complete sentences**: subject + verb + object; result pattern: `[Subject] [past-tense verb] [object] (estimate, 95% CI; heterogeneity).`
- **Passive voice** for Methods/Results; **active voice** for Introduction/Discussion interpretation
- **Formal transitions**: However, Therefore, In contrast — not But, So, Also; vary within subsection
- **Precise terminology**: adverse events (not side effects), mortality (not death), efficacious (not worked)
- **Complete statistics**: every claim needs estimate + 95% CI + p-value

---

## Rule 3 Summary: AMA Style (American Medical Association)

**Detail**: [style-ama-guide.md](style-ama-guide.md)

- **Citations**: Superscript numbered `[@key]` via `american-medical-association.csl`; sequential by first mention
- **Bibliography**: LastName AB format; up to 6 authors then "et al"; NLM journal abbreviations; DOI required
- **Numbers**: Numerals with units ("5 mg"); spell out at sentence start ("Twelve patients"); "%" not "percent"
- **Abbreviations**: Define at first use; redefine in abstract AND body; no abbreviations in title
- **Drug names**: Generic lowercase ("pembrolizumab" not "Keytruda")
- **P values**: AMA uses italic *P* with no leading zero (*P* = .03); check target journal convention
- **Punctuation**: Serial comma required; en-dash for ranges; hyphens for compound modifiers

---

## Validation Checklist

Run these checks before finalizing any manuscript section:

### Writing quality (Rules 1-2)

| Check | Method | Pass Criteria |
|-------|--------|---------------|
| No contractions | Search `.qmd` for `n't`, `'re`, `'ve`, `'ll` | 0 hits (excluding Crohn's, Hodgkin's) |
| No fragments | Manual review of prose paragraphs | Every sentence has subject + verb |
| No imperative mood | Search for sentence-initial verbs in prose | 0 command-voice sentences |
| No vague language | Search for "maybe, figure out, a lot, stuff, things, basically" | 0 hits |
| Passive/active balance | Manual review | Methods/Results mostly passive; Discussion mixed |
| Transition variety | Check for repeated "However" or "Moreover" | No transition > 2 uses per subsection |
| Precise terminology | Search for "showed, better, worse, worked, big, small" | 0 informal terms |
| Statistics complete | Each result has estimate + CI + p-value | 0 incomplete claims |

### AMA compliance (Rule 3)

| Check | Method | Pass Criteria |
|-------|--------|---------------|
| CSL file present | `ls 07_manuscript/american-medical-association.csl` | File exists |
| Citations render | Render HTML, inspect citation output | Sequential superscript numerals |
| DOI verification | `scripts/verify_doi.py --bib references.bib --out doi_report.md` | Exit code 0 (>= 90% coverage, 0 invalid) |
| P value format | Search for `p =`, `p <` (lowercase) | Correct per target journal |
| Serial comma | Search for "X, Y and Z" patterns | All lists use Oxford comma |
| Drug names | Search for brand names (Keytruda, Opdivo, Tecentriq) | Generic names used |
| Abbreviations | First occurrence of each abbreviation | Defined at first use in abstract AND body |
| No sentence-initial numerals | Search for `^\d+` at line starts in prose | 0 hits |

### AI vocabulary

| Check | Method | Pass Criteria |
|-------|--------|---------------|
| AI word scan | Run `human-write` skill scan | Score <= 4 (light AI flavor) |

---

## Cross-References

- **AI vocabulary detection**: `human-write` skill — word-level scan for AI-favored terms (delve, meticulous, etc.)
- **Quarto syntax**: [quarto-syntax-guide.md](quarto-syntax-guide.md) — cross-references, figures, tables, citations
- **Journal requirements**: `ma-publication-quality/references/journal-formatting.md` — word limits, figure counts per journal
