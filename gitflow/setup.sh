#!/bin/sh
# setup.sh: write a gitflow folder for one repo from templates/.
#
#   sh setup.sh --clone <path> [--staging <path>] [--name <repo>] [--remote <url>]
#               [--flow pr|main] [--base <branch>] [--tags changelog|none]
#               [--check '<command>']... [--exclude '<rsync excludes>'] [--out <dir>]
#
# With no arguments on a terminal it asks each question instead. Writes <out>/ (default
# ~/gitflow/<repo>) and never touches the repo itself.
set -eu
SRC=$(cd "$(dirname "$0")" && pwd)/templates
CLONE= STAGING= NAME= REMOTE= FLOW=pr BASE= TAGS= CHECKS= EXCL= OUT=
while [ $# -gt 0 ]; do
	case "$1" in
	--clone) CLONE=$2; shift 2;; --staging) STAGING=$2; shift 2;; --name) NAME=$2; shift 2;;
	--remote) REMOTE=$2; shift 2;; --flow) FLOW=$2; shift 2;; --base) BASE=$2; shift 2;;
	--tags) TAGS=$2; shift 2;; --exclude) EXCL=$2; shift 2;; --out) OUT=$2; shift 2;;
	--check) CHECKS="${CHECKS:+$CHECKS
}$2"; shift 2;;
	-h|--help) sed -n '2,9p' "$0"; exit 0;;
	*) echo "unknown option $1 (sh setup.sh --help)"; exit 1;;
	esac
done
q() { printf '%s' "$1"; [ -z "$2" ] || printf ' [%s]' "$2"; printf ': '; read -r a; [ -n "$a" ] || a=$2; }
if [ -z "$CLONE" ]; then
	[ -t 0 ] || { echo "--clone is required"; exit 1; }
	q "the git clone pushes go out from" "$PWD"; CLONE=$a
	q "a staging copy the agent edits (blank: the agent edits the clone)" ""; STAGING=$a
	q "pr (a branch per change, reviewed) or main (straight to the default branch)" pr; FLOW=$a
	q "checks to run before a push, separated by ;" ""; CHECKS=$(printf '%s' "$a" | tr ';' '\n' | sed 's/^ *//')
fi
CLONE=$(cd "$CLONE" && pwd) || exit 1
[ -d "$CLONE/.git" ] || { echo "$CLONE is not a git clone"; exit 1; }
[ -z "$STAGING" ] || STAGING=$(cd "$STAGING" && pwd)
NAME=${NAME:-$(basename "$CLONE")}
[ -n "$BASE" ] || BASE=$(git -C "$CLONE" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's#^origin/##') || true
BASE=${BASE:-main}
[ -n "$TAGS" ] || { [ -f "$CLONE/CHANGELOG.md" ] && TAGS=changelog || TAGS=none; }
case "$FLOW" in pr|main) ;; *) echo "--flow is pr or main"; exit 1;; esac
OUT=${OUT:-$HOME/gitflow/$NAME}
for v in "$CLONE" "$STAGING" "$REMOTE" "$CHECKS" "$EXCL"; do
	case "$v" in *"'"*) echo "a value contains a single quote, which conf.sh cannot hold: $v"; exit 1;; esac
done
[ ! -e "$OUT/conf.sh" ] || { echo "$OUT/conf.sh exists; edit it, or pick another --out"; exit 1; }
mkdir -p "$OUT"
export REPO_="$NAME" CLONE_="$CLONE" STAGING_="$STAGING" REMOTE_="$REMOTE" BASE_="$BASE" FLOW_="$FLOW" TAGS_="$TAGS" CHECKS_="$CHECKS" EXCL_="$EXCL"
# literal replace: & and \ in a value (a check like "make && make test") stay as typed
awk 'function rep(s, t, v,   o, i) { o = ""; while ((i = index(s, t)) > 0) { o = o substr(s, 1, i - 1) v; s = substr(s, i + length(t)) } return o s }
     { $0 = rep($0, "@REPO@", ENVIRON["REPO_"]); $0 = rep($0, "@CLONE@", ENVIRON["CLONE_"]); $0 = rep($0, "@STAGING@", ENVIRON["STAGING_"])
       $0 = rep($0, "@REMOTE@", ENVIRON["REMOTE_"]); $0 = rep($0, "@BASE@", ENVIRON["BASE_"]); $0 = rep($0, "@FLOW@", ENVIRON["FLOW_"])
       $0 = rep($0, "@TAGS@", ENVIRON["TAGS_"]); $0 = rep($0, "@CHECKS@", ENVIRON["CHECKS_"]); $0 = rep($0, "@EXCLUDES@", ENVIRON["EXCL_"]); print }' \
	"$SRC/conf.sh" >"$OUT/conf.sh"
for f in lib.sh check.sh push.sh merge.sh msg.md; do cp "$SRC/$f" "$OUT/$f"; done
[ -z "$STAGING" ] || cp "$SRC/copy.sh" "$OUT/copy.sh"
[ "$TAGS" = none ] || cp "$SRC/tag.sh" "$OUT/tag.sh"
chmod +x "$OUT"/*.sh
echo "wrote $OUT"
echo "  flow: $FLOW into $BASE$([ -n "$STAGING" ] && echo ", copied from $STAGING")"
echo "  next: write $OUT/msg.md, then$([ -n "$CHECKS" ] && echo " sh check.sh,")$([ -n "$STAGING" ] && echo " sh copy.sh,") sh push.sh"
