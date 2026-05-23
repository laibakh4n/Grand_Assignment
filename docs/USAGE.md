# Usage Guide

## Basic Usage
```bash
./scripts/analyze.sh <logfile> [options]
```

---

## Arguments

| Argument | Description | Required |
|----------|-------------|----------|
| `<logfile>` | Path to log file | Yes |
| `--format [text\|csv]` | Output format (default: text) | No |
| `--output <path>` | Output file path (default: stdout) | No |
| `--verbose` | Enable verbose output | No |
| `--help` | Print usage information | No |

---

## Examples

```bash
# analyze a single file
./scripts/analyze.sh test_data/sample_pass.log

# analyze with verbose output
./scripts/analyze.sh test_data/sample_fail.log --verbose

# output in csv format
./scripts/analyze.sh test_data/sample_sim.log --format csv

# save output to file
./scripts/analyze.sh test_data/sample_fail.log --output output/result.txt

# generate full report for all log files
./scripts/generate_report.sh

# check all required tools are installed
./scripts/setup_env.sh

# show help
./scripts/analyze.sh --help
```

---

## Make Targets

```bash
make all      # run analyzer on all log files
make test     # run tests on each log file
make report   # generate summary report in output/
make clean    # remove all generated output files
make setup    # check all required tools are installed
make help     # show all available targets
make lint     # check scripts for syntax errors
```

---

## Sample Output

### Text Format
```
=== RISC-V Log Analysis ===
File: test_data/sample_fail.log
Date: Sat May 23 2026

--- Results Summary ---
Total:   5
Passed:  2 (40.0%)
Failed:  2
Skipped: 1

--- Failed Tests ---
rv32i-sll
rv32i-beq

--- Timing Statistics ---
  Min time: 0.65s
  Max time: 2.31s
  Avg time: 1.20s

--- Verdict: FAIL ---
```

### CSV Format
```
file,total,passed,failed,skipped,pass_rate
test_data/sample_fail.log,5,2,2,1,40.0%
```

---

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | All tests passed |
| 1 | One or more tests failed |

---

## Project Structure

```
riscv-log-analyzer/
├── README.md
├── Makefile
├── .gitignore
├── scripts/
│   ├── analyze.sh          # main analysis script
│   ├── setup_env.sh        # environment setup
│   └── generate_report.sh  # report generation
├── test_data/
│   ├── sample_pass.log     # all tests passing
│   ├── sample_fail.log     # some tests failing
│   └── sample_sim.log      # mixed results
├── output/                 # generated reports (gitignored)
└── docs/
    └── USAGE.md            # this file
```

---

## Author

Laiba Khan — MEDS Lab, UET Lahore — Summer 2026
