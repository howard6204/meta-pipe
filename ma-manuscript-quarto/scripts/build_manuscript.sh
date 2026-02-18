#!/usr/bin/env bash
# build_manuscript.sh — Validate, lint, and render any project's manuscript.
# Generalized tool: lives in ma-manuscript-quarto/scripts/, works for any project.
#
# Usage:
#   bash ma-manuscript-quarto/scripts/build_manuscript.sh --project <name> [options]
#
# Options:
#   --project <name>  Project directory name under projects/ (REQUIRED)
#   --fix             Auto-fix lint issues (trailing whitespace, blank lines, etc.)
#   --render          Render to DOCX/HTML/PDF via Quarto
#   --verify-doi      Verify DOIs via Crossref API (slow, ~1s per entry)
#   --patch-doi       Verify + auto-patch missing DOIs (confidence >= 85%)
#   --all             Run everything (fix + render + verify-doi)
#   --formats <list>  Comma-separated render formats (default: docx,html,pdf)
#   (no options)      Validation + lint only (fast, no rendering)
#
# Examples:
#   bash ma-manuscript-quarto/scripts/build_manuscript.sh --project hrd-parp-inhibitors
#   bash ma-manuscript-quarto/scripts/build_manuscript.sh --project ici-breast-cancer --all
#   bash ma-manuscript-quarto/scripts/build_manuscript.sh --project hrd-parp-inhibitors --render --formats docx

set -euo pipefail

# Resolve repo root (this script lives in ma-manuscript-quarto/scripts/)
REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

# -------------------------------------------------------------------
# Parse arguments
# -------------------------------------------------------------------
PROJECT_NAME=""
DO_FIX=false
DO_RENDER=false
DO_VERIFY_DOI=false
DO_PATCH_DOI=false
FORMATS="docx,html,pdf"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)    PROJECT_NAME="$2"; shift 2 ;;
    --fix)        DO_FIX=true; shift ;;
    --render)     DO_RENDER=true; shift ;;
    --verify-doi) DO_VERIFY_DOI=true; shift ;;
    --patch-doi)  DO_VERIFY_DOI=true; DO_PATCH_DOI=true; shift ;;
    --all)        DO_FIX=true; DO_RENDER=true; DO_VERIFY_DOI=true; shift ;;
    --formats)    FORMATS="$2"; shift 2 ;;
    -h|--help)
      sed -n '2,/^$/p' "$0" | sed 's/^# \?//'
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      echo "Usage: $0 --project <name> [--fix] [--render] [--all] [--formats <list>]" >&2
      exit 1
      ;;
  esac
done

if [ -z "$PROJECT_NAME" ]; then
  echo "Error: --project <name> is required" >&2
  echo "Usage: $0 --project <name> [--fix] [--render] [--all]" >&2
  echo "" >&2
  echo "Available projects:" >&2
  for d in "$REPO_ROOT"/projects/*/07_manuscript; do
    [ -d "$d" ] && echo "  --project $(basename "$(dirname "$d")")" >&2
  done
  exit 1
fi

# Derive paths
PROJECT_ROOT="$REPO_ROOT/projects/$PROJECT_NAME"
ANALYSIS_DIR="$PROJECT_ROOT/06_analysis"
MS_DIR="$PROJECT_ROOT/07_manuscript"

if [ ! -d "$MS_DIR" ]; then
  echo "Error: Manuscript directory not found: $MS_DIR" >&2
  exit 1
fi

# -------------------------------------------------------------------
# Colors and helpers
# -------------------------------------------------------------------
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

ok()   { printf "${GREEN}✓${NC} %s\n" "$1"; }
warn() { printf "${YELLOW}⚠${NC} %s\n" "$1"; }
fail() { printf "${RED}✗${NC} %s\n" "$1"; }
info() { printf "${CYAN}→${NC} %s\n" "$1"; }

echo "============================================"
printf "  ${BOLD}Manuscript Build & Validation Report${NC}\n"
echo "  Project: $PROJECT_NAME"
echo "  $(date '+%Y-%m-%d %H:%M')"
echo "============================================"
echo ""

ERRORS=0

# -------------------------------------------------------------------
# 1. Sync figures/tables from 06_analysis
# -------------------------------------------------------------------
info "Step 1: Syncing figures and tables from 06_analysis"

mkdir -p "$MS_DIR/figures" "$MS_DIR/tables"

fig_count=0
if [ -d "$ANALYSIS_DIR/figures" ]; then
  shopt -s nullglob
  for f in "$ANALYSIS_DIR/figures"/*.png; do
    command cp -f "$f" "$MS_DIR/figures/" && fig_count=$((fig_count+1))
  done
  shopt -u nullglob
fi
# Also copy subgroup figures
if [ -d "$ANALYSIS_DIR/figures/subgroups" ]; then
  mkdir -p "$MS_DIR/figures/subgroups"
  shopt -s nullglob
  for f in "$ANALYSIS_DIR/figures/subgroups"/*.png; do
    command cp -f "$f" "$MS_DIR/figures/subgroups/" && fig_count=$((fig_count+1))
  done
  shopt -u nullglob
fi

tbl_count=0
if [ -d "$ANALYSIS_DIR/tables" ]; then
  shopt -s nullglob
  for f in "$ANALYSIS_DIR/tables"/*.png "$ANALYSIS_DIR/tables"/*.csv; do
    command cp -f "$f" "$MS_DIR/tables/" && tbl_count=$((tbl_count+1))
  done
  shopt -u nullglob
fi
if [ -d "$ANALYSIS_DIR/tables/subgroups" ]; then
  mkdir -p "$MS_DIR/tables/subgroups"
  shopt -s nullglob
  for f in "$ANALYSIS_DIR/tables/subgroups"/*.csv; do
    command cp -f "$f" "$MS_DIR/tables/subgroups/" && tbl_count=$((tbl_count+1))
  done
  shopt -u nullglob
fi

ok "Synced $fig_count figures, $tbl_count table files"
echo ""

# -------------------------------------------------------------------
# 2. Citation coverage check
# -------------------------------------------------------------------
info "Step 2: Citation coverage"

# Extract all [@key] from QMD files (macOS-compatible)
# Grab full [...] citation blocks, then extract individual @keys
cite_keys_in_qmd=$(grep -oh '\[@[^]]*\]' "$MS_DIR"/*.qmd 2>/dev/null \
  | tr ';' '\n' | sed 's/.*@//' | sed 's/[]\[,; ]//g' | grep -v '^$' | sort -u || true)
cite_count_qmd=$(echo "$cite_keys_in_qmd" | grep -c . || true)

# Extract all bib entry keys (macOS-compatible)
bib_keys=""
if [ -f "$MS_DIR/references.bib" ]; then
  bib_keys=$(grep '^@' "$MS_DIR/references.bib" | sed 's/^@[a-zA-Z]*{//' | sed 's/,.*//' | grep -v '^$' | sort -u)
fi
bib_count=$(echo "$bib_keys" | grep -c . || true)

echo "  QMD files use $cite_count_qmd unique citation keys"
echo "  references.bib has $bib_count entries"
echo ""

# Check for missing bib entries (cited but not in bib)
missing_in_bib=""
if [ -n "$cite_keys_in_qmd" ]; then
  for key in $cite_keys_in_qmd; do
    if ! echo "$bib_keys" | grep -qw "$key"; then
      missing_in_bib="$missing_in_bib $key"
    fi
  done
fi

if [ -n "$missing_in_bib" ]; then
  fail "Citations used in QMD but MISSING from references.bib:"
  for key in $missing_in_bib; do
    echo "    - @$key"
  done
  ERRORS=$((ERRORS+1))
else
  ok "All cited keys found in references.bib"
fi

# Check for unused bib entries (in bib but not cited)
unused_bib=""
if [ -n "$bib_keys" ]; then
  for key in $bib_keys; do
    if [ -z "$cite_keys_in_qmd" ] || ! echo "$cite_keys_in_qmd" | grep -qw "$key"; then
      unused_bib="$unused_bib $key"
    fi
  done
fi

if [ -n "$unused_bib" ]; then
  unused_count=$(echo "$unused_bib" | wc -w | tr -d ' ')
  warn "$unused_count bib entries not cited in any QMD file:"
  for key in $unused_bib; do
    echo "    - @$key"
  done
else
  ok "All bib entries are cited"
fi
echo ""

# -------------------------------------------------------------------
# 3. Per-section word count
# -------------------------------------------------------------------
info "Step 3: Word counts"

printf "  %-20s %6s  %s\n" "Section" "Words" "Target"
printf "  %-20s %6s  %s\n" "-------" "-----" "------"

count_words() {
  local file="$1"
  if [ -f "$file" ]; then
    # Strip markdown formatting, count words
    sed 's/\[@[^]]*\]//g; s/#//g; s/\*//g; s/---//g; s/^>.*//g' "$file" \
      | grep -v '^\*\*Word Count\*\*' \
      | grep -v '^## Cross-References' \
      | grep -v '^## Supplementary' \
      | grep -v '^- \*\*' \
      | wc -w | tr -d ' '
  else
    echo "0"
  fi
}

# Standard IMRaD sections — auto-detect which exist
sections=(
  "00_abstract.qmd:Abstract:250"
  "01_introduction.qmd:Introduction:600-700"
  "02_methods.qmd:Methods:800-900"
  "03_results.qmd:Results:1000-1200"
  "04_discussion.qmd:Discussion:1000-1200"
  "05_conclusion.qmd:Conclusion:100-120"
)

total_words=0
for entry in "${sections[@]}"; do
  IFS=':' read -r file name target <<< "$entry"
  if [ -f "$MS_DIR/$file" ]; then
    wc=$(count_words "$MS_DIR/$file")
    total_words=$((total_words + wc))
    printf "  %-20s %6d  %s\n" "$name" "$wc" "$target"
  fi
done

echo ""
printf "  %-20s %6d  %s\n" "TOTAL" "$total_words" "~4000"
echo ""

# -------------------------------------------------------------------
# 4. QMD Lint
# -------------------------------------------------------------------
info "Step 4: QMD lint check"

LINT_SCRIPT="$REPO_ROOT/ma-manuscript-quarto/scripts/lint_qmd.py"
if [ -f "$LINT_SCRIPT" ]; then
  lint_flags="--dir $MS_DIR"
  if $DO_FIX; then
    lint_flags="$lint_flags --fix"
    info "Auto-fixing lint issues..."
  fi
  # Run lint, capture output and exit code
  set +e
  lint_output=$(cd "$REPO_ROOT" && uv run "$LINT_SCRIPT" $lint_flags 2>&1)
  lint_rc=$?
  set -e

  echo "$lint_output"
  if [ $lint_rc -eq 0 ]; then
    ok "Lint: all clean"
  elif [ $lint_rc -eq 1 ]; then
    warn "Lint: warnings found (non-blocking)"
  else
    warn "Lint: errors found (check for include-file false positives)"
  fi
else
  warn "lint_qmd.py not found at $LINT_SCRIPT, skipping"
fi
echo ""

# -------------------------------------------------------------------
# 5. DOI verification
# -------------------------------------------------------------------
info "Step 5: DOI coverage check"

DOI_SCRIPT="$REPO_ROOT/ma-manuscript-quarto/scripts/verify_doi.py"
QA_DIR="$PROJECT_ROOT/09_qa"

if [ -f "$MS_DIR/references.bib" ] && [ "$bib_count" -gt 0 ]; then
  # Always show quick local count
  doi_count=$(grep -ci '^\s*doi\s*=' "$MS_DIR/references.bib" || true)
  echo "  $doi_count / $bib_count bib entries have DOI fields (local count)"

  if $DO_VERIFY_DOI && [ -f "$DOI_SCRIPT" ]; then
    # Full Crossref verification
    mkdir -p "$QA_DIR"
    doi_flags="--bib $MS_DIR/references.bib --out $QA_DIR/doi_verification_report.md"
    if $DO_PATCH_DOI; then
      doi_flags="$doi_flags --patch --min-confidence 85"
      info "Verifying DOIs via Crossref + auto-patching (>=85% confidence)..."
    else
      info "Verifying DOIs via Crossref API (~1s per entry)..."
    fi

    set +e
    doi_output=$(cd "$REPO_ROOT" && uv run "$DOI_SCRIPT" $doi_flags 2>&1)
    doi_rc=$?
    set -e

    echo "$doi_output"
    echo ""
    if [ $doi_rc -eq 0 ]; then
      ok "DOI verification passed (>=90% coverage, all DOIs valid)"
    elif [ $doi_rc -eq 1 ]; then
      warn "DOI coverage below 90% — run with --patch-doi to auto-fix"
    else
      fail "Invalid DOIs found — check $QA_DIR/doi_verification_report.md"
      ERRORS=$((ERRORS+1))
    fi
    echo "  Report: $QA_DIR/doi_verification_report.md"
  else
    # Quick local check only
    pct=$((doi_count * 100 / bib_count))
    if [ "$pct" -ge 90 ]; then
      ok "DOI coverage: ${pct}% (local count, target: >=90%)"
    else
      warn "DOI coverage: ${pct}% (local count, target: >=90%)"
    fi
    if ! $DO_VERIFY_DOI; then
      echo "  Tip: use --verify-doi to check DOIs against Crossref API"
      echo "  Tip: use --patch-doi to auto-find and patch missing DOIs"
    fi
  fi
else
  warn "references.bib not found or empty"
fi
echo ""

# -------------------------------------------------------------------
# 6. Figure/table file checks
# -------------------------------------------------------------------
info "Step 6: Figure and table file check"

check_file() {
  local path="$1"
  local label="$2"
  if [ -f "$MS_DIR/$path" ]; then
    ok "$label: $path"
  else
    fail "$label: $path NOT FOUND"
    ERRORS=$((ERRORS+1))
  fi
}

# Check figures referenced in figures.qmd
if [ -f "$MS_DIR/figures.qmd" ]; then
  fig_refs=$(grep -o '(figures/[^)]*' "$MS_DIR/figures.qmd" | sed 's/^(//' || true)
  for ref in $fig_refs; do
    check_file "$ref" "Figure"
  done
fi

# Check table files referenced in tables.qmd
if [ -f "$MS_DIR/tables.qmd" ]; then
  tbl_refs=$(grep -o '(tables/[^)]*' "$MS_DIR/tables.qmd" | sed 's/^(//' || true)
  for ref in $tbl_refs; do
    check_file "$ref" "Table"
  done
fi
echo ""

# -------------------------------------------------------------------
# 7. Quarto render (only with --render or --all)
# -------------------------------------------------------------------
if $DO_RENDER; then
  info "Step 7: Quarto render"

  IFS=',' read -ra fmt_list <<< "$FORMATS"
  for fmt in "${fmt_list[@]}"; do
    fmt=$(echo "$fmt" | tr -d ' ')
    set +e
    render_output=$(cd "$MS_DIR" && quarto render index.qmd --to "$fmt" 2>&1)
    render_rc=$?
    set -e

    if [ $render_rc -eq 0 ]; then
      ok "Rendered $fmt"
    else
      if [ "$fmt" = "pdf" ]; then
        warn "PDF render failed (SVG conversion issue — use DOCX for submission)"
      else
        fail "Render $fmt failed"
        echo "$render_output" | tail -10
        ERRORS=$((ERRORS+1))
      fi
    fi
  done

  # List output files
  echo ""
  echo "  Output files:"
  shopt -s nullglob
  for f in "$MS_DIR"/_manuscript/index.* "$MS_DIR"/_manuscript/*.docx "$MS_DIR"/_manuscript/*.html "$MS_DIR"/_manuscript/*.pdf; do
    [ -f "$f" ] && echo "    $(basename "$f") ($(du -h "$f" | cut -f1 | tr -d ' '))"
  done
  shopt -u nullglob
  echo ""
else
  info "Step 7: Quarto render — SKIPPED (use --render or --all)"
  echo ""
fi

# -------------------------------------------------------------------
# Summary
# -------------------------------------------------------------------
echo "============================================"
if [ $ERRORS -eq 0 ]; then
  printf "${GREEN}  ALL CHECKS PASSED${NC}  (%s)\n" "$PROJECT_NAME"
else
  printf "${RED}  %d ERROR(S) FOUND${NC}  (%s)\n" "$ERRORS" "$PROJECT_NAME"
fi
echo "============================================"
echo ""
echo "Usage:"
echo "  bash ma-manuscript-quarto/scripts/build_manuscript.sh --project $PROJECT_NAME"
echo "  bash ma-manuscript-quarto/scripts/build_manuscript.sh --project $PROJECT_NAME --render"
echo "  bash ma-manuscript-quarto/scripts/build_manuscript.sh --project $PROJECT_NAME --verify-doi"
echo "  bash ma-manuscript-quarto/scripts/build_manuscript.sh --project $PROJECT_NAME --patch-doi"
echo "  bash ma-manuscript-quarto/scripts/build_manuscript.sh --project $PROJECT_NAME --all"
echo ""

exit $ERRORS
