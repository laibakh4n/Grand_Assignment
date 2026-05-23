#!/bin/bash
# setup_env.sh - checks all required tools are installed

set -euo pipefail

echo "Checking required tools..."

for tool in bash grep awk sed git; do
    if command -v "$tool" > /dev/null 2>&1; then
        echo "  OK: $tool"
    else
        echo "  MISSING: $tool - please install it"
        exit 1
    fi
done

echo ""
echo "All tools found! Environment is ready."