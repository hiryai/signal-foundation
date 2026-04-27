# aiceOS Foundation

Starter repo for an aiceOS engine builder. This is the foundation every engine module is built on top of: a five-layer engine framework, two clean folders for the layers you populate yourself (Brain and Reference), and a guided command that walks you through filling your Brain so you do not have to edit a markdown file by hand.

## If you just cloned this, do these steps in order

These five steps are sequential. Each one depends on the previous one having completed. Work top-to-bottom and you will end up with a working environment, a populated Brain, a populated Reference folder, a clear understanding of all five layers, and a clean place to install your first engine module.

### 1. Set up Claude Code

Install Claude Code, configure your API key, add the `rtd` plugin marketplace, install the `code-foundations` plugin, and verify the install. The full walkthrough is in:

- [`docs/claude-code-setup.md`](docs/claude-code-setup.md)

Do not skip this step. The slash command in step 3 only runs inside Claude Code. Until the environment is set up, the rest of the on-ramp cannot proceed.

### 2. Read the engine framework

Read the doc that defines the five-layer architecture every aiceOS engine is built on (Reference, Pattern, Brain, Synthesis, Feedback) and the data flow that connects them:

- [`docs/engine-framework.md`](docs/engine-framework.md)

You only have to do this once. Everything in the rest of the on-ramp — and everything in every engine module you install later — assumes you understand what each of the five layers is for.

### 3. Populate your Brain

From inside the cloned repo, with Claude Code running, run the guided slash command:

```
/setup-brain
```

The command walks you through one section of `brain/brain.md` at a time, asks focused questions, and writes your answers back into the file for you. It covers the five Brain sections: Expertise, Audience, Voice, Offers, Beliefs.

Do not edit `brain/brain.md` by hand. The supported path is `/setup-brain`. The command is idempotent — if you stop partway through, re-running it picks up where you left off.

For more on what the Brain layer is and why it sits where it does in the framework, see [`brain/README.md`](brain/README.md).

### 4. Populate the Reference folder

Drop winning examples from creators in your niche into `/reference/`. Three kinds of artifacts are supported: URLs (one link per file with a short note), transcripts (full text of the spoken or written content), and screenshots (images of the visual layout, captions, thumbnails, or framing). Two subfolders are scaffolded for you: `creators/` (organize by creator) and `posts/` (organize by individual standout piece). Use whichever fits the example.

Quality over quantity. Five great examples beat fifty mediocre ones.

For the full layer description and detailed organization guidance, see:

- [`reference/README.md`](reference/README.md)

### 5. Install your first engine module

The foundation is now in place. You have a working environment, a populated Brain, a populated Reference folder, and a clear understanding of the five-layer framework — which is exactly the shape every engine module expects to find.

Engine modules are distributed separately from this foundation. Each one specializes the framework for a particular kind of deliverable (video scripts, written posts, offers, thumbnails, emails, and so on) and ships with its own install instructions. Pick the engine that matches what you want to ship next, follow its README, and it will read your Brain and Reference folders, extract Patterns, produce Synthesis, and (over time) close the Feedback loop.

You are now ready to install one. The foundation work is done.

## Repo layout

```
aiceos-foundation/
  README.md                       this file — the on-ramp
  brain/
    README.md                     what the Brain layer is for
    brain.md                      your Brain (populated via /setup-brain)
  reference/
    README.md                     what the Reference layer is for and how to organize it
    creators/                     organize by creator
    posts/                        organize by individual standout piece
  docs/
    engine-framework.md           the five-layer framework, definitions and data flow
    claude-code-setup.md          zero-to-working Claude Code install
  .claude/
    commands/
      setup-brain.md              the /setup-brain slash command
```

Two of those folders are yours to write to: `brain/` and `reference/`. Everything else is the framework and the tooling that supports it.
