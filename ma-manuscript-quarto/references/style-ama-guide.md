# Rule 3: AMA Style (American Medical Association)

**Parent**: [Academic Writing Style Guide](academic-writing-style.md)

This pipeline defaults to **AMA Manual of Style (11th edition)** for citations, bibliography, and writing conventions. AMA is the standard for JAMA, Lancet, BMJ, and most biomedical journals.

---

## 3.1 Citation Format

AMA uses **superscript Arabic numerals** cited in order of first appearance in text. This is handled automatically by Quarto + CSL.

**Quarto setup** (in `index.qmd` or `_quarto.yml`):

```yaml
bibliography: references.bib
csl: american-medical-association.csl
```

**Download**: Get `american-medical-association.csl` from the [Zotero Style Repository](https://www.zotero.org/styles?q=american+medical+association) or the [CSL GitHub repository](https://github.com/citation-style-language/styles).

**In-text citation rules**:

| Pattern | Quarto Syntax | Rendered Output |
|---------|---------------|-----------------|
| End of sentence | `...survival benefit.[@smith2020]` | ...survival benefit.^1^ |
| Multiple sources | `...prior studies[@smith2020; @jones2021]` | ...prior studies^1,2^ |
| Three or more consecutive | `[@a; @b; @c]` | ^1-3^ |
| Author named in text | `Smith et al[@smith2020] reported...` | Smith et al^1^ reported... |
| Multiple non-consecutive | `[@a; @c; @e]` | ^1,3,5^ |

**AMA citation rules to enforce**:

1. **Superscript numbers**, not parenthetical author-date.
2. **Sequential numbering** — references are numbered in order of first mention, not alphabetically.
3. **Place citation after punctuation** — `...treatment.^1^` not `...treatment^1^.` (Quarto CSL handles this automatically).
4. **No "Ref." or "Reference"** — use the number alone: `^1^` not `(Ref. 1)`.
5. **Do not use ibid.** — repeat the reference number.
6. **Up to 6 authors listed**, then "et al" in the bibliography.

---

## 3.2 Bibliography Format

AMA bibliography entries follow a specific format. BibTeX + `american-medical-association.csl` generates this automatically, but verify the output matches these patterns.

**Journal article** (standard):

```
1. Smith AB, Jones CD, Wilson EF, et al. Title of article in sentence case.
   JAMA Oncol. 2024;10(3):234-241. doi:10.1001/jamaoncol.2024.1234
```

**Key formatting rules**:

| Element | AMA Rule | Example |
|---------|----------|---------|
| Author names | LastName Initials (no periods, no commas between initials) | Smith AB, Jones CD |
| Author limit | List up to 6, then "et al" | Smith AB, Jones CD, ..., Brown KL, et al. |
| Article title | Sentence case (only first word and proper nouns capitalized) | Immune checkpoint inhibitors in breast cancer |
| Journal name | Abbreviated per NLM catalog (italicized) | *JAMA Oncol*. *Lancet Oncol*. *N Engl J Med*. |
| Year;Volume(Issue):Pages | No spaces around semicolons/colons | 2024;10(3):234-241 |
| DOI | Required, no URL prefix | doi:10.1001/jamaoncol.2024.1234 |
| PMID | Optional, after DOI | PMID:12345678 |

**Common journal abbreviations** (NLM style):

| Full Name | AMA Abbreviation |
|-----------|-----------------|
| Journal of the American Medical Association | *JAMA* |
| The Lancet Oncology | *Lancet Oncol* |
| New England Journal of Medicine | *N Engl J Med* |
| British Medical Journal | *BMJ* |
| Annals of Internal Medicine | *Ann Intern Med* |
| Journal of Clinical Oncology | *J Clin Oncol* |
| Nature Medicine | *Nat Med* |
| The Lancet | *Lancet* |
| Cochrane Database of Systematic Reviews | *Cochrane Database Syst Rev* |
| Systematic Reviews | *Syst Rev* |

**Other reference types**:

| Type | Format |
|------|--------|
| Book chapter | AuthorAB. Chapter title. In: EditorCD, ed. *Book Title*. Publisher; Year:Pages. |
| Website | Author/Organization. Title. URL. Accessed Month Day, Year. |
| Clinical trial registry | Identifier. Title. ClinicalTrials.gov. Accessed Month Day, Year. URL |
| Preprint | AuthorAB. Title. Preprint. Posted Month Day, Year. doi:... |

**BibTeX tips for clean AMA output**:

- Ensure `doi` field is populated for every journal article (target >= 90% DOI coverage).
- Use `journal` field with the **full journal name** — the CSL file handles abbreviation.
- Use `author` field as `{Last, First and Last, First}` — BibTeX/CSL handles AMA formatting.
- Include `volume`, `number` (issue), and `pages` fields.
- Use `year` or `date` field consistently.

**DOI verification** (mandatory before submission):

```bash
# Verify all DOIs exist and find missing ones via Crossref API
uv run ma-manuscript-quarto/scripts/verify_doi.py \
  --bib projects/<project>/07_manuscript/references.bib \
  --out projects/<project>/09_qa/doi_verification_report.md \
  --email "your@email.com"

# Auto-patch high-confidence missing DOIs (>= 85% match)
uv run ma-manuscript-quarto/scripts/verify_doi.py \
  --bib projects/<project>/07_manuscript/references.bib \
  --out projects/<project>/09_qa/doi_verification_report.md \
  --patch --min-confidence 85
```

The tool uses the Crossref API to:
1. **Verify existing DOIs** — confirms each DOI resolves (catches typos, expired DOIs)
2. **Find missing DOIs** — searches by title + year with confidence scoring (title similarity + year match)
3. **Auto-patch** — inserts high-confidence DOIs directly into `references.bib`

Exit codes: 0 = pass (>= 90% coverage, 0 invalid), 1 = low coverage, 2 = invalid DOIs found.

---

## 3.3 AMA Writing Conventions

AMA style prescribes specific conventions beyond general academic writing.

### Numbers

| Rule | Example |
|------|---------|
| Spell out numbers < 10 at sentence start | "Three studies reported..." |
| Use numerals for all measurements | "5 mg", "3 mL", "12 patients" |
| Use numerals with units always | "2 hours", "7 days", "4 cycles" |
| Never start a sentence with a numeral | "Twelve patients..." not "12 patients..." |
| Use "%" with numerals | "45%" not "45 percent" or "forty-five percent" |
| Report ranges with "to" or en-dash | "5% to 10%" or "5%-10%", consistent throughout |

### Abbreviations

| Rule | Example |
|------|---------|
| Define at first use | "overall survival (OS)" then "OS" thereafter |
| Do not abbreviate in title | Full terms in the title |
| Do not abbreviate terms used < 3 times | Spell out each time if used only once or twice |
| Standard abbreviations need no definition | "DNA", "RNA", "HIV", "CI", "OR", "RR", "HR" |
| Redefine in abstract AND text | Abstract and body are treated as separate contexts |

**Common AMA abbreviations** (no definition needed):

| Abbreviation | Meaning |
|-------------|---------|
| CI | confidence interval |
| OR | odds ratio |
| RR | relative risk / risk ratio |
| HR | hazard ratio |
| MD | mean difference |
| SMD | standardized mean difference |
| NNT | number needed to treat |
| NNH | number needed to harm |
| ITT | intention to treat |
| RCT | randomized clinical trial |
| PRISMA | Preferred Reporting Items for Systematic Reviews and Meta-Analyses |
| GRADE | Grading of Recommendations Assessment, Development and Evaluation |

### Drug Names

| Rule | Example |
|------|---------|
| Use generic names (lowercase) | "pembrolizumab" not "Keytruda" |
| Brand names only when clinically relevant | "pembrolizumab (Keytruda; Merck)" at first mention if needed |
| Do not capitalize generic names | "nivolumab", "atezolizumab" |

### Statistical Reporting

| Element | AMA Format | Example |
|---------|------------|---------|
| P values | Italic *P*, exact value to 2-3 decimals | *P* = .03 (not p = 0.03) |
| P value threshold | Report exact; thresholds in Methods only | *P* < .001 (not *P* < .05 unless predefined) |
| Leading zero | AMA omits leading zero for values that cannot exceed 1 | *P* = .04, not *P* = 0.04 |
| Confidence intervals | Parenthetical, with "95% CI" | (95% CI, 1.16-1.37) |
| Effect estimates | Bold or standard, with CI | RR, 1.26 (95% CI, 1.16-1.37) |
| I-squared | Superscript 2 | I^2^ = 45% |
| Mean (SD) | Parenthetical | 52.3 (14.7) years |
| Median (IQR) | Parenthetical with label | median, 36 (IQR, 24-48) months |

**Note on P value formatting**: AMA style uses uppercase italic *P* with no leading zero. Some journals (Lancet, BMJ) prefer lowercase italic *p* with a leading zero (p = 0.03). Check the target journal and be consistent throughout the manuscript. Configure once in `manuscript_outline.md` Section 1.

### Punctuation

| Rule | AMA Convention |
|------|----------------|
| Serial (Oxford) comma | **Required**: "age, sex, and stage" |
| Semicolons in lists | Use when items contain internal commas |
| En-dash for ranges | "pages 10-15", "2020-2024", "CI, 1.16-1.37" |
| Hyphens for compound modifiers | "progression-free survival", "intent-to-treat analysis" |
| No hyphen after -ly adverbs | "newly diagnosed patients" (not "newly-diagnosed") |

### Headings (IMRaD Structure)

| Level | AMA Convention | Use |
|-------|----------------|-----|
| 1 | Bold, title case, centered | Introduction, Methods, Results, Discussion |
| 2 | Bold, title case, left-aligned | Study Selection, Statistical Analysis |
| 3 | Bold italic, sentence case, left-aligned | Primary outcome, Subgroup analyses |
| 4 | Italic, sentence case, run-in with text | *Sensitivity analysis.* Results were... |

**Note**: Quarto handles heading rendering. Use standard markdown headings (`##`, `###`) and let the output format control styling.

---

## 3.4 Quarto Configuration for AMA

Complete YAML frontmatter for AMA-compliant manuscripts:

```yaml
---
title: "Full Title in Title Case Without Abbreviations"
format:
  html:
    toc: true
    number-sections: true
    embed-resources: true
  docx:
    toc: true
    number-sections: true
  typst:
    toc: true
    number-sections: true
    columns: 1
    margin:
      x: 1in
      y: 1in
    papersize: us-letter
    mainfont: "New Computer Modern"
    fontsize: 11pt
bibliography: references.bib
csl: american-medical-association.csl
link-citations: true
---
```

**Ensure**:

- `american-medical-association.csl` is present in `07_manuscript/`.
- `references.bib` has DOIs for >= 90% of journal articles.
- All `[@key]` citations in `.qmd` files resolve against `references.bib`.
