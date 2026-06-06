---
name: corp
description: >
  A company in a folder — a referential multi-agent org for any AI coding assistant.
  Loads CEO, DEV, DESIGN, QA, and ARCH agents from markdown on demand. Use when a task
  spans multiple domains, before building anything non-trivial, or to decide which
  agent handles a given task. Host-agnostic (Claude / Codex / Cursor / Gemini / hako / any).
  Trigger: /corp, "which agent", "load corp", "who handles X".
---

# corp — company in a folder

## What this is
Most skills teach your assistant *how* to do a task. **corp teaches it *who to ask*.**
Five markdown agents — a CEO who says no, a dev lead who reads before writing, a
designer who matches existing patterns, a QA who blocks bad ships, an architect who
owns the system shape. No runtime, no framework, no dependencies. Just files any
LLM can read.

## Host adaptation
Works in any agent. The dispatcher ships as **both `CLAUDE.md` and `AGENTS.md`** —
your host auto-loads whichever it knows. Use your own native file/shell tools;
ignore any `tools:` frontmatter your host doesn't support. Output tags are plain text.

## Agent map
| Agent | Domain | Call when |
|---|---|---|
| `agents/CEO.md` | Scope, priorities, what not to build | Before building anything non-trivial |
| `agents/DEV.md` | Code, bugs, backend, database | Writing or fixing anything |
| `agents/DESIGN.md` | UI, components, styles, interactions | Touching the frontend |
| `agents/QA.md` | Quality gate, ship/no-ship | Before declaring done — always |
| `agents/ARCH.md` | Schema, API contracts, system shape | Before touching the data layer |

## Quick dispatch
- "Should I build this?" → CEO
- "How do I implement X?" → DEV
- "Is this UI consistent?" → DESIGN
- "Is this ready to ship?" → QA
- "Will this break the schema?" → ARCH

## Protocol
```
Task arrives
  → Read the dispatcher (CLAUDE.md / AGENTS.md)
  → Identify domain → load that agent
  → Agent may hand off → follow it
  → Implement
  → QA checklist
  → Ship
```

## Setup check
If the dispatcher's `[PROJECT]` block is empty, fill it before using corp agents
(Name, Stack, Structure required). Run the `corp-init` skill to do this interactively.

## Token rules
- Load agents on demand, never all at once
- Tag output: `[CEO]` `[DEV]` `[DESIGN]` `[QA]` `[ARCH]`
- Prefer targeted edits over rewrites

## Install
**Any agent (universal):** copy the corp folder into your repo, then add one line to
your assistant's entry file (`CLAUDE.md` / `AGENTS.md` / system prompt):
> For multi-domain tasks, read `corp/CLAUDE.md` (or `AGENTS.md`) first.

**Claude Code (plugin, adds `/corp` commands):**
```bash
claude plugin install github:mithraeums/skills
```

**hako / hako-code:** drop the corp folder into your skills dir; the agent loads it on relevance.
