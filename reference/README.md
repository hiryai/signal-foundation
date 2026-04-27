# Reference

The Reference layer is one of the two member-input layers in the aiceOS five-layer engine framework. The other member-input layer is Brain. The remaining three layers (Pattern, Synthesis, Feedback) are produced by engine modules at runtime, not by you.

## What this layer is for

Reference holds **winning examples from creators in the niche you want to model**. An engine reads this folder when it needs to learn what is already working in your space — what hooks land, what structures keep attention, what beats convert.

You supply the proof. The engine extracts the reusable parts.

## What goes in here

Three kinds of artifacts, each as a separate file:

- **URLs** — links to specific posts, videos, threads, or pages that are working right now. One link per file, with a short note on why it works.
- **Transcripts** — full text of the spoken or written content of a winning piece. Plain text or markdown.
- **Screenshots** — images of the visual layout, on-screen captions, thumbnails, or framing of a winning piece. Drop them in alongside the URL or transcript they belong to.

Quality over quantity. Five great examples from one creator beats fifty mediocre ones from twenty.

## Suggested organization

Two subfolders are already scaffolded for you:

- `creators/` — one subfolder per creator you want to model. Inside each creator's folder, drop URLs, transcripts, and screenshots of their best work. Use this when the creator is the unit of study (their voice, their patterns across many pieces).
- `posts/` — one file per individual standout piece, regardless of who made it. Use this when the piece is the unit of study (a specific viral hook you want to deconstruct on its own).

Pick whichever organization fits the example. You can use both. The engine reads the whole folder.

## What an engine does with this folder

When an engine module runs, it scans `/reference/` to extract reusable templates — hooks, structures, beats, transitions — stripped of the original creator's specific content. Those templates become the Pattern layer. Pattern is then combined with your Brain to produce Synthesis (the actual scripts, posts, offers the engine ships).

You never write to Pattern, Synthesis, or Feedback directly. You only feed Reference.

## What does NOT go in here

Your own voice, your own expertise, your audience, your offers, your beliefs — those belong in `/brain/brain.md`, not here. Reference is what other people are doing well. Brain is what only you know.
