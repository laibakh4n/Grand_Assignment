.PHONY: all test report clean help setup

all:
	./scripts/analyze.sh test_data/sample_pass.log
	-./scripts/analyze.sh test_data/sample_fail.log
	-./scripts/analyze.sh test_data/sample_sim.log

test:
	@echo "Running tests..."
	-./scripts/analyze.sh test_data/sample_pass.log
	-./scripts/analyze.sh test_data/sample_fail.log
	-./scripts/analyze.sh test_data/sample_sim.log
	@echo "Tests complete"

report:
	@mkdir -p output
	./scripts/generate_report.sh

clean:
	rm -rf output/*
	@echo "Generated files removed"

setup:
	@which bash
	@which grep
	@which awk
	@echo "All tools found"

help:
	@echo "Available targets:"
	@echo "  make all    -> Run analyzer on all logs"
	@echo "  make test   -> Run tests"
	@echo "  make report -> Generate report"
	@echo "  make clean  -> Remove generated files"
	@echo "  make setup  -> Check required tools"
	@echo "  make help   -> Show this help"
