---
name: handoff
description: >
  Write a START-HERE state doc so the next session (you, later, or a teammate) resumes
  in seconds instead of re-deriving everything. Use at session end, before a long pause,
  when context is about to compact, or when the user says "wrap up / save state / where
  were we". Captures done / next / gotchas — not a transcript. Host-agnostic.
  Trigger: /handoff, "wrap up", "save state", "where were we", "hand off", "session notes".
---

# handoff — resume in seconds

## What this is
A single living state doc that answers, for the next session: *what's done, what's
next, and what will bite you.* Optimized for fast re-entry, not completeness.

## When to write
- End of a work session.
- Right before context compaction / a long break.
- After a milestone (a decision made, a phase finished).
- When the user asks to wrap up or save state.

## Where
A durable file the next session loads first — e.g. `STATE.md` at repo root, or a
`project` memory (see the `memory` skill). One file; keep it current by editing in
place, not appending forever.

## Structure
```markdown
# STATE — <project> (updated <absolute date>)

## ★ Start here
<the one or two sentences that orient someone instantly>

## Done (verified)
- <what's complete + how it was confirmed>

## Open / next
1. <next action, most important first> — <why / blocker>

## Decisions (don't re-litigate)
- <choice made + the reason, so it isn't reopened>

## Gotchas
- <traps: a path that breaks, an assumption proven wrong, an env quirk>
```

## Rules
- **Absolute dates**, never "yesterday" / "last session".
- Record **decisions with their why** so they don't get reopened.
- Mark what's **verified** vs assumed.
- Newest/most-important state at the **top**.
- Edit the existing doc; don't let it grow into a log. Prune what's no longer true.
- It's point-in-time: when resuming, verify any named file/flag still exists before trusting it.

## Notes
Pure markdown; any agent. Pairs with `memory` (durable facts) and `release` (a push
checklist is a kind of handoff).
