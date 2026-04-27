#!/usr/bin/env bash
set -u
cd /Users/ryanmus/Documents/aiceos-foundation

echo "=== DW-2.1: file exists at /.claude/commands/setup-brain.md ==="
if [ -f .claude/commands/setup-brain.md ]; then
  echo "PASS: file exists"
else
  echo "FAIL: file missing"
fi

echo ""
echo "=== DW-2.1: prompt covers all five Brain sections by name ==="
for section in Expertise Audience Voice Offers Beliefs; do
  if grep -q "^### $section\$\|^## $section\$\|$section" .claude/commands/setup-brain.md; then
    echo "  PASS: $section referenced"
  else
    echo "  FAIL: $section missing"
  fi
done

echo ""
echo "=== DW-2.2: prompt mentions key behaviors ==="
for term in 'walk' 'one section at a time' '<!-- fill -->' 'remove' 'sentinel' 'confirmation' 'idempotent\|already populated\|already filled' 'Revise'; do
  if grep -qiE "$term" .claude/commands/setup-brain.md; then
    echo "  PASS: '$term' present"
  else
    echo "  FAIL: '$term' missing"
  fi
done

echo ""
echo "=== DW-2.4: grep gate (must return zero matches) ==="
matches=$(grep -rEi "ryan|skool|hiry|hyperframes|insta-ce|video-pipeline|aiceOS\/|\\\$[0-9]" .claude/ || true)
if [ -z "$matches" ]; then
  echo "PASS: zero matches"
else
  echo "FAIL: matches found:"
  echo "$matches"
fi

echo ""
echo "=== File listing ==="
ls -la .claude/commands/

echo ""
echo "=== Working tree status ==="
git status --short
