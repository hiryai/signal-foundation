#!/bin/bash
# Phase 1 verification for signal-instagram engine scaffold
set -u
ENGINE=/Users/ryanmus/Documents/signal-instagram

echo "=== DW-1.1: directory layout ==="
ls -la "$ENGINE/"
echo "--- .claude/commands/ ---"
ls -la "$ENGINE/.claude/commands/"
echo "--- reference/ ---"
ls -la "$ENGINE/reference/"
echo "--- synthesis/ ---"
ls -la "$ENGINE/synthesis/"

echo ""
echo "=== DW-1.3: privacy grep (should return zero matches) ==="
if grep -ri -E "skool|hiry|hyperframes|insta-ce|video-pipeline|aiceOS" "$ENGINE/"; then
  echo "FAIL: matches found above"
else
  echo "PASS: no matches"
fi

echo ""
echo "=== DW-1.4: reference/ and synthesis/ contain only README.md and .gitkeep ==="
echo "reference/:"
ls -A "$ENGINE/reference/"
echo "synthesis/:"
ls -A "$ENGINE/synthesis/"

echo ""
echo "=== DW-1.8: gitignore content ==="
cat "$ENGINE/.gitignore"

echo ""
echo "=== full file inventory (find) ==="
find "$ENGINE" -type f
echo ""
echo "=== full directory inventory ==="
find "$ENGINE" -type d
