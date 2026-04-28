# Brain

The Brain layer is one of the two member-input layers in the aiceOS five-layer engine framework. The other member-input layer is Reference. The remaining three layers (Pattern, Synthesis, Feedback) are produced by engine modules at runtime.

## What this layer is for

Brain is **the stuff only you know**: your domain expertise, who your audience is, how you sound, what you sell, and what you actually believe. An engine reads your Brain on every generation. It is what makes the output sound like you instead of a generic copy of the creators in your Reference folder.

## The five sections of brain.md

Your Brain lives in a single file: `brain.md`. It has five sections, one per Brain element:

- **Expertise** — what you know deeply enough to teach
- **Audience** — who you are speaking to and what they want
- **Voice** — how you sound, what you say, what you refuse to say
- **Offers** — what you sell, the promise of each, and how each one is delivered
- **Beliefs** — the strong opinions and worldview that make you distinctive

Each section starts unfilled and contains a sentinel marker the setup command uses to detect that the section still needs content.

## How to fill it

**Do not edit `brain.md` by hand.** Instead, run the guided slash command from inside Claude Code:

```
/setup-brain
```

The command will walk you through one section at a time, ask focused questions, and write your answers back into the matching section of `brain.md` for you. It is idempotent — sections you have already filled are skipped on re-run unless you ask to revise them.

Editing `brain.md` directly is not the supported path. Use `/setup-brain` rather than typing into the file.

The file ships as `brain.md.template`, not `brain.md`. The first time you run `/setup-brain`, the command bootstraps `brain.md` by copying the template verbatim, then walks you through filling it. `brain.md` is gitignored so your filled answers stay local to your clone and are not committed to the shared Foundation repo. The template stays tracked because it is the on-ramp every new clone needs to get started.

## What an engine does with your Brain

When an engine module generates an artifact (a script, a post, an offer, a thumbnail, an email), it loads `/brain/brain.md` and combines it with a Pattern extracted from your Reference folder. The output is the Synthesis layer — the actual deliverable. Performance data on what shipped feeds the Feedback layer, which reweights future generations.

Your Brain is the constant. Reference can grow as you discover new creators worth modeling. Pattern, Synthesis, and Feedback are generated and updated by engines, not by you.
