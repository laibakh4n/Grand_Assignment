# riscv-log-analyzer

A shell-based tool that analyzes RISC-V simulation log files and generates summary reports.

## Installation

```bash
git clone <your-repo-url>
cd riscv-log-analyzer
chmod +x scripts/*.sh
```

## Usage

```bash
bash scripts/analyze.sh test_data/sample_fail.log
```

## Sample Output

=== RISC-V Log Analysis ===
File: test_data/sample_fail.log
Total:   5
Passed:  2
Failed:  2
Skipped: 1
--- Failed Tests ---
rv32i-sll
rv32i-beq
Verdict: FAIL


## Make Targets

- `make all` → Run analyzer on all logs
- `make test` → Run tests
- `make report` → Generate report
- `make clean` → Remove generated files
- `make setup` → Check required tools
- `make help` → Show help
## Author 
Meow meow 2023