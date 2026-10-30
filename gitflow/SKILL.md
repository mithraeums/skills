---
name: gitflow
description: >
  A reviewed push flow for agent-written code: the agent prepares the change, the human
  reads it (a phone is fine) and pushes with small scripts that ask y/N at every step:
  check → (copy) → push → merge → tag. Commits carry only the human's git identity. Use
  when the user wants to set up or run "the gitflow", push/merge/tag a repo, keep agents
  out of git, or review agent work before it goes up. Sets itself up by asking where things go.
  Trigger: /gitflow, "set up gitflow", "push this", "open a PR", "merge it", "tag a release".
---

# gitflow: the human pushes, the agent prepares

## What it is
A folder of POSIX sh scripts per repo (`check.sh push.sh merge.sh tag.sh`, plus `copy.sh` when
the agent edits a staging copy) and a `msg.md` the human writes or edits. Nothing runs git
behind the human's back: every commit, push, merge, branch delete and tag asks first (`YES=1`
answers all). No agent co-author lines. Works with any agent and with none.

## Setup (first run): ask, then run setup.sh
Ask the user, one short question at a time, offering the detected default:
1. Which repo(s)? (the git clone path for each)
2. Do you edit the clone directly (default), or keep a staging copy the agent edits and
   copy in for review? (staging keeps `.claude/` and other agent folders out of git without
   ignores. A global git ignore, `~/.config/git/ignore`, does the same for the in-place way.)
3. Per repo: `pr` (a branch per change, merged after review; default) or `main` (straight in)?
4. Checks to run before a push (detect and propose: `make test`, `npm test`, `cargo test`,
   `go test ./...`, `pytest`); none is fine.
5. Where the gitflow folders live (default `~/gitflow/<repo>`; suggest a synced folder if
   they review from a phone).
6. Tags from `CHANGELOG.md` (`## [vX.Y.Z]`), or none?

Then, per repo:
```sh
sh <this skill>/setup.sh --clone <path> [--staging <path>] --flow pr|main \
   --check '<cmd>' [--check '<cmd>'] [--tags changelog|none] --out <dir>
```
Tell them the folder it wrote and the next command. setup.sh never touches the repo.

## Running it
- agent: make the change; write `msg.md` (title line first; for a release start it with the version)
- `sh check.sh`: every gate; ALL PASS or stop
- `sh copy.sh [branch]`: staging setups only; the clone now matches staging, nothing committed
- human: review the clone (`git diff`, or the files app)
- `sh push.sh [branch]`: commit with msg.md and push; prints the PR link for a branch
- `sh merge.sh <branch>`: merge and tidy up (also after a PR merged on the website)
- `sh tag.sh [vX.Y.Z]`: tag the base and push the tag

The agent may run these only when the user says to, and never answers their prompts with
`YES=1` unless told.

## Guards (why each exists)
- refuses a `msg.md` that is the template or matches a recent commit: an old message never ships twice
- refuses "name 2" / "conflicted copy" files and stray `.git/*.lock`: synced folders (iCloud,
  Dropbox) make them, and one inside `.git` breaks every git command. Read a lock before removing it
- copy syncs in place (`rsync --inplace --delete`), never wipe-and-copy, which is what makes those copies
- a published tag is never moved: a failed release build gets a new version

## Files
`setup.sh` (generator) · `templates/` (`conf.sh lib.sh check.sh copy.sh push.sh merge.sh tag.sh msg.md`).
Settings per repo live in its `conf.sh`; edit it freely.
