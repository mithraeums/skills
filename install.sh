#!/bin/sh
# install.sh: put mithraeum skills where your agents look.
#
#   sh install.sh [skill ...] [options]
#   curl -fsSL https://raw.githubusercontent.com/mithraeums/skills/main/install.sh | sh
#   curl -fsSL https://raw.githubusercontent.com/mithraeums/skills/main/install.sh | sh -s -- brief debug
#
#   --project      into this folder (./.agents/skills, ./.claude/skills) instead of your home
#   --agent NAME   only link for NAME (claude, hako, hermes); repeatable. default: every one found
#   --copy         copy into each agent's folder instead of linking (automatic where links fail)
#   --force        replace a skill folder of the same name that this script did not install
#   --remove       take the named (default: all) mithraeum skills out again
#   --list         what is available and where it is installed
#
# One copy goes to .agents/skills, the shared folder Codex, OpenCode, Cursor, Copilot and hako
# read. Agents with their own folder (Claude Code, hako before 0.2.11, Hermes) get a link to it.
set -eu
REPO=mithraeums/skills
SCOPE=user AGENTS= MODE=link FORCE=0 ACTION=install NAMES=
while [ $# -gt 0 ]; do
	case "$1" in
	--project) SCOPE=project;; --copy) MODE=copy;; --force) FORCE=1;;
	--remove) ACTION=remove;; --list) ACTION=list;;
	--agent) AGENTS="$AGENTS $2"; shift;;
	-h|--help) sed -n '2,18p' "$0" 2>/dev/null || echo "see https://github.com/$REPO"; exit 0;;
	-*) echo "unknown option $1"; exit 1;;
	*) NAMES="$NAMES $1";;
	esac
	shift
done

# where the skills come from: this checkout, or a fresh download
SRC=$(cd "$(dirname "$0")" 2>/dev/null && pwd) || SRC=
if [ -z "$SRC" ] || [ ! -f "$SRC/brief/SKILL.md" ]; then
	TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
	curl -fsSL "https://codeload.github.com/$REPO/tar.gz/refs/heads/main" | tar xz -C "$TMP"
	SRC="$TMP/skills-main"
fi
ALL=$(cd "$SRC" && for d in */; do [ -f "$d/SKILL.md" ] && echo "${d%/}"; done)
[ -n "$NAMES" ] || NAMES=$ALL
for n in $NAMES; do echo "$ALL" | grep -qx "$n" || { echo "no skill named $n (sh install.sh --list)"; exit 1; }; done

if [ $SCOPE = project ]; then BASE=$PWD; STORE=$BASE/.agents/skills; else BASE=$HOME; STORE=$HOME/.agents/skills; fi
# agents that read their own folder, not .agents/skills: name, folder, how to tell it is installed
targets() {
	if [ $SCOPE = project ]; then echo "claude $BASE/.claude/skills"; return; fi
	{ command -v claude >/dev/null 2>&1 || [ -d "$HOME/.claude" ]; } && echo "claude $HOME/.claude/skills"
	{ command -v hako >/dev/null 2>&1 || [ -d "$HOME/.hako" ]; } && [ ! -d "$HOME/.claude" ] && echo "hako $HOME/.hako/skills"
	[ -d "$HOME/.hermes" ] && echo "hermes $HOME/.hermes/skills"
	return 0
}
wanted() { [ -z "$AGENTS" ] || echo " $AGENTS " | grep -q " $1 "; }
ours() { [ -f "$1/.mithraeum" ] || { [ -L "$1" ] && case "$(readlink "$1")" in "$STORE"/*) true;; *) false;; esac; }; }

case $ACTION in
list)
	for n in $ALL; do
		where=$( { [ -d "$STORE/$n" ] && printf ' .agents'; targets | while read -r a dir; do [ -e "$dir/$n" ] && printf ' %s' "$a"; done; } || true)
		desc=$(awk '/^description:/{ sub(/^description: *[>|]? */, ""); if ($0 != "") { print; exit } getline; sub(/^ */, ""); print; exit }' "$SRC/$n/SKILL.md")
		printf '%-10s %.64s%s\n' "$n" "$desc" "${where:+   [installed:$where]}"
	done
	exit 0;;
remove)
	for n in $NAMES; do
		targets | while read -r a dir; do ours "$dir/$n" && rm -rf "$dir/$n" && echo "removed $a: $n"; done || true
		ours "$STORE/$n" && rm -rf "$STORE/$n" && echo "removed .agents: $n"
	done
	exit 0;;
esac

mkdir -p "$STORE"
for n in $NAMES; do
	d=$STORE/$n
	if [ -e "$d" ] && ! ours "$d" && [ $FORCE = 0 ]; then echo "skip $n: $d is not ours (--force replaces it)"; continue; fi
	rm -rf "$d"; mkdir -p "$d"
	(cd "$SRC/$n" && tar cf - --exclude .git --exclude skills-site --exclude .DS_Store .) | (cd "$d" && tar xf -)
	echo "$REPO" >"$d/.mithraeum"
	echo "installed $n -> $d"
done
targets | while read -r a dir; do
	wanted "$a" || continue
	mkdir -p "$dir"
	for n in $NAMES; do
		[ -f "$STORE/$n/.mithraeum" ] || continue
		t=$dir/$n
		if [ -e "$t" ] || [ -L "$t" ]; then
			ours "$t" || [ $FORCE = 1 ] || { echo "skip $a: $t is not ours"; continue; }
			rm -rf "$t"
		fi
		if [ $MODE = link ] && ln -s "$STORE/$n" "$t" 2>/dev/null; then :; else cp -R "$STORE/$n" "$t"; fi
	done
	echo "linked for $a: $dir"
done
echo "done. Codex, OpenCode, Cursor, Copilot and hako read $STORE"
echo "Claude Code can also install them as plugins: /plugin marketplace add $REPO"
