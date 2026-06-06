---
name: sync
description: >
  Propagate one change to every place that references it — code, docs, version strings,
  config, sibling repos, JSON/YAML data. Use after a rename, a version bump, an API or
  contract change, or any edit where "did I update everywhere?" is a real question.
  Turns the error-prone manual sweep into a deliberate pass. Host-agnostic.
  Trigger: /sync, "update everywhere", "did I get all of them", "rename X to Y", "keep in sync".
---

# sync — change once, update everywhere

## What this is
When you change a thing, every *reference* to that thing is now potentially stale:
docs, READMEs, version badges, changelogs, comments, example commands, JSON/YAML
data, and other repos in the suite. This is a discipline for catching all of them
instead of the 80% you remember.

## The loop
1. **Name the change precisely.** Old token → new token (e.g. `hako-sho-stock` → `hako-sho`); old path → new path; old version → new version.
2. **Search wide, then judge.** Grep the *old* token across all file types — code, `*.md`, `*.html`, `*.json`, `*.yml`, Makefiles, configs — and any sibling repos in scope. Don't trust memory of where it appears.
3. **Classify each hit:**
   - **Live** → update it.
   - **Historical** → leave it (dated changelog entries, migration notes describing the old state — these are *correct* as history).
   - **Coincidental** → skip (substring false match).
4. **Apply** updates; prefer targeted edits.
5. **Re-grep** for the old token. Remaining hits should all be the historical/coincidental set you justified. Empty-or-justified = done.
6. **Validate** anything machine-read after edits: JSON/YAML parse, code builds, links resolve.

## Watch for
- The same fact mirrored in two formats (e.g. prose **and** an embedded JSON blob) — fix both.
- Version strings live in many spots: source `#define`, README badge, mockup/screenshot text, CHANGELOG heading, package metadata, website data.
- Renames break **both** the identifier **and** derived paths/filenames.
- Sibling repos: a contract owned by repo A is referenced in B, C, the website, the org profile.

## Honesty rule
Don't claim "updated everywhere / 100%" until step 5's re-grep is clean or every
remaining hit is explicitly justified. "I think I got them all" is the failure mode
this skill exists to kill.

## Notes
Pure search-and-judge protocol; works in any agent. Pairs with `release` (version
bumps). Always re-verify after a sweep — builds compile, JSON/YAML parse, links resolve.
