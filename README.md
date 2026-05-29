<p align="center">
  <a href="https://mithraeums.github.io">
    <img src="https://mithraeums.github.io/assets/banner-skills-dark.svg" alt="skills — behaviors for the hako suite, by name" width="100%"/>
  </a>
</p>

<p align="center">
  <em>Markdown behaviors for hako-code and hake. Drop a folder, name it, the agent loads it.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/version-pre--1.0-b89656?style=flat-square&labelColor=14130f" alt="pre-1.0"/>
  <img src="https://img.shields.io/badge/license-GPL--3.0-c8c2b2?style=flat-square&labelColor=14130f" alt="GPL-3.0"/>
  <img src="https://img.shields.io/badge/format-markdown-c8c2b2?style=flat-square&labelColor=14130f" alt="markdown"/>
  <img src="https://img.shields.io/badge/runtime-none-c8c2b2?style=flat-square&labelColor=14130f" alt="no runtime"/>
</p>

<p align="center">
  <sub><a href="https://mithraeums.github.io/#skills">site catalog</a> &nbsp;·&nbsp; <a href="#format">SKILL.md spec</a> &nbsp;·&nbsp; <a href="https://github.com/mithraeums/hako-code">hako-code</a> &nbsp;·&nbsp; <a href="https://github.com/mithraeums/hako-edit">hako-edit</a> &nbsp;·&nbsp; <a href="https://github.com/mithraeums">org</a></sub>
</p>

<br>

<p align="center"><sub><b>—— I ——</b></sub></p>

## Catalog

<table>
  <tr>
    <td width="60" align="center"><sub>— 01 —</sub></td>
    <td><b><a href="corp/">corp</a></b><br/><sub>A company in a folder. CEO · DEV · DESIGN · QA · ARCH. Routes tasks by domain. Markdown only, no runtime.</sub></td>
  </tr>
  <tr>
    <td width="60" align="center"><sub>— 02 —</sub></td>
    <td><b><em>your skill here</em></b><br/><sub>Open a PR. Folder name becomes the invocation.</sub></td>
  </tr>
</table>

<p align="center"><sub><b>—— II ——</b></sub></p>

## Install

Both `hako` (the agent) and `hake` (the editor's Rei pane) read skills from `~/.hako/skills/`.

```sh
git clone https://github.com/mithraeums/skills /tmp/skills_tmp
cp -r /tmp/skills_tmp/<skill> ~/.hako/skills/
rm -rf /tmp/skills_tmp
hako                  # "loaded 1 skill(s)"
```

Or from inside a session: `:skill install <url>`. The agent loads any folder containing a `SKILL.md` at startup; inner files are pulled on demand via the `read_skill(skill, path)` tool.

<p align="center"><sub><b>—— III ——</b></sub></p>

## Format

Every skill is a folder:

```
<skill-name>/
├── SKILL.md          dispatcher: frontmatter + intro + agent map
└── (any *.md, agents/, helpers, assets)
```

`SKILL.md` frontmatter:

```yaml
---
name: <skill-name>
description: >
  One-paragraph summary. When to load. What it solves.
  Include trigger phrases.
---
```

Inside `SKILL.md`: keep it dispatcher-shaped — orient the model, list which inner files exist, hand off. Under 50 lines is the goal. If a skill needs more, split it into agents.

<p align="center"><sub><b>—— IV ——</b></sub></p>

## Compatibility

| Tool | Path | Status |
|---|---|---|
| **hako-code** (`hako`) | `~/.hako/skills/` | native, `read_skill` tool |
| **hake** (Rei pane) | `~/.hako/skills/` | native, system-prompt inject |
| **Claude Code** | `.claude/skills/` | drop-in |
| Codex CLI · Cursor · Gemini CLI · OpenCode · Windsurf | varies | markdown is markdown |

<p align="center"><sub><b>—— V ——</b></sub></p>

## Contribute

```sh
git clone https://github.com/mithraeums/skills
git checkout -b add/your-skill
# add your-skill/SKILL.md (+ any agents/helpers)
git push origin add/your-skill
# open PR
```

Keep skills **referential**, not prescriptive. Token budget first. The dispatcher orients — the model reasons.

<p align="center"><sub><em>— deus sol invictus mithras —</em></sub></p>
