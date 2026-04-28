#!/usr/bin/env bash
# Verify Phase 2: signal-instagram member-content gitignore
set +e
REPO=/Users/ryanmus/Documents/signal-instagram

echo "=== HEAD ==="
git -C "$REPO" log --oneline -n 3

echo ""
echo "=== git status ==="
git -C "$REPO" status

echo ""
echo "=== Files changed in HEAD ==="
git -C "$REPO" show --stat HEAD

echo ""
echo "=== .gitignore full content ==="
cat -A "$REPO/.gitignore"

echo ""
echo "=== DW-2.1: check-ignore -v reference/anything.md (expect rule reported) ==="
git -C "$REPO" check-ignore -v reference/anything.md
echo "exit=$?"

echo ""
echo "=== DW-2.2: check-ignore reference/.gitkeep (expect nothing, exit 1) ==="
git -C "$REPO" check-ignore reference/.gitkeep
echo "exit=$?"

echo ""
echo "=== DW-2.3: check-ignore reference/README.md (expect nothing, exit 1) ==="
git -C "$REPO" check-ignore reference/README.md
echo "exit=$?"

echo ""
echo "=== DW-2.4a: check-ignore -v synthesis/anything.md ==="
git -C "$REPO" check-ignore -v synthesis/anything.md
echo "exit=$?"

echo ""
echo "=== DW-2.4b: check-ignore synthesis/.gitkeep ==="
git -C "$REPO" check-ignore synthesis/.gitkeep
echo "exit=$?"

echo ""
echo "=== DW-2.4c: check-ignore synthesis/README.md ==="
git -C "$REPO" check-ignore synthesis/README.md
echo "exit=$?"

echo ""
echo "=== DW-2.5: ls-files reference/ synthesis/ ==="
git -C "$REPO" ls-files reference/ synthesis/

echo ""
echo "=== DW-2.6: banned terms grep on HEAD diff ==="
git -C "$REPO" show HEAD | grep -E -i "skool|hiry|hyperframes|insta-ce|video-pipeline|aiceOS"
echo "exit=$? (1 = no matches = pass)"

echo ""
echo "=== DW-2.7: HEAD log oneline ==="
git -C "$REPO" log --oneline -n 1

echo ""
echo "=== Slash command unchanged check ==="
git -C "$REPO" diff HEAD~1 HEAD -- .claude/commands/generate-reel.md
echo "exit=$?"
echo "(empty output means unchanged)"

echo ""
echo "=== Subdirectory edge case: reference/sub/transcript.md ==="
git -C "$REPO" check-ignore -v reference/sub/transcript.md
echo "exit=$?"

echo ""
echo "=== Files-changed-in-HEAD count ==="
git -C "$REPO" diff-tree --no-commit-id --name-only -r HEAD | wc -l

echo ""
echo "=== EOF byte check on .gitignore ==="
xxd "$REPO/.gitignore" | tail -3
