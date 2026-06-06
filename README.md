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

Pull only what you want — each is a self-contained folder, pure markdown, **works in any agent or LLM**.

<table>
  <tr>
    <td width="60" align="center"><sub>— 01 —</sub></td>
    <td><b><a href="corp/">corp</a></b><br/><sub>A company in a folder. CEO · DEV · DESIGN · QA · ARCH — routes tasks by domain. Ships as <code>CLAUDE.md</code> + <code>AGENTS.md</code>, molds to its host.</sub></td>
  </tr>
  <tr>
    <td width="60" align="center"><sub>— 02 —</sub></td>
    <td><b><a href="brief/">brief</a></b><br/><sub>Token-lean output. Cut ~50–75% of length, keep every fact. Drops filler, not information.</sub></td>
  </tr>
  <tr>
    <td width="60" align="center"><sub>— 03 —</sub></td>
    <td><b><a href="memory/">memory</a></b><br/><sub>Durable cross-session memory: a <code>MEMORY.md</code> index + one-fact-per-file, with recall &amp; dedupe rules. No database.</sub></td>
  </tr>
  <tr>
    <td width="60" align="center"><sub>— 04 —</sub></td>
    <td><b><a href="sync/">sync</a></b><br/><sub>Change once, update everywhere — docs, version strings, sibling repos, JSON. Kills the "did I get them all?" miss.</sub></td>
  </tr>
  <tr>
    <td width="60" align="center"><sub>— 05 —</sub></td>
    <td><b><a href="scope/">scope</a></b><br/><sub>Vague ask → goal + explicit non-goals + smallest viable step, before building. Stops scope creep.</sub></td>
  </tr>
  <tr>
    <td width="60" align="center"><sub>— 06 —</sub></td>
    <td><b><a href="release/">release</a></b><br/><sub>Bump version consistently, write the changelog, generate a multi-repo push-order checklist.</sub></td>
  </tr>
  <tr>
    <td width="60" align="center"><sub>— 07 —</sub></td>
    <td><b><a href="handoff/">handoff</a></b><br/><sub>Write a START-HERE state doc (done / next / gotchas) so the next session resumes in seconds.</sub></td>
  </tr>
  <tr>
    <td width="60" align="center"><sub>— ·· —</sub></td>
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
