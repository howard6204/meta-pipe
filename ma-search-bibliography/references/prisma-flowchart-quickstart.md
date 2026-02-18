# PRISMA Flowchart Quick Start

## One-Line Command

```bash
Rscript generate_prisma_flowchart.R 122 122 117 5 5 2402 figures/
```

**Parameters**: `DB_RECORDS SCREENED EXCLUDED FULLTEXT INCLUDED [PARTICIPANTS] [OUTPUT_DIR]`

---

## Stage-by-Stage Examples

### After Search (Stage 02)

```bash
cd /Users/htlin/meta-pipe/ma-search-bibliography/scripts

# Count records
DB_RECORDS=$(wc -l < ../../projects/my-project/02_search/round-01/dedupe.bib | xargs)

# Generate flowchart
Rscript generate_prisma_flowchart.R $DB_RECORDS 0 0 0 0 NA ../../projects/my-project/figures/
```

### After Screening (Stage 03)

```bash
# Count screened and excluded
SCREENED=$(tail -n +2 ../../projects/my-project/03_screening/round-01/decisions.csv | wc -l | xargs)
EXCLUDED=$(grep -c "exclude" ../../projects/my-project/03_screening/round-01/decisions.csv || echo 0)
FULLTEXT=$((SCREENED - EXCLUDED))

# Regenerate
Rscript generate_prisma_flowchart.R $DB_RECORDS $SCREENED $EXCLUDED $FULLTEXT 0 NA ../../projects/my-project/figures/
```

### After Analysis (Stage 06)

```bash
# Count included studies and participants
INCLUDED=5
PARTICIPANTS=2402

# Final flowchart
Rscript generate_prisma_flowchart.R $DB_RECORDS $SCREENED $EXCLUDED $FULLTEXT $INCLUDED $PARTICIPANTS ../../projects/my-project/figures/
```

---

## Output Files

✅ **PNG** (manuscript) - `prisma_flowchart.png`
✅ **PDF** (publication) - `prisma_flowchart.pdf`
✅ **SVG** (presentation) - `prisma_flowchart.svg`
✅ **HTML** (interactive) - `prisma_flowchart_interactive.html`

---

## Common Errors

### "Cannot find PRISMA2020 package"

```r
install.packages("PRISMA2020")
```

### "Missing required arguments"

Provide all 5 required numbers: `DB_RECORDS SCREENED EXCLUDED FULLTEXT INCLUDED`

---

## Full Documentation

See: `references/prisma-flowchart-guide.md`
