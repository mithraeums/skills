# lib.sh: shared by every gitflow script in this folder (sourced, not run).
# Settings live in conf.sh next to it; nothing here is repo-specific.
HERE=$(cd "$(dirname "$0")" && pwd)
. "$HERE/conf.sh"
MSG=${MSG:-$HERE/msg.md}
BASE=${BASE:-main}

# y/N prompt; anything but y stops the script. YES=1 answers every prompt yes.
ask() {
	printf '%s [y/N] ' "$1"
	if [ "${YES:-0}" = 1 ]; then echo y; a=y; else read -r a; fi
	[ "$a" = y ] || [ "$a" = Y ] || { echo "stopped, nothing further done."; exit 1; }
}

# Synced folders (iCloud, Dropbox, OneDrive) keep a file they could not merge as "name 2" or
# "name (conflicted copy)", in the work tree AND inside .git, where one breaks every git command.
# Run from inside the clone.
no_conflict_copies() {
	dups=$(find . -path ./.git/objects -prune -o \( -name '* [0-9]' -o -name '* [0-9].*' -o -name '*conflicted copy*' \) -print)
	[ -z "$dups" ] || { echo "-- sync conflict copies (check each, remove, re-run):"; echo "$dups"; exit 1; }
	locks=$(find .git -maxdepth 3 -name '*.lock' 2>/dev/null)
	[ -z "$locks" ] || { echo "-- git lock files left (another git running? if not, a sync cut one short; read it before deleting): $locks"; exit 1; }
	[ -f .git/HEAD ] && [ -f .git/index ] || { echo "-- .git/HEAD or .git/index is missing, fix before going on"; exit 1; }
}

# The message file must exist, not be the template, and not repeat a recent commit.
check_msg() {
	[ -f "$MSG" ] || { echo "no message file $MSG"; exit 1; }
	title=$(head -n 1 "$MSG")
	[ -n "$title" ] || { echo "$MSG has no title line"; exit 1; }
	case "$title" in "title line"*) echo "$MSG is still the template, write the message first"; exit 1;; esac
	if git log --format=%s -n 100 2>/dev/null | grep -qxF "$title"; then
		echo "$MSG still holds an old commit's message (\"$title\"), write the new one first"; exit 1
	fi
}

# Point origin at REMOTE when one is set, then fetch.
sync_remote() {
	[ -z "${REMOTE:-}" ] || git remote set-url origin "$REMOTE"
	git fetch -q --prune ${1:-} origin
}

web_url() {
	u=$(git remote get-url origin 2>/dev/null) || return 0
	case "$u" in git@*:*) u="https://${u#git@}"; u=$(echo "$u" | sed 's#:#/#2');; esac
	echo "${u%.git}"
}
