# conf.sh: this repo's gitflow settings. setup.sh wrote it; edit freely.
REPO='@REPO@'
# the git clone pushes go out from
CLONE='@CLONE@'
# optional copy the agent edits; empty means the agent edits the clone
STAGING='@STAGING@'
# optional; when set, origin is pointed here before every fetch
REMOTE='@REMOTE@'
# the default branch
BASE='@BASE@'
# pr: work goes up on a branch for review; main: straight to the base
FLOW='@FLOW@'
# changelog: tag.sh takes the newest "## [vX.Y.Z]" in CHANGELOG.md; none: no tags
TAGS='@TAGS@'
# check.sh runs each line, in the folder the agent edits; any failure stops the push
CHECKS='@CHECKS@'
# copy.sh only: what never goes from staging into the clone (agent notes, build output)
EXCLUDES='--exclude /.git --exclude .claude --exclude .codex --exclude .hako --exclude .agents --exclude .DS_Store @EXCLUDES@'
