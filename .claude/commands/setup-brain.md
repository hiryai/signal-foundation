---
description: Walk the operator through populating /brain/brain.md one section at a time, conversationally, instead of editing the file by hand.
---

# /setup-brain

You are running this command inside the operator's cloned aiceos-foundation repo. Your job is to populate `brain/brain.md` conversationally, one section at a time, by interviewing the operator and writing their answers back into the file. Do not ask the operator to edit the file themselves.

`brain/brain.md` is the consolidated Brain layer of the aiceOS engine framework. It has exactly five sections, in this order:

1. Expertise
2. Audience
3. Voice
4. Offers
5. Beliefs

Each section in the template ships with structural prompts plus an HTML-comment sentinel: `<!-- fill -->`. A section is **unfilled** if and only if its body still contains that sentinel. A section without the sentinel is considered **already filled**.

---

## Algorithm

Execute these steps in order. Do not skip ahead. Do not batch all five sections into a single message; walk one section at a time so the operator can think.

### Step 1. Bootstrap brain.md from template if missing

Check whether `brain/brain.md` exists at the repo root.

- **If `brain/brain.md` exists**, proceed to Step 2.
- **If `brain/brain.md` does NOT exist but `brain/brain.md.template` exists**, read `brain/brain.md.template` and write its full contents verbatim to `brain/brain.md`. Do not transform, slug, substitute, or otherwise alter the contents in any way — this is a literal byte-for-byte copy. The only observable side effect of this step is the creation of one new file at `brain/brain.md`. Then tell the operator one line of confirmation: "Initialized brain.md from template — walking you through it now." Then proceed to Step 2.
- **If both `brain/brain.md` AND `brain/brain.md.template` are missing**, abort with a friendly malformed-repo error: "I can't find brain/brain.md OR brain/brain.md.template in this repo. The Foundation may be malformed; reinstall and try again." Do not write any file in this branch.

### Step 2. Read

Read `brain/brain.md` from the repo root. Identify each of the five sections by its `## <SectionName>` heading. For each section, capture its current body (everything between its heading and the next section's heading, or end-of-file).

### Step 3. Greet and detect

Tell the operator you will walk them through their Brain one section at a time. Briefly list the five sections so they know what is coming. Then count how many sections still contain `<!-- fill -->` and tell them how many are unfilled vs already populated.

### Step 4. Walk the five sections in order

For each section in the canonical order (Expertise, then Audience, then Voice, then Offers, then Beliefs):

**4a. If the section's body contains `<!-- fill -->`** (it is unfilled):

  - Announce the section by name and one sentence of context for what it captures.
  - Ask the section's questions (see the question banks below). You may ask them as a single bundled message or as a short back-and-forth, but do NOT advance to the next section until the operator has given you enough to write the section.
  - Synthesize the operator's answer into a clean section body. Use plain prose or short bullet lists, whichever fits the operator's answer. Do not invent details the operator did not give you. Do not pad. If the operator's answer is sparse, write it sparse — Brain is meant to capture what they actually have, not what would sound impressive.
  - Update `brain/brain.md` so the section now reads:

    ```
    ## <SectionName>

    <the operator's synthesized content>
    ```

    The original structural prompts (the bullet-point template lines like `- The domain or domains you have real depth in`) MUST be removed. The `<!-- fill -->` sentinel MUST be removed. The `## <SectionName>` heading and any `---` separators around the section MUST be preserved. Adjacent sections MUST NOT be modified.

  - Briefly show the operator what you wrote and confirm before moving on. If they want a tweak, edit the section, then move on.

**4b. If the section's body does NOT contain `<!-- fill -->`** (it is already populated):

  - Tell the operator the section is already populated.
  - Show them the current content of that section.
  - Ask: "Revise this section? (yes / no)"
  - On **yes**: ask the section's questions, synthesize, and write back exactly as in 4a (replacing the existing body). On **no**: leave the section untouched and move to the next section.

### Step 5. End-of-flow confirmation

After walking all five sections, summarize each section's status using these labels:

- **filled-this-run** — was unfilled at the start, you wrote content this session
- **revised-this-run** — was already populated, operator asked to revise, you rewrote it
- **kept-existing** — was already populated, operator chose not to revise
- **still-unfilled** — was unfilled and the operator declined to fill it this session (only happens if the operator explicitly skipped)

Then ask: "Do any of these need another pass?" If yes, return to Step 4 for the named section(s). If no, end the command with a one-line summary: how many sections are now populated, and how many (if any) remain unfilled.

---

## Question banks

These are the focused questions to ask per section. Treat them as the floor, not the ceiling — if the operator's answer is thin, ask one or two follow-ups in plain language to draw it out, but do not interrogate.

### Expertise

1. What domain or domains do you have real depth in?
2. Inside that domain, what specific problems have you solved repeatedly?
3. Do you have any frameworks, shortcuts, or unfair advantages you developed yourself?
4. What level of audience can you credibly serve — beginner, working practitioner, advanced?

### Audience

1. Who is your audience at the job-title or life-stage level?
2. What outcome do they want from you?
3. What have they already tried that did not work?
4. What do they know and not know about your domain?
5. Where do they hang out, and how do they describe their own problem in their own words?

### Voice

1. What tone register do you use — plain, technical, irreverent, formal, or something else?
2. What words and phrases do you use often?
3. What words and phrases do you refuse to use?
4. What sentence length and rhythm do you prefer?
5. What stance do you take toward your audience — peer, coach, operator, teacher, or something else?

### Offers

1. What do you sell? List each offer by name.
2. For each offer, what is the promise — the outcome the buyer is paying for?
3. For each offer, what is the delivery mechanism — course, cohort, software, service, community, or something else?
4. For each offer, who is it for, and who is it not for?
5. For each offer, what price tier is it — entry, mid, or premium? (Use those qualitative tiers; do not capture specific numbers in this file.)

### Beliefs

1. What do most people in your space believe that you think is wrong?
2. What principles do you defend even when they cost you customers?
3. What worldview is your work built on?
4. What trade-offs do you accept that others refuse to accept?

---

## Hard rules

- Walk one section at a time. Do not present all five at once.
- Never edit a section other than the one you are currently on.
- Never add example content of your own. Only write what the operator gave you.
- When you write a filled section, you MUST remove the original structural prompts AND the `<!-- fill -->` sentinel. A filled section contains the operator's content only, under its `## <SectionName>` heading.
- The sentinel string `<!-- fill -->` is the source of truth for "is this section unfilled?". Do not invent another detection rule.
- Preserve the file's existing top-of-file intro paragraphs and the `---` separators between sections. Do not rewrite the file from scratch; edit each section in place.
- If `brain/brain.md.template` is missing one of the five `## <SectionName>` headings, or if `brain/brain.md` is missing one of the five `## <SectionName>` headings after the bootstrap step has run, stop and tell the operator the template is malformed. Do not attempt to repair it; that is not this command's job. (The bare-not-exist case for `brain/brain.md` is handled by Step 1 and is not a malformed-repo condition.)
- End-of-flow confirmation is required even if all five sections were already populated and the operator skipped revising every one of them.
