#!/usr/bin/env bash
# Rebuild the downloadable skill package from skill/callista-connector/.
#
# claude.ai's uploader wants a .zip whose ROOT is the skill folder — i.e. the archive
# contains callista-connector/SKILL.md, not SKILL.md at top level. Hence the cd: zipping
# from the repo root would bury it under skill/.
#
# -X drops extra file attributes (uid/gid, timestamps beyond the DOS field) so a rebuild
# of unchanged content produces a near-identical archive rather than a noisy binary diff.
set -euo pipefail
cd "$(dirname "$0")"
rm -f ../callista-connector.zip
zip -rXq ../callista-connector.zip callista-connector -x '.*' -x '*/.*'
unzip -l ../callista-connector.zip
