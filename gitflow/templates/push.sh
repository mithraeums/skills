#!/bin/sh
# push.sh: commit the clone's changes with msg.md and push them, to a branch or the base.
# Asks before the commit and before the push. Commits carry your own git identity only.
#
#   run: sh push.sh [branch]     default: a branch named after the title when FLOW=pr, else the base
#   YES=1 answers every question yes.
set -eu
. "$(cd "$(dirname "$0")" && pwd)/lib.sh"
[ -d "$CLONE/.git" ] || { echo "no git clone at $CLONE"; exit 1; }
cd "$CLONE"
check_msg
if [ -n "${1:-}" ]; then BRANCH=$1
elif [ "$FLOW" = pr ]; then BRANCH=$(head -n 1 "$MSG" | tr 'A-Z' 'a-z' | tr -cs 'a-z0-9.' '-' | sed 's/^-*//; s/-*$//' | cut -c1-40)
else BRANCH=$BASE
fi
no_conflict_copies
sync_remote
[ -n "$(git status --porcelain --ignore-submodules)" ] || { echo "nothing to commit"; exit 1; }
cur=$(git symbolic-ref --short HEAD)
if [ "$cur" != "$BRANCH" ]; then
	[ -z "$STAGING" ] || { echo "clone is on $cur, not $BRANCH; run copy.sh $BRANCH first"; exit 1; }
	ask "move the changes on $cur to branch $BRANCH?"
	if git rev-parse -q --verify "refs/heads/$BRANCH" >/dev/null; then git checkout -q "$BRANCH"; else git checkout -q -b "$BRANCH"; fi
fi
git add -A
echo "-- going into the commit on $BRANCH:"; git status --short --ignore-submodules | head -80
echo "   ($(git status --short --ignore-submodules | wc -l | tr -d ' ') files)"
ask "commit with $(basename "$MSG")?"
git commit -q -F "$MSG"
git log --oneline -1 --format='%h %an <%ae> %s'
if [ "$BRANCH" = "$BASE" ]; then ask "push to $BASE?"; else ask "push branch $BRANCH (not $BASE)?"; fi
git push -q -u origin "$BRANCH"
url=$(web_url)
if [ "$BRANCH" = "$BASE" ]; then
	echo "pushed $BASE${url:+: $url/commits/$BASE}"
	[ "$TAGS" = none ] || echo "release? sh tag.sh"
else
	echo "pushed $BRANCH.${url:+ open its PR: $url/compare/$BRANCH?expand=1}"
	echo "after review: sh merge.sh $BRANCH   (or merge the PR on the website, then the same script tidies up)"
fi
