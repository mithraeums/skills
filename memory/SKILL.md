---
name: memory
description: >
  Persistent file-based memory for any agent. Keep durable facts across sessions in a
  MEMORY.md index + one-fact-per-file, with rules for what to save, how to recall, and
  how to avoid stale/duplicate memories. Use when the user shares a durable preference,
  a project constraint, or says "remember this" / "from now on" — or at session start
  to recall. Host-agnostic; no database, just markdown.
  Trigger: /memory, "remember", "don't forget", "save this", "what do you know about".
---

# memory — durable knowledge in markdown

## What this is
A portable long-term memory: a `memory/` folder where each fact is one small file,
indexed by a `MEMORY.md` you load at session start. No runtime — just files any
agent can read and write.

## Layout
```
memory/
├── MEMORY.md              ← index: one line per fact, loaded every session
└── <slug>.md              ← one fact per file, with frontmatter
```

Each fact file:
```markdown
---
name: <short-kebab-slug>
description: <one line — used to judge relevance on recall>
type: user | preference | project | reference
---
<the fact. link related facts with [[other-slug]].>
```

`MEMORY.md` line: `- [Title](slug.md) — short hook`. One line each. Never put fact
bodies in the index.

## What to save
- **user** — who they are: role, stack, expertise, hard preferences.
- **preference** — how they want you to work (a correction, a confirmed approach) + *why*.
- **project** — goals/constraints not derivable from the code or git history; convert relative dates to absolute.
- **reference** — pointers to external resources (URLs, dashboards, tickets).

## What NOT to save
- Anything the repo already records (code structure, past fixes, git history).
- Things that only matter to the current conversation.
- If asked to remember something obvious, ask what was *non-obvious* about it and save that.

## Recall
At session start (or when a task touches a known area), read `MEMORY.md`; pull the
fact files whose description looks relevant. Treat recalled facts as point-in-time —
if one names a file/flag/function, verify it still exists before relying on it.

## Hygiene
- Before saving, check for an existing file that covers it — update, don't duplicate.
- Delete facts that turn out wrong.
- Link related facts with `[[slug]]`; a link to a not-yet-written slug is fine.

## Notes
Pure markdown, no deps — works in any agent. Pairs with `handoff` (session-state)
and `corp` (give agents a shared `STATE.md`).
