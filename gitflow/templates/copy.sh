#!/bin/sh
# copy.sh (staging setups only): make the clone match staging, .git kept, on the given branch.
# Nothing is committed. Review the clone, then run push.sh with the same branch.
#
#   run: sh copy.sh [branch]     default: the base branch; a new branch is made from it (asks first)
#   YES=1 answers every question yes.
set -eu
. "$(cd "$(dirname "$0")" && pwd)/lib.sh"
[ -n "$STAGING" ] || { echo "no STAGING in conf.sh: the agent edits the clone itself, so there is nothing to copy. run push.sh"; exit 1; }
BRANCH=${1:-$BASE}
[ -d "$CLONE/.git" ] || { echo "no git clone at $CLONE"; exit 1; }
[ -d "$STAGING" ] || { echo "no staging folder at $STAGING"; exit 1; }

cd "$CLONE"
no_conflict_copies
sync_remote
if [ "$(git symbolic-ref --short HEAD)" != "$BRANCH" ]; then
	[ -z "$(git status --porcelain --ignore-submodules)" ] || { echo "clone has uncommitted changes on $(git symbolic-ref --short HEAD); push or discard them first"; exit 1; }
	if git rev-parse -q --verify "refs/heads/$BRANCH" >/dev/null; then git checkout -q "$BRANCH"
	elif git rev-parse -q --verify "refs/remotes/origin/$BRANCH" >/dev/null; then git checkout -q -b "$BRANCH" --track "origin/$BRANCH"
	else ask "branch $BRANCH does not exist, create it from $BASE?"; git checkout -q -b "$BRANCH" "origin/$BASE"
	fi
fi
base="origin/$BRANCH"; git rev-parse -q --verify "refs/remotes/$base" >/dev/null || base="origin/$BASE"
if [ -n "$(git status --porcelain --ignore-submodules)" ]; then
	git status --short --ignore-submodules | head -40
	ask "the clone has uncommitted changes (shown above); overwrite them from staging?"
fi
git merge -q --ff-only "$base" 2>/dev/null || { echo "$BRANCH cannot fast-forward to $base (diverged); sort that out first"; exit 1; }

ask "make $REPO match staging?"
# In place, never wipe-and-copy: a synced folder keeps a deleted-then-rewritten file as "name 2".
# Excluded paths are left alone on the clone side, which keeps .git.
set -f
rsync -a --inplace --delete $EXCLUDES "$STAGING/" "$CLONE/"
set +f
no_conflict_copies
git add -A; git status --short --ignore-submodules | head -80
echo "   ($(git status --short --ignore-submodules | wc -l | tr -d ' ') files)"; git reset -q
echo "copied. review the clone, then: sh push.sh $BRANCH"
