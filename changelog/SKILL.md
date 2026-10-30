---
name: changelog
description: >
  Turn a diff or a session log into one clean CHANGELOG entry, in the project's own
  style: grouped Added / Changed / Fixed / Removed, user-visible effect first, the
  *why* kept when a change reverses or surprises. Single-repo and focused; use when
  the user says "write the changelog / what changed / log this", or after a batch of
  work that needs recording. Host-agnostic.
  Trigger: /changelog, "write the changelog", "changelog entry", "what changed", "log this".
---

# changelog — one entry, in the house style

## What this is
A focused changelog-writer for a single repo. It reads what actually changed (a
`git diff`, a range of commits, or a session log) and emits one dated section that
matches the project's existing CHANGELOG voice. Narrower than `release` (which bumps
versions and orchestrates a multi-repo push) — this just writes the entry well.

## 1. Read the change, not your memory
Pull the real delta before writing:
- `git diff <base>..HEAD --stat` then drill into the meaningful files.
- or a commit range / session log the user points at.
Never write a changelog from recall — you will miss reverts and overstate intent.

## 2. Match the existing voice
Open the current CHANGELOG first. Copy *its* conventions, don't impose new ones:
- heading shape (`## vX.Y.Z — YYYY-MM-DD` vs `## [X.Y.Z]`), date format, bullet style.
- whether it groups by Added/Changed/Fixed/Removed or runs a flat list.
- terminology the project already uses for its parts (pane names, subsystems, flags).

## 3. Write the entry
- One line per user-visible change. Lead with the **effect**, not the file.
- Group: **Added / Changed / Fixed / Removed** (or the project's own grouping).
- Keep the **why** when a change reverses a prior decision, surprises, or is a
  workaround — that sentence is the whole value of a changelog later.
- Name the user-facing surface (command, flag, error text), not the internal symbol,
  unless the audience is contributors.
- Fold pure-internal churn (refactor, rename, formatting) into one "Internal" line or
  drop it — a changelog is for the reader, not the committer.

## 4. Never rewrite history
Append above the latest version; leave older entries byte-for-byte. They record what
was true then — editing them to match new reality is a lie, not a tidy-up.

## Entry template
```markdown
## vX.Y.Z — YYYY-MM-DD
### Added
- <new capability, effect-first>
### Changed
- <changed behavior> — <why, if non-obvious>
### Fixed
- <bug> — <symptom the user saw>
### Removed
- <gone thing> — <what to use instead>
```

## Rules
- One entry per call; don't bump versions or touch other repos — that's `release`.
- Unreleased work goes under an `## [Unreleased]` heading until the version is cut.
- If nothing user-visible changed, say so — don't pad an entry to look productive.

## Notes
Pure protocol; any agent. Pairs with `release` (which calls this as its step 2) and
`sync` (propagating the version string the heading needs).
