# CORP
**A company in a folder. Lightweight multi-agent org structure for AI coding assistants.**

Drop a `corp/` folder into any repo and give your assistant a CEO, a dev lead, a designer, a QA engineer, and a systems architect — all in markdown. No frameworks, no orchestration layer, no dependencies. Just files any LLM can read.

**Host-agnostic.** The dispatcher ships as both `CLAUDE.md` and `AGENTS.md`, so it auto-loads in **Claude Code · Codex CLI · Cursor · Gemini CLI · Aider · hako** and any tool that reads the Agent Skills / AGENTS.md standard. It molds to its host — use your native tools, ignore frontmatter your host doesn't grok.

---

## What It Is
Most skills teach your assistant *how* to do a task. Corp teaches it *who to ask*.

Each agent is a markdown file with a defined role, domain knowledge, and a handoff protocol. The dispatcher routes tasks to the right agent. Agents call each other when work crosses domains. Nothing is loaded that isn't needed.

```
corp/
├── CLAUDE.md            ← dispatcher (Claude hosts), always read first
├── AGENTS.md            ← same dispatcher (Codex/Cursor/Gemini/… hosts)
└── agents/
    ├── CEO.md           ← scope, priorities, what not to build
    ├── DEV.md           ← code, backend, database
    ├── DESIGN.md        ← UI, components, CSS, interactions
    ├── QA.md            ← quality gate, ship/no-ship
    └── ARCH.md          ← schema, API contracts, system boundaries
```

---

## Install

**Any agent (universal):** copy the `corp/` folder into your repo, then add one line to your assistant's entry file (`CLAUDE.md` / `AGENTS.md` / system prompt):
> For multi-domain tasks, read `corp/CLAUDE.md` (or `AGENTS.md`) first.

**As a Claude Code plugin** (enables `/corp` slash commands):
```bash
claude plugin install github:mithraeums/skills
```

**Manual clone:**
```bash
git clone https://github.com/mithraeums/skills .skills-tmp
cp -r .skills-tmp/corp ./corp
rm -rf .skills-tmp
```

---

## Slash Commands

Once installed as a plugin, these commands are available in Claude Code:

| Command | What it does |
|---|---|
| `/corp` | Quick-reference: agent map, dispatch protocol, setup status |
| `/corp:init` | Interactive setup wizard — fills in `[PROJECT]` and `ARCH.md` by asking questions |
| `/corp:add-agent` | Scaffolds a new specialist agent and wires it into the org |

Start with `/corp:init` on a new repo. Takes about 2 minutes.

---

## Setup (manual)
If not using the plugin, fill in two files:

**1. `[PROJECT]` block in the dispatcher (`CLAUDE.md` / `AGENTS.md`)**
```
Name: your-project
Stack: language · framework · database · frontend
Structure: /src · /api · /components
Entry: main entrypoints
Conventions: tabs/spaces, naming style, test framework
```

**2. Entity/contract section in `agents/ARCH.md`**
Sketch your data model and API shapes. Keep it under 40 lines.

Everything else works as-is.

Full guide: [CONTRIBUTING.md](CONTRIBUTING.md)

---

## How It Works
```
Task arrives
  → your assistant reads the dispatcher (CLAUDE.md / AGENTS.md)
  → Identifies domain
  → Reads relevant agent
  → Agent may call another agent
  → Implements
  → QA.md checklist
  → Ships
```

Agents are **referential, not prescriptive** — they tell your assistant what it knows and who to consult, not what to do step by step. This keeps token usage low and lets the model reason rather than follow a script.

Each agent tags its output: `[CEO]` `[DEV]` `[DESIGN]` `[QA]` `[ARCH]` so you always know who's talking.

---

## Design Principles
**Token-first.** Every line earns its place. Agents load on demand, not upfront. The whole org is under 500 lines.

**Referential over prescriptive.** Agents know what they know. They don't script every step — they orient the model and hand off.

**Generic core, project-specific edges.** Only the `[PROJECT]` block in `CLAUDE.md` and the entity section in `ARCH.md` change per repo. Everything else ports as-is.

**Output-tagged.** Every agent response carries its tag. You always know who's talking.

---

## Adding Agents
When a domain grows large enough (auth, infra, ML, payments, data pipeline):

Use `/corp:add-agent` or do it manually:
1. Copy the structure: `ROLE · KNOWS · CALLS · OUTPUT FORMAT`
2. Add it to the Agent Map table in `CLAUDE.md`
3. Reference it from relevant existing agents' `CALLS` sections
4. Keep it under 50 lines — if longer, split it

---

## Compatibility
| Tool | Path | Status |
|---|---|---|
| Claude Code | `.claude/agents/` | ✅ native + plugin |
| Codex CLI | `codex.md` + agents | ✅ compatible |
| Cursor | `.cursor/rules/` | ✅ copy agents there |
| Gemini CLI | `GEMINI.md` + agents | ✅ compatible |
| OpenCode | `.agents/` | ✅ compatible |
| Any AGENTS.md tool | root `AGENTS.md` | ✅ copy dispatcher |

---

## Inspired By
- Caveman Claude compression principles
- Karpathy's LLM idea file patterns
- The Agent Skills open standard

---

*corp is a skill, not a framework. It has no runtime, no install step, no version to update. It's just files that know how to work together.*
