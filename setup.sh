#!/bin/bash
# Automated environment setup for meta-analysis pipeline

set -e  # Exit on error

echo ""
echo "============================================================"
echo "🚀 META-ANALYSIS PIPELINE ENVIRONMENT SETUP"
echo "============================================================"
echo ""

# Detect OS
OS="$(uname -s)"
case "${OS}" in
    Darwin*)    PLATFORM="macOS";;
    Linux*)     PLATFORM="Linux";;
    MINGW*|MSYS*|CYGWIN*) PLATFORM="Windows";;
    *)          PLATFORM="Unknown";;
esac

echo "📍 Detected platform: ${PLATFORM}"
echo ""

# Step 1: Check Python
echo "Step 1/5: Checking Python..."
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 not found."
    echo "   Please install Python 3.12+ from https://python.org"
    echo "   Then run this script again."
    exit 1
else
    PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
    echo "✅ Python ${PYTHON_VERSION} found"
fi
echo ""

# Step 2: Check/Install uv
echo "Step 2/5: Checking uv (Python package manager)..."
if ! command -v uv &> /dev/null; then
    echo "📦 Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh

    # Add to PATH for current session
    export PATH="$HOME/.cargo/bin:$PATH"

    if command -v uv &> /dev/null; then
        echo "✅ uv installed successfully"
    else
        echo "⚠️  uv installed, but not in PATH yet"
        echo "   Please restart your terminal or run:"
        echo "   export PATH=\"\$HOME/.cargo/bin:\$PATH\""
    fi
else
    UV_VERSION=$(uv --version | cut -d' ' -f2)
    echo "✅ uv ${UV_VERSION} found"
fi
echo ""

# Step 3: Setup Python environment
echo "Step 3/5: Setting up Python environment..."
cd tooling/python

if [ -d ".venv" ]; then
    echo "✅ Virtual environment already exists"
else
    echo "📦 Creating virtual environment..."
    uv venv
fi

echo "📦 Installing Python dependencies..."
uv sync

echo "✅ Python environment ready"
cd ../..
echo ""

# Step 3b: Check cmake (required for R packages like 'fs' on macOS ARM)
echo "Checking cmake (needed for R package compilation)..."
if ! command -v cmake &> /dev/null; then
    echo "⚠️  cmake not found."
    if [ "${PLATFORM}" = "macOS" ]; then
        echo "   Install with: brew install cmake"
    elif [ "${PLATFORM}" = "Linux" ]; then
        echo "   Install with: sudo apt install cmake"
    fi
    echo "   cmake is required for building R packages like 'fs' on macOS ARM."
    echo "   Please install cmake and run this script again."
    exit 1
else
    CMAKE_VERSION=$(cmake --version | head -n1)
    echo "✅ ${CMAKE_VERSION}"
fi
echo ""

# Step 4: Check R
echo "Step 4/5: Checking R..."
if ! command -v R &> /dev/null; then
    echo "❌ R not found."
    echo ""
    if [ "${PLATFORM}" = "macOS" ]; then
        echo "   Install with: brew install r"
    elif [ "${PLATFORM}" = "Linux" ]; then
        echo "   Install with: sudo apt install r-base"
    fi
    echo "   Or download from: https://r-project.org"
    echo ""
    echo "⚠️  Skipping R setup. You can run this script again after installing R."
    R_INSTALLED=false
else
    R_VERSION=$(R --version | head -n1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
    echo "✅ R ${R_VERSION} found"
    R_INSTALLED=true
fi
echo ""

# Step 5: Setup R environment
if [ "${R_INSTALLED}" = true ]; then
    echo "Step 5/5: Setting up R environment..."

    # Check if renv.lock exists
    if [ -f "renv.lock" ]; then
        echo "✅ renv.lock found, restoring packages..."
        Rscript -e "
        if (!requireNamespace('renv', quietly = TRUE)) {
          install.packages('renv', repos='https://cloud.r-project.org')
        }
        renv::restore()
        "
    else
        echo "📦 Initializing renv and installing core packages..."
        Rscript -e "
        # Install renv
        if (!requireNamespace('renv', quietly = TRUE)) {
          install.packages('renv', repos='https://cloud.r-project.org')
        }

        # Initialize renv
        renv::init()

        # Install core meta-analysis packages
        packages <- c(
          'dplyr', 'readr', 'tidyr', 'stringr',
          'meta', 'metafor',
          'ggplot2', 'forestplot',
          'gtsummary', 'gt', 'flextable'
        )

        install.packages(packages, repos='https://cloud.r-project.org')

        # Create snapshot
        renv::snapshot()

        cat('\n✅ R environment initialized\n')
        "
    fi
    echo "✅ R environment ready"
else
    echo "Step 5/5: Skipped (R not installed)"
fi
echo ""

# Final check
echo "============================================================"
echo "🔍 VERIFICATION"
echo "============================================================"
echo ""

# Python check
cd tooling/python
if uv run python -c "import pandas, bibtexparser, pdfplumber" &> /dev/null; then
    echo "✅ Python environment: OK"
else
    echo "⚠️  Python environment: Some packages missing"
fi
cd ../..

# R check
if [ "${R_INSTALLED}" = true ]; then
    if Rscript -e "library(meta); library(metafor)" &> /dev/null; then
        echo "✅ R environment: OK"
    else
        echo "⚠️  R environment: Some packages missing"
    fi
fi

echo ""
echo "============================================================"
echo "✅ SETUP COMPLETE!"
echo "============================================================"
echo ""
echo "Next steps:"
echo ""
echo "1. Verify installation:"
echo "   bash verify_environment.sh"
echo ""
echo "2. Initialize a new project:"
echo "   uv run tooling/python/init_project.py --name <project-name>"
echo ""
echo "3. Start working:"
echo "   Open Claude Code and say 'start'"
echo ""

# Check for optional tools
echo "Optional tools (recommended):"
if ! command -v jags &> /dev/null; then
    echo "   ⬜ JAGS (for Network Meta-Analysis)"
    if [ "${PLATFORM}" = "macOS" ]; then
        echo "      Install: brew install jags"
    elif [ "${PLATFORM}" = "Linux" ]; then
        echo "      Install: sudo apt install jags"
    fi
fi

if ! command -v quarto &> /dev/null; then
    echo "   ⬜ Quarto (for manuscript rendering)"
    echo "      Download: https://quarto.org"
fi

echo ""
