#!/usr/bin/env bash
# Quick test suite for typewriter - uses xxxfast for all tests
set -euo pipefail

# Color output
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[0;33m'
NC=$'\033[0m'

echo "Quick Typewriter Test Suite"
echo "=========================="
echo

PASS=0
FAIL=0

# Test helper
test_cmd() {
  local name="$1"
  local cmd="$2"
  local expected="$3"

  printf "%-50s" "$name"
  result=$(eval "$cmd" 2>&1) || true

  if [[ "$result" == *"$expected"* ]]; then
    echo "${GREEN}✓${NC}"
    ((PASS++))
  else
    echo "${RED}✗${NC}"
    echo "  Expected: '$expected'"
    echo "  Got:      '$result'"
    ((FAIL++))
  fi
}

echo "1. Basic Tests"
echo "--------------"
test_cmd "Version check" "./typewriter -V" "typewriter 1.0.10"
test_cmd "Basic output" "./typewriter -s xxxfast 'Hello'" "Hello"
test_cmd "Help option" "./typewriter -h | head -1" "Typewriter-style output"
echo

echo "2. Speed Tests"
echo "--------------"
test_cmd "xxxfast speed" "./typewriter -s xxxfast 'Fast'" "Fast"
test_cmd "slow speed exists" "./typewriter -s slow 'X' | head -c1" "X"
test_cmd "Invalid speed error" "./typewriter -s invalid 'X' 2>&1" "Invalid speed"
echo

echo "3. Indentation Tests"
echo "-----------------"
test_cmd "2-space indent" "./typewriter -s xxxfast -i 2 'Text' | cat -A" "  Text"
test_cmd "Invalid indent" "./typewriter -i abc 'X' 2>&1" "must be a positive integer"
echo

echo "4. Color Tests"
echo "--------------"
test_cmd "Red color (31)" "./typewriter -s xxxfast -c 31 'Red' | cat -v | head -1" "^[[31mRed"
test_cmd "Color reset" "./typewriter -s xxxfast -c 31 'X' 2>&1 | cat -v | tail -1" "^[[0m"
echo

echo "5. Newline Tests"
echo "----------------"
test_cmd "Default newline" "./typewriter -s xxxfast 'Line' | wc -l | tr -d ' '" "1"
test_cmd "No newline flag" "{ ./typewriter -s xxxfast -n 'X'; echo '|'; } | tr -d '\n'" "X|"
test_cmd "Literal newline fix" "./typewriter -s xxxfast 'A\nB' | wc -l | tr -d ' '" "2"
echo

echo "6. STDIN Tests"
echo "--------------"
test_cmd "Simple stdin" "echo 'Input' | ./typewriter -s xxxfast" "Input"
test_cmd "Multi-line stdin" "printf 'L1\nL2' | ./typewriter -s xxxfast | wc -l | tr -d ' '" "2"
test_cmd "Empty input error" "./typewriter -s xxxfast 2>&1" "No input provided"
echo

echo "7. Combined Options"
echo "-------------------"
test_cmd "Speed + Indent" "./typewriter -s xxxfast -i 3 'X' | cat -A" "   X"
test_cmd "Indent + Color" "./typewriter -s xxxfast -i 2 -c 32 'X' | cat -v" "^[[32mX"
test_cmd "All options" "./typewriter -s xxxfast -i 2 -c 31 -n 'X' | cat -v" "^[[31mX^[[0m"
echo

echo "8. Environment Variables"
echo "------------------------"
test_cmd "TW_SPEED env" "TW_SPEED=xxxfast ./typewriter 'X'" "X"
test_cmd "TW_INDENT env" "TW_INDENT=4 ./typewriter -s xxxfast 'X' | cat -A" "    X"
echo

echo "9. TW Function Tests"
echo "--------------------"
test_cmd "Source script" "source ./typewriter && declare -f tw > /dev/null && echo 'OK'" "OK"
test_cmd "tw function works" "source ./typewriter && tw -s xxxfast 'Test'" "Test"
echo

echo "10. Edge Cases"
echo "--------------"
test_cmd "Empty string" "./typewriter -s xxxfast ''" ""
test_cmd "Special chars" "./typewriter -s xxxfast '!@#\$%'" '!@#$%'
test_cmd "Unicode" "./typewriter -s xxxfast '→←↑↓'" "→←↑↓"
test_cmd "Very long line" "./typewriter -s xxxfast \$(printf 'A%.0s' {1..1000}) | wc -c | tr -d ' '" "1001"
echo

echo "11. Exit Codes"
echo "--------------"
test_cmd "Success exit code" "./typewriter -s xxxfast 'X' >/dev/null 2>&1; echo \$?" "0"
test_cmd "Error exit code" "./typewriter -s invalid 'X' >/dev/null 2>&1 || echo \$?" "1"
echo

echo "=========================="
echo "Results: ${GREEN}$PASS passed${NC}, ${RED}$FAIL failed${NC}"

if [[ $FAIL -eq 0 ]]; then
  echo "${GREEN}✓ All tests passed!${NC}"
  exit 0
else
  echo "${RED}✗ Some tests failed${NC}"
  exit 1
fi

#fin