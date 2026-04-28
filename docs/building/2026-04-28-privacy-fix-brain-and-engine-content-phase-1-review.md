# Review: Phase 1 - Foundation template/fill split for brain.md

## Requirement Fulfillment

| DW-ID | Done-When Item | Status | Evidence |
|-------|---------------|--------|----------|
| DW-1.1 | `git ls-files brain/brain.md` returns empty | SATISFIED | `git ls-files brain/brain.md` produced no output (RC=0). Confirmed via scratch script run. |
| DW-1.2 | `git ls-files brain/brain.md.template` returns the path | SATISFIED | Output: `brain/brain.md.template` (RC=0). Template is tracked. |
| DW-1.3 | Rename event recorded with arrow notation | SATISFIED | `git show --stat HEAD` produces `brain/{brain.md => brain.md.template} | 0` — exactly the arrow notation the DW item allows. |
| DW-1.4 | `.gitignore` contains `brain/brain.md` under a clear comment heading | SATISFIED | Final two lines of `.gitignore`: `# Member-private filled brain — bootstrapped from brain.md.template on first /setup-brain run` followed by `brain/brain.md`. Blank-line spacing matches existing group style. Pattern is exactly `brain/brain.md` (not `/brain/brain.md` and not `brain/*.md`). |
| DW-1.5 | Template byte-identical to pre-rename brain.md | SATISFIED | `diff /tmp/pre_brain.md brain/brain.md.template` produced no output and confirmed BYTE-IDENTICAL. Rename recorded with `0` insertions/deletions and similarity 100% (file mode `brain/{brain.md => brain.md.template} | 0`). Template still has 65 lines, exactly 5 `## ` headings, and exactly 5 `<!-- fill -->` sentinels. |
| DW-1.6 | New Step 1 bootstrap + renumber + Hard rule narrowing | SATISFIED | setup-brain.md:25-31 contains the new "Step 1. Bootstrap brain.md from template if missing" with all three branches (exists / missing-but-template-exists-and-bootstrap / both-missing-abort). Diff vs HEAD~1 shows only: (a) Step 1 inserted as new section; (b) Steps 1->2, 2->3, 3->4, 4->5 cleanly renumbered with NO content changes; (c) substep `3a`->`4a` and `3b`->`4b`; (d) "as in 3a"->"as in 4a" on line 67 (was 59); (e) "return to Step 3"->"return to Step 4" on line 78 (was 70); (f) the malformed-template Hard rule on line 134 (was 126) is replaced verbatim with the dispatch-specified narrowed wording. No other changes anywhere in the file. |
| DW-1.7 | brain/README.md paragraph explains template/fill split | SATISFIED | brain/README.md:33 contains the 4-sentence paragraph: "The file ships as `brain.md.template`, not `brain.md`. The first time you run `/setup-brain`, the command bootstraps `brain.md` by copying the template verbatim, then walks you through filling it. `brain.md` is gitignored so your filled answers stay local to your clone and are not committed to the shared Foundation repo. The template stays tracked because it is the on-ramp every new clone needs to get started." Placement is at the end of the "How to fill it" section, before "What an engine does with your Brain" — natural lifecycle-explanation placement. |
| DW-1.8 | Single new commit with conventional-commit message | SATISFIED | `git log --oneline -n 1`: `f86f4c9 feat(foundation): split brain template from filled brain for member privacy`. Conventional-commit form `feat(foundation):`, names the privacy change, exactly one new commit at HEAD. |
| DW-1.9 | Bootstrap Step 1 inspection: reads template, writes verbatim, single side effect, one-line confirmation, missing-template aborts cleanly | SATISFIED | setup-brain.md:30 prose explicitly: (a) "read `brain/brain.md.template`"; (b) "write its full contents verbatim ... Do not transform, slug, substitute, or otherwise alter the contents in any way — this is a literal byte-for-byte copy"; (c) "The only observable side effect of this step is the creation of one new file at `brain/brain.md`"; (d) one-line confirmation "Initialized brain.md from template — walking you through it now."; (e) line 31 both-missing branch: "abort with a friendly malformed-repo error: \"I can't find brain/brain.md OR brain/brain.md.template in this repo. The Foundation may be malformed; reinstall and try again.\" Do not write any file in this branch." |

**All requirements met:** YES

## Test-DW Coverage

- [x] All DW items have corresponding verification (this phase produces no executable code; verification is by `git ls-files`, `git check-ignore`, `git show --stat`, file inspection, byte-comparison).
- [x] No unplanned additions: the four-file change set (`brain/brain.md` -> `brain/brain.md.template`, `.gitignore`, `.claude/commands/setup-brain.md`, `brain/README.md`) matches the plan's IN scope exactly.
- [x] Test coverage matches plan level (N/A — markdown + gitignore + slash-command-prompt build).

Additional review checks performed:

- **Step renumbering integrity:** searched the post-edit setup-brain.md for any leftover stale step references. Both internal references ("as in 3a" and "return to Step 3") were correctly updated to "as in 4a" and "return to Step 4". Substep markers `3a`/`3b` correctly became `4a`/`4b`. No stale references remain.
- **Hard rule narrowing precision:** the diff shows ONE Hard rule line changed (line 126 in pre / line 134 in post). The other six Hard rules are byte-identical to the pre-edit version.
- **Five-section walk preservation:** Step 4 (was Step 3) still walks Expertise -> Audience -> Voice -> Offers -> Beliefs in canonical order with the same sentinel-detection-based 4a/4b logic. No semantic change.
- **Question banks:** byte-identical pre vs post (no diff lines in the question-bank section).
- **Top-level README.md and engine-framework.md unchanged:** `git diff HEAD~1 HEAD -- README.md docs/engine-framework.md` returns empty.
- **brain/README.md placement:** the new paragraph lands at the end of the existing "How to fill it" section, before the "What an engine does with your Brain" heading. README still flows.
- **gitignore entry:** exactly `brain/brain.md` (not `/brain/brain.md` and not `brain/*.md`).
- **Scope discipline:** post-commit working tree is clean except for the discovery file (allowed) and a transient edit to `docs/building/scratch.sh` made by this review process. No other files modified.

## Dead Code

None found. All edits are additive prose (new Step 1, new gitignore section, new README paragraph) or pure mechanical renumbering. No commented-out code, no unused imports (N/A — markdown), no unreachable branches.

## Correctness Dimensions

| Dimension | Status | Evidence |
|-----------|--------|----------|
| Concurrency | N/A | No shared state, no async, no handlers — slash-command prose. |
| Error Handling | PASS | Step 1's both-missing branch has a friendly aborting error message that names both files. The file-write branch is unconditional once the template-exists check passes; this is correct because Step 1 is prose telling an LLM what to do, not executable code. The narrowed Hard rule covers the post-bootstrap structural-validation case. |
| Resources | N/A | No file handles, connections, or locks held across boundaries — single-shot read+write described as one logical operation. |
| Boundaries | PASS | Three discrete branches cover the three meaningful states: brain.md present (proceed), brain.md absent + template present (bootstrap + proceed), both absent (abort). The "template present + brain.md present" case implicitly falls into the "brain.md exists" branch, which is correct (template content is irrelevant once brain.md exists). |
| Security | PASS | Verbatim copy with no transformation, slug, or substitution explicitly forbids the most common content-mangling vectors. The template content is repo-controlled, not external input, so trust boundary is clean. The gitignore entry prevents the privacy regression that motivated this whole phase — verified by reading the .gitignore. |

## Defensive Programming: PASS

Crisis triage:
1. External input validated at boundaries? — N/A; no external input. Repo-controlled template only.
2. Return values checked for all external calls? — N/A.
3. Error paths tested? — both-missing abort path is explicit prose with a friendly error and a "do not write any file" guarantee. Verified by reading line 31.
4. Assertions on critical invariants? — the post-bootstrap structural-validation rule (narrowed Hard rule on line 134) is the assertion-equivalent: if either file is missing one of the five canonical headings, stop. Correct narrowing.
5. Resources released on all paths? — N/A.

The narrowed Hard rule is the load-bearing defensive change here. Pre-edit, the rule treated "brain.md does not exist" as malformed-template, which would have created a behavioral contradiction with the new bootstrap step (the bootstrap step's whole purpose is to handle that case non-fatally). The narrowing was performed exactly as the dispatch specified: brain.md.template structural-validation always applies; brain.md structural-validation only applies AFTER bootstrap has run; bare-not-exist for brain.md is no longer an error.

## Design Quality

**Depth > Length:** the new Step 1 is one section of prose with three branches, each one-sentence-or-so. Interface (single algorithm step) is simpler than implementation (three branches with verbatim-copy guarantee). Appropriate depth for the responsibility.

**Unknown unknowns:** none. All three branches are enumerated and named in DW-1.9. No surprising new behavior introduced.

**Together/Apart:** bootstrap is correctly co-located with the rest of the algorithm (it's a precondition step for the existing walk, shares the same operator-context). Splitting it into a separate command would have introduced a 2-call dance. Keep together is correct.

**Pass-through methods:** N/A — no executable code.

**Steel-man check:** the design is intentional and minimal. The bootstrap step is a precondition; the renumbering is mechanical; the Hard rule narrowing is the strict minimum needed to prevent contradiction with the new step.

No HIGH or MEDIUM severity findings.

## Testing: PASS (N/A)

Test Coverage Level was declared N/A in the plan — this phase produces no executable code. Verification is by `git ls-files`, `git check-ignore`, `git show --stat`, byte-comparison of template content, and direct file inspection per DW-1.9. All such verifications passed in this review.

T-1, T-2, T-3 from the Test Plan have been performed in this review:
- T-1: rename history preserved across both paths (commit f86f4c9 uses arrow notation showing the rename was 100% similar).
- T-2: setup-brain.md end-to-end read confirms (a) bootstrap Step 1 first; (b) five-section walk intact; (c) friendly error in both-missing branch; (d) Hard rule narrowed exactly per DW-1.6; (e) all other Hard rules byte-identical.
- T-3: brain/brain.md.template has the five canonical headings (Expertise, Audience, Voice, Offers, Beliefs) and five `<!-- fill -->` sentinels; `ls brain/` shows only `README.md` and `brain.md.template` on disk.

## Issues

None.

**Verdict: PASS**
