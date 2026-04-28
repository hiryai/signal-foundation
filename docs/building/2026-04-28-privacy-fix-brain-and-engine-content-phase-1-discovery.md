# Discovery + Design: Phase 1 - Foundation template/fill split for brain.md

## Files Found

- `/Users/ryanmus/Documents/aiceos-foundation/brain/brain.md` — exists, 65 lines, tracked. Five sections (Expertise, Audience, Voice, Offers, Beliefs) each with structural prompts and a `<!-- fill -->` sentinel.
- `/Users/ryanmus/Documents/aiceos-foundation/brain/README.md` — exists, 38 lines, tracked. Has a "How to fill it" section ending at line 31 ("Editing `brain.md` directly is not the supported path…"), then a "What an engine does with your Brain" section.
- `/Users/ryanmus/Documents/aiceos-foundation/.claude/commands/setup-brain.md` — exists, 128 lines, tracked. Algorithm currently has Steps 1–4 (Read, Greet and detect, Walk the five sections, End-of-flow confirmation). Step 3 contains substep 3a (unfilled branch) and 3b (already-populated branch). Step 3a contains the phrase "as in 3a" (line 59) — verified the only internal step-number reference. Hard rules block at lines 118–127 contains the malformed-template rule on line 126.
- `/Users/ryanmus/Documents/aiceos-foundation/.gitignore` — exists, 10 lines, tracked. Uses comment-heading style: `# Local plan files — not part of the shipped repo`, `# OS noise`, `# Local environment`. Each comment header is followed by one or more pattern lines, with blank lines between groups.

## Current State

- `brain/brain.md` ships as a template with `<!-- fill -->` sentinels in every section. It is currently tracked.
- `/setup-brain` command reads/writes `brain/brain.md` directly, with no template/fill split.
- `.gitignore` does not exclude `brain/brain.md`.
- `brain/README.md` does not mention the template/fill split (because it does not exist yet).

## Gaps

- The plan introduces a template/fill split that does not exist in the current codebase.
- The bootstrap step (new Step 1) does not exist — must be inserted.
- The malformed-template Hard rule (line 126) currently treats "brain.md does not exist" as a malformed condition; this contradicts the new bootstrap behavior and must be narrowed.
- Internal reference "as in 3a" on line 59 must be renumbered to "as in 4a" after Step 3 → Step 4 renumber.
- Plan mentions "Section 3.1" — searched the file, no such literal string exists. The plan's "Section 3.1" reference appears to be an imprecise label for substep 3a/3b. The DW item DW-1.6 only requires renumbering of the existing sub-references; the only one in the file is "as in 3a" → "as in 4a".

## Code Standards

No `docs/code-standards.md` found at project root. This phase is a markdown + gitignore + slash-command-prompt edit; no executable code. Convention inferred from existing files:

- `.gitignore` uses `# Comment heading` style with blank lines between groups.
- Slash command algorithm uses `### Step N. <Name>` heading style.
- README prose uses plain markdown headings, no emojis.
- File preserves trailing newline.

## Test Infrastructure

N/A — this phase produces no executable code. Verification is by `git ls-files`, `git status`, byte-comparison of template content, and direct file inspection per DW-1.9.

## DW Verification

| DW-ID | Done-When Item | Status | Test Cases |
|-------|----------------|--------|------------|
| DW-1.1 | `git ls-files brain/brain.md` empty after rename | COVERED | After `git mv`, run `git ls-files brain/brain.md` — expect empty. Verified in post-edit `git status` showing `renamed: brain/brain.md -> brain/brain.md.template`. |
| DW-1.2 | `git ls-files brain/brain.md.template` returns the path | COVERED | After `git mv`, run `git ls-files brain/brain.md.template` — expect the path. |
| DW-1.3 | Rename event recorded (orchestrator-side post-commit) | COVERED | I confirm via `git status` that the rename is staged (the file is recognized as a rename, not delete+add). The post-commit `git log` check is the orchestrator's. |
| DW-1.4 | `.gitignore` contains `brain/brain.md` under a clear comment heading | COVERED | After edit, read `.gitignore` and confirm a comment heading like `# Member-private filled brain — bootstrapped from brain.md.template on first /setup-brain run` followed by `brain/brain.md`. |
| DW-1.5 | `brain.md.template` byte-identical to pre-rename `brain.md` | COVERED | `git mv` preserves byte content. Verified by reading both pre- and post-rename content. No edits to file content during this phase. |
| DW-1.6 | New Step 1 + renumber + Hard rule narrowing | COVERED | Insert new Step 1 with three branches (exists / missing-and-bootstrap / both-missing-and-abort); renumber Steps 1→2, 2→3, 3→4, 4→5; update line 59 "as in 3a" → "as in 4a"; replace malformed-template Hard rule with the narrowed wording. Verified by reading the resulting file. |
| DW-1.7 | `brain/README.md` paragraph explains template/fill split | COVERED | Append a 3–5 sentence paragraph at the end of the "How to fill it" section explaining: ships as `brain.md.template`; `/setup-brain` creates `brain.md` on first run; `brain.md` is gitignored; template stays tracked as on-ramp. |
| DW-1.8 | Orchestrator-side commit verification | N/A | Skipped per dispatch (orchestrator handles commit). |
| DW-1.9 | Bootstrap Step 1 inspection: reads template; writes verbatim; one side effect; one-line confirmation; missing-template aborts cleanly | COVERED | Bootstrap step prose explicitly: (a) reads `brain/brain.md.template`; (b) writes contents verbatim to `brain/brain.md` with no transformation/slug/substitution; (c) single side effect (one new file); (d) one-line confirmation message named in the prose; (e) both-missing branch aborts with friendly error and writes nothing. |

**All items COVERED:** YES (DW-1.8 explicitly orchestrator-side, marked N/A per dispatch).

## Design Decisions

### Bootstrap Step 1 wording

The new Step 1 is purely descriptive prose (not executable code) telling the LLM running the command what to do. Three branches:

1. `brain/brain.md` exists → proceed to Step 2.
2. `brain/brain.md` does not exist AND `brain/brain.md.template` exists → read template, write its full contents verbatim to `brain/brain.md`, tell operator one line ("Initialized brain.md from template — walking you through it now."), proceed to Step 2.
3. Both files missing → abort with friendly error: "I can't find brain/brain.md OR brain/brain.md.template in this repo. The Foundation may be malformed; reinstall and try again."

Verbatim copy is explicitly called out (no transformation, no slug, no substitution) to satisfy DW-1.9(b).

### Hard rule narrowing

Old rule (line 126):
> If `brain/brain.md` does not exist or is missing one of the five `## <SectionName>` headings, stop and tell the operator the template is malformed. Do not attempt to repair it; that is not this command's job.

New rule (per dispatch wording):
> If `brain/brain.md.template` is missing one of the five `## <SectionName>` headings, or if `brain/brain.md` is missing one of the five `## <SectionName>` headings after the bootstrap step has run, stop and tell the operator the template is malformed. Do not attempt to repair it; that is not this command's job. (The bare-not-exist case for `brain/brain.md` is handled by Step 1 and is not a malformed-repo condition.)

### Internal reference renumber

Line 59 currently reads `…and write back exactly as in 3a (replacing the existing body)`. After Step 3 → Step 4 renumber, substep 3a becomes 4a. Update to `…as in 4a`. No other internal step-number references exist in the file (verified by inspection).

### `.gitignore` comment heading

Use a single comment line consistent with the existing style:

```
# Member-private filled brain — bootstrapped from brain.md.template on first /setup-brain run
brain/brain.md
```

Placed at the end of the file with a blank line separating it from the previous group, matching the existing inter-group spacing.

### `brain/README.md` paragraph placement

Append at the end of the existing "How to fill it" section, after the existing line "Editing `brain.md` directly is not the supported path. Use `/setup-brain` rather than typing into the file." (line 31), before the next `##` heading. This is the natural place because the paragraph explains the file lifecycle that `/setup-brain` initiates.

Paragraph (4 sentences):

> The file ships as `brain.md.template`, not `brain.md`. The first time you run `/setup-brain`, the command bootstraps `brain.md` by copying the template verbatim, then walks you through filling it. `brain.md` is gitignored so your filled answers stay local to your clone and are not committed to the shared Foundation repo. The template stays tracked because it is the on-ramp every new clone needs to get started.

### Rename mechanics

Use `git mv` (not `mv` + `git add`) so the rename is recorded explicitly and Git's `--diff-filter=R` post-commit verification (DW-1.3) succeeds independently of similarity-scoring.

## Prerequisites

- [x] `brain/brain.md` exists at the repo root (verified).
- [x] `brain/README.md` exists (verified).
- [x] `.gitignore` exists (verified).
- [x] `.claude/commands/setup-brain.md` exists (verified).
- [x] Working tree clean before edits (verified).

## Recommendation

BUILD — all prerequisites met, all DW items mappable to specific edits, no skip conditions, no plan-vs-reality gaps requiring UPDATE_PLAN.
