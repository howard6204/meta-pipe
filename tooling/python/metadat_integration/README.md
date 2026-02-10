# metadat Integration Module

**Purpose**: Validate meta-pipe workflow with benchmark datasets from R metadat package

---

## 🚀 Quick Start

### One-Click Validation

```bash
cd /Users/htlin/meta-pipe
bash tooling/python/metadat_integration/run_validation_suite.sh
```

**Expected time**: 2-5 minutes

**Output**: ✅ PASS/FAIL validation report

---

## 📁 Files

| File                      | Purpose                                      |
| ------------------------- | -------------------------------------------- |
| `import_metadat.py`       | Import R metadat datasets → `extraction.csv` |
| `validate_pipeline.py`    | Compare results vs expected benchmarks       |
| `run_validation_suite.sh` | One-click full validation suite              |
| `README.md`               | This file                                    |

---

## 🧪 Current Tests

### BCG Vaccine Test (dat.bcg)

- **Dataset**: 13 RCTs, N=357,347 participants
- **Expected RR**: 0.51 (95% CI: 0.34-0.71)
- **Actual RR**: 0.490 (95% CI: 0.345-0.695)
- **Status**: ✅ **PASS** (4.0% difference)

---

## 📖 Full Documentation

See [metadat Validation](../../../ma-end-to-end/references/metadat-validation.md) for:

- Architecture details
- Adding new tests
- CI/CD integration
- Troubleshooting guide

---

## 🎯 Usage Examples

### Import a dataset

```bash
python3 import_metadat.py --dataset dat.bcg --project validation-bcg
```

### Validate results

```bash
python3 validate_pipeline.py --project validation-bcg
```

### Run specific test

```bash
Rscript ../projects/validation-bcg/06_analysis/01_bcg_meta_analysis.R
```

---

## ✅ Requirements

**R packages**:

- metadat
- metafor
- meta
- dplyr
- ggplot2

**Python packages**:

- pandas

**Install**:

```bash
Rscript -e 'install.packages(c("metadat", "metafor", "meta", "dplyr", "ggplot2"))'
source .venv/bin/activate
uv pip install pandas
```

---

**Last Updated**: 2026-02-10
