---
name: release
description: >
  Cut a clean release: bump the version consistently everywhere, write the changelog
  entry, and generate a push-order checklist — including multi-repo suites where order
  matters. Use when the user says "ship it / cut a release / bump the version / push
  everything", or is juggling several repos. Host-agnostic.
  Trigger: /release, "cut a release", "bump version", "push order", "ship it", "tag".
---

# release — bump, log, push, in order

## What this is
A repeatable release discipline. Versions live in many files and multi-repo pushes
have a load-bearing order; this turns "which repos, what version, in what order" from
stressful recall into a generated checklist.

## 1. Version bump (use the `sync` discipline)
Pick the bump (semver: patch = fix, minor = feature, major = break). Update the
version in **every** spot — they drift:
- source constant (`#define VERSION` / `__version__` / etc.)
- package metadata (package.json, Cargo.toml, pyproject, …)
- README badge + any mockup/screenshot text
- CHANGELOG heading
- any website / data file that names the version

Re-grep the old version; remaining hits must be historical (dated changelog) only.

## 2. Changelog entry
Add a dated section under the new version. Group **Added / Changed / Fixed /
Removed**. Lead each line with the user-visible effect; include the *why* when a
change reverses or surprises. Keep prior entries intact — they're history, never edit
old versions to match new reality.

## 3. Push order (single repo)
```
commit (clear message) → push branch → tag vX.Y.Z → push tag (triggers release CI)
```
If release CI is new/untested: push a throwaway `-rc` tag first, watch it go green,
delete it, then push the real tag.

## 4. Push order (multi-repo suite)
Order by dependency: **the thing others reference goes first.**
1. List repos + what each depends on.
2. Sort: shared lib / engine / contract → consumers → docs/site/profile → unchanged (skip).
3. For each: what changed, commit message, tag (if any), one verify step.
Emit it as a checklist file (e.g. `PUSH.md`) the user can walk top-to-bottom.

## Checklist template
```markdown
# PUSH — <suite> (<date>)
order: A (vX) → B (vY) → site → profile
- [ ] A: <changed> · commit "<msg>" · tag vX · verify <…>
- [ ] B: <changed> · commit "<msg>" · tag vY · verify <…>
- [ ] site: <changed> · push, no tag
```

## Rules
- Never reuse a public tag — if vX shipped wrong, ship vX+1, don't force-retag.
- Don't claim released until CI is green / the artifact exists.
- State plainly what's pushed vs pending.

## Notes
Pure protocol; any agent. Pairs with `sync` (version propagation) and `handoff`
(the checklist survives the session).
