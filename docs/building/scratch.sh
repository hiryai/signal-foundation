#!/usr/bin/env bash
set +e
REPO=/Users/ryanmus/Documents/aiceos-foundation
echo "==== DW-1.1: ls-files brain/brain.md (expect empty) ===="
git -C "$REPO" ls-files brain/brain.md
echo "RC=$?"
echo ""
echo "==== DW-1.2: ls-files brain/brain.md.template (expect path) ===="
git -C "$REPO" ls-files brain/brain.md.template
echo "RC=$?"
echo ""
echo "==== DW-1.3: show --stat HEAD -- brain/brain.md brain/brain.md.template ===="
git -C "$REPO" show --stat HEAD -- brain/brain.md brain/brain.md.template
echo ""
echo "==== DW-1.4: .gitignore content ===="
cat "$REPO/.gitignore"
echo ""
echo "==== DW-1.5 prep: rename similarity ===="
git -C "$REPO" show --stat HEAD -- brain/brain.md.template | head -20
echo ""
echo "==== DW-1.5: file size + heading + sentinel counts ===="
wc -l "$REPO/brain/brain.md.template"
echo "Headings:"
grep -c '^## ' "$REPO/brain/brain.md.template"
echo "Sentinels:"
grep -c '<!-- fill -->' "$REPO/brain/brain.md.template"
echo ""
echo "==== DW-1.5: Compare to pre-rename ===="
git -C "$REPO" show HEAD~1:brain/brain.md > /tmp/pre_brain.md 2>&1
diff /tmp/pre_brain.md "$REPO/brain/brain.md.template" && echo "BYTE-IDENTICAL"
echo ""
echo "==== DW-1.8: log --oneline -n 1 ===="
git -C "$REPO" log --oneline -n 1
echo ""
echo "==== status check ===="
git -C "$REPO" status --short
echo ""
echo "==== Files changed in HEAD ===="
git -C "$REPO" show --stat HEAD
echo ""
echo "==== Verify README.md and engine-framework.md unchanged ===="
git -C "$REPO" diff HEAD~1 HEAD -- README.md docs/engine-framework.md
echo "(empty above = unchanged)"
echo ""
echo "==== ls brain/ on disk ===="
ls "$REPO/brain/"
