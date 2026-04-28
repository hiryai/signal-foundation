# Discovery + Design: Phase 2 — signal-instagram member-content gitignore

## Files Found
- `/Users/ryanmus/Documents/signal-instagram/.gitignore` (8 lines: OS noise + Local environment sections)
- `/Users/ryanmus/Documents/signal-instagram/reference/.gitkeep` (tracked, empty)
- `/Users/ryanmus/Documents/signal-instagram/reference/README.md` (tracked, 1966 bytes)
- `/Users/ryanmus/Documents/signal-instagram/synthesis/.gitkeep` (tracked, empty)
- `/Users/ryanmus/Documents/signal-instagram/synthesis/README.md` (tracked, 948 bytes)

## Current State
- Working tree clean. `git ls-files reference/ synthesis/` returns exactly the four expected paths.
- `.gitignore` currently contains only two short sections — `# OS noise` and `# Local environment` — separated by one blank line, terminated by a single trailing newline (no trailing blank line).
- No untracked Reel transcripts or Synthesis files currently exist on disk; this phase is preventive (the gitignore patterns will activate the moment a member or the engine drops a file into either folder).

## Gaps
- No member-private patterns yet. Without this phase, `git add -A` after a member drops `reel-123.txt` into `reference/`, or after the engine writes `2026-04-28-synthesis.md` into `synthesis/`, would stage that file. This phase closes that gap with a `whitelist`-style block (`folder/*` + `!folder/.gitkeep` + `!folder/README.md`).

## Code Standards
No `docs/code-standards.md` exists in the signal-instagram repo. Style match for `.gitignore` is: short comment heading prefixed with `# `, entries one per line, blank line between sections, no trailing blank line.

## Test Infrastructure
No test framework — verification is `git check-ignore` and `git ls-files` on the live repo (the orchestrator runs these as part of DW-2.1 through DW-2.5 after this change).

## DW Verification

| DW-ID | Done-When Item | Status | Test Cases |
|-------|----------------|--------|------------|
| DW-2.1 | `git check-ignore -v reference/anything.md` reports the matching rule (file is ignored) | COVERED | `reference/*` pattern matches any non-whitelisted file. Verify with `git check-ignore -v reference/anything.md` after edit. |
| DW-2.2 | `git check-ignore reference/.gitkeep` returns nothing AND exits non-zero | COVERED | `!reference/.gitkeep` re-includes the marker. Verify with `git check-ignore reference/.gitkeep`. |
| DW-2.3 | `git check-ignore reference/README.md` returns nothing AND exits non-zero | COVERED | `!reference/README.md` re-includes the README. Verify with `git check-ignore reference/README.md`. |
| DW-2.4 | Same three checks for `synthesis/anything.md`, `synthesis/.gitkeep`, `synthesis/README.md` | COVERED | Mirror block for `synthesis/*`, `!synthesis/.gitkeep`, `!synthesis/README.md`. Verify with three matching `git check-ignore` calls. |
| DW-2.5 | `git ls-files reference/ synthesis/` returns exactly four paths | COVERED | Already true pre-edit; gitignore changes affect future staging only, so this stays true. Verify with `git ls-files reference/ synthesis/` after edit. |
| DW-2.6 | Diff has no banned terms (`skool|hiry|hyperframes|insta-ce|video-pipeline|aiceOS`) | COVERED | The six-line block uses only `reference/`, `synthesis/`, `.gitkeep`, `README.md`, plus a generic comment heading. None of these are banned. Verify with `git diff \| grep -E -i ...` returning zero matches. (Orchestrator runs this on the committed diff downstream.) |
| DW-2.7 | One new conventional-commit at HEAD in `chore(engine):` or `feat(engine):` family | COVERED — orchestrator-side | Not the build agent's job; the orchestrator commits after this phase returns. The agent leaves the staged diff clean and minimal so the orchestrator can commit it as one logical change. |

**All items COVERED:** YES

## Design Decisions

The pattern shape — `folder/*` followed by negation lines `!folder/.gitkeep` and `!folder/README.md` — is the canonical git idiom for the "ignore everything in this folder except these two files" requirement. There is no meaningful design alternative worth a design-it-twice comparison:

- An alternative `folder/**/*` (recursive) would also work, but the requirement is a flat folder of dropped files; `folder/*` is sufficient and more conservative.
- An alternative whitelist approach (`*` then `!folder/`) would be wrong — it would ignore everything else in the repo too.

So the only real choice is comment heading wording. The plan suggests `# Member-private content — transcripts dropped in reference/, synthesis files written by the engine`. That heading is precise (says WHAT and gives the WHY for both folders in one line), matches the existing `.gitignore`'s short-comment style, and contains no banned terms. Adopting it as-is.

Whitespace: place one blank line between the existing `Local environment` block and the new section, one blank line between the `reference/*` and `synthesis/*` sub-blocks, and no trailing blank line after `!synthesis/README.md` (matching the existing file's terminal style — single newline at EOF).

## Prerequisites
- [x] `.gitignore` exists at `/Users/ryanmus/Documents/signal-instagram/.gitignore`
- [x] Both `reference/` and `synthesis/` exist with `.gitkeep` and `README.md` already tracked
- [x] Working tree clean (no other pending changes to confuse the diff)

## Recommendation
**BUILD** — append the six-line block (plus a one-line comment heading) to `.gitignore`. No other files touched. Orchestrator commits after return.
