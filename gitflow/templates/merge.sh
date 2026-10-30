#!/bin/sh
# merge.sh: merge a finished branch into the base, push, then delete the branch here and on the
# remote. If the PR was already merged on the website, it only tidies up. Asks before each step.
#
#   run: sh merge.sh <branch>
#   YES=1 answers every question yes.
set -eu
. "$(cd "$(dirname "$0")" && pwd)/lib.sh"
FROM=${1:-}
[ -n "$FROM" ] && [ "$FROM" != "$BASE" ] || { echo "usage: sh merge.sh <branch>   (not $BASE)"; exit 1; }
[ -d "$CLONE/.git" ] || { echo "no git clone at $CLONE"; exit 1; }
cd "$CLONE"
sync_remote
[ -z "$(git status --porcelain --ignore-submodules)" ] || { echo "the clone has uncommitted changes; push or discard them first"; exit 1; }
git rev-parse -q --verify "refs/heads/$FROM" >/dev/null || { echo "no local $FROM branch"; exit 1; }
if git rev-parse -q --verify "refs/remotes/origin/$FROM" >/dev/null; then
	[ "$(git rev-parse "$FROM")" = "$(git rev-parse "origin/$FROM")" ] || { echo "$FROM differs from the remote; push it first"; exit 1; }
fi
git checkout -q "$BASE"
git merge -q --ff-only "origin/$BASE" || { echo "$BASE has local commits the remote does not; sort that out first"; exit 1; }
if [ -n "$(git log --oneline "$BASE..$FROM")" ]; then
	git log --oneline "$BASE..$FROM"
	ask "merge $FROM into $BASE (commits above)?"
	git merge -q --no-ff "$FROM" -m "Merge $FROM"
	ask "push $BASE?"
	git push -q origin "$BASE"
else
	echo "-- $FROM is already in $BASE (merged on the website?), nothing to merge"
fi
ask "delete $FROM here and on the remote?"
if git rev-parse -q --verify "refs/remotes/origin/$FROM" >/dev/null; then git push -q origin --delete "$FROM"; fi
git branch -d "$FROM"
echo "done."; [ "$TAGS" = none ] || echo "tag it: sh tag.sh"
