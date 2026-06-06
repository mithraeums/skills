---
name: corp
description: Load when working in any repo with corp agents. Dispatches tasks to specialized agents by domain. Read before any multi-domain task, feature build, or architectural decision.
---

# corp — dispatcher
> Read this first. Always. (This file = `AGENTS.md` = the corp entry. Same content; your host reads whichever it loads.)

## Host adaptation (read once)
This org is host-agnostic — you may be Claude Code, Codex, Cursor, Gemini, Aider,
hako, or another agent. Adapt automatically:
- **Entry:** whichever of `CLAUDE.md` / `AGENTS.md` your host auto-loads — both carry this dispatcher.
- **Agents:** live in `agents/` next to this file. Read `agents/<NAME>.md` with your own file-read tool.
- **Tools:** use YOUR native file/shell tools. Ignore any `tools:` frontmatter field your host doesn't recognize.
- **Tags:** `[CEO]` etc. are plain text — they work everywhere.

## [PROJECT]
Name:
Stack:
Structure:
Entry:
Docs:
Conventions: (tabs/spaces, naming, async patterns, test framework, etc.)

---

## Agent Map
| Task type | Read |
|---|---|
| Scope, priorities, what to build next | agents/CEO.md |
| Code, implementation, bugs | agents/DEV.md |
| UI, layout, components, styles | agents/DESIGN.md |
| Testing, edge cases, before shipping | agents/QA.md |
| System boundaries, schema, contracts | agents/ARCH.md |

## Dispatch Rules
1. Identify domain → pull that agent
2. Agent may call another → follow it
3. Never invent architecture — check ARCH.md first
4. Never ship without QA.md
5. Priority unclear → CEO.md

## Token Rules
- Load agents on demand, never all at once
- Read [PROJECT] before acting — all agents defer to it
- Prefer targeted edits over rewrites
- Tag all output: `[CEO]` `[DEV]` `[DESIGN]` `[QA]` `[ARCH]`
