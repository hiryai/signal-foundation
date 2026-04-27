#!/bin/bash
# Post-gate review verification script for Phase 3
set -u
cd /Users/ryanmus/Documents/aiceos-foundation

echo "=========================================="
echo "1. Run the build agent's verify script"
echo "=========================================="
bash docs/building/phase-3-verify.sh
echo ""

echo "=========================================="
echo "2. Confirm cross-reference integrity"
echo "=========================================="
echo "All paths the README links to:"
for path in docs/claude-code-setup.md docs/engine-framework.md brain/README.md reference/README.md brain/brain.md .claude/commands/setup-brain.md; do
  if [ -e "$path" ]; then
    echo "  EXISTS: $path"
  else
    echo "  MISSING: $path"
  fi
done
echo ""

echo "=========================================="
echo "3. Forbidden-token grep with marketplace exception"
echo "=========================================="
grep -rEni "ryan|skool|hiry|hyperframes|insta-ce|video-pipeline|aiceOS/|\$[0-9]" \
  docs/engine-framework.md docs/claude-code-setup.md README.md \
  | grep -v "ryanthedev/rtd-claude-inn"
echo "(Expected: zero output above)"
echo ""

echo "=========================================="
echo "4. Verify aiceOS (no slash) usage is fine — but check no /aiceOS/ path-style"
echo "=========================================="
grep -rEni "aiceOS/" docs/engine-framework.md docs/claude-code-setup.md README.md
echo "(Expected: zero output)"
echo ""

echo "=========================================="
echo "5. Verify no leakage of operator concepts"
echo "=========================================="
echo "Search for Character/Conversion/Comedy pillars, '\$200k', '10 hours', 'Skool', etc."
grep -rEni "character|conversion|comedy|\b200k\b|10 hours|1 hour" docs/engine-framework.md docs/claude-code-setup.md README.md || echo "  (none found)"
echo ""

echo "=========================================="
echo "6. Confirm /setup-brain command exists where README references it"
echo "=========================================="
ls -la .claude/commands/setup-brain.md
echo ""

echo "=========================================="
echo "7. Confirm brain.md has the expected five sections"
echo "=========================================="
grep -nE "^## (Expertise|Audience|Voice|Offers|Beliefs)" brain/brain.md
echo ""

echo "=========================================="
echo "8. Framework doc Brain section names brain.md and /setup-brain"
echo "=========================================="
echo "Brain section line numbers:"
grep -n "^## Brain" docs/engine-framework.md
echo "/brain/brain.md mentions:"
grep -n "/brain/brain.md\|brain/brain.md" docs/engine-framework.md
echo "/setup-brain mentions:"
grep -n "/setup-brain" docs/engine-framework.md
echo ""

echo "=========================================="
echo "9. README explicitly bans 'edit brain.md by hand' as instruction"
echo "=========================================="
grep -n "edit.*brain\.md" README.md
echo "(Expected: only 'Do not edit ...' lines)"
echo ""

echo "=========================================="
echo "10. README ordered step links — sequential check"
echo "=========================================="
grep -nE "^### [0-9]+\." README.md
echo ""

echo "=========================================="
echo "11. Engine framework: each layer has Job/Produced by/Consumed by"
echo "=========================================="
echo "Counts (expecting 5 each):"
echo "Job. count: $(grep -c '^\*\*Job\.\*\*' docs/engine-framework.md)"
echo "Produced by. count: $(grep -c '^\*\*Produced by\.\*\*' docs/engine-framework.md)"
echo "Consumed by. count: $(grep -c '^\*\*Consumed by\.\*\*' docs/engine-framework.md)"
echo ""

echo "=========================================="
echo "12. Confirm docs/plans is gitignored"
echo "=========================================="
grep -n "docs/plans" .gitignore
echo ""

echo "Done."
