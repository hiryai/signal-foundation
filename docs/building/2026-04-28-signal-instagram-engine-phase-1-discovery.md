# Discovery + Design: Phase 1 - Scaffold the engine repo

## Files Found

The target directory `/Users/ryanmus/Documents/signal-instagram/` does not exist yet. Parent `/Users/ryanmus/Documents/` does exist and contains the sibling Foundation repo at `/Users/ryanmus/Documents/aiceos-foundation/`.

Foundation style references read:
- `/Users/ryanmus/Documents/aiceos-foundation/README.md` — top-level README voice and section ordering
- `/Users/ryanmus/Documents/aiceos-foundation/brain/README.md` — sub-folder README voice (layer description + how-to)
- `/Users/ryanmus/Documents/aiceos-foundation/reference/README.md` — sub-folder README voice (what-goes-in + organization)
- `/Users/ryanmus/Documents/aiceos-foundation/.gitignore` — gitignore style
- `/Users/ryanmus/Documents/aiceos-foundation/docs/engine-framework.md` — five-layer framework definitions

## Current State

Greenfield. No files, no directory. We create everything from scratch.

## Gaps

None. The plan's IN-scope is fully achievable as written. Phase 1 is pure scaffolding: directory creation + four prose files + two `.gitkeep` markers.

## Code Standards

No `docs/code-standards.md` found in the parent Foundation repo. Phase is markdown-only — no code conventions to apply. Prose conventions inherited from Foundation style references:
- Lowercase opening of headings ("What this layer is for"), sentence case for sub-headings
- Bold lead-in for key claims (`**Job.**`, `**Produced by.**` style in framework doc; `**Quality over quantity.**` style in reference README)
- Code-fenced shell snippets when invoking commands
- Backticked file paths and folder names in inline prose
- Section ordering follows reader-journey: what it is, what goes in, how to use, what NOT to do

## Test Infrastructure

N/A — markdown scaffold. Verification is by file-existence checks, privacy grep, and structural reads. The plan's Test Plan (T-1..T-5) covers Phase 2 completion; Phase 1 verification reduces to DW-1.1, DW-1.3, DW-1.4, DW-1.5, DW-1.6, DW-1.7, DW-1.8 (DW-1.2 happens after the orchestrator runs `git init`).

## DW Verification

| DW-ID | Done-When Item | Status | Test Cases |
|-------|---------------|--------|------------|
| DW-1.1 | Directory layout exists: `README.md`, `.gitignore`, `.claude/commands/`, `reference/{README.md,.gitkeep}`, `synthesis/{README.md,.gitkeep}` | COVERED | `mkdir -p` for all directories; `Write` for each file; final `find` listing confirms exact layout. |
| DW-1.2 | `git log --oneline` shows exactly one commit | COVERED | The orchestrator runs `git init` and the initial commit after this BUILD returns. Our job is to leave the tree in a state where one commit captures all scaffolded files. We do not run git ourselves. |
| DW-1.3 | Privacy grep returns no matches for `skool\|hiry\|hyperframes\|insta-ce\|video-pipeline\|aiceOS` | COVERED | Manual prose audit during authoring; final grep run as last step of Phase 2 implementation to confirm. The README refers to "the Foundation" as a proper noun and "the engine framework" generically. |
| DW-1.4 | `reference/` and `synthesis/` each contain only `.gitkeep` and `README.md` | COVERED | We write exactly those two files in each folder; nothing else. `ls -A` confirms. |
| DW-1.5 | Top-level `README.md` covers, in order: what this engine does; the prerequisite (Foundation as sibling with `brain/brain.md` populated); auto-discovery one-liner; how to drop transcripts into `reference/`; how to invoke `/generate-reel <topic>`; the two output fields (`visual_hook` 3–7 words for on-screen overlay; `script` full spoken Reel script) | COVERED | README authored with explicit sections in this exact order. Headings: "What this engine does", "Prerequisite", "How auto-discovery works", "Drop in your Reel transcripts", "Generate a Reel", "What the engine outputs". Final read-through against DW-1.5 checklist. |
| DW-1.6 | `reference/README.md` describes Reel transcripts as plain text or markdown, one file per transcript, no creator/brand/platform terms beyond "Instagram Reel" and "transcript" | COVERED | Authored to mention only "Instagram Reel" and "transcript". No creator names, no other platform names. Manual lexicon audit. |
| DW-1.7 | `synthesis/README.md` describes one timestamped file per `/generate-reel` run; notes folder is engine-managed | COVERED | Authored with two short sections: "What gets written here" (timestamped file per run) and "Engine-managed" (do not edit by hand). |
| DW-1.8 | `.gitignore` excludes `.DS_Store`, `.env`, `.env.local`, `.env.*.local` at minimum | COVERED | `.gitignore` contains all four entries. Foundation's `.gitignore` includes a `docs/plans/` line that is Foundation-specific; the engine's gitignore does NOT need that line (the engine has no `docs/plans/`). |

**All items COVERED:** YES

## Design Decisions

### README.md section ordering and voice

**Constraint:** DW-1.5 fixes the section order. Six topics, in this order: what the engine does, prerequisite, auto-discovery one-liner, transcripts into reference, invocation, two output fields.

**Three approaches considered:**

1. **Flat numbered steps mirroring Foundation's "If you just cloned this".** Pro: members coming from Foundation recognize the pattern; the on-ramp shape is familiar. Con: the engine's flow is not a five-step on-ramp — it is a description plus a single command. Forcing five numbered steps would pad and read as ceremony.

2. **Topic sections with H2 headings (chosen).** Pro: reads as a reference card matching the framework doc's voice (`docs/engine-framework.md`), which is heading-per-concept; lets each DW-1.5 item land in its own section so a reviewer can map sections to the DW item one-for-one. Con: slightly less prescriptive than numbered steps.

3. **Single long prose blob.** Pro: shortest. Con: DW-1.5 requires six items in a specific order — sections enforce that visibly; prose hides the order check from a reviewer.

**Chosen:** option 2. Six H2 sections in DW-1.5 order. The "How auto-discovery works" section is exactly one line per the DW spec ("a one-line statement"). Each section title maps cleanly to a DW-1.5 item, which makes review trivial.

### Privacy lexicon — what to call the Foundation

**Constraint:** DW-1.3 forbids `skool`, `hiry`, `hyperframes`, `insta-ce`, `video-pipeline`, `aiceOS`. Foundation's own README uses `aiceOS` and `aiceos-foundation` — we cannot copy that voice directly.

**Chosen substitutions:**
- "the Foundation" (capitalized proper noun) — when referring to the sibling repo abstractly
- "the Foundation repo" — when concretely referring to the directory
- "the engine framework" or "the five-layer engine framework" — when referring to the framework doc concept
- `brain/brain.md` — the file pattern, generic
- "this engine" or `signal-instagram` — self-reference (allowed; the engine's own name is not a sibling reference)

The README will not name Foundation's directory (`aiceos-foundation`) explicitly, since that contains `aiceOS` as a substring and would trip DW-1.3.

### reference/README.md vocabulary lock

**Constraint:** DW-1.6 permits only "Instagram Reel" and "transcript" as platform/format terms; no creator names, no other platform terms.

**Decision:** Keep the file short. One paragraph on "what to drop in", one on "format" (plain text or markdown, one file per transcript), one on "what the engine does with it" (extracts Pattern at run time). No examples that would tempt a creator name. No mention of TikTok, Shorts, YouTube, etc.

### synthesis/README.md scope

**Constraint:** DW-1.7 requires two things: timestamped-file-per-run description, and engine-managed note.

**Decision:** Two short H2 sections. "What gets written here" describes the per-run timestamped markdown file. "Engine-managed" tells the member not to hand-edit and that the slash command (introduced in Phase 2) writes here. No need to describe the file's internal format — that's Phase 2's slash command's contract.

### `.claude/commands/` empty directory persistence

**Constraint:** Git does not track empty directories. The plan calls for an empty `.claude/commands/` in Phase 1, and Phase 2 will add `generate-reel.md` to it. The plan does NOT list a `.gitkeep` for `.claude/commands/`.

**Decision:** Create the directory with `mkdir -p` only. Do not add a `.gitkeep`. Rationale: Phase 2 will populate the directory with `generate-reel.md`, which is the next commit. Between Phase 1's commit and Phase 2's commit, the directory will not be tracked — but the plan explicitly says Phase 2 adds the file, so the directory is transient-empty by design. Adding a `.gitkeep` would create a stale marker file that Phase 2 would never remove. The plan's IN-scope for Phase 1 lists "empty `.claude/commands/` directory" without a `.gitkeep`, confirming this read.

DW-1.1 lists `.claude/commands/` (a directory) but not `.claude/commands/.gitkeep` (a file) — consistent with the no-`.gitkeep` decision. The directory will exist on disk after Phase 1's `mkdir`; whether git tracks it before Phase 2 is irrelevant to DW-1.1 (which checks the layout, not the git index).

### `.gitignore` contents

**Constraint:** DW-1.8 requires the four exclusions at minimum.

**Decision:** Keep it tight. Only the four required entries plus the OS noise comment style Foundation uses. Do NOT include Foundation's `docs/plans/` line — the engine has no `docs/plans/` folder and adding speculative ignore rules is noise. Comment groupings mirror Foundation's gitignore: an "OS noise" group and a "Local environment" group.

## Prerequisites
- [x] Parent directory `/Users/ryanmus/Documents/` exists
- [x] Foundation style references readable
- [x] Plan file readable
- [x] DW items fully scoped to file-creation work; no external dependencies

## Recommendation
**BUILD** — proceed to implementation. Greenfield scaffold, all DW items COVERED, design decisions resolved.
