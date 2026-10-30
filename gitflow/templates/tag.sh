#!/bin/sh
# tag.sh: tag the base branch's tip and push the tag. A failed release build is fixed by a new
# version, never by moving a published tag.
#
#   run: sh tag.sh [vX.Y.Z]      default: the newest "## [vX.Y.Z]" in CHANGELOG.md
#   YES=1 answers every question yes.
set -eu
. "$(cd "$(dirname "$0")" && pwd)/lib.sh"
[ "$TAGS" != none ] || { echo "TAGS=none in conf.sh"; exit 1; }
cd "$CLONE"
sync_remote --tags
[ "$(git symbolic-ref --short HEAD)" = "$BASE" ] || { echo "clone is not on $BASE; merge first"; exit 1; }
[ -z "$(git status --porcelain --ignore-submodules)" ] || { echo "uncommitted changes; push first"; exit 1; }
git merge -q --ff-only "origin/$BASE" || { echo "$BASE has local commits the remote does not"; exit 1; }
[ "$(git rev-parse HEAD)" = "$(git rev-parse "origin/$BASE")" ] || { echo "$BASE is ahead of the remote; push first"; exit 1; }
TAG=${1:-$(sed -n 's/^## \[\(v[0-9][0-9.]*\)\].*/\1/p' CHANGELOG.md 2>/dev/null | head -1)}
case "$TAG" in v[0-9]*) ;; *) echo "no version found; pass one: sh tag.sh vX.Y.Z"; exit 1;; esac
[ -z "${1:-}" ] || [ ! -f CHANGELOG.md ] || grep -q "^## \[$TAG\]" CHANGELOG.md || echo "note: CHANGELOG.md has no [$TAG] section"
git rev-parse -q --verify "refs/tags/$TAG" >/dev/null && { echo "$TAG already exists"; exit 1; }
echo "-- $REPO $BASE is at: $(git log --oneline -1)"
echo "-- newest tags: $(git tag --sort=-v:refname | head -5 | tr '\n' ' ')"
ask "tag $TAG and push it?"
git tag -a "$TAG" -m "$REPO $TAG"
git push -q origin "$TAG"
echo "tagged $TAG"
