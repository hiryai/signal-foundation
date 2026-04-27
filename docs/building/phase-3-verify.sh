#!/bin/bash
# Phase 3 verification — runs all DW checks defined in the discovery file.
set -u
cd /Users/ryanmus/Documents/aiceos-foundation

echo "=========================================="
echo "V-A: Forbidden-token grep (DW-3.4)"
echo "=========================================="
echo "Pattern: ryan|skool|hiry|hyperframes|insta-ce|video-pipeline|aiceOS/|\$[0-9]"
echo "Targets: docs/engine-framework.md, docs/claude-code-setup.md, README.md"
echo "Expected: zero matches"
echo "------------------------------------------"
RESULT=$(grep -rEni "ryan|skool|hiry|hyperframes|insta-ce|video-pipeline|aiceOS/|\$[0-9]" \
  docs/engine-framework.md \
  docs/claude-code-setup.md \
  README.md 2>&1)
if [ -z "$RESULT" ]; then
  echo "PASS — zero matches"
else
  echo "FAIL — matches found:"
  echo "$RESULT"
fi
echo ""

echo "=========================================="
echo "V-B: Engine framework — five-layer section presence (DW-3.1)"
echo "=========================================="
echo "Expected: ## Reference, ## Pattern, ## Brain, ## Synthesis, ## Feedback"
echo "------------------------------------------"
grep -n "^## " docs/engine-framework.md
echo ""

echo "=========================================="
echo "V-C: Engine framework — per-layer content keywords (DW-3.1)"
echo "=========================================="
echo "Each section should mention 'Job.', 'Produced by.', 'Consumed by.'"
echo "------------------------------------------"
echo "Job. occurrences:"
grep -c "^\*\*Job\.\*\*" docs/engine-framework.md
echo "Produced by. occurrences:"
grep -c "^\*\*Produced by\.\*\*" docs/engine-framework.md
echo "Consumed by. occurrences:"
grep -c "^\*\*Consumed by\.\*\*" docs/engine-framework.md
echo ""

echo "=========================================="
echo "V-D: Engine framework — data flow chain (DW-3.1)"
echo "=========================================="
echo "Expected: References, Pattern, Brain, Synthesis, Feedback all named in flow"
echo "------------------------------------------"
grep -n "Reference\|Pattern\|Brain\|Synthesis\|Feedback" docs/engine-framework.md | grep -iE "data flow|reweight|extract|combine|ships" | head -20
echo "Has 'Data flow' section heading:"
grep -n "^## Data flow" docs/engine-framework.md
echo ""

echo "=========================================="
echo "V-E: Engine framework — Brain section names brain.md and /setup-brain (DW-3.1)"
echo "=========================================="
grep -n "brain/brain.md\|/brain/brain.md" docs/engine-framework.md | head -5
grep -n "/setup-brain" docs/engine-framework.md | head -5
echo ""

echo "=========================================="
echo "V-F: Claude Code setup — required steps (DW-3.2)"
echo "=========================================="
echo "Required literal strings:"
echo "  /plugin marketplace add ryanthedev/rtd-claude-inn:"
grep -n "/plugin marketplace add ryanthedev/rtd-claude-inn" docs/claude-code-setup.md
echo "  /plugin install code-foundations@rtd:"
grep -n "/plugin install code-foundations@rtd" docs/claude-code-setup.md
echo "  /reload-plugins:"
grep -n "/reload-plugins" docs/claude-code-setup.md
echo "  ANTHROPIC_API_KEY:"
grep -n "ANTHROPIC_API_KEY" docs/claude-code-setup.md
echo "Step headings:"
grep -n "^## Step " docs/claude-code-setup.md
echo ""

echo "=========================================="
echo "V-G: README — opening line (DW-3.3)"
echo "=========================================="
grep -n "If you just cloned this, do these steps in order" README.md
echo ""

echo "=========================================="
echo "V-H: README — sequential ordered links (DW-3.3)"
echo "=========================================="
echo "Step headings (### N. ...):"
grep -nE "^### [0-9]+\." README.md
echo ""
echo "Link to docs/claude-code-setup.md:"
grep -n "docs/claude-code-setup.md" README.md
echo "Link to docs/engine-framework.md:"
grep -n "docs/engine-framework.md" README.md
echo "/setup-brain mentioned:"
grep -n "/setup-brain" README.md
echo "Link to reference/README.md:"
grep -n "reference/README.md" README.md
echo "Step 5 'install ... engine module':"
grep -nE "[Ii]nstall .* engine module" README.md
echo ""
echo "MUST NOT instruct user to edit brain.md by hand. Lines mentioning 'edit ... brain.md':"
grep -nE "edit .*brain\.md" README.md
echo "(Above should only be 'do not edit' instructions, never 'edit brain.md' as a step.)"
echo ""

echo "=========================================="
echo "Done."
echo "=========================================="
