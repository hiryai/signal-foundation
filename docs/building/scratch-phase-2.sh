#!/usr/bin/env bash
# Phase 2 verification — DW-2.1 through DW-2.5 plus the diff sanity check for DW-2.6.
set +e
REPO=/Users/ryanmus/Documents/signal-instagram

echo "=== final .gitignore content ==="
cat -A "$REPO/.gitignore"
echo

echo "=== git status (expect: exactly .gitignore modified) ==="
git -C "$REPO" status --porcelain
echo

echo "=== DW-2.1: reference/anything.md should be ignored (rule shown) ==="
git -C "$REPO" check-ignore -v reference/anything.md; echo "exit=$?"
echo

echo "=== DW-2.2: reference/.gitkeep should NOT be ignored (no output, exit non-zero) ==="
git -C "$REPO" check-ignore reference/.gitkeep; echo "exit=$?"
echo

echo "=== DW-2.3: reference/README.md should NOT be ignored ==="
git -C "$REPO" check-ignore reference/README.md; echo "exit=$?"
echo

echo "=== DW-2.4a: synthesis/anything.md should be ignored ==="
git -C "$REPO" check-ignore -v synthesis/anything.md; echo "exit=$?"
echo

echo "=== DW-2.4b: synthesis/.gitkeep should NOT be ignored ==="
git -C "$REPO" check-ignore synthesis/.gitkeep; echo "exit=$?"
echo

echo "=== DW-2.4c: synthesis/README.md should NOT be ignored ==="
git -C "$REPO" check-ignore synthesis/README.md; echo "exit=$?"
echo

echo "=== DW-2.5: ls-files of reference/ synthesis/ (expect exactly 4 paths) ==="
git -C "$REPO" ls-files reference/ synthesis/
echo

echo "=== DW-2.6 (preview): banned-term scan of staged diff ==="
git -C "$REPO" diff -- .gitignore | grep -E -i "skool|hiry|hyperframes|insta-ce|video-pipeline|aiceOS"
echo "grep exit=$? (1 = no matches = good)"
