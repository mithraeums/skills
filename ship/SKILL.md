---
name: ship
description: >
  The pre-push gate: run the checks that decide whether a tag is allowed to leave:
  clean build on every target, ASan/valgrind, version bumped in *every* file, CHANGELOG
  synced, no debug cruft, docs match reality. Returns a pass/blocked verdict with the
  exact failures, never a vibe. Use before a release or when the user says "is this
  ready to ship / pre-flight / can I tag this". Host-agnostic.
  Trigger: /ship, "ready to ship", "pre-flight", "pre-tag", "can I tag", "ship check".
---

# ship — earn the tag before you push it

## What this is
A gate, not a launcher. `release` performs the push; `ship` decides whether you're
allowed to. It runs the suite's ship gates, then returns **PASS** or **BLOCKED: <list>**.
A single failed gate blocks — no "mostly green." Report what failed with the exact
output, never a summary that hides it.

## The gates (run all; collect failures, don't stop at first)

### 1. Build — clean, every target
- Build each supported target the project actually ships (e.g. `make`, plus any
  `BUNDLE_*` / OS branches). Treat **any warning** as a finding under `-Wall -Wextra`.
- Build the *no-optional-deps* variant too if one exists — the minimal build is a
  real user.

### 2. Memory — ASan, then valgrind
- ASan build, then walk the project's manual test matrix (TEST.md) end to end.
- `valgrind --leak-check=full` on Linux where available; at clean exit only libc
  atexit "still reachable" is allowed.
- If the platform can't run one (e.g. no valgrind on macOS), say so explicitly —
  "skipped, unavailable" is a reportable state, not a pass.

### 3. Version — bumped everywhere, drift-free
- Re-grep the **old** version string. Every remaining hit must be historical
  (a dated changelog line) — a live hit in source/README/site is a BLOCK.
- Confirm the **new** version is present in: source constant, package metadata,
  README badge, any mockup/screenshot text, CHANGELOG heading. (This is `sync`'s job;
  `ship` verifies it was done.)

### 4. Changelog — synced to the diff
- A dated section exists for the new version, and it matches what actually changed
  (`git diff` the range). No "v0.1.5" heading over a v0.1.4 entry.

### 5. Cruft — nothing debug ships
- No leftover debug prints, `TODO: remove`, commented-out blocks, hardcoded local
  paths, secrets/keys, or `-rc`/`-dev` suffixes in the version being tagged.

### 6. Docs — match reality
- Install steps, flags, and command names in README/site reflect the binary you're
  about to ship. Stale command in the docs = a finding.

## Verdict format
```
SHIP CHECK — <project> <version>
[x] build         clean, 3 targets
[x] asan          TEST.md walked, 0 reports
[ ] valgrind      SKIPPED — no valgrind on macOS (run on Linux runner)
[ ] version       BLOCK — old "0.1.4" still live at README.md:12, hake.c:6338
[x] changelog     v0.1.5 section matches diff
[x] cruft         none
[x] docs          install + flags current

VERDICT: BLOCKED — version drift (2 hits). Fix, re-run.
```

## Rules
- One BLOCK blocks. Don't average gates into "good enough."
- Never claim a gate passed you didn't run — report skips as skips.
- `ship` reads and checks; it does not bump, fix, or push. Findings hand off to
  `sync` (version), `changelog` (entry), then `release` (the push).

## Notes
Pure protocol; any agent. The enforcement half of `release` — run `ship` until PASS,
then `release` to push.
