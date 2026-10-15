<p align="center">
  <a href="https://mithraeums.github.io">
    <img src="https://mithraeums.github.io/assets/banner-skills.png" alt="skills — behaviors for the hako suite, by name" width="100%"/>
  </a>
</p>

<p align="center">
  <em>Markdown behaviors for the hako suite — and any agent that reads <a href="https://agentskills.io">Agent Skills</a>. Drop a folder, name it, the agent loads it.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/version-pre--1.0-e2402e?style=flat-square&labelColor=14130f" alt="pre-1.0"/>
  <img src="https://img.shields.io/badge/license-GPL--3.0-2636c4?style=flat-square&labelColor=14130f" alt="GPL-3.0"/>
  <img src="https://img.shields.io/badge/format-markdown-2636c4?style=flat-square&labelColor=14130f" alt="markdown"/>
  <img src="https://img.shields.io/badge/runtime-none-2636c4?style=flat-square&labelColor=14130f" alt="no runtime"/>
</p>

<p align="center">
  <sub><a href="https://mithraeums.github.io/#skills">site catalog</a> &nbsp;·&nbsp; <a href="#format">SKILL.md spec</a> &nbsp;·&nbsp; <a href="https://github.com/mithraeums/hako-code">hako-code</a> &nbsp;·&nbsp; <a href="https://github.com/mithraeums/hako-edit">hako-edit</a> &nbsp;·&nbsp; <a href="https://github.com/mithraeums/hako-studio">hako-studio</a> &nbsp;·&nbsp; <a href="https://github.com/mithraeums">org</a></sub>
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
    <td width="60" align="center"><sub>— 08 —</sub></td>
    <td><b><a href="changelog/">changelog</a></b><br/><sub>Turn a diff or session log into one clean CHANGELOG entry, in the project's own voice. Single-repo; the focused half of <code>release</code>.</sub></td>
  </tr>
  <tr>
    <td width="60" align="center"><sub>— 09 —</sub></td>
    <td><b><a href="ship/">ship</a></b><br/><sub>The pre-push gate: build matrix · ASan/valgrind · version-drift · CHANGELOG sync · cruft · docs. Returns PASS or BLOCKED, never a vibe.</sub></td>
  </tr>
  <tr>
    <td width="60" align="center"><sub>— ·· —</sub></td>
    <td><b><em>your skill here</em></b><br/><sub>Open a PR. Folder name becomes the invocation.</sub></td>
  </tr>
</table>

<p align="center"><sub><b>—— II ——</b></sub></p>

## Install

From inside `hako` — the CLI, the editor's Rei pane, or hako studio:

```
:skill install mithraeums/skills          # all of them, into ~/.hako/skills
:skill install mithraeums/skills/brief    # just one
:skills                                   # what is loaded
:use brief                                # one skill as a standing mode, until :use none
```

Or by hand — each skill is a folder, so copying it is installing it:

```sh
git clone --depth 1 https://github.com/mithraeums/skills /tmp/skills
cp -r /tmp/skills/<skill> ~/.hako/skills/
```

hako looks in `./.hako/skills`, `./.claude/skills`, `~/.hako/skills` and `~/.claude/skills`,
nearest first. Each skill costs one line of the prompt (its `description`) until the model
needs it; the body and inner files are read on demand with the `read_skill(skill, path)` tool.

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
| **hako-code** (`hako`) | `~/.hako/skills/`, `.claude/skills/` | native — descriptions up front, `read_skill` for the rest |
| **hake** (Rei pane) · **hako studio** | same as hako | they run hako, so they get the same skills |
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

<p align="center"><sub><a href="LICENSE">— SEE LICENSE —</a> &nbsp;·&nbsp; GPL-3.0 &nbsp;·&nbsp; <a href="CONTRIBUTING.md">CONTRIBUTING</a></sub></p>

<p align="center"><sub><em>— deus sol invictus mithras —</em></sub></p>
