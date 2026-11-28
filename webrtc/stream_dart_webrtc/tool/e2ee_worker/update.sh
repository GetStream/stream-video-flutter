#!/usr/bin/env bash
# Rebuilds lib/src/e2ee/e2ee_worker_source.g.dart from the pinned
# @stream-io/video-client, or from the version given as the first argument.
set -euo pipefail
cd "$(dirname "$0")"

if [[ $# -gt 0 ]]; then
  npm install --no-fund --no-audit --ignore-scripts --save-exact "@stream-io/video-client@$1"
else
  npm ci --no-fund --no-audit --ignore-scripts
fi
npm run --silent build

dart format ../../lib/src/e2ee/e2ee_worker_source.g.dart > /dev/null
echo "Rebuilt the E2EE worker from @stream-io/video-client $(node -p "require('@stream-io/video-client/package.json').version")."
