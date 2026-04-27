# Discovery + Design: Phase 2 — Guided brain setup slash command

## Files Found

- `/Users/ryanmus/Documents/aiceos-foundation/.claude/commands/` — exists, empty directory (Phase 1 created it)
- `/Users/ryanmus/Documents/aiceos-foundation/brain/brain.md` — exists, contains the five sections (`## Expertise`, `## Audience`, `## Voice`, `## Offers`, `## Beliefs`) each terminated with an `<!-- fill -->` sentinel
- `/Users/ryanmus/Documents/aiceos-foundation/brain/README.md` — exists, already directs the operator to run `/setup-brain` rather than edit `brain.md` by hand
- `/Users/ryanmus/Documents/aiceos-foundation/.gitignore` — excludes `docs/plans/`, `.DS_Store`, `.env*`
- `/Users/ryanmus/Documents/aiceos-foundation/docs/code-standards.md` — does NOT exist

## Current State

Phase 1 left the repo at commit `000cdbf` with the empty `.claude/commands/` directory ready and the brain.md template in its post-template, pre-fill state. The five section headers and the `<!-- fill -->` sentinels are exactly where Phase 1 placed them. Nothing in `.claude/` exists yet.

## Gaps

None. The Phase 1 brain.md exactly matches what Phase 2 needs to read at runtime: five `## <Name>` headers, each followed by structural prompts, each terminating in `<!-- fill -->`.

## Code Standards

No `docs/code-standards.md` found. Project-level conventions for Phase 2:

- Output is a single markdown file consumed by Claude Code as a slash command prompt
- The file's content is read as a user-message prompt at command invocation
- Optional YAML frontmatter is allowed; not required
- The prompt must be self-contained (Claude reads it with no other repo context preloaded)
- Operator-facing language inside the prompt addresses Claude in second person ("you will...") describing what Claude should do
- No em-dashes (project-wide constraint inherited from operator memory rules — substitute discourse markers)
- No Ryan-/operator-/business-specific examples; no dollar amounts (DW-2.4 grep gate)

## Test Infrastructure

No automated tests. Verification is two-stage:

1. **Static checks:** file exists, contains all five section names, contains the four required behaviors (walk-through, sentinel-based idempotency, write-back removing sentinel, end confirmation), and passes the DW-2.4 grep
2. **Dry-run trace:** thought-experiment trace of a synthetic operator running the command, confirming the prompt's instructions if followed produce the diff DW-2.3 describes

## DW Verification

| DW-ID | Done-When Item | Status | Test Cases |
|-------|----------------|--------|------------|
| DW-2.1 | `/.claude/commands/setup-brain.md` exists and contains a complete slash-command prompt covering all five Brain sections | COVERED | Static check 1: file exists at path. Static check 2: prompt body lists all five section names (Expertise, Audience, Voice, Offers, Beliefs) with their question banks |
| DW-2.2 | Prompt explicitly handles section-by-section walk-through, idempotent re-runs (sentinel-based detection), write-back removing sentinel + structural prompts, end-of-flow confirmation | COVERED | Static check 3: prompt body contains the algorithm describing each of the four required behaviors using the exact `<!-- fill -->` token for sentinel detection. Static check 4: prompt instructs the agent to replace structural prompts AND remove the sentinel, not just append |
| DW-2.3 | Manual run-through (treated as dry-run trace per orchestrator note): a synthetic operator answering each prompt would produce a brain.md whose five sections contain their answers and no longer contain the sentinel | COVERED | Dry-run trace: synthetic operator answers traced through the algorithm step-by-step, expected diff documented in this file |
| DW-2.4 | `grep -rEi "ryan\|skool\|hiry\|hyperframes\|insta-ce\|video-pipeline\|aiceOS\/\|\$[0-9]"` against `/.claude/` returns zero matches | COVERED | Static check 5: run the exact grep against `/.claude/` post-write, confirm zero matches |

**All items COVERED:** YES

## Design Decisions

### Design-it-twice: structuring the command's instructions

**Approach A — Procedural script (per-section explicit blocks).** Five near-identical prose blocks, each spelling out the full read/detect/ask/write/confirm flow for that section. Pro: zero LLM ambiguity. Con: ~5x repetition; flow changes touch five places; bloats the file.

**Approach B — Algorithm + per-section question bank.** State the flow algorithm ONCE at the top, then provide a bank of focused questions per section. Pro: DRY; isolates per-section content from per-section flow; easy to audit. Con: relies on the agent applying the algorithm uniformly across the five sections — mitigated by an explicit five-item checklist + end-of-flow confirmation step.

**Approach C — Conversational meta-prompt.** Single sentence: "have a conversation about the five Brain elements and update brain.md." Pro: shortest. Con: skips sentinel contract (DW-2.2 fails); no determinism on idempotency.

**Chosen:** Approach B.

**Comparison criteria:**

| Criterion | A | B | C |
|---|---|---|---|
| Interface simplicity (file structure) | Repetitive | Clean | Trivial |
| Information hiding (Q-bank vs flow logic) | Mixed | Separated | None |
| Caller (Claude) ease of use | Highest | High | Low |
| DW-2.2 contract met | Yes | Yes | No |
| Auditability for grep + manual review | Hard (5x scan) | Easy | Easy but vague |

What B sacrifices vs A: per-section flow specificity. What B sacrifices vs C: brevity.

### Algorithm specified by the prompt

Once invoked, the prompt instructs Claude to execute, in order:

1. **Read** `brain/brain.md` from the repo root.
2. **Detect** for each of the five canonical sections (Expertise, Audience, Voice, Offers, Beliefs) whether it contains the literal string `<!-- fill -->`.
3. **For each section in order:**
   - If it contains `<!-- fill -->`: announce the section, ask the section's focused questions one bundle per turn (waiting for the operator's response), then synthesize their answer into a clean section body, then update `brain.md` so the section contains the operator's answer ONLY (structural prompts removed, sentinel removed).
   - If it does NOT contain `<!-- fill -->`: tell the operator that section is already populated, show the current content, and ask "Revise this section? (yes/no)". On yes, ask the questions and replace the body; on no, leave it untouched.
4. **End-of-flow confirmation:** list each section's status (filled-this-run / kept-existing / revised-this-run / still-unfilled), then ask the operator if any section needs another pass. If yes, return to step 3 for the named section. If no, end the command.

### Per-section question banks

Five sections, each gets a small focused bank (3-5 questions max) drawn directly from the structural prompts already in the Phase 1 `brain.md`. The questions are operator-facing, plain language, no jargon, no operator-specific framing.

| Section | Question bank |
|---|---|
| Expertise | (1) What domain or domains do you have real depth in? (2) Inside that domain, what specific problems have you solved repeatedly? (3) Do you have any frameworks, shortcuts, or unfair advantages you developed yourself? (4) What level of audience can you credibly serve — beginner, working practitioner, advanced? |
| Audience | (1) Who is your audience at the job-title or life-stage level? (2) What outcome do they want from you? (3) What have they already tried that did not work? (4) What do they know and not know about your domain? (5) Where do they hang out and how do they describe their own problem in their own words? |
| Voice | (1) What tone register do you use — plain, technical, irreverent, formal, something else? (2) What words and phrases do you use often? (3) What words and phrases do you refuse to use? (4) What sentence length and rhythm do you prefer? (5) What stance do you take toward your audience — peer, coach, operator, teacher? |
| Offers | (1) What do you sell? List each offer by name. (2) For each one, what is the promise — the outcome the buyer is paying for? (3) For each one, what is the delivery mechanism — course, cohort, software, service, community, etc.? (4) For each one, who is it for and who is it not for? (5) For each one, what price tier is it — entry, mid, or premium? (No specific numbers.) |
| Beliefs | (1) What do most people in your space believe that you think is wrong? (2) What principles do you defend even when they cost you customers? (3) What worldview is your work built on? (4) What trade-offs do you accept that others refuse to accept? |

### Write-back contract

For every filled section, the post-write content of that section is:

```
## <SectionName>

<operator's synthesized answer in prose or bullets>
```

That is — the operator's content alone. The structural prompts (the `- bullet` lines from the template) and the `<!-- fill -->` sentinel are both removed. The `## <SectionName>` heading and the `---` section separators are preserved.

### Section ordering

Walk through in the canonical order Expertise → Audience → Voice → Offers → Beliefs. Matches the order of sections in brain.md (file order = walk order, simplest mental model).

## Prerequisites

- [x] `.claude/commands/` directory exists (Phase 1 created it)
- [x] `brain/brain.md` exists with all five `## <SectionName>` headings and `<!-- fill -->` sentinels
- [x] No `docs/code-standards.md` to conflict with
- [x] Operator's working repo will be the cwd when `/setup-brain` runs (Claude Code project-scoped slash command convention)

## Dry-run trace (DW-2.3 evidence)

Synthetic operator state: starts at post-Phase-1 commit `000cdbf`. Runs `/setup-brain`. The operator answers every prompt with throwaway test content. Trace:

**Step 0 — invocation.** Operator types `/setup-brain`. Claude Code reads `.claude/commands/setup-brain.md` and sends its body as the user prompt for this turn.

**Step 1 — read.** Claude reads `brain/brain.md`. All five sections still contain `<!-- fill -->`.

**Step 2 — detect.** Claude finds five sections, all unfilled.

**Step 3a — Expertise (unfilled).** Claude announces the section, asks the four Expertise questions. Synthetic operator answers (e.g.: "domain = hydroponic lettuce; solved nutrient burn repeatedly; built a 3-step pH protocol; serve working hobbyists, not commercial growers"). Claude synthesizes the answer into a clean prose-or-bullet section body. Claude updates `brain/brain.md`: locates the `## Expertise` heading, replaces everything between that heading and the next `## ` heading (or the next `---`) with the operator's synthesized content, then re-emits the section trailing whitespace. Critical: the structural prompts (`- The domain...`, `- The specific problems...`, etc.) are gone, AND the `<!-- fill -->` sentinel is gone.

**Step 3b — Audience (unfilled).** Same flow with the five Audience questions. Synthetic answer written back; sentinel and structural prompts removed.

**Step 3c — Voice (unfilled).** Same.

**Step 3d — Offers (unfilled).** Same.

**Step 3e — Beliefs (unfilled).** Same.

**Step 4 — confirmation.** Claude lists all five sections as "filled-this-run" and asks if any need another pass. Synthetic operator says no.

**Resulting state.** `brain/brain.md`:
- Top intro paragraphs unchanged
- Each of the five `## <SectionName>` sections now contains the operator's synthesized prose/bullets only
- Zero `<!-- fill -->` strings remain in the file
- `git diff HEAD` (against commit `000cdbf`) shows changes confined to the five section bodies

**Idempotent re-run trace.** Operator runs `/setup-brain` a second time. Claude reads brain.md, detects zero `<!-- fill -->` sentinels, walks each section in order, announces each as already populated, asks "Revise? (yes/no)", and on "no" leaves them all alone. End-of-flow confirmation lists all five as "kept-existing". No file changes. This satisfies the idempotency requirement of DW-2.2.

**Mixed-state trace.** Operator runs once, fills only Expertise and Audience, abandons. Operator returns later and runs again. Claude detects three sentinels remaining (Voice, Offers, Beliefs); for those it executes Step 3 with questions; for Expertise and Audience it announces "already populated" and asks "Revise? (yes/no)". Confirms DW-2.2's idempotency-with-revise behavior.

## Recommendation

BUILD. Write `/.claude/commands/setup-brain.md` per the design above.
