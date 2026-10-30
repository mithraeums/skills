#!/bin/sh
# check.sh: run every gate from conf.sh against the folder the agent edits. Any FAIL means do not push.
set -u
. "$(cd "$(dirname "$0")" && pwd)/lib.sh"
cd "${STAGING:-$CLONE}" || exit 1
fail=0
while IFS= read -r c; do
	[ -n "$c" ] || continue
	if out=$(sh -c "$c" 2>&1 </dev/null); then echo "PASS  $c"; else echo "FAIL  $c"; echo "$out" | tail -12 | sed 's/^/      /'; fail=1; fi
done <<END
$CHECKS
END
[ $fail = 0 ] || { echo "SOMETHING FAILED, do not push"; exit 1; }
echo "ALL PASS"
