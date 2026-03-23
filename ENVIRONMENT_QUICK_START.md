# Environment Quick Start

**ONE-TIME SETUP** - Run once per machine

---

## 🚀 3-Minute Setup

```bash
cd /Users/htlin/meta-pipe

# 1. Run automated setup
bash setup.sh

# 2. Verify installation
bash verify_environment.sh
```

**Expected**: All checks ✅

---

## 📦 What Gets Installed?

### System Tools
- ✅ **Python 3.12+** - Data processing
- ✅ **uv** - Python package manager (fast)
- ✅ **R 4.3+** - Statistical analysis
- ✅ **cmake** - Required for building R packages (e.g., `fs`) on macOS ARM
- ⚠️ **JAGS** - Optional (only for Network Meta-Analysis)
- ⚠️ **Quarto** - Optional (for manuscript rendering)

### Python Packages
```
bibtexparser  # BibTeX parsing
biopython     # PubMed API
pandas        # Data frames
pdfplumber    # PDF extraction
pyyaml        # YAML files
requests      # HTTP requests
```

### R Packages
```r
# Core (always needed)
meta, metafor      # Meta-analysis
dplyr, tidyr       # Data wrangling
ggplot2            # Plots
gt, flextable      # Tables

# NMA only (optional)
gemtc, rjags       # Bayesian NMA
netmeta            # Frequentist NMA
```

---

## 🔧 Manual Setup (if automated fails)

### Python

```bash
cd tooling/python

# Create environment
uv venv

# Install packages
uv sync

# Verify
uv run python -c "import pandas; print('✅ OK')"
```

### R

```bash
# Run R setup script
Rscript tooling/setup/setup_r_environment.R

# Or manually:
R
```

**In R console**:
```r
install.packages("renv")
renv::init()
install.packages(c("meta", "metafor", "ggplot2", "dplyr", "gt"))
renv::snapshot()
```

---

## ✅ Verify Installation

```bash
bash verify_environment.sh
```

**Check for**:
- ✅ All system tools found
- ✅ Python packages installed
- ✅ R packages installed
- ⚠️ Optional warnings OK

---

## 🚨 Troubleshooting

### "uv: command not found"

```bash
# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Add to PATH
export PATH="$HOME/.cargo/bin:$PATH"

# Restart terminal
```

### "Python packages missing"

```bash
cd tooling/python
rm -rf .venv
uv venv
uv sync
```

### "R packages won't install"

**macOS**:
```bash
xcode-select --install
brew install cmake  # Required for packages like 'fs' on ARM Macs
```

**Linux**:
```bash
sudo apt install build-essential libcurl4-openssl-dev cmake
```

### "JAGS not found"

**Only needed for Network Meta-Analysis**

```bash
# macOS
brew install jags

# Linux
sudo apt install jags
```

---

## 📚 After Setup

### Create First Project

```bash
uv run tooling/python/init_project.py --name my-meta-analysis
```

### Start Working

Open Claude Code and say: **"start project my-meta-analysis"**

---

## 🔄 Restoring Environment (New Machine)

If you cloned this repo on a new machine, restore the environment:

### Python

```bash
cd tooling/python
uv sync  # Restore from pyproject.toml
```

### R

```r
# In R console
renv::restore()  # Restore from renv.lock
```

---

## 🔄 Updating Packages

### Update Python packages

```bash
cd tooling/python
uv sync --upgrade
```

### Update R packages

```r
# In R console
renv::update()
renv::snapshot()
```

---

**Setup time**: 30-60 minutes (first time)
**Verification**: 2 minutes
**Status**: Run `bash verify_environment.sh` anytime
