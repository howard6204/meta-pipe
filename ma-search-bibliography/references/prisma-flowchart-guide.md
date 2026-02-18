# PRISMA 2020 Flowchart Generation Guide

## Quick Start

**Goal**: Generate publication-quality PRISMA 2020 flow diagrams automatically using R.

**Time**: 2-5 minutes per flowchart

---

## Installation (One-Time)

The PRISMA2020 R package is automatically installed when you first run the script.

**Manual installation** (if needed):

```r
install.packages("PRISMA2020")
```

---

## Usage

### Simple Command

```bash
cd /Users/htlin/meta-pipe/ma-search-bibliography/scripts

Rscript generate_prisma_flowchart.R \
  DB_RECORDS \
  SCREENED \
  EXCLUDED \
  FULLTEXT \
  INCLUDED \
  [PARTICIPANTS] \
  [OUTPUT_DIR]
```

### Real Example (ICI-Breast-Cancer)

```bash
Rscript generate_prisma_flowchart.R 122 122 117 5 5 2402 ../../projects/ici-breast-cancer/figures/
```

This generates:
- ✅ **PNG** (73 KB, 300 DPI) - For manuscript Figure 1
- ✅ **PDF** (21 KB, vector) - For publication submission
- ✅ **SVG** (13 KB, scalable) - For presentations
- ✅ **HTML** (2.1 MB, interactive) - For supplementary materials

---

## Parameters

| Parameter | Description | Example | Required |
|-----------|-------------|---------|----------|
| `DB_RECORDS` | Total records from database search | `122` | ✅ Yes |
| `SCREENED` | Records screened (title/abstract) | `122` | ✅ Yes |
| `EXCLUDED` | Records excluded after screening | `117` | ✅ Yes |
| `FULLTEXT` | Full-text articles assessed | `5` | ✅ Yes |
| `INCLUDED` | Studies included in final analysis | `5` | ✅ Yes |
| `PARTICIPANTS` | Total N in included studies | `2402` | ❌ Optional |
| `OUTPUT_DIR` | Where to save files | `figures/` | ❌ Optional (default: `figures/`) |

---

## Output Files

### 1. PNG (Manuscript)

**File**: `prisma_flowchart.png`

- **Resolution**: 300 DPI (publication quality)
- **Size**: ~70-80 KB
- **Use**: Manuscript Figure 1
- **Format**: Raster image

### 2. PDF (Publication)

**File**: `prisma_flowchart.pdf`

- **Format**: Vector (infinite scalability)
- **Size**: ~20-25 KB
- **Use**: Journal submission (preferred by most publishers)

### 3. SVG (Presentation)

**File**: `prisma_flowchart.svg`

- **Format**: Scalable vector graphics
- **Size**: ~12-15 KB
- **Use**: PowerPoint, conference presentations
- **Advantage**: Scales perfectly at any size

### 4. HTML (Interactive)

**File**: `prisma_flowchart_interactive.html`

- **Size**: ~2 MB (includes JavaScript)
- **Features**: Hover tooltips, clickable boxes
- **Use**: Supplementary materials, online appendix
- **Advantage**: Enhanced transparency for readers

---

## Integration into Workflow

### After Search Completion (Stage 02)

When you finish database searches:

```bash
cd /Users/htlin/meta-pipe/projects/<your-project>/

# Extract numbers from search logs
DB_RECORDS=$(wc -l < 02_search/round-01/dedupe.bib | xargs)

# Generate flowchart (screening not yet done, so use 0 for later stages)
Rscript ../../ma-search-bibliography/scripts/generate_prisma_flowchart.R \
  $DB_RECORDS 0 0 0 0 NA figures/
```

### After Screening (Stage 03)

When title/abstract screening is complete:

```bash
# Count screened and excluded
SCREENED=$(tail -n +2 03_screening/round-01/decisions.csv | wc -l | xargs)
EXCLUDED=$(tail -n +2 03_screening/round-01/decisions.csv | grep -c "exclude" || echo 0)
FULLTEXT=$((SCREENED - EXCLUDED))

# Regenerate flowchart
Rscript ../../ma-search-bibliography/scripts/generate_prisma_flowchart.R \
  $DB_RECORDS $SCREENED $EXCLUDED $FULLTEXT 0 NA figures/
```

### After Final Analysis (Stage 06)

When meta-analysis is complete:

```bash
# Count included studies
INCLUDED=$(tail -n +2 05_extraction/round-01/extraction.csv | cut -d',' -f1 | sort -u | wc -l | xargs)

# Calculate total N
PARTICIPANTS=$(tail -n +2 05_extraction/round-01/extraction.csv | awk -F',' '{sum+=$X} END {print sum}')

# Final flowchart
Rscript ../../ma-search-bibliography/scripts/generate_prisma_flowchart.R \
  $DB_RECORDS $SCREENED $EXCLUDED $FULLTEXT $INCLUDED $PARTICIPANTS figures/
```

---

## Compliance & Standards

### PRISMA 2020 Compliance

✅ **Fully compliant** with:
- [PRISMA 2020 Statement](http://www.prisma-statement.org/)
- [PRISMA 2020 Flow Diagram](https://doi.org/10.1002/cl2.1230)

### Journal Requirements

✅ **Accepted by**:
- BMJ, Lancet, JAMA (mandatory for systematic reviews)
- Cochrane Reviews (required)
- PLoS Medicine, Annals of Internal Medicine
- All journals following EQUATOR Network guidelines

---

## Customization (Advanced)

### Custom Database Labels

If you searched multiple databases, edit the R script line:

```r
data$boxtext[data$data == "database_results"] <- "PubMed + Embase + Cochrane (n=XXX)"
```

### Multiple Databases

For multi-database searches:

```bash
# Example: PubMed (122) + Embase (89) + Cochrane (45)
TOTAL_RECORDS=$((122 + 89 + 45))

Rscript generate_prisma_flowchart.R $TOTAL_RECORDS ...
```

---

## Troubleshooting

### Error: "PRISMA2020 package not found"

**Solution**:
```r
install.packages("PRISMA2020", repos = "https://cran.r-project.org")
```

### Error: "argument is of length zero"

**Cause**: Missing required parameters

**Solution**: Provide all 5 required arguments (DB_RECORDS, SCREENED, EXCLUDED, FULLTEXT, INCLUDED)

### Flowchart looks wrong

**Common issues**:
1. **Math doesn't add up**: SCREENED should equal (EXCLUDED + FULLTEXT)
2. **Negative numbers**: Check your counts
3. **Wrong numbers**: Verify extraction from CSV files

---

## Best Practices

### 1. **Version Control**

Keep flowchart data in a CSV for reproducibility:

```csv
stage,count,date
database_records,122,2026-02-07
screened,122,2026-02-08
excluded,117,2026-02-08
fulltext_assessed,5,2026-02-09
included,5,2026-02-10
total_participants,2402,2026-02-10
```

### 2. **Update Incrementally**

Regenerate the flowchart after each stage completion:
- After search → Update DB_RECORDS
- After screening → Update SCREENED, EXCLUDED
- After full-text → Update FULLTEXT
- After extraction → Update INCLUDED, PARTICIPANTS

### 3. **Include in Manuscript**

**Figure caption example**:

> **Figure 1. PRISMA 2020 flow diagram of study selection.**
> The systematic search identified 122 records from PubMed/MEDLINE. After title and abstract screening, 5 full-text articles were assessed for eligibility. All 5 studies (N=2,402 participants) met inclusion criteria and were included in the meta-analysis.

### 4. **Archive Interactive Version**

**Supplementary materials**:
- Include `prisma_flowchart_interactive.html` as **Supplementary File 1**
- Provides enhanced transparency for peer reviewers and readers

---

## Time Investment

| Task | Time |
|------|------|
| First-time package installation | 2-3 min |
| Generate flowchart (subsequent runs) | 30 sec |
| Customize labels (optional) | 2-5 min |
| **Total (first time)**: | **5-8 min** |
| **Total (updates)**: | **<1 min** |

---

## Comparison: Manual vs Automated

| Method | Time | Quality | Compliance | Reproducibility |
|--------|------|---------|------------|-----------------|
| **Manual (PowerPoint/Visio)** | 30-60 min | Variable | Often incomplete | Low |
| **Draw.io / Lucidchart** | 20-40 min | Good | Manual verification needed | Medium |
| **PRISMA2020 R Package** ✅ | **2-5 min** | **Excellent** | **100% compliant** | **High** |

---

## Reference

**Original publication**:

Haddaway, N. R., Page, M. J., Pritchard, C. C., & McGuinness, L. A. (2022). PRISMA2020: An R package and Shiny app for producing PRISMA 2020-compliant flow diagrams, with interactivity for optimised digital transparency and Open Synthesis. *Campbell Systematic Reviews*, 18(2), e1230. https://doi.org/10.1002/cl2.1230

**PRISMA 2020 Statement**:

Page, M. J., McKenzie, J. E., Bossuyt, P. M., et al. (2021). The PRISMA 2020 statement: an updated guideline for reporting systematic reviews. *BMJ*, 372, n71. https://doi.org/10.1136/bmj.n71

---

## Support

**Questions?** See:
- [PRISMA2020 package documentation](https://cran.r-project.org/web/packages/PRISMA2020/PRISMA2020.pdf)
- [PRISMA2020 GitHub](https://github.com/nealhaddaway/PRISMA2020)
- [PRISMA official website](http://www.prisma-statement.org/)
