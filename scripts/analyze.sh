#!/bin/bash
# analyze.sh - reads a log file and counts test results

# safety settings
set -euo pipefail

# check if user gave a file
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <logfile>"
    exit 1
fi

# store the file name
LOG_FILE="$1"

# check if file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: file not found: $LOG_FILE"
    exit 1
fi

# count results by searching for keywords
PASSED=$(grep -c "TEST PASS" "$LOG_FILE" || true)
FAILED=$(grep -c "TEST FAIL" "$LOG_FILE" || true)
SKIPPED=$(grep -c "TEST SKIP" "$LOG_FILE" || true)
TOTAL=$((PASSED + FAILED + SKIPPED))

# get failing test names
FAILED_TESTS=$(grep "TEST FAIL" "$LOG_FILE" | awk '{print $5}' || true)

# print results
echo "=== RISC-V Log Analysis ==="
echo "File: $LOG_FILE"
echo ""
echo "Total:   $TOTAL"
echo "Passed:  $PASSED"
echo "Failed:  $FAILED"
echo "Skipped: $SKIPPED"
echo ""
echo "--- Failed Tests ---"
if [ -z "$FAILED_TESTS" ]; then
    echo "None"
else
    echo "$FAILED_TESTS"
fi

# exit code
if [ "$FAILED" -gt 0 ]; then
    echo ""
    echo "Verdict: FAIL"
    exit 1
else
    echo ""
    echo "Verdict: PASS"
    exit 0
fi
