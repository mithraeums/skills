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

> This is the host-agnostic skill entry. Claude Code hosts may read `CLAUDE.md`
> (same dispatcher); hako / hako-edit and other skill loaders read this file.
> The `agents/` directory sits next to this file — read `agents/<NAME>.md` with
> your own file-read tool.

## What this is
Most skills teach your assistant *how* to do a task. **corp teaches it *who to ask*.**
Five markdown agents — a CEO who says no, a dev lead who reads before writing, a
designer who matches existing patterns, a QA who blocks bad ships, an architect who
owns the system shape. No runtime, no framework, no dependencies. Just files any
LLM can read.

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
  → Read this dispatcher
  → Identify domain → load that agent (agents/<NAME>.md)
  → Agent may hand off → follow it
  → Implement
  → QA checklist
  → Ship
```

## Setup check
If a `[PROJECT]` block (in `CLAUDE.md` / `AGENTS.md`) is empty, fill it before using
corp agents (Name, Stack, Structure required). All agents defer to it.

## Token rules
- Load agents on demand, never all at once
- Tag output: `[CEO]` `[DEV]` `[DESIGN]` `[QA]` `[ARCH]`
- Prefer targeted edits over rewrites
