#!/usr/bin/env bash
# Comprehensive Test Runner for Typewriter
set -uo pipefail

# Colors for output
GREEN=$'\033[0;32m'
RED=$'\033[0;31m'
YELLOW=$'\033[0;33m'
BLUE=$'\033[0;34m'
BOLD=$'\033[1m'
NC=$'\033[0m'

echo "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "${BOLD}${BLUE}    TYPEWRITER v1.0.10 - COMPREHENSIVE TESTS    ${NC}"
echo "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

TOTAL=0
PASS=0
FAIL=0
FAILURES=()

# Test function
run_test() {
  local category="$1"
  local name="$2"
  local cmd="$3"
  local check="$4"

  ((TOTAL++))

  # Run command and capture output/exit code
  local output exit_code
  output=$(eval "$cmd" 2>&1) && exit_code=0 || exit_code=$?

  # Check result based on check type
  local passed=false
  case "${check%%:*}" in
    equals)
      [[ "$output" == "${check#*:}" ]] && passed=true
      ;;
    contains)
      [[ "$output" == *"${check#*:}"* ]] && passed=true
      ;;
    lines)
      local line_count=$(echo "$output" | wc -l | tr -d ' ')
      [[ "$line_count" == "${check#*:}" ]] && passed=true
      ;;
    exit)
      [[ "$exit_code" == "${check#*:}" ]] && passed=true
      ;;
    not_empty)
      [[ -n "$output" ]] && passed=true
      ;;
  esac

  if [[ "$passed" == true ]]; then
    echo "${GREEN}✓${NC} [$category] $name"
    ((PASS++))
  else
    echo "${RED}✗${NC} [$category] $name"
    FAILURES+=("[$category] $name: expected '${check#*:}', got '$output' (exit: $exit_code)")
    ((FAIL++))
  fi
}

# Category header
category() {
  echo
  echo "${BOLD}${YELLOW}▶ $1${NC}"
  echo "${YELLOW}$(printf '─%.0s' {1..40})${NC}"
}

# ============================================================================
# TEST EXECUTION
# ============================================================================

category "BASIC FUNCTIONALITY"
run_test "Basic" "Version check" "./typewriter -V" "equals:typewriter 1.0.10"
run_test "Basic" "Simple text output" "./typewriter -s xxxfast 'Hello World'" "equals:Hello World"
run_test "Basic" "Help displays" "./typewriter -h | head -1" "contains:Typewriter-style output"
run_test "Basic" "Exit code success" "./typewriter -s xxxfast 'test' >/dev/null; echo \$?" "equals:0"
run_test "Basic" "Script is executable" "[[ -x ./typewriter ]] && echo 'yes'" "equals:yes"

category "SPEED OPTIONS (11 speeds)"
for speed in xxxfast xxfast xfast vfast fast normal slow vslow xslow xxslow xxxslow; do
  run_test "Speed" "$speed" "./typewriter -s $speed 'X' 2>/dev/null" "equals:X"
done
run_test "Speed" "Invalid speed error" "./typewriter -s invalid 'X' 2>&1" "contains:Invalid speed setting"

category "INDENTATION"
run_test "Indent" "No indent (default)" "./typewriter -s xxxfast 'Text' | sed 's/$/|/'" "equals:Text|"
run_test "Indent" "2 spaces" "./typewriter -s xxxfast -i 2 'Text' | sed 's/$/|/'" "equals:  Text|"
run_test "Indent" "4 spaces" "./typewriter -s xxxfast -i 4 'Text' | sed 's/$/|/'" "equals:    Text|"
run_test "Indent" "Invalid indent error" "./typewriter -i abc 'X' 2>&1" "contains:must be a positive integer"
run_test "Indent" "Negative indent error" "./typewriter -i -5 'X' 2>&1" "contains:must be a positive integer"

category "COLOR OUTPUT"
run_test "Color" "Red (31)" "./typewriter -s xxxfast -c 31 'Text' | cat -v" "contains:[31mText"
run_test "Color" "Green (32)" "./typewriter -s xxxfast -c 32 'Text' | cat -v" "contains:[32mText"
run_test "Color" "Bold Yellow (1;33)" "./typewriter -s xxxfast -c '1;33' 'Text' | cat -v" "contains:[1;33mText"
run_test "Color" "Color reset applied" "./typewriter -s xxxfast -c 31 'X' | cat -v" "contains:[0m"

category "NEWLINE HANDLING"
run_test "Newline" "Default adds newline" "./typewriter -s xxxfast 'Line'" "lines:1"
run_test "Newline" "No-newline flag (-n)" "{ ./typewriter -s xxxfast -n 'X'; echo '|'; } | tr -d '\n'" "equals:X|"
run_test "Newline" "Literal \\n handling (v1.0.10 fix)" "./typewriter -s xxxfast \$'First\\nSecond'" "lines:2"
run_test "Newline" "Multiple lines from literal" "./typewriter -s xxxfast \$'A\\nB\\nC'" "lines:3"

category "STDIN INPUT"
run_test "Stdin" "Simple stdin" "echo 'From stdin' | ./typewriter -s xxxfast" "equals:From stdin"
run_test "Stdin" "Multi-line stdin" "printf 'Line1\nLine2\nLine3' | ./typewriter -s xxxfast" "lines:3"
run_test "Stdin" "Stdin with indent" "echo 'Text' | ./typewriter -s xxxfast -i 3 | sed 's/$/|/'" "equals:   Text|"
run_test "Stdin" "Empty input error" "./typewriter 2>&1" "contains:No input provided"
run_test "Stdin" "Large stdin (100 lines)" "seq 1 100 | ./typewriter -s xxxfast | wc -l | tr -d ' '" "equals:100"

category "COMBINED OPTIONS"
run_test "Combo" "Speed + Indent" "./typewriter -s xxxfast -i 2 'X' | sed 's/$/|/'" "equals:  X|"
run_test "Combo" "Speed + Color" "./typewriter -s xxxfast -c 32 'X' | cat -v" "contains:[32mX"
run_test "Combo" "Indent + Color + No-newline" "{ ./typewriter -s xxxfast -i 2 -c 31 -n 'X'; echo '|'; } | cat -v" "contains:[31mX"
run_test "Combo" "All options together" "./typewriter -s xxxfast -i 3 -c '1;32' -n 'Test' | cat -v" "contains:[1;32mTest"

category "ENVIRONMENT VARIABLES"
run_test "Env" "TW_SPEED variable" "TW_SPEED=xxxfast ./typewriter 'X'" "equals:X"
run_test "Env" "TW_INDENT variable" "TW_INDENT=3 ./typewriter -s xxxfast 'X' | sed 's/$/|/'" "equals:   X|"
run_test "Env" "Both env variables" "TW_SPEED=xxxfast TW_INDENT=2 ./typewriter 'X' | sed 's/$/|/'" "equals:  X|"
run_test "Env" "CLI overrides env" "TW_SPEED=slow ./typewriter -s xxxfast 'X'" "equals:X"

category "INPUT VALIDATION"
run_test "Valid" "Missing -s argument" "./typewriter -s 2>&1" "contains:Missing argument"
run_test "Valid" "Missing -i argument" "./typewriter -i 2>&1" "contains:Missing argument"
run_test "Valid" "Missing -c argument" "./typewriter -c 2>&1" "contains:Missing argument"
run_test "Valid" "Invalid option" "./typewriter -z 2>&1" "contains:Invalid option"
run_test "Valid" "Option needs value" "./typewriter -s -i 2 'X' 2>&1" "contains:Invalid speed"

category "EDGE CASES"
run_test "Edge" "Empty string" "./typewriter -s xxxfast ''" "equals:"
run_test "Edge" "Single character" "./typewriter -s xxxfast 'A'" "equals:A"
run_test "Edge" "Special characters" "./typewriter -s xxxfast '!@#\$%^&*()'" "equals:!@#\$%^&*()"
run_test "Edge" "Unicode characters" "./typewriter -s xxxfast '→←↑↓'" "equals:→←↑↓"
run_test "Edge" "Tab character" "./typewriter -s xxxfast \$'Tab\\there' | cat -A" "contains:Tab^Ihere"
run_test "Edge" "1000 character line" "./typewriter -s xxxfast \$(printf 'A%.0s' {1..1000}) | wc -c | tr -d ' '" "equals:1001"

category "TW WRAPPER FUNCTION"
run_test "tw" "Source and declare" "source ./typewriter && declare -f tw > /dev/null && echo 'OK'" "equals:OK"
run_test "tw" "tw basic usage" "source ./typewriter && tw -s xxxfast 'Test'" "equals:Test"
run_test "tw" "tw with stdin" "source ./typewriter && echo 'Input' | tw -s xxxfast" "equals:Input"
run_test "tw" "tw default speed (v1.0.10)" "source ./typewriter && TW_SPEED=xxxfast tw 'X'" "equals:X"

category "LIBRARY MODE"
cat > /tmp/test_lib.$$ << 'EOF'
#!/usr/bin/env bash
source ./typewriter
typewriter -s xxxfast "Library works"
EOF
chmod +x /tmp/test_lib.$$
run_test "Lib" "Use as library" "/tmp/test_lib.$$" "equals:Library works"
run_test "Lib" "Functions exported" "source ./typewriter && { declare -f typewriter >/dev/null && declare -f tw >/dev/null; } && echo 'OK'" "equals:OK"
rm -f /tmp/test_lib.$$

category "ERROR HANDLING & EXIT CODES"
run_test "Error" "Success exit (0)" "./typewriter -s xxxfast 'X' >/dev/null 2>&1; echo \$?" "equals:0"
run_test "Error" "Error exit (non-zero)" "./typewriter -s invalid 'X' >/dev/null 2>&1 || echo 'failed'" "equals:failed"
run_test "Error" "No input exit code" "./typewriter >/dev/null 2>&1 || echo \$?" "equals:1"
run_test "Error" "Invalid option exit" "./typewriter -z 'X' >/dev/null 2>&1 || echo \$?" "equals:22"

category "PERFORMANCE"
run_test "Perf" "xxxfast is instant" "time -p bash -c './typewriter -s xxxfast X >/dev/null' 2>&1 | grep real | awk '{\$2<0.1 ? print \"fast\" : print \"slow\"}'" "contains:fast"
run_test "Perf" "Handle 1000 lines" "seq 1 1000 | ./typewriter -s xxxfast | wc -l | tr -d ' '" "equals:1000"

# ============================================================================
# RESULTS SUMMARY
# ============================================================================

echo
echo "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "${BOLD}TEST RESULTS SUMMARY${NC}"
echo "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
echo "Total Tests: ${BOLD}$TOTAL${NC}"
echo "Passed:      ${GREEN}${BOLD}$PASS${NC} ($(( PASS * 100 / TOTAL ))%)"
echo "Failed:      ${RED}${BOLD}$FAIL${NC} ($(( FAIL * 100 / TOTAL ))%)"

if [[ $FAIL -gt 0 ]]; then
  echo
  echo "${RED}${BOLD}FAILED TESTS:${NC}"
  for failure in "${FAILURES[@]}"; do
    echo "  ${RED}•${NC} $failure"
  done
  echo
  echo "${RED}${BOLD}✗ TEST SUITE FAILED${NC}"
  exit 1
else
  echo
  echo "${GREEN}${BOLD}✓ ALL TESTS PASSED!${NC}"
  echo "${GREEN}Typewriter v1.0.10 is fully functional.${NC}"
  exit 0
fi

#fin