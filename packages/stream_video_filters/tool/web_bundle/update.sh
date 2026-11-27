#!/usr/bin/env bash
# Rebuilds web_files of stream_video_filters, from the pinned versions or
# after moving to another @stream-io/video-filters-web version.
#
#   melos run update:web_filters                 # rebuild the pinned version
#   melos run update:web_filters -- 1.0.0-beta.4 # move to another version
set -euo pipefail
cd "$(dirname "$0")"

if [[ $# -gt 0 ]]; then
  npm install --no-fund --no-audit --ignore-scripts --save-exact "@stream-io/video-filters-web@$1"
else
  npm ci --no-fund --no-audit --ignore-scripts
fi
npm run --silent build
echo "Rebuilt packages/stream_video_filters/web_files ($(cat ../../web_files/VERSION))."
