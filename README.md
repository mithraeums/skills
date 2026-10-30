<p align="center">
  <a href="https://mithraeums.github.io">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://mithraeums.github.io/assets/banner-skills-night.png"/>
      <img src="https://mithraeums.github.io/assets/banner-skills.png" alt="skills: behaviors for any agent, by name" width="100%"/>
    </picture>
  </a>
</p>

<p align="center">
  <em>plain markdown behaviors for any agent that reads <a href="https://agentskills.io">Agent Skills</a>: hako, Claude Code, Codex, OpenCode, Cursor, Copilot, Hermes</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/version-pre--1.0-e2402e?style=flat-square&labelColor=14130f" alt="pre-1.0"/>
  <img src="https://img.shields.io/badge/license-GPL--3.0-2636c4?style=flat-square&labelColor=14130f" alt="GPL-3.0"/>
  <img src="https://img.shields.io/badge/format-markdown-2636c4?style=flat-square&labelColor=14130f" alt="markdown"/>
  <img src="https://img.shields.io/badge/runtime-none-2636c4?style=flat-square&labelColor=14130f" alt="no runtime"/>
</p>

<p align="center">
  <sub><a href="https://mithraeums.github.io/#skills">site catalog</a> &nbsp;·&nbsp; <a href="#install">install</a> &nbsp;·&nbsp; <a href="#format">format</a> &nbsp;·&nbsp; <a href="https://github.com/mithraeums/hako-code">hako-code</a> &nbsp;·&nbsp; <a href="https://github.com/mithraeums">org</a></sub>
</p>

## Catalog

Each skill is one folder. Take what you want.

| skill | what it does |
|---|---|
| [corp](corp/) | a company in a folder: CEO, DEV, DESIGN, QA and ARCH agents that route work by domain |
| [brief](brief/) | token-lean answers: 50 to 75 percent shorter, every fact kept |
| [debug](debug/) | evidence, repro, proof: find the real cause, pin the fix with a test that fails without it |
| [gitflow](gitflow/) | a reviewed push flow: the agent prepares, you read it and push with y/N scripts; sets itself up by asking where things go |
| [memory](memory/) | durable memory across sessions: a `MEMORY.md` index and one fact per file |
| [handoff](handoff/) | a START-HERE state doc so the next session resumes in seconds |
| [scope](scope/) | a vague ask becomes a goal, non-goals and the smallest first step |
| [sync](sync/) | change once, update everywhere: docs, versions, sibling repos, data files |
| [changelog](changelog/) | one clean CHANGELOG entry from a diff or a session, in the project's voice |
| [release](release/) | bump versions everywhere, write the changelog, plan the push order |
| [ship](ship/) | the pre-push gate: builds, sanitizers, versions, changelog, docs; PASS or BLOCKED |

## Install

**Any agent, one line.** Puts a copy in `~/.agents/skills` (read by Codex, OpenCode, Cursor,
Copilot and hako) and links it for Claude Code and Hermes when they are installed:

```sh
curl -fsSL https://raw.githubusercontent.com/mithraeums/skills/main/install.sh | sh
curl -fsSL https://raw.githubusercontent.com/mithraeums/skills/main/install.sh | sh -s -- debug gitflow
```

`--project` installs into the current repo instead, `--list` shows what is installed where,
`--remove` takes them out again. A folder of the same name that you made yourself is never
replaced.

**Claude Code plugins:**

```
/plugin marketplace add mithraeums/skills
/plugin install debug@mithraeum
```

**hako** (the CLI, hake's Rei pane, hako studio):

```
:skill install mithraeums/skills          all of them
:skill install mithraeums/skills/brief    one
/brief                                    run one; :use brief keeps it on until :use none
```

**By hand:** copy a folder into your agent's skills folder. That is the whole install.

## Format

```
<skill-name>/
├── SKILL.md      frontmatter (name, description) + a short dispatcher
└── anything else it points to: more .md, agents/, scripts, templates
```

The `description` is all an agent reads before it decides to load the rest, so it says
when to use the skill in the words a user would type. `SKILL.md` stays short (under ~60
lines) and hands off to the other files. Skills that care about the host (where memory
lives, which instruction file to write) say how to adapt in a short "host" section.

## Contribute

Add `your-skill/SKILL.md`, check it in two different agents, open a PR. The folder name is
the invocation. More in [CONTRIBUTING](CONTRIBUTING.md).

<p align="center"><sub><a href="LICENSE">GPL-3.0</a> &nbsp;·&nbsp; <em>deus sol invictus mithras</em></sub></p>
