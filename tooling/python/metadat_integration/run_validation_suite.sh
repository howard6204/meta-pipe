#!/bin/bash
# Meta-pipe Workflow Validation Suite
# Tests the pipeline with benchmark datasets from R metadat package

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║       Meta-pipe Workflow Validation Suite                 ║"
echo "╔════════════════════════════════════════════════════════════╗"
echo ""

# Activate virtual environment
if [ ! -d "$ROOT_DIR/tooling/python/.venv" ]; then
    echo "⚠️  Virtual environment not found. Creating..."
    cd "$ROOT_DIR/tooling/python"
    uv venv
    source .venv/bin/activate
    uv pip install pandas
else
    source "$ROOT_DIR/tooling/python/.venv/bin/activate"
fi

# Test 1: BCG vaccine meta-analysis
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test 1: BCG Vaccine Meta-Analysis (13 RCTs)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Import dataset
echo "📥 Importing dat.bcg from metadat..."
python3 "$SCRIPT_DIR/import_metadat.py" \
    --dataset dat.bcg \
    --project validation-bcg

# Run analysis
echo ""
echo "📊 Running meta-analysis..."
Rscript "$ROOT_DIR/tooling/projects/validation-bcg/06_analysis/01_bcg_meta_analysis.R"

# Validate results
echo ""
echo "✅ Validating results..."
python3 "$SCRIPT_DIR/validate_pipeline.py" --project validation-bcg

BCG_PASSED=$?

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Summary
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                   VALIDATION SUMMARY                       ║"
echo "╔════════════════════════════════════════════════════════════╗"
echo ""

if [ $BCG_PASSED -eq 0 ]; then
    echo "✅ BCG Vaccine Test: PASSED"
else
    echo "❌ BCG Vaccine Test: FAILED"
fi

echo ""
echo "📊 Generated outputs:"
echo "   - Forest plot: $(pwd)/tooling/projects/validation-bcg/06_analysis/figures/forest_plot.png"
echo "   - Funnel plot: $(pwd)/tooling/projects/validation-bcg/06_analysis/figures/funnel_plot.png"
echo "   - Validation report: $(pwd)/tooling/projects/validation-bcg/06_analysis/results/validation_report.md"
echo ""

if [ $BCG_PASSED -eq 0 ]; then
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║  ✅ ALL TESTS PASSED - Workflow validated successfully!    ║"
    echo "╔════════════════════════════════════════════════════════════╗"
    exit 0
else
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║  ❌ SOME TESTS FAILED - Review validation reports          ║"
    echo "╔════════════════════════════════════════════════════════════╗"
    exit 1
fi
