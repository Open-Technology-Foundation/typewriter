#!/usr/bin/env bash
# Comprehensive test suite for typewriter script
# Tests all functionality, options, and edge cases
set -euo pipefail

# Test configuration
readonly SCRIPT="./typewriter"
readonly TW_SCRIPT="./tw"
readonly VERSION="1.0.10"
declare -i TESTS_RUN=0
declare -i TESTS_PASSED=0
declare -i TESTS_FAILED=0
declare -a FAILED_TESTS=()

# Color definitions for test output
if [[ -t 1 ]]; then
  readonly RED=$'\033[0;31m'
  readonly GREEN=$'\033[0;32m'
  readonly YELLOW=$'\033[0;33m'
  readonly CYAN=$'\033[0;36m'
  readonly BOLD=$'\033[1m'
  readonly NC=$'\033[0m'
else
  readonly RED='' GREEN='' YELLOW='' CYAN='' BOLD='' NC=''
fi

# Test helper functions
test_header() {
  echo
  echo "${CYAN}${BOLD}=== $1 ===${NC}"
}

test_subheader() {
  echo "${YELLOW}--- $1 ---${NC}"
}

run_test() {
  local test_name="$1"
  local test_command="$2"
  local expected_result="${3:-}"
  local comparison_type="${4:-exact}"

  ((TESTS_RUN++))

  printf "  %-50s" "$test_name"

  # Execute test and capture output/error/exit code
  local output exit_code
  output=$(eval "$test_command" 2>&1) && exit_code=$? || exit_code=$?

  local test_passed=false

  case "$comparison_type" in
    exact)
      [[ "$output" == "$expected_result" ]] && test_passed=true
      ;;
    contains)
      [[ "$output" == *"$expected_result"* ]] && test_passed=true
      ;;
    regex)
      [[ "$output" =~ $expected_result ]] && test_passed=true
      ;;
    exit_code)
      [[ "$exit_code" == "$expected_result" ]] && test_passed=true
      ;;
    lines)
      local line_count
      line_count=$(echo "$output" | wc -l)
      [[ "$line_count" == "$expected_result" ]] && test_passed=true
      ;;
    not_empty)
      [[ -n "$output" ]] && test_passed=true
      ;;
  esac

  if [[ "$test_passed" == true ]]; then
    echo "${GREEN}✓${NC} PASS"
    ((TESTS_PASSED++))
  else
    echo "${RED}✗${NC} FAIL"
    ((TESTS_FAILED++))
    FAILED_TESTS+=("$test_name")
    if [[ -n "${VERBOSE:-}" ]]; then
      echo "    Expected: '$expected_result'"
      echo "    Got: '$output'"
      echo "    Exit code: $exit_code"
    fi
  fi
}

# Cleanup function
cleanup() {
  # Remove any test files created
  rm -f test_*.tmp
}
trap cleanup EXIT

# --------------------------------------------------------------------------------
# TEST SUITES
# --------------------------------------------------------------------------------

test_basic_functionality() {
  test_header "Basic Functionality Tests"

  run_test "Script exists and is executable" \
    "[[ -x '$SCRIPT' ]] && echo 'OK'" \
    "OK" \
    exact

  run_test "Version output" \
    "$SCRIPT -V" \
    "typewriter $VERSION" \
    exact

  run_test "Version long option" \
    "$SCRIPT --version" \
    "typewriter $VERSION" \
    exact

  run_test "Help option shows usage" \
    "$SCRIPT -h 2>&1 | head -1" \
    "typewriter $VERSION - Typewriter-style output with variable speed and indent" \
    exact

  run_test "Basic text output" \
    "$SCRIPT -s xxxfast 'Hello World'" \
    "Hello World" \
    exact

  run_test "Exit code success" \
    "$SCRIPT -s xxxfast 'test' > /dev/null; echo \$?" \
    "0" \
    exact
}

test_speed_options() {
  test_header "Speed Options Tests"
  test_subheader "Testing all 11 speed settings"

  local speeds=(xxxfast xxfast xfast vfast fast normal slow vslow xslow xxslow xxxslow)
  for speed in "${speeds[@]}"; do
    run_test "Speed: $speed" \
      "$SCRIPT -s $speed 'Test' 2>/dev/null" \
      "Test" \
      exact
  done

  run_test "Default speed (normal)" \
    "$SCRIPT -s normal 'X' 2>/dev/null" \
    "X" \
    exact

  run_test "Speed with long option" \
    "$SCRIPT --speed xxxfast 'Quick'" \
    "Quick" \
    exact
}

test_indentation() {
  test_header "Indentation Tests"

  run_test "No indent (default)" \
    "$SCRIPT -s xxxfast 'Text' | cat -A" \
    "Text$" \
    exact

  run_test "2-space indent" \
    "$SCRIPT -s xxxfast -i 2 'Text' | cat -A" \
    "  Text$" \
    exact

  run_test "4-space indent" \
    "$SCRIPT -s xxxfast -i 4 'Text' | cat -A" \
    "    Text$" \
    exact

  run_test "8-space indent" \
    "$SCRIPT -s xxxfast -i 8 'Text' | cat -A" \
    "        Text$" \
    exact

  run_test "Indent with long option" \
    "$SCRIPT -s xxxfast --indent 3 'Text' | cat -A" \
    "   Text$" \
    exact

  run_test "Multi-line with indent" \
    "$SCRIPT -s xxxfast -i 2 $'Line1\nLine2' | cat -A" \
    "  Line1\$\n  Line2$" \
    exact
}

test_color_options() {
  test_header "Color Options Tests"

  run_test "Red color (31)" \
    "$SCRIPT -s xxxfast -c 31 'Red' | cat -v" \
    "^[[31mRed^[[0m" \
    contains

  run_test "Green color (32)" \
    "$SCRIPT -s xxxfast -c 32 'Green' | cat -v" \
    "^[[32mGreen^[[0m" \
    contains

  run_test "Bold red (1;31)" \
    "$SCRIPT -s xxxfast -c '1;31' 'Bold' | cat -v" \
    "^[[1;31mBold^[[0m" \
    contains

  run_test "Color with long option" \
    "$SCRIPT -s xxxfast --color 33 'Yellow' | cat -v" \
    "^[[33mYellow^[[0m" \
    contains

  run_test "Color reset on exit" \
    "$SCRIPT -s xxxfast -c 31 'Text' 2>&1 | tail -c 4 | cat -v" \
    "^[[0m" \
    exact
}

test_newline_options() {
  test_header "Newline Options Tests"

  run_test "Default (with newline)" \
    "$SCRIPT -s xxxfast 'Text' | wc -l" \
    "1" \
    exact

  run_test "No newline option -n" \
    "{ $SCRIPT -s xxxfast -n 'Text'; echo '|'; } | cat -A" \
    "Text|$" \
    exact

  run_test "No newline long option" \
    "{ $SCRIPT -s xxxfast --no-newline 'Text'; echo '|'; } | cat -A" \
    "Text|$" \
    exact

  run_test "Literal newline handling" \
    "$SCRIPT -s xxxfast $'First\\nSecond' | wc -l" \
    "2" \
    exact

  run_test "Multiple arguments" \
    "$SCRIPT -s xxxfast 'First' 'Second' | cat -A" \
    "FirstSecond$" \
    exact
}

test_stdin_input() {
  test_header "STDIN Input Tests"

  run_test "Simple stdin" \
    "echo 'From stdin' | $SCRIPT -s xxxfast" \
    "From stdin" \
    exact

  run_test "Multi-line stdin" \
    "printf 'Line1\nLine2\nLine3' | $SCRIPT -s xxxfast | wc -l" \
    "3" \
    exact

  run_test "Empty stdin" \
    "echo -n '' | $SCRIPT -s xxxfast 2>&1" \
    "error" \
    contains

  run_test "Stdin with indent" \
    "echo 'Indented' | $SCRIPT -s xxxfast -i 3 | cat -A" \
    "   Indented$" \
    exact

  run_test "Stdin with color" \
    "echo 'Colored' | $SCRIPT -s xxxfast -c 32 | cat -v" \
    "^[[32mColored^[[0m" \
    contains

  run_test "Large stdin input" \
    "seq 1 100 | $SCRIPT -s xxxfast | wc -l" \
    "100" \
    exact
}

test_combined_options() {
  test_header "Combined Options Tests"

  run_test "Speed + Indent" \
    "$SCRIPT -s xxxfast -i 2 'Text' | cat -A" \
    "  Text$" \
    exact

  run_test "Speed + Color" \
    "$SCRIPT -s xxxfast -c 31 'Text' | cat -v" \
    "^[[31mText^[[0m" \
    contains

  run_test "Indent + Color" \
    "$SCRIPT -i 2 -c 32 -s xxxfast 'Text' | cat -v" \
    "  ^[[32mText^[[0m" \
    contains

  run_test "Speed + Indent + Color" \
    "$SCRIPT -s xxxfast -i 2 -c 33 'Text' | cat -v" \
    "  ^[[33mText^[[0m" \
    contains

  run_test "All options combined" \
    "{ $SCRIPT -s xxxfast -i 2 -c 31 -n 'Text'; echo '|'; } | cat -v" \
    "  ^[[31mText^[[0m|" \
    contains

  run_test "Short options combined" \
    "$SCRIPT -sicn xxxfast 2 31 'Text' 2>&1" \
    "error" \
    contains
}

test_input_validation() {
  test_header "Input Validation Tests"

  run_test "Invalid speed" \
    "$SCRIPT -s invalid 'Text' 2>&1" \
    "Invalid speed setting" \
    contains

  run_test "Invalid indent (non-numeric)" \
    "$SCRIPT -i abc 'Text' 2>&1" \
    "must be a positive integer" \
    contains

  run_test "Invalid indent (negative)" \
    "$SCRIPT -i -5 'Text' 2>&1" \
    "must be a positive integer" \
    contains

  run_test "Invalid option" \
    "$SCRIPT -z 'Text' 2>&1" \
    "Invalid option" \
    contains

  run_test "Missing argument for -s" \
    "$SCRIPT -s 2>&1" \
    "Missing argument" \
    contains

  run_test "Missing argument for -i" \
    "$SCRIPT -i 2>&1" \
    "Missing argument" \
    contains

  run_test "Missing argument for -c" \
    "$SCRIPT -c 2>&1" \
    "Missing argument" \
    contains

  run_test "No input provided" \
    "$SCRIPT 2>&1" \
    "No input provided" \
    contains
}

test_environment_variables() {
  test_header "Environment Variable Tests"

  run_test "TW_SPEED environment variable" \
    "TW_SPEED=xxxfast $SCRIPT 'Text'" \
    "Text" \
    exact

  run_test "TW_INDENT environment variable" \
    "TW_INDENT=3 $SCRIPT -s xxxfast 'Text' | cat -A" \
    "   Text$" \
    exact

  run_test "Both environment variables" \
    "TW_SPEED=xxxfast TW_INDENT=2 $SCRIPT 'Text' | cat -A" \
    "  Text$" \
    exact

  run_test "Option overrides environment" \
    "TW_SPEED=slow $SCRIPT -s xxxfast 'Text'" \
    "Text" \
    exact

  run_test "Environment in help output" \
    "TW_SPEED=fast $SCRIPT -h 2>&1 | grep TW_SPEED | head -1" \
    "TW_SPEED" \
    contains
}

test_edge_cases() {
  test_header "Edge Cases Tests"

  run_test "Empty string argument" \
    "$SCRIPT -s xxxfast ''" \
    "" \
    exact

  run_test "Single character" \
    "$SCRIPT -s xxxfast 'X'" \
    "X" \
    exact

  run_test "Special characters" \
    "$SCRIPT -s xxxfast '!@#\$%^&*()'" \
    '!@#$%^&*()' \
    exact

  run_test "Unicode characters" \
    "$SCRIPT -s xxxfast '→ ← ↑ ↓ ♠ ♣ ♥ ♦'" \
    "→ ← ↑ ↓ ♠ ♣ ♥ ♦" \
    exact

  run_test "Tab character" \
    "$SCRIPT -s xxxfast $'Tab\\there' | cat -A" \
    "Tab^Ihere$" \
    exact

  run_test "Backslash handling" \
    "$SCRIPT -s xxxfast 'back\\slash'" \
    'back\slash' \
    exact

  run_test "Quote handling" \
    "$SCRIPT -s xxxfast \"It's a 'test'\"" \
    "It's a 'test'" \
    exact

  run_test "Very long line (1000 chars)" \
    "$SCRIPT -s xxxfast \$(printf 'A%.0s' {1..1000}) | wc -c" \
    "1001" \
    exact

  run_test "Binary null handling" \
    "printf 'before\\0after' | $SCRIPT -s xxxfast | cat -v" \
    "before^@after" \
    exact
}

test_tw_wrapper() {
  test_header "TW Wrapper Function Tests"

  run_test "Source and use tw function" \
    "source $SCRIPT && tw -s xxxfast 'Text' 2>/dev/null" \
    "Text" \
    exact

  run_test "tw default speed" \
    "source $SCRIPT && TW_SPEED=xxxfast tw 'Text' 2>/dev/null" \
    "Text" \
    exact

  run_test "tw with indent" \
    "source $SCRIPT && tw -s xxxfast -i 2 'Text' 2>/dev/null | cat -A" \
    "  Text$" \
    exact

  run_test "tw with color" \
    "source $SCRIPT && tw -s xxxfast -c 32 'Text' 2>/dev/null | cat -v" \
    "^[[32mText^[[0m" \
    contains

  run_test "tw with stdin" \
    "source $SCRIPT && echo 'Input' | tw -s xxxfast 2>/dev/null" \
    "Input" \
    exact
}

test_library_mode() {
  test_header "Library Mode Tests"

  cat > test_library.tmp << 'EOF'
#!/usr/bin/env bash
source ./typewriter
typewriter -s xxxfast "Library test"
EOF

  chmod +x test_library.tmp

  run_test "Use as library" \
    "./test_library.tmp 2>/dev/null" \
    "Library test" \
    exact

  cat > test_functions.tmp << 'EOF'
#!/usr/bin/env bash
source ./typewriter
declare -f typewriter > /dev/null && echo "typewriter defined"
declare -f tw > /dev/null && echo "tw defined"
EOF

  chmod +x test_functions.tmp

  run_test "Functions exported" \
    "./test_functions.tmp 2>/dev/null | wc -l" \
    "2" \
    exact

  rm -f test_library.tmp test_functions.tmp
}

test_performance() {
  test_header "Performance Tests"

  run_test "xxxfast speed is instant" \
    "time -p $SCRIPT -s xxxfast 'Test' 2>&1 | grep real | awk '{print (\$2 < 0.1)}'" \
    "1" \
    exact

  run_test "Can handle 10000 lines" \
    "seq 1 10000 | $SCRIPT -s xxxfast | wc -l" \
    "10000" \
    exact

  run_test "Can handle very long lines" \
    "printf 'A%.0s' {1..10000} | $SCRIPT -s xxxfast | wc -c" \
    "10001" \
    exact
}

test_signal_handling() {
  test_header "Signal Handling Tests"

  # Test color cleanup on interrupt
  cat > test_signal.tmp << 'EOF'
#!/usr/bin/env bash
./typewriter -s xxxslow -c 31 'This is a very long text that will take time to type' &
PID=$!
sleep 0.1
kill $PID 2>/dev/null
wait $PID 2>/dev/null
echo "Terminated"
EOF

  chmod +x test_signal.tmp

  run_test "Cleanup on signal" \
    "./test_signal.tmp 2>/dev/null" \
    "Terminated" \
    contains

  rm -f test_signal.tmp
}

test_bash_completion() {
  test_header "Bash Completion Tests"

  run_test "Completion file exists" \
    "[[ -f '.bash_completion' ]] && echo 'OK'" \
    "OK" \
    exact

  run_test "Completion loads without error" \
    "source .bash_completion 2>&1 && echo 'OK'" \
    "OK" \
    exact

  run_test "Completion function defined" \
    "source .bash_completion && declare -f _typewriter_completion > /dev/null && echo 'OK'" \
    "OK" \
    exact
}

test_shellcheck_compliance() {
  test_header "ShellCheck Compliance Tests"

  if command -v shellcheck > /dev/null; then
    run_test "Main script passes shellcheck" \
      "shellcheck $SCRIPT 2>&1 && echo 'OK'" \
      "OK" \
      exact

    run_test "Completion script passes shellcheck" \
      "shellcheck .bash_completion 2>&1 && echo 'OK'" \
      "OK" \
      exact
  else
    echo "  ${YELLOW}⚠${NC}  ShellCheck not installed - skipping"
  fi
}

# --------------------------------------------------------------------------------
# MAIN TEST EXECUTION
# --------------------------------------------------------------------------------

main() {
  echo "${BOLD}${CYAN}╔════════════════════════════════════════════╗${NC}"
  echo "${BOLD}${CYAN}║     Typewriter Test Suite v1.0            ║${NC}"
  echo "${BOLD}${CYAN}╚════════════════════════════════════════════╝${NC}"
  echo
  echo "Testing typewriter version: $VERSION"
  echo "Test mode: ${1:-full}"
  echo

  local test_mode="${1:-full}"

  case "$test_mode" in
    basic)
      test_basic_functionality
      ;;
    speed)
      test_speed_options
      ;;
    full|*)
      # Run all test suites
      test_basic_functionality
      test_speed_options
      test_indentation
      test_color_options
      test_newline_options
      test_stdin_input
      test_combined_options
      test_input_validation
      test_environment_variables
      test_edge_cases
      test_tw_wrapper
      test_library_mode
      test_performance
      test_signal_handling
      test_bash_completion
      test_shellcheck_compliance
      ;;
  esac

  # Print summary
  echo
  echo "${BOLD}${CYAN}╔════════════════════════════════════════════╗${NC}"
  echo "${BOLD}${CYAN}║              TEST SUMMARY                  ║${NC}"
  echo "${BOLD}${CYAN}╚════════════════════════════════════════════╝${NC}"
  echo
  echo "Total tests run:    ${BOLD}$TESTS_RUN${NC}"
  echo "Tests passed:       ${GREEN}${BOLD}$TESTS_PASSED${NC}"
  echo "Tests failed:       ${RED}${BOLD}$TESTS_FAILED${NC}"

  if ((TESTS_FAILED > 0)); then
    echo
    echo "${RED}${BOLD}Failed tests:${NC}"
    printf '%s\n' "${FAILED_TESTS[@]}" | sed 's/^/  - /'
    echo
    echo "${RED}${BOLD}TEST SUITE FAILED${NC}"
    exit 1
  else
    echo
    echo "${GREEN}${BOLD}ALL TESTS PASSED! ✓${NC}"
    exit 0
  fi
}

# Check if script exists
if [[ ! -x "$SCRIPT" ]]; then
  echo "${RED}Error: $SCRIPT not found or not executable${NC}"
  exit 1
fi

# Parse command line arguments
VERBOSE=""
if [[ "${1:-}" == "-v" ]] || [[ "${1:-}" == "--verbose" ]]; then
  VERBOSE=1
  shift
fi

# Run main test suite
main "${1:-full}"

#fin