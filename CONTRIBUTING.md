# Contributing a skill

A skill is a folder of markdown. No runtime, no build step. If it works as text an
agent can read, it belongs here.

## Shape

```
<skill-name>/
├── SKILL.md          dispatcher: frontmatter + intro + map of the other files
└── (any *.md, agents/, helpers, assets)
```

`SKILL.md` starts with frontmatter:

```yaml
---
name: <skill-name>        # must match the folder name
description: >
  One paragraph: what it does, when to load it, the trigger phrases.
---
```

The description is what an agent sees before it decides to load the rest, so it
carries the weight: say when to use it, in the words a user would type.

## Rules

- **Dispatcher-shaped.** `SKILL.md` orients the model and points at the other files.
  Aim for under ~60 lines; if it needs more, split the rest into files it links.
- **Referential, not prescriptive.** Give the model what it needs to reason, not a
  script to recite.
- **Token budget first.** Every line is paid for on every load.
- **Host-agnostic.** No assumptions about one agent's tools. It should read the same
  in hako, hake's Rei pane, Claude Code, Codex, Cursor or a plain chat.

## Try it before you open a PR

```sh
# in hako
:skill install <you>/skills/<skill-name>
:skills                      # it is listed
:use <skill-name>            # turn it on as a mode, then use it
```

Or from a checkout, for every agent on the machine: `sh install.sh <skill-name>`.
If it should install as a Claude Code plugin too, add it to `.claude-plugin/marketplace.json`
and run `claude plugin validate .`.

## Send it

```sh
git clone https://github.com/mithraeums/skills
git checkout -b add/<skill-name>
# add <skill-name>/SKILL.md (+ any other files)
git push origin add/<skill-name>
# open a PR; add a row to the catalog in README.md and an entry in .claude-plugin/marketplace.json
```

License: GPL-3.0, like the rest of the repo.
