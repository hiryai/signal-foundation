#!/usr/bin/env bash
# Phase 1 verification — runs the structural + grep checks defined in the discovery file.
# Exits non-zero on first failure.
set -u
cd /Users/ryanmus/Documents/aiceos-foundation/

fail=0
pass() { echo "PASS: $1"; }
fail() { echo "FAIL: $1"; fail=1; }

# DW-1.1: git repo + required top-level entries
[ -d .git ]               && pass "DW-1.1 .git/ present"          || fail "DW-1.1 .git/ missing"
[ -f README.md ]          && pass "DW-1.1 README.md present"      || fail "DW-1.1 README.md missing"
[ -f .gitignore ]         && pass "DW-1.1 .gitignore present"     || fail "DW-1.1 .gitignore missing"
[ -d reference ]          && pass "DW-1.1 reference/ present"     || fail "DW-1.1 reference/ missing"
[ -d brain ]              && pass "DW-1.1 brain/ present"         || fail "DW-1.1 brain/ missing"
[ -d docs ]               && pass "DW-1.1 docs/ present"          || fail "DW-1.1 docs/ missing"
[ -d .claude/commands ]   && pass "DW-1.1 .claude/commands/ present" || fail "DW-1.1 .claude/commands/ missing"

# DW-1.2: /reference/ exact contents
ref_entries=$(cd reference && ls -A | LC_ALL=C sort | tr '\n' ' ')
expected_ref="README.md creators posts "
if [ "$ref_entries" = "$expected_ref" ]; then
  pass "DW-1.2 /reference/ has exactly README.md, creators/, posts/"
else
  fail "DW-1.2 /reference/ entries: got [$ref_entries] expected [$expected_ref]"
fi
[ -f reference/creators/.gitkeep ] && pass "DW-1.2 creators/.gitkeep present" || fail "DW-1.2 creators/.gitkeep missing"
[ -f reference/posts/.gitkeep ]    && pass "DW-1.2 posts/.gitkeep present"    || fail "DW-1.2 posts/.gitkeep missing"
grep -qiE "reference" reference/README.md         && pass "DW-1.2 reference README mentions Reference layer" || fail "DW-1.2 reference README missing 'Reference'"
grep -qiE "five.layer" reference/README.md        && pass "DW-1.2 reference README mentions five-layer"      || fail "DW-1.2 reference README missing 'five-layer'"
grep -qiE "url"        reference/README.md        && pass "DW-1.2 reference README mentions URLs"            || fail "DW-1.2 reference README missing 'URL'"
grep -qiE "transcript" reference/README.md        && pass "DW-1.2 reference README mentions transcripts"     || fail "DW-1.2 reference README missing 'transcript'"
grep -qiE "screenshot" reference/README.md        && pass "DW-1.2 reference README mentions screenshots"     || fail "DW-1.2 reference README missing 'screenshot'"
grep -qE  "creators"   reference/README.md        && pass "DW-1.2 reference README mentions creators/"       || fail "DW-1.2 reference README missing 'creators'"
grep -qE  "posts"      reference/README.md        && pass "DW-1.2 reference README mentions posts/"          || fail "DW-1.2 reference README missing 'posts'"

# DW-1.3: /brain/ exact contents + brain.md structure
brain_entries=$(cd brain && ls -A | LC_ALL=C sort | tr '\n' ' ')
expected_brain="README.md brain.md "
if [ "$brain_entries" = "$expected_brain" ]; then
  pass "DW-1.3 /brain/ has exactly README.md, brain.md"
else
  fail "DW-1.3 /brain/ entries: got [$brain_entries] expected [$expected_brain]"
fi
heading_count=$(grep -c "^## " brain/brain.md || true)
if [ "$heading_count" = "5" ]; then
  pass "DW-1.3 brain.md has exactly 5 H2 sections"
else
  fail "DW-1.3 brain.md H2 count: got $heading_count expected 5"
fi
for h in Expertise Audience Voice Offers Beliefs; do
  grep -qE "^## $h\$" brain/brain.md && pass "DW-1.3 brain.md has '## $h'" || fail "DW-1.3 brain.md missing '## $h'"
done
sentinel_count=$(grep -c -F "<!-- fill -->" brain/brain.md || true)
if [ "$sentinel_count" = "5" ]; then
  pass "DW-1.3 brain.md has 5 sentinels (one per section)"
else
  fail "DW-1.3 brain.md sentinel count: got $sentinel_count expected 5"
fi
grep -qE "/setup-brain" brain/README.md && pass "DW-1.3 brain README mentions /setup-brain"  || fail "DW-1.3 brain README missing /setup-brain"
grep -qiE "do not edit|don't edit|not.*by hand|not.*manually|rather than" brain/README.md && pass "DW-1.3 brain README contains do-not-edit-by-hand instruction" || fail "DW-1.3 brain README missing do-not-edit instruction"

# DW-1.4: forbidden-token grep on /reference/ and /brain/
hits=$(grep -rEi "ryan|skool|hiry|hyperframes|insta-ce|video-pipeline|aiceOS\/|\\\$[0-9]" reference/ brain/ || true)
if [ -z "$hits" ]; then
  pass "DW-1.4 forbidden-token grep clean"
else
  fail "DW-1.4 forbidden-token grep matched:"
  echo "$hits"
fi

echo
if [ "$fail" = "0" ]; then
  echo "ALL CHECKS PASSED"
  exit 0
else
  echo "FAILURES PRESENT"
  exit 1
fi
