# Discovery + Design: Phase 1 - Repo skeleton + Reference scaffold + brain.md template

## Files Found

Working directory `/Users/ryanmus/Documents/aiceos-foundation/` currently contains:

- `docs/plans/2026-04-27-foundation-build.md` — the plan being executed

Nothing else. No `.git/`, no `README.md`, no top-level dirs, no `.gitignore`. This matches the plan's stated starting state ("NOT a git repo yet. Phase 1 starts with `git init`").

## Current State

Empty greenfield. Phase 1 must create everything in scope from first principles.

## Gaps

None between plan and reality. The dispatch prompt is unambiguous about scope and explicitly forbids deriving structure from `/Documents/aiceOS/`, `insta-ce`, or `video-pipeline`.

One ambiguity resolved by design: the Phase 1 scope description in the dispatch prompt mentions the Reference README should describe "suggested organization across `creators/` and `posts/` subfolders," while the plan file body (line 61) says "suggested organization" without naming the subdirs. The DW items (DW-1.2) explicitly require `creators/.gitkeep` and `posts/.gitkeep`, so the dispatch prompt's wording wins — README must name both.

## Code Standards

No `docs/code-standards.md` found in `/Users/ryanmus/Documents/aiceos-foundation/`. Phase produces only markdown content + directory scaffold; no code conventions apply. The grep-clean constraint (DW-1.4) is the dominant standard for this phase.

## Test Infrastructure

No automated tests for this repo. Per the plan ("Test Coverage: Manual verification, inspection-based checks"), verification is grep + file-existence + structural checks only. For this phase the verification gates are:

- `test -d` / `test -f` for the structural DW-1.1 / DW-1.2 / DW-1.3 file-existence checks
- `ls` for the "exactly N entries" checks in DW-1.2 and DW-1.3
- `grep -c "^## "` to count the five required headings in `brain.md`
- `grep -F "<!-- fill -->"` to confirm the sentinel appears in each of the five sections
- `grep -rEi "ryan|skool|hiry|hyperframes|insta-ce|video-pipeline|aiceOS\/|\$[0-9]"` for the cleanliness gate (DW-1.4)

## DW Verification

| DW-ID | Done-When Item | Status | Verification |
|-------|----------------|--------|--------------|
| DW-1.1 | Repo is git-initialized with top-level `README.md`, `/reference/`, `/brain/`, `/docs/`, `/.claude/commands/`, and `.gitignore` | COVERED | `test -d .git && test -f README.md && test -f .gitignore && test -d reference && test -d brain && test -d docs && test -d .claude/commands` |
| DW-1.2 | `/reference/` contains exactly `README.md`, `creators/.gitkeep`, `posts/.gitkeep`; README explains the layer's role + how to add URLs / transcripts / screenshots | COVERED | `ls reference/` returns 3 entries; `grep -E "URL\|transcript\|screenshot" reference/README.md` returns matches; README mentions "five-layer" and "Reference" |
| DW-1.3 | `/brain/` contains exactly `README.md`, `brain.md`; `brain.md` has the five required `##` headings, each section contains `<!-- fill -->`; `/brain/README.md` directs operator to `/setup-brain` rather than hand-edit | COVERED | `ls brain/` returns 2 entries; `grep -c "^## " brain/brain.md` equals 5; each of the five expected headings present; sentinel count equals 5 (one per section); `grep "/setup-brain" brain/README.md` matches; README contains an explicit "do not edit by hand" instruction |
| DW-1.4 | Forbidden-token grep against `/reference/` and `/brain/` returns zero matches | COVERED | `grep -rEi "ryan\|skool\|hiry\|hyperframes\|insta-ce\|video-pipeline\|aiceOS\/\|\$[0-9]" reference/ brain/` exits 1 (no matches) |

**All items COVERED:** YES

## Design Decisions

### Design A vs B for `brain.md` section structure (chosen B)

**A: Heavy prose prompts per section.** Each section is a multi-paragraph self-documenting brief — purpose paragraph, 5-7 question bullets, sentinel.

**B: Minimal structural prompts per section.** Each section is one purpose line, a short bullet list of micro-questions, sentinel.

**Comparison:**

| Criterion | A (heavy) | B (minimal) |
|-----------|-----------|-------------|
| Interface simplicity | Loses — verbose | Wins — `/setup-brain` sees a clean replace block |
| Information hiding | Loses — duplicates content that belongs in `/brain/README.md` and the framework doc | Wins — heavy explanation lives in README + framework doc |
| Operator-by-hand readability | Wins | Loses — terse |
| DW-1.4 grep risk | Loses — more prose surface | Wins — less prose surface |
| Sentinel boundary clarity for Phase 2 | Loses — sentinel buried in prose | Wins — sentinel is the obvious "below this is unfilled" marker |

**Choice: B.** The plan explicitly says "Members populate `brain.md` via a guided slash command (`/setup-brain`)... not edit the file by hand" (plan line 26). The hand-readability advantage of A is therefore worthless — the by-hand path is contraindicated. B wins on every other criterion. Sacrificed from A: rich self-explanation; mitigated by `/brain/README.md` carrying the explanation and pointing to `/setup-brain`.

### Design A vs B for sentinel placement (chosen A — end-of-section)

**A: Sentinel at the END of each section's prompts, on its own line.**
**B: Sentinel right after the heading, before the prompts.**

A wins because it acts as a natural "cut line." The `/setup-brain` command (Phase 2) will replace from the `## Heading` line through the sentinel line with the operator's answer. End-placement maps exactly to that span. B would split the prompts across the sentinel, awkward for replacement.

### Design for `.gitignore`

Plan-required entries: `docs/plans/`, `.DS_Store`, `.env`.
Defensive additions (low-risk, common-sense): `.env.local`, `.env.*.local`. These are not in the plan but are universal Node/CC-app conventions for local-only env files; since the repo will eventually host engine modules they'll be needed. Not adding anything else (no `node_modules/`, no `dist/`, etc. — out of scope, can be added when needed).

### Design for `/reference/README.md` content shape

Sections:
1. Purpose — what the Reference layer is in the five-layer engine framework
2. What goes in here — URLs, transcripts, screenshots of winning examples from creators in your niche
3. Suggested organization — `creators/` (one folder per creator with their best examples) and `posts/` (one file per individual standout piece)
4. How an engine uses this — engines read this folder when extracting Patterns
5. What does NOT go here — your own voice/expertise/offers (those are in `/brain/`)

### Design for `/brain/README.md` content shape

Sections:
1. Purpose — what the Brain layer is
2. The five sections of `brain.md`
3. How to fill it — `/setup-brain` slash command (NOT hand-editing); explicit warning
4. What an engine does with it — read at generation time, combined with Pattern to produce Synthesis

### Design for top-level `README.md` (scaffold only)

Plan says "scaffold only — section headers + intro placeholder; full body in Phase 3." So:
- H1 title
- One-line intro placeholder
- Empty section headers for: Setup, Framework, Brain, Reference, First Engine
- A note that the body is filled in Phase 3

This avoids any operator-specific or example content that could trip DW-1.4 in later phases.

## Prerequisites

- [x] Target directory exists (`/Users/ryanmus/Documents/aiceos-foundation/`)
- [x] Plan file exists at expected path
- [x] `git` is available (standard macOS tool, will be invoked)
- [x] No prior phase outputs required

## Recommendation

**BUILD** — proceed to implement all artifacts in scope.
