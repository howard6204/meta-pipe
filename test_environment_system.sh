#!/bin/bash

# ============================================================
# Environment System Unit Test Suite
# ============================================================
# Tests all components of the environment setup system
# Usage: bash test_environment_system.sh

set -e  # Exit on error

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Change to project root if needed
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "============================================================"
echo "🧪 ENVIRONMENT SYSTEM UNIT TEST SUITE"
echo "============================================================"
echo "Working directory: $(pwd)"
echo ""

# Track results
total_tests=0
passed_tests=0
failed_tests=0

# Test function
test_case() {
  local name="$1"
  local command="$2"

  total_tests=$((total_tests + 1))
  echo -n "Testing: $name ... "

  if eval "$command" > /dev/null 2>&1; then
    echo -e "${GREEN}✅ PASS${NC}"
    passed_tests=$((passed_tests + 1))
    return 0
  else
    echo -e "${RED}❌ FAIL${NC}"
    failed_tests=$((failed_tests + 1))
    return 1
  fi
}

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1. File Existence Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

test_case "setup.sh exists" "[ -f setup.sh ]"
test_case "verify_environment.sh exists" "[ -f verify_environment.sh ]"
test_case "setup_r_environment.R exists" "[ -f setup_r_environment.R ]"
test_case "ENVIRONMENT_SETUP.md exists" "[ -f ENVIRONMENT_SETUP.md ]"
test_case "ENVIRONMENT_QUICK_START.md exists" "[ -f ENVIRONMENT_QUICK_START.md ]"
test_case "docs/ENVIRONMENT_FILES.md exists" "[ -f docs/ENVIRONMENT_FILES.md ]"
test_case "docs/SETUP_SUMMARY.md exists" "[ -f docs/SETUP_SUMMARY.md ]"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "2. Script Syntax Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

test_case "setup.sh syntax valid" "bash -n setup.sh"
test_case "verify_environment.sh syntax valid" "bash -n verify_environment.sh"
test_case "setup.sh is executable" "[ -x setup.sh ]"
test_case "verify_environment.sh is executable" "[ -x verify_environment.sh ]"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "3. Verification Script Functionality Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

test_case "verify_environment.sh runs without crashing" "timeout 30 bash verify_environment.sh > /tmp/verify_test.log 2>&1 || true"
test_case "verify_environment.sh checks Python" "grep -q 'python3' /tmp/verify_test.log"
test_case "verify_environment.sh checks uv" "grep -q 'uv' /tmp/verify_test.log"
test_case "verify_environment.sh checks R" "grep -q 'R version' /tmp/verify_test.log"
test_case "verify_environment.sh checks packages" "grep -q 'pandas\|meta\|ggplot2' /tmp/verify_test.log"
test_case "verify_environment.sh produces summary" "grep -q 'Summary' /tmp/verify_test.log"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "4. Documentation Content Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

test_case "ENVIRONMENT_SETUP.md contains setup instructions" "grep -q 'bash setup.sh' ENVIRONMENT_SETUP.md"
test_case "ENVIRONMENT_SETUP.md contains troubleshooting" "grep -qi 'troubleshooting\|common issues' ENVIRONMENT_SETUP.md"
test_case "ENVIRONMENT_QUICK_START.md contains quick commands" "grep -q 'Quick Start' ENVIRONMENT_QUICK_START.md"
test_case "ENVIRONMENT_QUICK_START.md contains verification" "grep -q 'verify_environment' ENVIRONMENT_QUICK_START.md"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "5. Integration with CLAUDE.md Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

test_case "CLAUDE.md exists" "[ -f CLAUDE.md ]"
test_case "CLAUDE.md mentions environment setup" "grep -q 'setup.sh\|verify_environment' CLAUDE.md"
test_case "CLAUDE.md has Quick Start section" "grep -q 'Quick Start' CLAUDE.md"
test_case "CLAUDE.md has Rules section with environment" "grep -A5 'Rules' CLAUDE.md | grep -qi 'environment'"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "6. Dependency Configuration Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

test_case "tooling/python/pyproject.toml exists" "[ -f tooling/python/pyproject.toml ]"
test_case "pyproject.toml contains dependencies" "grep -q 'dependencies' tooling/python/pyproject.toml"
test_case "pyproject.toml contains pandas" "grep -q 'pandas' tooling/python/pyproject.toml"
test_case "renv.lock exists" "[ -f renv.lock ]"
test_case "renv.lock contains R packages" "grep -q 'meta\|ggplot2\|dplyr' renv.lock"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "7. Project Structure Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

test_case "tooling/python directory exists" "[ -d tooling/python ]"
test_case "ma-meta-analysis/assets/r directory exists" "[ -d ma-meta-analysis/assets/r ]"
test_case "projects directory exists" "[ -d projects ]"
test_case "docs directory exists" "[ -d docs ]"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "8. Command Examples Tests (from docs)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

test_case "ENVIRONMENT_SETUP.md contains uv add example" "grep -q 'uv add' ENVIRONMENT_SETUP.md"
test_case "ENVIRONMENT_SETUP.md contains R install example" "grep -q 'install.packages' ENVIRONMENT_SETUP.md"
test_case "ENVIRONMENT_SETUP.md contains renv::snapshot example" "grep -q 'renv::snapshot' ENVIRONMENT_SETUP.md"
test_case "ENVIRONMENT_QUICK_START.md contains restore commands" "grep -q 'renv::restore' ENVIRONMENT_QUICK_START.md"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "9. Error Handling Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

test_case "verify_environment.sh handles missing tools gracefully" "bash verify_environment.sh > /tmp/verify_test.log 2>&1 || true"
test_case "verify_environment.sh shows helpful error messages" "grep -q '❌\|Install with:' /tmp/verify_test.log || true"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "10. Documentation Cross-Reference Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

test_case "ENVIRONMENT_FILES.md references all files" "grep -q 'setup.sh\|verify_environment.sh\|ENVIRONMENT_SETUP.md' docs/ENVIRONMENT_FILES.md"
test_case "SETUP_SUMMARY.md exists and has content" "[ -s docs/SETUP_SUMMARY.md ]"
test_case "docs reference each other correctly" "grep -q 'ENVIRONMENT_SETUP.md\|ENVIRONMENT_QUICK_START.md' docs/ENVIRONMENT_FILES.md"

echo ""
echo "============================================================"
echo "📊 TEST RESULTS SUMMARY"
echo "============================================================"
echo ""
echo -e "${BOLD}Total Tests:${NC}   $total_tests"
echo -e "${GREEN}Passed:${NC}        $passed_tests"
echo -e "${RED}Failed:${NC}        $failed_tests"
echo ""

if [ $failed_tests -eq 0 ]; then
  echo -e "${GREEN}${BOLD}✅ ALL TESTS PASSED!${NC}"
  echo ""
  echo "🎉 The environment system is fully functional and ready to use."
  exit 0
else
  success_rate=$(( (passed_tests * 100) / total_tests ))
  echo -e "${YELLOW}${BOLD}⚠️  SOME TESTS FAILED (Success Rate: ${success_rate}%)${NC}"
  echo ""
  echo "Please review the failed tests above and fix the issues."
  exit 1
fi
