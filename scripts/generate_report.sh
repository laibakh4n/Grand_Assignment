#!/bin/bash
set -euo pipefail
# generate_report.sh - generates summary report for all log files

echo "Generating report..."

# create output directory
mkdir -p output

# create report file
REPORT="output/report.txt"

echo "=== RISC-V Test Report ===" > "$REPORT"
echo "Date: $(date)" >> "$REPORT"
echo "" >> "$REPORT"

# run analyzer on each log file
echo "--- sample_pass.log ---" >> "$REPORT"
bash scripts/analyze.sh test_data/sample_pass.log >> "$REPORT"
echo "" >> "$REPORT"

echo "--- sample_fail.log ---" >> "$REPORT"
bash scripts/analyze.sh test_data/sample_fail.log >> "$REPORT" || true
echo "" >> "$REPORT"

echo "--- sample_sim.log ---" >> "$REPORT"
bash scripts/analyze.sh test_data/sample_sim.log >> "$REPORT" || true
echo "" >> "$REPORT"

echo "Report saved to: $REPORT"