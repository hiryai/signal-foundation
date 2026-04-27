# Discovery + Design: Phase 3 — Engine framework doc + Claude Code setup + finalize README

## Files Found

- `/Users/ryanmus/Documents/aiceos-foundation/README.md` — scaffold from Phase 1, will be replaced
- `/Users/ryanmus/Documents/aiceos-foundation/brain/README.md` — Phase 1 (tone reference)
- `/Users/ryanmus/Documents/aiceos-foundation/brain/brain.md` — Phase 1 (referenced by setup-brain)
- `/Users/ryanmus/Documents/aiceos-foundation/reference/README.md` — Phase 1 (tone reference)
- `/Users/ryanmus/Documents/aiceos-foundation/.claude/commands/setup-brain.md` — Phase 2 (defines the `/setup-brain` flow the README forwards to)
- `/Users/ryanmus/Documents/aiceos-foundation/.gitignore` — excludes `docs/plans/`, `.DS_Store`, `.env*`
- `/Users/ryanmus/Documents/aiceos-foundation/docs/` — exists, contains only `plans/` and `building/`. The two new shipped docs are the first members of `/docs/`.

## Current State

Phase 1 and Phase 2 are committed. The repo currently ships:

- Scaffold `README.md` with stub sections for Setup / Framework / Brain / Reference / Your First Engine
- `/brain/brain.md` (5 sections, `<!-- fill -->` sentinels) and `/brain/README.md`
- `/reference/README.md` plus `creators/.gitkeep` and `posts/.gitkeep`
- `/.claude/commands/setup-brain.md` — guided Brain population command

What is missing for a clone-and-go member experience:
- The engine framework doc (the conceptual map of the five layers)
- The Claude Code zero-to-working setup walkthrough
- A real README that links these together as an ordered on-ramp

## Gaps

| Gap | Resolution |
|-----|-----------|
| `/docs/engine-framework.md` does not exist | Author from the canonical five-layer definitions in the dispatch prompt |
| `/docs/claude-code-setup.md` does not exist | Author the install → API key → marketplace → plugin → reload → verify walkthrough |
| `README.md` is a scaffold, not a linear on-ramp | Replace with the ordered five-step on-ramp |
| README scaffold uses "Your First Engine" with no concrete next-action | Final README must point at "install your first engine module" as a forward step (no module exists yet, but the README must name this as step 5) |

## Code Standards

`docs/code-standards.md` does not exist. No project conventions to apply beyond the tone established by the existing `/brain/README.md` and `/reference/README.md` (clean prose, no operator-specific examples, second-person voice addressing the cloning member). I will match that tone.

Conventions I will follow, derived from the existing shipped docs:
- Second person ("you") addressing the cloning member
- No emojis
- No em-dashes inside fenced code blocks; em-dashes are fine in prose (existing shipped docs use them)
- Lowercase plain language in headings; sentence case
- No operator-specific names, businesses, dollar figures
- Backticks for paths, file names, slash commands

## Test Infrastructure

This phase ships only documentation. There are no automated tests. Verification is grep-based plus structural/content checks. I will define those checks BEFORE writing the docs and run them after.

## Verification Criteria (defined first, run after authoring)

### V-A: Forbidden-token grep (DW-3.4)

Command:

```
grep -rEi "ryan|skool|hiry|hyperframes|insta-ce|video-pipeline|aiceOS/|\$[0-9]" \
  /Users/ryanmus/Documents/aiceos-foundation/docs/engine-framework.md \
  /Users/ryanmus/Documents/aiceos-foundation/docs/claude-code-setup.md \
  /Users/ryanmus/Documents/aiceos-foundation/README.md
```

Expected: zero matches. Note: `aiceOS` (no slash) is allowed; only path-style `/aiceOS/` is forbidden.

### V-B: Engine framework doc — five-layer section presence (DW-3.1)

`grep -n "^## " /docs/engine-framework.md` must yield section headings that include all five layer names: Reference, Pattern, Brain, Synthesis, Feedback. Each layer must have its own `## ` section heading.

### V-C: Engine framework doc — per-layer content (DW-3.1)

For each layer section, the section body must contain:
- A "job" statement (what the layer is for)
- A "produced by" attribution (member input vs. engine)
- A "consumed by" attribution (what reads it)

Verified by reading each section after authoring and confirming all three are present.

### V-D: Engine framework doc — data flow (DW-3.1)

The doc must contain a data-flow description showing the chain:
- References → Pattern (engine extracts)
- Pattern + Brain → Synthesis (engine produces deliverable)
- Synthesis ships → Feedback (performance data)
- Feedback → reweights future Pattern selection / Synthesis behavior

Verified by `grep -E "References .* Pattern" docs/engine-framework.md` finding the chain references, plus a read-through.

### V-E: Engine framework doc — Brain section names brain.md and /setup-brain (DW-3.1)

The Brain section must contain literal strings `brain/brain.md` (or `/brain/brain.md`) and `/setup-brain`. Verified by grep.

### V-F: Claude Code setup doc — required steps (DW-3.2)

The doc must walk:
1. Install Claude Code
2. Configure API key
3. Run `/plugin marketplace add ryanthedev/rtd-claude-inn`
4. Run `/plugin install code-foundations@rtd`
5. Run `/reload-plugins`
6. Verify with a concrete test command

Verified by grep for each literal string: `/plugin marketplace add ryanthedev/rtd-claude-inn`, `/plugin install code-foundations@rtd`, `/reload-plugins`, plus a section per step in the heading structure.

### V-G: README — opening line (DW-3.3)

First non-title content line must be / contain: "If you just cloned this, do these steps in order". Verified by grep.

### V-H: README — sequential ordered links (DW-3.3)

The README's ordered step list must, in order, reference:
1. Claude Code setup (link to `docs/claude-code-setup.md`)
2. Engine framework doc (link to `docs/engine-framework.md`)
3. Run `/setup-brain` to populate Brain (NOT "edit brain.md")
4. Populate `/reference/` (link to `reference/README.md`)
5. Install your first engine module

Verified by reading the numbered list and grepping for `/setup-brain` (must appear) and "edit brain.md" (must NOT appear as an instruction).

### V-I: Cold-readability assessment (DW-3.5)

Documented below in the `Cold-Readability Assessment` section. As the build agent I cannot perform a true cold read, but I document a reasoned assessment and commit to defending it.

## Design Decisions

### Decision 1: Document tone and structure (design-it-twice)

**Approach A — Heavy reference manual.** Each doc is exhaustive, with full background, edge cases, troubleshooting subsections.
- Pro: covers every possible question
- Con: cloning member is on step 1, not step 50; depth is wasted and obscures the next action

**Approach B — Linear walkthroughs that respect the on-ramp.** Each doc is structured for a member doing the steps for the first time, in order, top-to-bottom. Depth only where the member is likely to get stuck.
- Pro: matches the README promise ("do these steps in order"); respects that this is foundation, not engine docs
- Con: experienced members may want more reference material — but that's not who the foundation serves

**Approach C — Minimum viable.** Each doc is a few bullets pointing at canonical external sources.
- Pro: shortest to write
- Con: a member who has never installed Claude Code needs concrete commands, not pointers

**Chosen: Approach B.** Loses to A on completeness, loses to C on brevity, but is the right shape for a cloning member doing this for the first time. This is what the README's "if you just cloned this, do these steps in order" demands.

### Decision 2: Engine framework doc structure

The doc must define five layers AND show data flow. Two natural shapes:

**Shape A — Five sections, then a data-flow section at the end.** Reader sees layer-by-layer first, then the flow.
- Pro: each layer gets its own self-contained explanation; matches the DW-3.1 requirement that each layer has its own section
- Con: data flow appears late; a reader who wants the system view first has to scroll

**Shape B — Data-flow narrative first, then a section per layer as appendix-style detail.**
- Pro: system thinking up front
- Con: the per-layer sections feel redundant to readers who already grokked the flow narrative

**Chosen: Shape A with a short upfront overview.** The doc opens with a one-paragraph tour ("here are the five layers, here's the chain"), then dedicates a `## ` section to each layer, then closes with a `## Data flow` section that re-states the chain in concrete read/write terms. This satisfies "each layer in its own section" cleanly while still giving the system view. The repetition between the upfront overview and the data-flow section is intentional: the overview is one sentence per layer, the data-flow section is the operational chain (who reads what, who writes what).

### Decision 3: README on-ramp shape

Single shape, no real alternative to evaluate: numbered ordered list with one short paragraph per step explaining what the step gives the member and a link to the doc that walks the step in detail. The README is a router, not a tutorial. The detail lives in the linked doc.

The README must explicitly say "run `/setup-brain`" and not "edit `brain.md`" — this is a hard constraint. I'll handle it by:
- Step 3's heading is "Populate your Brain" with body text saying "run `/setup-brain` from inside Claude Code"
- A short "do not edit `brain.md` directly" line, mirroring `/brain/README.md`'s existing language

### Decision 4: Step 5 of the README — "install your first engine module"

No engine module exists in the foundation. The README must still name step 5 as a forward step. The honest framing is: "the foundation is now in place; engine modules are installed separately when you're ready." I will not invent a fake install command. The step describes what the member is now equipped to do, with a one-sentence pointer that engine modules are distributed separately and each will come with its own install instructions.

### Decision 5: Claude Code setup — verification step

A "verify" step needs a concrete command the member can run that will give a recognizable signal. Two options:

**Option A — Run `/help` or list installed plugins.** Generic; works without knowing what's in `code-foundations`.

**Option B — Run a known slash command from `code-foundations`.** Concrete signal but assumes knowledge of which command to invoke.

**Chosen: hybrid.** I'll use `/plugin` (or equivalent listing command) as the primary verification, since it directly answers "did the install succeed?", and reference that the `code-foundations` plugin's commands are now available in the slash-command picker. This gives the member an unambiguous yes/no signal without depending on a specific command's behavior.

I will NOT invent a command name that doesn't exist. The instruction will be: "open the slash-command menu and confirm `code-foundations` commands appear" — which is a concrete check that doesn't require a specific command.

## DW Verification

| DW-ID | Done-When Item | Status | Test Cases / Verification |
|-------|---------------|--------|---------------------------|
| DW-3.1 | `/docs/engine-framework.md` defines all five layers in their own sections; each names job, producer (member-input vs. engine), consumer; doc includes data-flow description (References → Pattern, Pattern + Brain → Synthesis, Synthesis ships → Feedback → reweights future runs); Brain section names `/brain/brain.md` and points to `/setup-brain` | COVERED | V-B (section presence), V-C (per-layer content), V-D (data flow), V-E (Brain section names brain.md + /setup-brain) |
| DW-3.2 | `/docs/claude-code-setup.md` walks zero-to-working: install Claude Code, configure API key, add `rtd` marketplace, install `code-foundations`, reload plugins, verify with concrete test command | COVERED | V-F (six required steps with literal command strings) |
| DW-3.3 | `README.md` opens with "If you just cloned this, do these steps in order" and links sequentially to: Claude Code setup → engine framework doc → run `/setup-brain` (NOT "edit brain.md") → populate Reference → install first engine module | COVERED | V-G (opening line), V-H (ordered five-step list with `/setup-brain` not "edit brain.md") |
| DW-3.4 | Forbidden-token grep against `/docs/engine-framework.md`, `/docs/claude-code-setup.md`, and `/README.md` returns zero matches | COVERED | V-A (run grep after authoring) |
| DW-3.5 | Sanity-read pass: a reader with no prior aiceOS exposure can follow the README end-to-end and understand all five layers without external context — documented reasoned assessment | COVERED | V-I + Cold-Readability Assessment section below |

**All items COVERED:** YES.

## Cold-Readability Assessment (preview — finalized after authoring)

I will assess the shipped README + linked docs against these specific cold-reader risks and document findings post-authoring:

1. **Jargon without definition.** Does the README use "Pattern", "Synthesis", "Feedback", "Brain", "Reference" before linking the framework doc that defines them? If yes, that's a cold-read failure.
2. **Forward references to nonexistent files.** Does any link target a path that doesn't exist in the repo?
3. **Order assumes prior context.** Are the five steps runnable in literal order from a fresh clone with no other knowledge?
4. **Slash commands referenced before the environment that runs them.** `/setup-brain` only works inside Claude Code. Does the README ensure Claude Code setup precedes any slash-command instruction?
5. **External tool assumptions.** Does the Claude Code setup doc assume the member already has anything beyond a normal dev machine (a terminal, an editor, internet)?

The README + docs will be authored to pass each of these. The post-authoring section at the bottom of this discovery file records the actual findings.

## Post-Authoring Cold-Readability Findings (DW-3.5)

After authoring, I checked the README + linked docs against each of the five cold-reader risks named above.

1. **Jargon without definition.** The README's opening paragraph names "five-layer engine framework", "Brain", and "Reference" before any link. Step 2's body names all five layer terms (Reference, Pattern, Brain, Synthesis, Feedback) immediately above the link to the framework doc that defines them. A cold reader meets each jargon term within one paragraph of a forward-pointer to the doc that defines it, and step 2 is itself "go read the framework doc." **Pass — but worth noting**: the opening paragraph could be read by an impatient reader as terminal in itself; if a member skips step 2 they will not fully understand what each layer does. The README cannot prevent skipping; it can only sequence honestly, which it does.

2. **Forward references to nonexistent files.** All four linked paths (`docs/claude-code-setup.md`, `docs/engine-framework.md`, `brain/README.md`, `reference/README.md`) exist in the repo. The repo-layout block at the end of the README correctly lists every file and folder in the shipped foundation. **Pass.**

3. **Order assumes prior context.** Step 1 (install Claude Code) is a hard prerequisite for step 3 (run `/setup-brain`, which only works inside Claude Code), and the README explicitly says so in step 1's body ("the slash command in step 3 only runs inside Claude Code"). Step 2 (read the framework) is a soft prerequisite for steps 3-5, since the layer terminology is used in those steps' bodies. Step 4 (Reference) and step 5 (install an engine module) are not strictly ordered relative to each other in a technical sense, but the framing — "you are now ready to install one" — makes the order pedagogically right: Brain and Reference must be in place before an engine module has anything to read. **Pass.**

4. **Slash commands referenced before the environment that runs them.** `/setup-brain` is referenced only in step 3 and in the repo-layout block. Step 3 is preceded by step 1 (install Claude Code) and the body of step 3 explicitly says "with Claude Code running, run the guided slash command." A cold reader cannot encounter `/setup-brain` as a runnable instruction before Claude Code is set up. **Pass.**

5. **External tool assumptions.** The Claude Code setup doc opens with a "What you need before you start" block listing terminal, editor, internet, API key. The doc does not assume the member has any aiceOS-specific tooling already installed. The Anthropic API key is the one external dependency; the doc walks the member to the console URL where they can create one if they do not yet have one. **Pass.**

**Overall cold-readability assessment: Pass.** A reader with no prior aiceOS exposure can follow the README end-to-end. They will understand all five layers because step 2 routes them to the framework doc that defines all five in self-contained sections (verified by V-B and V-C). The on-ramp is sequenced so each step's prerequisites are satisfied by the preceding steps. No file links are broken. No jargon is introduced without a forward-pointer to its definition.

**Caveat.** I am the build agent and cannot perform a true cold read; I authored the doc and know what is in it. The honest weakness in this assessment is that I cannot detect blind-spots from a true first-time reader. The reasoned check above is the strongest verification possible from this position. The full DW-3.5 spec calls for a sanity-read by a human (Ryan reads top-to-bottom and confirms) — that human pass remains the final gate and I am not substituting for it.

## Verification Run Results (post-authoring)

All checks defined in the V-A through V-I block above were run via `/Users/ryanmus/Documents/aiceos-foundation/docs/building/phase-3-verify.sh`. Results:

- **V-A (forbidden-token grep, DW-3.4).** Two matches found, both inside the literal string `ryanthedev/rtd-claude-inn` in `docs/claude-code-setup.md` (lines 81 and 126). DW-3.2 explicitly mandates `/plugin marketplace add ryanthedev/rtd-claude-inn` as a required literal command in the setup doc. The two grep hits are the substring `ryan` inside `ryanthedev`, which is unavoidable given the marketplace identifier. After excluding the required marketplace literal, the grep returns zero matches:
  ```
  grep -rEni "ryan|skool|hiry|hyperframes|insta-ce|video-pipeline|aiceOS/|\$[0-9]" \
    docs/engine-framework.md docs/claude-code-setup.md README.md \
    | grep -v "ryanthedev/rtd-claude-inn"
  ```
  → no output. The forbidden-token spirit (no operator-specific names like the human "Ryan", no other-folder names, no dollar figures) is satisfied. Documenting this as the only acceptable exception, mandated by DW-3.2's required literal.

- **V-B (five-layer section presence, DW-3.1).** All five `## ` headings present: `## Reference`, `## Pattern`, `## Brain`, `## Synthesis`, `## Feedback`, plus `## The five layers at a glance` (overview) and `## Data flow`. **Pass.**

- **V-C (per-layer content, DW-3.1).** Each of the five layer sections contains exactly one `**Job.**`, one `**Produced by.**`, and one `**Consumed by.**` line. Counts: 5 / 5 / 5. **Pass.**

- **V-D (data flow, DW-3.1).** `## Data flow` section present at line 81. The seven-step ordered list inside it walks: you write Reference → you write Brain → engine reads References and writes Pattern → engine reads Pattern and Brain and writes Synthesis → Synthesis ships → engine writes Feedback → next run reads Feedback to bias Pattern selection and Synthesis. **Pass.**

- **V-E (Brain section names brain.md and /setup-brain, DW-3.1).** Both literals appear in the Brain section: `/brain/brain.md` (line 51) and `/setup-brain` (line 53). **Pass.**

- **V-F (Claude Code setup steps, DW-3.2).** All required literal command strings present:
  - `/plugin marketplace add ryanthedev/rtd-claude-inn` (line 81)
  - `/plugin install code-foundations@rtd` (line 91)
  - `/reload-plugins` (line 103)
  - `ANTHROPIC_API_KEY` (lines 42, 47, 53, 59, 62, 125)
  Seven step-headings (`## Step 1` through `## Step 7`) walk install → API key → open Claude Code → add marketplace → install plugin → reload → verify. **Pass.**

- **V-G (README opening line, DW-3.3).** Heading `## If you just cloned this, do these steps in order` is present at line 5, immediately after the `# aiceOS Foundation` title and the introductory paragraph. **Pass.**

- **V-H (README ordered links, DW-3.3).** Five numbered step headings present (`### 1.` through `### 5.`) in the right order: Set up Claude Code → Read the engine framework → Populate your Brain → Populate the Reference folder → Install your first engine module. Links: `docs/claude-code-setup.md` (step 1), `docs/engine-framework.md` (step 2), `/setup-brain` (step 3), `reference/README.md` (step 4). The phrase "install your first engine module" appears in step 5's heading and in the introduction. The only `edit ... brain.md` mention is the explicit "Do not edit `brain/brain.md` by hand" anti-instruction. **Pass.**

- **V-I (cold-readability, DW-3.5).** See the post-authoring findings section above. **Pass.**

All DW items satisfied. Recommendation: hand off to REVIEW.

## Prerequisites

- [x] `/docs/` directory exists (confirmed)
- [x] Phase 1 + Phase 2 artifacts committed (commits 000cdbf and d3ed4d1)
- [x] `/.claude/commands/setup-brain.md` exists and matches what the README will describe (confirmed by reading it)
- [x] `/brain/brain.md` and `/reference/` directory exist (confirmed)

## Recommendation

**BUILD.** All prerequisites met. All DW items have a clear path. Proceed to authoring with verification checks defined.
