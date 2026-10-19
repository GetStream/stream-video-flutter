#!/bin/bash
set -euo pipefail

# Regenerates the SFU protobuf models in lib/protobuf from GetStream/protocol.
#
# Requires `protoc` (e.g. `brew install protobuf`).
# Set PROTOCOL_REF to generate from a branch or tag other than main.

PROTOCOL_REPO="https://github.com/GetStream/protocol.git"
PROTOCOL_REF="${PROTOCOL_REF:-main}"
PROTO_FILES=(
  "video/sfu/event/events.proto"
  "video/sfu/models/models.proto"
  "video/sfu/signal_rpc/signal.proto"
)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/lib/protobuf"
LOCK_FILE="$SCRIPT_DIR/../../pubspec.lock"

if ! command -v protoc >/dev/null 2>&1; then
  echo "protoc not found. Install it first, e.g. 'brew install protobuf'." >&2
  exit 1
fi

# Use the protoc_plugin version resolved in the workspace lock file.
PLUGIN_VERSION=$(awk -F'"' '
  /^  protoc_plugin:/ { found = 1 }
  found && /^    version:/ { print $2; exit }
' "$LOCK_FILE")
if [ -z "$PLUGIN_VERSION" ]; then
  echo "Could not find protoc_plugin in $LOCK_FILE. Run 'melos bootstrap' first." >&2
  exit 1
fi

TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

# Build the Dart protoc plugin.
PUB_CACHE_DIR="${PUB_CACHE:-$HOME/.pub-cache}"
PLUGIN_SOURCE="$PUB_CACHE_DIR/hosted/pub.dev/protoc_plugin-$PLUGIN_VERSION"
if [ ! -d "$PLUGIN_SOURCE" ]; then
  dart pub cache add protoc_plugin --version "$PLUGIN_VERSION"
fi
cp -R "$PLUGIN_SOURCE" "$TEMP_DIR/protoc_plugin"
chmod -R u+w "$TEMP_DIR/protoc_plugin"
# The published package is part of a pub workspace, which can't resolve on its own.
sed -i.bak '/^resolution: workspace/d' "$TEMP_DIR/protoc_plugin/pubspec.yaml"
(cd "$TEMP_DIR/protoc_plugin" && dart pub get >/dev/null)
dart compile exe "$TEMP_DIR/protoc_plugin/bin/protoc_plugin.dart" \
  -o "$TEMP_DIR/protoc-gen-dart" >/dev/null

# Fetch the protocol definitions.
git clone --quiet --depth 1 --branch "$PROTOCOL_REF" "$PROTOCOL_REPO" "$TEMP_DIR/protocol"

# Generate into a temporary directory, then copy over the checked-in files.
# signal.pbtwirp.dart is not produced by protoc and is left untouched.
mkdir -p "$TEMP_DIR/out"
(cd "$TEMP_DIR/protocol/protobuf" && protoc \
  --plugin=protoc-gen-dart="$TEMP_DIR/protoc-gen-dart" \
  --dart_out="$TEMP_DIR/out" \
  "${PROTO_FILES[@]}")
cp -R "$TEMP_DIR/out/." "$OUTPUT_DIR/"

echo "Generated protobuf models from $PROTOCOL_REPO@$PROTOCOL_REF (protoc_plugin $PLUGIN_VERSION)."
