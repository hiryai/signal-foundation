# Discovery + Design: Phase 2 - Build /generate-reel slash command

## Files Found

Engine repo `/Users/ryanmus/Documents/signal-instagram/` (Phase 1 output, frozen):

- `README.md` — describes the engine, prerequisite, auto-discovery summary, invocation, and the two output fields.
- `.gitignore` — excludes `.DS_Store`, `.env`, `.env.local`, `.env.*.local`.
- `.claude/commands/` — empty directory (this phase populates it).
- `reference/README.md`, `reference/.gitkeep` — Reference layer scaffold.
- `synthesis/README.md`, `synthesis/.gitkeep` — Synthesis layer scaffold.

Foundation reference (read-only context for design):

- `/Users/ryanmus/Documents/aiceos-foundation/.claude/commands/setup-brain.md` — exact stylistic template for this phase's deliverable.
- `/Users/ryanmus/Documents/aiceos-foundation/docs/engine-framework.md` — defines the five layers and the "Pattern beats Brain" hierarchy.
- `/Users/ryanmus/Documents/aiceos-foundation/brain/brain.md` — the discovered Brain at runtime in this developer environment; ships in Foundation with `<!-- fill -->` sentinels for unfilled sections.

## Current State

Phase 1 left `.claude/commands/` empty. The engine root, the two sub-folder READMEs, the top-level README, and `.gitignore` are all in place and frozen. Privacy grep across the engine returns zero matches (verified during discovery: `grep -ri -E "skool|hiry|hyperframes|insta-ce|video-pipeline|aiceOS" ...` exit 1).

This phase needs to author exactly one new file: `.claude/commands/generate-reel.md`. No other files in the engine repo will be created or modified.

## Gaps

None between plan and reality. Phase 1 review PASSED all 8 DW items. The slash command is the only missing artifact. The DW list for Phase 2 is internally consistent and self-verifiable from the resulting file plus a privacy grep.

One subtle point worth flagging: DW-2.2's privacy constraint is stricter than the general banned-term list. The slash command body must contain neither `aiceos-foundation` nor `signal-instagram` as path strings, and must not embed any other concrete sibling folder name in the discovery algorithm. The bare word `signal` may appear in self-referential prose (e.g. naming the engine in `# /generate-reel` heading context) but not inside a path expression. The Algorithm must describe discovery generically: "the directory this command lives inside" → "its parent" → "enumerate sibling folders".

## Code Standards

No `docs/code-standards.md` in the engine repo. This is a markdown-only artifact, so no executable-code conventions apply. Style conventions taken from Foundation's `setup-brain.md`:

- YAML frontmatter with a `description:` line, opened and closed with `---`.
- `# /<command-name>` H1 immediately after the frontmatter.
- Short orientation paragraph naming what the command does and the role it plays.
- `## Algorithm` section with numbered steps, optionally sub-stepped.
- `## Hard rules` section at the bottom as a bullet list.
- Plain prose voice, no emojis.

## Test Infrastructure

N/A — markdown deliverable, no executable code. Verification is by structural reads, privacy grep, and the self-verify grep called out in DW-2.2 (`grep -E -i "aiceos-foundation|signal-instagram"` against the new file should return zero matches).

## DW Verification

| DW-ID | Done-When Item | Status | Test Cases |
|-------|----------------|--------|------------|
| DW-2.1 | `.claude/commands/generate-reel.md` exists with frontmatter `description:` line, `## Algorithm`, and `## Hard rules`, structurally matching Foundation's `setup-brain.md`. | COVERED | Read the file end-to-end; confirm frontmatter `description:` on line 2, presence of `## Algorithm` and `## Hard rules` headings. |
| DW-2.2 | Algorithm explicitly documents Foundation auto-discovery (compute parent, list siblings, first sibling whose `brain/brain.md` exists). No hardcoded folder name; in particular no `aiceos-foundation`, no `signal-instagram`, no other concrete sibling folder name in any discovery path. | COVERED | Step 2 of the Algorithm describes the parent-and-siblings walk in generic terms. Self-verify: `grep -E -i "aiceos-foundation\|signal-instagram" .claude/commands/generate-reel.md` returns zero matches. |
| DW-2.3 | Algorithm specifies exactly two output fields with the documented roles. `visual_hook`: 3–7 words for on-screen overlay, shaped by overlay conventions identified in References. `script`: full spoken script, shaped by structural moves identified in References. Pattern is whatever the references prove out. | COVERED | Step 6 (Synthesize) names the two fields, gives each a role description, and explicitly states that the structural moves come from the References at runtime, not from a hardcoded schema. |
| DW-2.4 | Hard rules include both: "Pattern beats Brain on conflict — across whatever structural elements the engine identifies in the Reference transcripts at run time, not a hardcoded multi-field schema" and "Both fields (`visual_hook` and `script`) are mandatory in every Synthesis." | COVERED | Hard rules section contains both lines verbatim. |
| DW-2.5 | Output filename is timestamped + topic-slug markdown under `synthesis/` (e.g. `synthesis/YYYY-MM-DD-HHMM-<topic-slug>.md`). File body uses simple labeled sections separating `visual_hook` and `script`. | COVERED | Step 7 (Write) defines the filename format and the labeled-section body format. |
| DW-2.6 | Friendly error messages and aborts (no file written) for: Foundation not discoverable, Brain still contains `<!-- fill -->`, `reference/` empty. | COVERED | Steps 2, 3, and 4 each include a halt-with-friendly-message branch when their precondition fails. |
| DW-2.7 | Privacy grep across the engine still returns no matches after Phase 2. | COVERED | Slash command authored without any banned term; final grep run before returning. |
| DW-2.8 | `git log --oneline` shows two commits, the second adding only `.claude/commands/generate-reel.md`. | COVERED | Only this one file is created in Phase 2; no other files are created or modified. The orchestrator handles the commit. |

**All items COVERED:** YES

## Design Decisions

### 1. Auto-discovery phrasing (DW-2.2)

The slash command must describe how to find the Foundation without naming it.

**Approach taken:** describe operations generically.

- "Take the directory the slash command file lives inside; walk up two levels to reach the engine repo root." (The slash command's own file path is `<engine-root>/.claude/commands/generate-reel.md`, so two `..` from that file gives the engine root. The Algorithm itself must not mention the literal `signal-instagram`; "engine repo root" is enough.)
- "Compute that root's parent directory."
- "Enumerate the parent's child directories deterministically (alphabetical sort) excluding the engine repo's own directory."
- "For each sibling, in order, check whether `<sibling>/brain/brain.md` exists as a file. First match wins."

The string `brain/brain.md` is fine — it's a generic file pattern within whatever folder is discovered, not a hardcoded sibling folder name. The plan constraint and the engine's own README both already use this exact path.

**Alternatives considered:**

- *Walk up looking for any directory containing `brain/brain.md` anywhere in the ancestor tree.* Rejected: the plan and the engine README both say "sibling folder", not "ancestor". Members place the Foundation alongside the engine, not as a parent.
- *Read an environment variable for the Foundation path.* Rejected: adds configuration the README does not promise; auto-discovery is the contract.
- *Hardcode a list of likely Foundation folder names and probe each.* Rejected: explicitly forbidden by DW-2.2.

### 2. Output file format (DW-2.5)

**Three approaches considered:**

- **A. YAML frontmatter** — both fields as `visual_hook:` and `script:` keys in a frontmatter block, body empty. Machine-parseable cleanly. Rejected: heavyweight for v1, awkward for a multi-paragraph `script` value, and v1 is text-only — no automation has been built yet, so no need to commit to YAML.
- **B. H2 labeled sections** — `## visual_hook` followed by the value on the next line, then `## script` followed by the value below. Markdown-native, matches the engine's voice, and downstream automation can split on `\n## script\n` to extract the script body. Picked.
- **C. Plain key-value lines** — `visual_hook: <value>` then `script: <value>`. Rejected: ambiguous when the script contains line breaks; a multi-paragraph script can't fit on one line cleanly.

**Chosen format (Option B):**

```
# Reel: <topic-as-typed>

Generated: YYYY-MM-DD HH:MM

## visual_hook

<3 to 7 word overlay line>

## script

<full spoken script as one continuous text>
```

Rationale:
- The `# Reel: <topic>` H1 anchors the file to its run.
- `Generated:` line is a human-readable timestamp matching the filename's prefix.
- Each field gets its own H2 with the field's exact name (`visual_hook`, `script`) as the heading. Downstream automation parses by splitting on these section headings; humans read it as plain markdown.

What's sacrificed from each parent: lost YAML's strict machine-parseability (Option A) and lost key-value's compactness (Option C). Gained Markdown-nativeness and clean separation of multi-paragraph values.

### 3. Topic slug rules (DW-2.5)

The filename uses `<topic-slug>` derived from the topic argument. Slug rules:

- Lowercase the topic.
- Replace any run of non-alphanumeric characters with a single hyphen.
- Trim leading and trailing hyphens.
- Cap length at 60 characters (cut at the last hyphen boundary that fits).
- If the result is empty (e.g. topic was all punctuation), fall back to the literal slug `untitled`.

These rules are documented in the Algorithm so the running session is deterministic across runs.

### 4. Timestamp format (DW-2.5)

`YYYY-MM-DD-HHMM` in the local timezone of the running session. No seconds; minute granularity is enough to keep filenames distinct for any human-paced workflow, and short filenames are preferable to long ones. If two runs collide within the same minute (rare), the second run appends `-2`, then `-3`, etc., to the slug.

### 5. Reference file filtering

When validating that `reference/` is non-empty, the session counts only files that match the supported transcript shape:

- Extension `.txt` or `.md`.
- Excludes `README.md` (engine docs, not a transcript).
- Excludes `.gitkeep` and any dotfile.

If the filtered list is empty, the friendly error fires. If non-empty, every file in the filtered list is read and treated as a transcript.

### 6. Brain unfilled detection

Brain is "unfilled" iff its body anywhere contains the literal sentinel `<!-- fill -->`. This matches `setup-brain.md`'s rule and matches the plan constraint. A Brain with all five sections filled but a stray sentinel still counts as unfilled — the friendly error tells the operator to run `/setup-brain` in the Foundation to finish populating it.

### 7. Hard rules content (DW-2.4)

Two rules MUST appear, verbatim or as plain restatements:

- "Pattern beats Brain on conflict — across whatever structural elements the engine identifies in the Reference transcripts at run time, not a hardcoded multi-field schema."
- "Both fields (`visual_hook` and `script`) are mandatory in every Synthesis."

Both will be included verbatim. Additional Hard rules to add (justifications inline):

- *Walk the algorithm in order; do not skip steps.* Mirrors `setup-brain.md` style and prevents the running session from short-circuiting validation.
- *Auto-discovery scans siblings; do not hardcode any folder name.* Reinforces DW-2.2 at runtime.
- *Never invent transcript content. Pattern is extracted from the actual files in `reference/`, not from training-data assumptions about Reels.* Prevents the model from filling gaps in the Reference layer with invented examples — which would defeat the entire engine.
- *Writeable scope is `synthesis/` only. Never write to `reference/`, never write to the discovered `brain/`, never write to any sibling folder.* Reinforces the engine's single-output contract and the read-only treatment of Brain.
- *The discovered `brain/brain.md` is read-only from this engine.* Direct restatement of a plan constraint.
- *On any abort path, do not write a Synthesis file.* Direct restatement of DW-2.6.

### 8. Empty-topic handling

If the operator runs `/generate-reel` with no topic argument (or only whitespace), the session prints a one-line usage hint and aborts. This is not in the DW list, but the algorithm sketch says "Empty topic → friendly usage error" and the slash command would be broken without it. Treating this as part of "parse topic" rather than a fourth abort path so the friendly-error count of three (Foundation, Brain, Reference) stays clean.

## Prerequisites

- [x] Engine root exists at `/Users/ryanmus/Documents/signal-instagram/`.
- [x] `.claude/commands/` directory exists and is empty.
- [x] Phase 1 review PASSED, all 8 DW items satisfied.
- [x] Privacy grep currently returns zero matches.
- [x] Foundation `setup-brain.md` style template available.

No missing prerequisites.

## Recommendation

BUILD. Author `.claude/commands/generate-reel.md` according to the design above. Self-verify against DW-2.1 through DW-2.7 by reading the file and running the two grep checks (`skool|hiry|hyperframes|insta-ce|video-pipeline|aiceOS` across the engine, and `aiceos-foundation|signal-instagram` against the new file). DW-2.8 is the orchestrator's commit step — return control after the file is written.
