#!/bin/bash
# analyze.sh - reads a log file and counts test results
# Usage: ./analyze.sh <logfile> [--verbose] [--help] [--format text|csv] [--output <path>]

# safety settings
set -euo pipefail

# ─── FUNCTIONS ───────────────────────────────────────

# function 1: print usage/help
print_help() {
    echo "Usage: $0 <logfile> [options]"
    echo ""
    echo "Arguments:"
    echo "  <logfile>          Path to log file (required)"
    echo "  --format [text|csv]  Output format (default: text)"
    echo "  --output <path>    Output file path (default: stdout)"
    echo "  --verbose          Enable verbose output"
    echo "  --help             Print this help message"
    echo ""
    echo "Examples:"
    echo "  $0 test_data/sample_pass.log"
    echo "  $0 test_data/sample_fail.log --verbose"
    echo "  $0 test_data/sample_sim.log --format csv"
}

# function 2: calculate pass rate percentage
calc_percentage() {
    local part="$1"
    local total="$2"
    if [ "$total" -eq 0 ]; then
        echo "0.0"
    else
        # calculate percentage using awk
        awk "BEGIN {printf \"%.1f\", ($part/$total)*100}"
    fi
}

# function 3: get timing statistics
calc_timing() {
    local log_file="$1"
    # extract all times from log using grep and awk
    local times
    times=$(grep -oE '\([0-9]+\.[0-9]+s\)' "$log_file" | grep -oE '[0-9]+\.[0-9]+' || true)

    if [ -z "$times" ]; then
        echo "  No timing data available"
        return
    fi

    # calculate min max avg using awk
    echo "$times" | awk '
    BEGIN { min=999; max=0; sum=0; count=0 }
    {
        sum += $1
        count++
        if ($1 < min) min = $1
        if ($1 > max) max = $1
    }
    END {
        printf "  Min time: %.2fs\n", min
        printf "  Max time: %.2fs\n", max
        printf "  Avg time: %.2fs\n", sum/count
    }'
}

# ─── ARGUMENT PARSING ────────────────────────────────

# check if user gave a file
if [ "$#" -lt 1 ]; then
    print_help
    exit 1
fi

# default values
LOG_FILE=""
FORMAT="text"
OUTPUT=""
VERBOSE=0

# parse arguments
for arg in "$@"; do
    case "$arg" in
        --help)
            print_help
            exit 0
            ;;
        --verbose)
            VERBOSE=1
            ;;
        --format)
            ;;
        text|csv)
            FORMAT="$arg"
            ;;
        --output)
            ;;
        *)
            if [ -z "$LOG_FILE" ]; then
                LOG_FILE="$arg"
            else
                OUTPUT="$arg"
            fi
            ;;
    esac
done

# check if file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: file not found: $LOG_FILE"
    exit 1
fi

# ─── ANALYSIS ────────────────────────────────────────

# count results by searching for keywords
PASSED=$(grep -c "TEST PASS" "$LOG_FILE" || true)
FAILED=$(grep -c "TEST FAIL" "$LOG_FILE" || true)
SKIPPED=$(grep -c "TEST SKIP" "$LOG_FILE" || true)
TOTAL=$((PASSED + FAILED + SKIPPED))

# get failed test names
FAILED_TESTS=$(grep "TEST FAIL" "$LOG_FILE" | grep -oE 'rv32i-[a-z]+' || true)

# calculate pass rate
PASS_RATE=$(calc_percentage "$PASSED" "$TOTAL")

# ─── OUTPUT ──────────────────────────────────────────

# build output content
generate_text_output() {
    echo "=== RISC-V Log Analysis ==="
    echo "File: $LOG_FILE"
    echo "Date: $(date)"
    echo ""
    echo "--- Results Summary ---"
    echo "Total:   $TOTAL"
    echo "Passed:  $PASSED ($PASS_RATE%)"
    echo "Failed:  $FAILED"
    echo "Skipped: $SKIPPED"
    echo ""
    echo "--- Failed Tests ---"
    if [ -z "$FAILED_TESTS" ]; then
        echo "None"
    else
        echo "$FAILED_TESTS"
    fi
    echo ""
    echo "--- Timing Statistics ---"
    calc_timing "$LOG_FILE"
    echo ""
    if [ "$FAILED" -gt 0 ]; then
        echo "--- Verdict: FAIL ---"
    else
        echo "--- Verdict: PASS ---"
    fi
}

generate_csv_output() {
    echo "file,total,passed,failed,skipped,pass_rate"
    echo "$LOG_FILE,$TOTAL,$PASSED,$FAILED,$SKIPPED,$PASS_RATE%"
}

# verbose mode
if [ "$VERBOSE" -eq 1 ]; then
    echo "[VERBOSE] Analyzing file: $LOG_FILE"
    echo "[VERBOSE] Format: $FORMAT"
    echo "[VERBOSE] Output: ${OUTPUT:-stdout}"
    echo ""
fi

# send output to file or stdout
if [ -n "$OUTPUT" ]; then
    if [ "$FORMAT" = "csv" ]; then
        generate_csv_output > "$OUTPUT"
    else
        generate_text_output > "$OUTPUT"
    fi
    echo "Output saved to: $OUTPUT"
else
    if [ "$FORMAT" = "csv" ]; then
        generate_csv_output
    else
        generate_text_output
    fi
fi

# ─── EXIT CODE ───────────────────────────────────────
if [ "$FAILED" -gt 0 ]; then
    exit 1
else
    exit 0
fi