# Environment Setup Guide

**Purpose**: One-time setup for meta-analysis pipeline
**Time**: 30-60 minutes
**Platforms**: macOS, Linux, Windows (WSL)

---

## Quick Start (TL;DR)

```bash
# 1. Clone and enter repo
cd /Users/htlin/meta-pipe

# 2. Run automated setup
bash setup.sh

# 3. Verify installation
bash verify_environment.sh
```

**Expected**: All checks ✅ → Ready to start meta-analysis

---

## Prerequisites

### Required (Must Have)

| Tool | Version | Check Command | Install |
|------|---------|---------------|---------|
| **Python** | ≥3.12 | `python3 --version` | [python.org](https://python.org) |
| **uv** | Latest | `uv --version` | `curl -LsSf https://astral.sh/uv/install.sh \| sh` |
| **R** | ≥4.3 | `R --version` | [r-project.org](https://r-project.org) |
| **JAGS** | ≥4.3 | `jags` (command exists) | [mcmc-jags.sourceforge.io](https://mcmc-jags.sourceforge.io) |
| **Git** | Any | `git --version` | Pre-installed on macOS/Linux |

### Optional (Recommended)

| Tool | Purpose | Install |
|------|---------|---------|
| **Quarto** | Manuscript rendering | [quarto.org](https://quarto.org) |
| **RStudio** | R IDE | [posit.co/downloads](https://posit.co/downloads) |
| **VS Code** | Code editing | [code.visualstudio.com](https://code.visualstudio.com) |

---

## Step-by-Step Setup

### Step 1: Install System Dependencies

#### macOS (Homebrew)

```bash
# Install Homebrew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install core tools
brew install python@3.12 r jags

# Install uv (Python package manager)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Optional: Install Quarto
brew install --cask quarto

# Optional: Install RStudio
brew install --cask rstudio
```

#### Linux (Ubuntu/Debian)

```bash
# Update package list
sudo apt update

# Install Python 3.12
sudo apt install python3.12 python3.12-venv python3-pip

# Install R
sudo apt install r-base r-base-dev

# Install JAGS
sudo apt install jags

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Optional: Install Quarto
wget https://quarto.org/download/latest/quarto-linux-amd64.deb
sudo dpkg -i quarto-linux-amd64.deb
```

#### Windows (WSL2 recommended)

```powershell
# Install WSL2 + Ubuntu
wsl --install

# Then follow Linux instructions inside WSL
```

---

### Step 2: Python Environment Setup

```bash
cd /Users/htlin/meta-pipe/tooling/python

# Create virtual environment using uv
uv venv

# Activate environment (if not using uv run)
# macOS/Linux:
source .venv/bin/activate
# Windows:
.venv\Scripts\activate

# Install Python dependencies
uv sync

# Verify installation
uv run python -c "import pandas; import bibtexparser; print('✅ Python OK')"
```

**Installed packages** (from `pyproject.toml`):
- `bibtexparser` - BibTeX parsing
- `biopython` - PubMed API access
- `pandas` - Data manipulation
- `pdfplumber` - PDF text extraction
- `pyyaml` - YAML parsing
- `requests` - HTTP requests

---

### Step 3: R Environment Setup

#### 3.1 Install JAGS (Required for Bayesian NMA)

**macOS**:
```bash
brew install jags
```

**Linux**:
```bash
sudo apt install jags
```

**Windows**:
Download installer from [mcmc-jags.sourceforge.io](https://mcmc-jags.sourceforge.io)

**Verify**:
```bash
jags
# Should show JAGS version, not "command not found"
```

#### 3.2 Initialize R Project Environment

```bash
cd /Users/htlin/meta-pipe

# Option A: Automated setup (recommended)
Rscript setup_r_environment.R

# Option B: Manual setup
R
```

**In R console** (if manual):

```r
# Install renv
install.packages("renv")

# Initialize renv for project
renv::init()

# Install core meta-analysis packages
install.packages(c(
  # Data manipulation
  "dplyr", "readr", "tidyr", "stringr",

  # Meta-analysis (standard)
  "meta", "metafor",

  # Network meta-analysis (Bayesian)
  "gemtc", "rjags", "coda",

  # Network meta-analysis (Frequentist)
  "netmeta",

  # Visualization
  "ggplot2", "forestplot",

  # Tables
  "gtsummary", "gt", "flextable",

  # Utilities
  "dmetar"
))

# Create snapshot
renv::snapshot()

# Exit R
q()
```

**Expected output**: `renv.lock` file created with pinned package versions

---

### Step 4: Verify Installation

```bash
cd /Users/htlin/meta-pipe

# Run comprehensive verification
bash verify_environment.sh
```

**Expected output**:

```
============================================================
🔍 META-ANALYSIS PIPELINE ENVIRONMENT VERIFICATION
============================================================

System Dependencies:
✅ Python 3.12.1 installed
✅ uv 0.5.24 installed
✅ R 4.3.2 installed
✅ JAGS 4.3.0 installed
✅ Git 2.39.0 installed
⚠️  Quarto not found (optional)

Python Environment:
✅ Virtual environment exists
✅ bibtexparser installed
✅ biopython installed
✅ pandas installed
✅ pdfplumber installed
✅ pyyaml installed
✅ requests installed

R Environment:
✅ renv initialized
✅ meta package installed
✅ metafor package installed
✅ gemtc package installed
✅ rjags package installed
✅ netmeta package installed
✅ ggplot2 package installed
✅ gt package installed

JAGS Configuration:
✅ JAGS executable found
✅ rjags can load JAGS modules

Project Structure:
✅ tooling/python/ exists
✅ ma-*/assets/r/ directories exist
✅ projects/ directory exists

============================================================
✅ ENVIRONMENT READY FOR META-ANALYSIS
============================================================

Next steps:
1. Initialize a new project: uv run init_project.py --name <name>
2. Start analysis: Say "start" in Claude Code
```

---

## Dependency Lists

### Python Dependencies (pyproject.toml)

```toml
[project]
requires-python = ">=3.12"
dependencies = [
    "bibtexparser>=1.4.4",    # BibTeX parsing
    "biopython>=1.86",         # PubMed API
    "pandas>=3.0.0",           # Data frames
    "pdfplumber>=0.11.9",      # PDF extraction
    "pyyaml>=6.0.3",           # YAML parsing
    "requests>=2.32.5",        # HTTP requests
]
```

**To update**:
```bash
cd tooling/python
uv add <package>           # Add new package
uv sync                    # Sync dependencies
```

---

### R Dependencies (renv.lock)

#### Core Packages (Always Required)

```r
# Meta-analysis engines
meta          # Forest plots, heterogeneity, standard MA
metafor       # Effect sizes, random-effects models

# Data manipulation
dplyr         # Data wrangling
readr         # CSV reading
tidyr         # Data reshaping
stringr       # String manipulation

# Visualization
ggplot2       # Graphics
forestplot    # Forest plot utilities

# Tables
gtsummary     # Summary tables
gt            # Table formatting
flextable     # Word/HTML tables
```

#### Network Meta-Analysis Packages (Optional)

**Only needed if `analysis_type: nma` in PICO**

```r
# Bayesian NMA (Primary)
gemtc         # GeMTC Bayesian NMA
rjags         # JAGS interface
coda          # MCMC diagnostics

# Frequentist NMA (Sensitivity)
netmeta       # Frequentist NMA

# Utilities
dmetar        # Meta-analysis helpers
```

**To install later** (if needed):
```r
install.packages(c("gemtc", "rjags", "coda", "netmeta"))
renv::snapshot()
```

---

### System Libraries (Platform-Specific)

#### macOS Additional Libraries

```bash
# For PDF rendering (if using Quarto PDF)
brew install basictex
sudo tlmgr update --self
sudo tlmgr install collection-fontsrecommended

# For image processing (if using magick)
brew install imagemagick
```

#### Linux Additional Libraries

```bash
# For R package compilation
sudo apt install build-essential libcurl4-openssl-dev libssl-dev libxml2-dev

# For PDF rendering
sudo apt install texlive-latex-base texlive-fonts-recommended

# For image processing
sudo apt install libmagick++-dev
```

---

## Environment Variables

Create `.env` file in project root:

```bash
# API Keys (optional, for database searches)
PUBMED_EMAIL=your@email.com
SCOPUS_API_KEY=your_scopus_key_here
EMBASE_API_KEY=your_embase_key_here

# R environment
R_LIBS_USER=~/.local/R/library

# Python environment
PYTHONPATH=/Users/htlin/meta-pipe/tooling/python
```

**Security**: Add `.env` to `.gitignore` (already done)

---

## Reproducibility: renv Workflow

### For Project Maintainers

**When adding new R packages**:

```r
# In R console
install.packages("new_package")
renv::snapshot()  # Update renv.lock
```

**Commit `renv.lock`**:
```bash
git add renv.lock
git commit -m "Add new_package for X functionality"
```

---

### For New Users

**Restore exact package versions**:

```r
# In R console
renv::restore()  # Install packages from renv.lock
```

**Benefit**: Ensures identical package versions across all users

---

## Troubleshooting

### Problem: `uv: command not found`

**Solution**:
```bash
# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Add to PATH (if needed)
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

---

### Problem: JAGS not found (rjags fails)

**macOS**:
```bash
brew install jags

# If R still can't find JAGS
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
```

**Linux**:
```bash
sudo apt install jags pkg-config
```

**Test**:
```r
library(rjags)  # Should load without error
```

---

### Problem: Python package conflicts

**Solution**:
```bash
cd tooling/python

# Remove old environment
rm -rf .venv

# Recreate
uv venv
uv sync
```

---

### Problem: R packages won't install

**Check dependencies**:
```bash
# macOS
xcode-select --install

# Linux
sudo apt install build-essential libcurl4-openssl-dev libssl-dev
```

**In R**:
```r
# Clear package cache
renv::purge()

# Reinstall
renv::restore()
```

---

### Problem: `gemtc` installation fails

**Reason**: `gemtc` requires JAGS

**Solution**:
1. Install JAGS first (see Step 3.1)
2. Restart R
3. Try again:
   ```r
   install.packages("rjags")
   install.packages("gemtc")
   ```

---

## Platform-Specific Notes

### macOS M1/M2 (Apple Silicon)

**Rosetta not needed** - all packages have ARM64 builds

**R installation**:
```bash
# Use native ARM64 build
brew install r

# NOT Rosetta x86_64 version
```

**Verify architecture**:
```bash
R
# In R:
Sys.info()["machine"]  # Should show "arm64"
```

---

### Windows (WSL2)

**Recommended setup**:
1. Install WSL2: `wsl --install`
2. Install Ubuntu from Microsoft Store
3. Follow Linux instructions inside WSL

**Not recommended**: Native Windows R (path issues)

---

### Linux HPC / Server (No sudo)

**Python (user install)**:
```bash
# Install uv without sudo
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**R (user library)**:
```bash
# Set user library path
mkdir -p ~/R/library
export R_LIBS_USER=~/R/library
```

**JAGS (ask admin)**:
```bash
# Request admin to install
# Or build from source
```

---

## Automated Setup Scripts

### `setup.sh` (Full Automated Setup)

```bash
#!/bin/bash
# Automated environment setup

set -e

echo "🚀 Setting up meta-analysis pipeline environment..."

# Check Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 not found. Please install Python 3.12+"
    exit 1
fi

# Check uv
if ! command -v uv &> /dev/null; then
    echo "📦 Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# Setup Python environment
echo "🐍 Setting up Python environment..."
cd tooling/python
uv venv
uv sync
cd ../..

# Check R
if ! command -v R &> /dev/null; then
    echo "❌ R not found. Please install R 4.3+"
    exit 1
fi

# Setup R environment
echo "📊 Setting up R environment..."
Rscript -e "
if (!requireNamespace('renv', quietly = TRUE)) {
  install.packages('renv', repos='https://cloud.r-project.org')
}
renv::init()
"

echo "✅ Setup complete! Run 'bash verify_environment.sh' to verify."
```

---

### `verify_environment.sh` (Verification Script)

```bash
#!/bin/bash
# Verify environment setup

echo "============================================================"
echo "🔍 META-ANALYSIS PIPELINE ENVIRONMENT VERIFICATION"
echo "============================================================"
echo ""

# Check system tools
echo "System Dependencies:"
command -v python3 && echo "✅ Python installed" || echo "❌ Python missing"
command -v uv && echo "✅ uv installed" || echo "❌ uv missing"
command -v R && echo "✅ R installed" || echo "❌ R missing"
command -v jags && echo "✅ JAGS installed" || echo "⚠️  JAGS missing (needed for NMA)"
command -v git && echo "✅ Git installed" || echo "❌ Git missing"
echo ""

# Check Python packages
echo "Python Environment:"
cd tooling/python
if [ -d ".venv" ]; then
    echo "✅ Virtual environment exists"
    uv run python -c "import pandas" && echo "✅ pandas installed" || echo "❌ pandas missing"
    uv run python -c "import bibtexparser" && echo "✅ bibtexparser installed" || echo "❌ bibtexparser missing"
else
    echo "❌ Virtual environment missing"
fi
cd ../..
echo ""

# Check R packages
echo "R Environment:"
Rscript -e "
if (requireNamespace('renv', quietly=TRUE)) {
  cat('✅ renv installed\n')
  pkgs <- c('meta', 'metafor', 'ggplot2', 'gt')
  for (pkg in pkgs) {
    if (requireNamespace(pkg, quietly=TRUE)) {
      cat(paste0('✅ ', pkg, ' installed\n'))
    } else {
      cat(paste0('❌ ', pkg, ' missing\n'))
    }
  }
} else {
  cat('❌ renv not initialized\n')
}
"
echo ""

echo "============================================================"
echo "✅ VERIFICATION COMPLETE"
echo "============================================================"
```

---

## Next Steps After Setup

Once environment is ready:

1. **Initialize a project**:
   ```bash
   cd /Users/htlin/meta-pipe
   uv run tooling/python/init_project.py --name my-meta-analysis
   ```

2. **Start working**:
   - Open Claude Code
   - Say "start project my-meta-analysis"

3. **Check status anytime**:
   ```bash
   uv run smart_resume.py --project my-meta-analysis
   ```

---

## Maintenance

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

### Update system tools

```bash
# macOS
brew update && brew upgrade

# Linux
sudo apt update && sudo apt upgrade
```

---

## FAQ

### Q: Do I need all R packages upfront?

**A**: No. Core packages (`meta`, `metafor`) are required. NMA packages (`gemtc`, `netmeta`) only needed if `analysis_type: nma`.

### Q: Can I use conda instead of uv?

**A**: Yes, but `uv` is recommended (faster, simpler). If using conda:
```bash
conda env create -f environment.yml
```

### Q: Do I need RStudio?

**A**: No. R scripts can run from command line. RStudio is optional for interactive development.

### Q: What if I don't have sudo access?

**A**: See "Linux HPC / Server" section above for user-local installs.

---

**Created**: 2026-02-17
**Status**: ✅ Ready to use
**Maintainer**: Run `verify_environment.sh` after setup
