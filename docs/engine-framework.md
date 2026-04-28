# The aiceOS Engine Framework

Every aiceOS engine is built on the same five-layer architecture. Two of those layers are populated by you. The other three are produced by engines at runtime. This document defines all five layers, what each one is for, who produces it, who consumes it, and how the layers connect into a single feedback-driven loop.

## The five layers at a glance

1. **Reference** — winning examples from creators in your niche. *You supply this.*
2. **Pattern** — reusable templates extracted from your References. *Engine-generated.*
3. **Brain** — the stuff only you know: expertise, audience, voice, offers, beliefs. *You supply this.*
4. **Synthesis** — the deliverable an engine produces by combining a Pattern with your Brain. *Engine-generated.*
5. **Feedback** — performance data on what shipped, used to reweight what the engine reaches for next. *Engine-generated.*

Read each section below for the full job description of each layer.

---

## Reference

**Job.** Hold winning examples from creators in the niche you want to model — URLs, transcripts, screenshots — so the engine can see what is already working in your space.

**Produced by.** You. This is one of the two member-input layers. You decide which creators are worth modeling and which specific pieces represent their best work.

**Consumed by.** Engines, when they are extracting Patterns. An engine reads the entire `/reference/` folder and pulls out reusable structures — hooks, beats, transitions, layouts — stripped of the original creator's specific content.

**Where it lives.** `/reference/` in this repo. The folder is scaffolded with two suggested subfolders: `creators/` (one folder per creator you want to model) and `posts/` (one file per individual standout piece). See `/reference/README.md` for guidance on what to drop in and how to organize it.

**Note.** Quality over quantity. Five great examples from one creator beat fifty mediocre ones from twenty.

---

## Pattern

**Job.** Hold reusable templates extracted from References — the shape of a winning hook, the beat structure of a winning post, the rhythm of a winning thread — with the original creator's specific content stripped out so the templates can be filled with anything.

**Produced by.** Engines. You do not write Patterns. When an engine runs, it reads your Reference folder and emits Patterns as a working artifact.

**Consumed by.** Engines, in the next step of the chain. A Pattern is the structural half of any Synthesis. The Brain provides the content half. Patterns are also reweighted over time by the Feedback layer — engines learn which Patterns produced output that performed well for you specifically.

**Where it lives.** Wherever the engine module decides to put it. The foundation does not ship a Pattern folder because Pattern artifacts are engine-managed, not member-managed. Each engine module documents where its own Pattern artifacts are written.

---

## Brain

**Job.** Hold the things only you know — your domain expertise, who your audience is, how you sound, what you sell, and what you actually believe. This is what makes engine output sound like you instead of a generic remix of the creators in your Reference folder.

**Produced by.** You. This is the second of the two member-input layers.

**Consumed by.** Engines, on every generation. Whatever the deliverable — script, post, offer, thumbnail, email — the engine loads your Brain to fill in the content half of the Synthesis.

**Where it lives.** A single consolidated file: `/brain/brain.md`. It has exactly five sections, one per Brain element: Expertise, Audience, Voice, Offers, Beliefs. The file is created from `/brain/brain.md.template` the first time you run `/setup-brain`, so a fresh clone shows only the template until then. The filled `brain.md` is gitignored and stays local to your machine.

**How to populate it.** Run the `/setup-brain` slash command from inside Claude Code in this repo. The command walks you through one section at a time, asks focused questions, and writes your answers back into `brain.md` for you. Do not edit `brain.md` by hand. The command is idempotent — sections you have already filled are skipped on re-run unless you ask to revise them. See `/brain/README.md` for the full description of the Brain layer.

---

## Synthesis

**Job.** Hold the actual deliverables an engine produces — the scripts, the posts, the offers, the thumbnails, the emails. This is the layer that earns the engine its keep. Everything before Synthesis is preparation; Synthesis is what ships.

**Produced by.** Engines. An engine produces a Synthesis artifact by combining a Pattern (the structural half) with your Brain (the content half).

**Consumed by.** Whatever channel ships the artifact — a video editor, a posting tool, a delivery platform, a CRM. Once a Synthesis artifact ships into the world, its performance becomes the input to the Feedback layer.

**Where it lives.** Wherever the engine module decides to put it. Like Pattern, Synthesis artifacts are engine-managed and not part of the foundation scaffold. Each engine module documents where its own Synthesis artifacts are written.

---

## Feedback

**Job.** Capture what worked and what flopped after a Synthesis artifact ships, and reweight the engine so future runs reach for what worked more often and what flopped less often.

**Produced by.** Engines. An engine collects performance data on shipped Synthesis artifacts — views, completion rate, conversion, replies, whatever the relevant signal is for that engine's deliverable — and turns it into weights the next run consults.

**Consumed by.** The same engine on its next run, when it picks which Patterns to use and how to bias the Synthesis. Feedback closes the loop: it is what makes the engine get sharper over time for you specifically rather than staying generic.

**Where it lives.** Wherever the engine module decides to put it. Like Pattern and Synthesis, Feedback artifacts are engine-managed and not part of the foundation scaffold.

---

## Layer hierarchy

The five layers are not equals. They have an order of authority.

Reference establishes what works in your niche — by definition, because the references you supplied are pieces with proof. Pattern extracts the structural truth from Reference. Brain fills the content slots inside that structure. Synthesis combines them in that order of authority.

When Brain conflicts with Pattern, Pattern wins.

This matters because there is a real failure mode where a member says "but my voice is more thoughtful" or "my brand is less aggressive" and the engine softens a winning structure to accommodate. That softening produces output that does not perform — because the structure is what made the original references work, not the voice that filled it.

The structural elements of a Pattern — hook formula, beat sequence, retention mechanics, CTA placement, opening pattern interrupt — are load-bearing. They came from work that proved itself. Your voice fills the words inside that structure. Your voice does not flex the structure.

If your voice cannot survive the structure of winning content in your niche, your voice needs to flex, not the structure.

Reference and Pattern are grounded in proven performance. Brain is grounded in member preference. When they conflict, the engine sides with proven performance.

---

## Data flow

The five layers connect in a single chain. Read this top-to-bottom; each step names who reads what and who writes what.

1. **You write Reference.** You drop winning examples from creators in your niche into `/reference/` (URLs, transcripts, screenshots).
2. **You write Brain.** You run `/setup-brain` and the command writes your expertise, audience, voice, offers, and beliefs into `/brain/brain.md`.
3. **The engine reads References and writes Pattern.** When an engine module runs, it scans `/reference/` and extracts reusable structural templates, stripped of the original creators' content.
4. **The engine reads Pattern and Brain and writes Synthesis.** It picks a Pattern, fills it with content drawn from your Brain, and produces the actual deliverable.
5. **The Synthesis artifact ships.** It goes out into the world through whatever channel the engine targets.
6. **The engine reads performance data and writes Feedback.** It records what happened and turns the result into weights.
7. **The next run reads Feedback to bias step 3 and step 4.** Patterns that produced winning Synthesis are reached for more often; Patterns that produced flops are reached for less often. The engine sharpens over time for you specifically.

The two layers you write to (Reference and Brain) are the only places your hand touches the loop. Everything else is engine-managed: Pattern is engine-extracted from your Reference, Synthesis is engine-produced from Pattern plus Brain, Feedback is engine-recorded from how Synthesis performed.

This is the framework every aiceOS engine module is built on. Specific engines specialize the layers — a video engine extracts video-shaped Patterns and produces video-shaped Synthesis; a writing engine does the same for written work — but the five-layer shape and the data flow are constant.
