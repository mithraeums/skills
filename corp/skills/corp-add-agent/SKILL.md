---
name: corp-add-agent
description: >
  Scaffolds a new corp agent file and wires it into the org. Use when a domain grows
  large enough to deserve its own agent (auth, infra, ML, data pipeline, payments, etc.).
  Trigger: /corp:add-agent, "add agent", "new agent", "create agent for X".
---

# corp:add-agent — scaffold a new agent

You are adding a new specialist agent to the corp org. Follow this in order.

## Step 1 — Gather info

Ask the user (one message):

> To create the new agent, I need:
> 1. **Domain** — what does this agent own? (e.g. "auth", "payments", "infra", "ML pipeline")
> 2. **Knows** — what files, services, or systems does it have expertise over?
> 3. **Calls** — which existing agents does it hand off to? (CEO / DEV / DESIGN / QA / ARCH)
> 4. **Called by** — which existing agents should call this one?
> 5. **Tools** *(optional)* — if your host scopes tools per agent (e.g. Claude Code), which does it need? (read, write, edit, shell, search). Hosts that don't scope tools ignore this.

Wait for response.

## Step 2 — Create the agent file

Create `.claude/agents/<DOMAIN>.md` using this exact structure:

```markdown
---
name: corp-<domain>
description: Load when <one-line trigger description>. <What it owns>. <When to call it>.
tools: <tools from user input>
---

# <DOMAIN>.md
> <One-line purpose statement.>

## ROLE
<What this agent owns and is responsible for. 2-3 lines max.>

## KNOWS
- <File paths, services, or systems it has expertise over>
- <Add one per line>

## PRINCIPLES
- <Domain-specific rules — what to check before acting, what to never do>
- <Keep under 5 lines>

## CALLS
- <AgentName>.md → <when and why>

## OUTPUT
```
[<TAG>] <domain-specific output format matching existing agents>
```
```

Use SCREAMING_SNAKE for the tag (e.g. AUTH, INFRA, ML).
Keep the whole file under 50 lines.

## Step 3 — Wire into CLAUDE.md

Read `.claude/CLAUDE.md`. Add a row to the Agent Map table:

```
| <Domain description> | <DOMAIN>.md |
```

## Step 4 — Wire into existing agents

For each agent the user listed under "Called by":
- Read that agent's file
- Add a line to its `## CALLS` section:
  ```
  - <DOMAIN>.md → <when to call it>
  ```

## Step 5 — Confirm

Tell the user:
- File created at `.claude/agents/<DOMAIN>.md`
- Which agents now reference it
- Suggest 1-2 things to add to the KNOWS section once they start using it

## Rules
- Never create an agent over 50 lines — if scope demands more, split it
- Match the formatting of existing agents exactly
- Don't modify anything outside the Agent Map row and CALLS sections of existing agents
- Tag must be unique — check existing agents before assigning
