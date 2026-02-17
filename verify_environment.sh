#!/bin/bash
# Verify meta-analysis pipeline environment

echo ""
echo "============================================================"
echo "🔍 META-ANALYSIS PIPELINE ENVIRONMENT VERIFICATION"
echo "============================================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check function
check_command() {
    if command -v "$1" &> /dev/null; then
        VERSION=$($2 2>&1 | head -n1 || echo "")
        echo -e "${GREEN}✅ $1${NC} - $VERSION"
        return 0
    else
        echo -e "${RED}❌ $1 not found${NC}"
        return 1
    fi
}

# System Dependencies
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "System Dependencies"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

SYSTEM_OK=true
check_command "python3" "python3 --version" || SYSTEM_OK=false
check_command "uv" "uv --version" || SYSTEM_OK=false
check_command "R" "R --version | head -n1" || SYSTEM_OK=false
check_command "git" "git --version" || SYSTEM_OK=false

# Optional tools
if check_command "jags" "jags -v 2>&1 | head -n1"; then
    true
else
    echo -e "${YELLOW}⚠️  JAGS not found (optional, needed for Network Meta-Analysis)${NC}"
fi

if check_command "quarto" "quarto --version"; then
    true
else
    echo -e "${YELLOW}⚠️  Quarto not found (optional, for manuscript rendering)${NC}"
fi

echo ""

# Python Environment
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Python Environment"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

PYTHON_OK=true
cd tooling/python

if [ -d ".venv" ]; then
    echo -e "${GREEN}✅ Virtual environment exists${NC}"

    # Check each package
    PACKAGES=("bibtexparser" "biopython" "pandas" "pdfplumber" "pyyaml" "requests")
    for pkg in "${PACKAGES[@]}"; do
        if uv run python -c "import $pkg" &> /dev/null; then
            VERSION=$(uv run python -c "import $pkg; print($pkg.__version__)" 2>/dev/null || echo "installed")
            echo -e "${GREEN}✅ $pkg${NC} - $VERSION"
        else
            echo -e "${RED}❌ $pkg not installed${NC}"
            PYTHON_OK=false
        fi
    done
else
    echo -e "${RED}❌ Virtual environment not found${NC}"
    echo "   Run: uv venv && uv sync"
    PYTHON_OK=false
fi

cd ../..
echo ""

# R Environment
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "R Environment"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

R_OK=true
if command -v R &> /dev/null; then
    # Check renv
    if Rscript -e "library(renv)" &> /dev/null; then
        echo -e "${GREEN}✅ renv initialized${NC}"

        # Check core packages
        R_PACKAGES=("meta" "metafor" "ggplot2" "dplyr" "gt")
        for pkg in "${R_PACKAGES[@]}"; do
            if Rscript -e "library($pkg)" &> /dev/null; then
                VERSION=$(Rscript -e "cat(as.character(packageVersion('$pkg')))" 2>/dev/null || echo "installed")
                echo -e "${GREEN}✅ $pkg${NC} - $VERSION"
            else
                echo -e "${RED}❌ $pkg not installed${NC}"
                R_OK=false
            fi
        done

        # Check NMA packages (optional)
        echo ""
        echo "Network Meta-Analysis packages (optional):"
        NMA_PACKAGES=("gemtc" "rjags" "netmeta")
        for pkg in "${NMA_PACKAGES[@]}"; do
            if Rscript -e "library($pkg)" &> /dev/null; then
                VERSION=$(Rscript -e "cat(as.character(packageVersion('$pkg')))" 2>/dev/null || echo "installed")
                echo -e "${GREEN}✅ $pkg${NC} - $VERSION"
            else
                echo -e "${YELLOW}⚠️  $pkg not installed (install if needed for NMA)${NC}"
            fi
        done
    else
        echo -e "${RED}❌ renv not initialized${NC}"
        echo "   Run: Rscript -e \"install.packages('renv'); renv::init()\""
        R_OK=false
    fi
else
    echo -e "${RED}❌ R not installed${NC}"
    R_OK=false
fi

echo ""

# JAGS Configuration (if installed)
if command -v jags &> /dev/null && command -v R &> /dev/null; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "JAGS Configuration"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    echo -e "${GREEN}✅ JAGS executable found${NC}"

    if Rscript -e "library(rjags)" &> /dev/null; then
        echo -e "${GREEN}✅ rjags can load JAGS modules${NC}"
    else
        echo -e "${YELLOW}⚠️  rjags cannot connect to JAGS${NC}"
        echo "   Try: export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig"
    fi
    echo ""
fi

# Project Structure
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Project Structure"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

STRUCTURE_OK=true
[ -d "tooling/python" ] && echo -e "${GREEN}✅ tooling/python/ exists${NC}" || { echo -e "${RED}❌ tooling/python/ missing${NC}"; STRUCTURE_OK=false; }
[ -d "ma-meta-analysis/assets/r" ] && echo -e "${GREEN}✅ ma-meta-analysis/assets/r/ exists${NC}" || { echo -e "${RED}❌ ma-meta-analysis/assets/r/ missing${NC}"; STRUCTURE_OK=false; }
[ -d "projects" ] && echo -e "${GREEN}✅ projects/ directory exists${NC}" || { echo -e "${RED}❌ projects/ directory missing${NC}"; STRUCTURE_OK=false; }

echo ""

# Final Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ "$SYSTEM_OK" = true ] && [ "$PYTHON_OK" = true ] && [ "$R_OK" = true ] && [ "$STRUCTURE_OK" = true ]; then
    echo -e "${GREEN}✅ ENVIRONMENT READY FOR META-ANALYSIS${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Initialize a new project:"
    echo "   uv run tooling/python/init_project.py --name <project-name>"
    echo ""
    echo "2. Start working:"
    echo "   Open Claude Code and say 'start'"
else
    echo -e "${RED}❌ ENVIRONMENT SETUP INCOMPLETE${NC}"
    echo ""
    echo "Issues found:"
    [ "$SYSTEM_OK" = false ] && echo "  - System dependencies missing (run: bash setup.sh)"
    [ "$PYTHON_OK" = false ] && echo "  - Python environment incomplete (run: cd tooling/python && uv sync)"
    [ "$R_OK" = false ] && echo "  - R environment incomplete (run R setup from ENVIRONMENT_SETUP.md)"
    [ "$STRUCTURE_OK" = false ] && echo "  - Project structure incomplete (check git clone)"
    echo ""
    echo "See ENVIRONMENT_SETUP.md for detailed instructions"
fi

echo ""
echo "============================================================"
