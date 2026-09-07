#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Usage:
#   CHAT_DIR=/absolute/path/to/chat melos run gen:api
#   (or) export CHAT_DIR=... then: melos run gen:api
# Requires: go, dart (and optionally flutter)
# Melos sets MELOS_ROOT_PATH when invoked via `melos run`
# ============================================================

# ---------- config (env-required) ----------
: "${CHAT_DIR:?❌ CHAT_DIR not set.
Please run with:
  CHAT_DIR=/path/to/chat melos run gen:api
or export it in your shell/profile.}"

# ---------- paths ----------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${MELOS_ROOT_PATH:-$(cd "${SCRIPT_DIR}/.." && pwd)}"

PKG_DIR="${REPO_ROOT}/packages/stream_video"
OUTPUT_DIR_VIDEO="${PKG_DIR}/lib/open_api/video/coordinator"
RENAMED_MODELS="${PKG_DIR}/scripts/renamed-models.json"  # optional

PRODUCTS="video,common,moderation"
API_VERSION="v2"
SPEC_DIR_REL="releases/${API_VERSION}"
SPEC_BASENAME="video-clientside-api"
SPEC_PATH="${SPEC_DIR_REL}/${SPEC_BASENAME}.yaml"

# ---------- helpers ----------
section() { echo ""; echo "$*"; echo ""; }
# cross-platform sed -i (GNU vs BSD)
sed_inplace() { if sed --version >/dev/null 2>&1; then sed -i "$@"; else sed -i '' "$@"; fi; }

# ---------- validation ----------
[[ -d "$CHAT_DIR" ]] || { echo "❌ CHAT_DIR not found: $CHAT_DIR"; exit 1; }
command -v go   >/dev/null || { echo "❌ 'go' is required in PATH"; exit 1; }
command -v dart >/dev/null || { echo "❌ 'dart' is required in PATH"; exit 1; }

# Optional renamed-models flag
RENAMED_MODELS_FLAG=()
if [[ -f "$RENAMED_MODELS" ]]; then
  RENAMED_MODELS_FLAG=(-renamed-models "$RENAMED_MODELS")
  echo "ℹ️ Using renamed-models.json: $RENAMED_MODELS"
fi

echo ""
echo "📂 Repo:     $REPO_ROOT"
echo "📦 Package:  $PKG_DIR"
echo "🗂 Output:   $OUTPUT_DIR_VIDEO"
echo "💬 CHAT_DIR: $CHAT_DIR"
echo ""

# ---------- [1/5] Generate spec & client ----------
section "➡️ [1/5] Generating OpenAPI spec and Dart client…"

# Clean target & ensure parent exists
rm -rf "$OUTPUT_DIR_VIDEO"
mkdir -p "$OUTPUT_DIR_VIDEO"

(
  set -o pipefail
  cd "$CHAT_DIR/projects/chat-manager"

  go run . openapi generate-spec \
    -products "$PRODUCTS" \
    -version "$API_VERSION" \
    --clientside \
    -output "$CHAT_DIR/$SPEC_DIR_REL/$SPEC_BASENAME" \
    "${RENAMED_MODELS_FLAG[@]}"

  # Generate Dart client into stream_video coordinator generated folder
  go run . openapi generate-client \
    --language dart \
    --spec "$CHAT_DIR/$SPEC_PATH" \
    --output "$OUTPUT_DIR_VIDEO"
)

section "✅ Finished generating client at: $OUTPUT_DIR_VIDEO"

# ---------- [2/5] Post-generation fixes ----------
section "➡️ [2/5] Applying post-generation fixes…"

# Every fix below is a text patch against generated output, so it goes stale the
# moment the Dart templates change shape — and `sed` exits 0 when it matches
# nothing, so a stale patch is silent. Each fix therefore asserts its own result
# and fails the run rather than shipping half-patched models.
#
# require_file fails when a fix's target model is gone, so a renamed or dropped
# model is reported instead of silently skipped.
require_file() {
  [[ -f "$1" ]] || {
    echo "❌ post-gen fix target is missing: $1"
    echo "   the model was renamed or is no longer generated — update generate.sh"
    exit 1
  }
}

# require_match fails when a patch left no trace, i.e. its pattern went stale.
require_match() {
  grep -q "$2" "$1" || {
    echo "❌ post-gen fix did not apply to $1"
    echo "   expected to find: $2"
    echo "   the generated output changed shape — update generate.sh"
    exit 1
  }
}

# capabilitiesByRole: Map<String, List<String>> — the generated cast crashes for
# non-List values. Insert a tolerant helper and wire it via @JsonKey(fromJson:).
for file in \
  "$OUTPUT_DIR_VIDEO/model/call_updated_event.dart" \
  "$OUTPUT_DIR_VIDEO/model/call_member_updated_permission_event.dart"; do
  require_file "$file"

  # Insert the helper function before the first @freezed annotation.
  awk '/^@freezed$/ && !inserted {
    print "Map<String, List<String>> _capabilitiesByRoleFromJson(Map<String, dynamic> json) {"
    print "  return {"
    print "    for (final entry in json.entries)"
    print "      if (entry.value is List)"
    print "        entry.key: (entry.value as List).map((i) => i as String).toList(),"
    print "  };"
    print "}"
    print ""
    inserted=1
  }
  { print }' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"

  # Wire the helper onto the field, keeping the generated `name:` argument.
  # capabilitiesByRole is the only Map<String, List<String>> field in these two
  # event models, so keying off its JSON name is unambiguous.
  sed_inplace \
    "s/@JsonKey(name: 'capabilities_by_role')/@JsonKey(name: 'capabilities_by_role', fromJson: _capabilitiesByRoleFromJson)/" \
    "$file"

  require_match "$file" 'Map<String, List<String>> _capabilitiesByRoleFromJson'
  require_match "$file" 'fromJson: _capabilitiesByRoleFromJson'
  echo "• Fixed capabilitiesByRole in $(basename "$file")"
done

section "✅ Post-generation fixes applied"

# ---------- [3/5] build_runner (package only) ----------
section "➡️ [3/5] Running build_runner in stream_video…"

(
  cd "$PKG_DIR"
  if command -v flutter >/dev/null; then
    flutter pub run build_runner build --delete-conflicting-outputs
  else
    dart run build_runner build --delete-conflicting-outputs
  fi
)

section "✅ build_runner completed"

# ---------- [4/5] Format generated files only ----------
section "➡️ [4/5] Formatting generated API files…"

(
  cd "$PKG_DIR"
  # Format only the generated directory; keep logs, ignore exit code
  dart format "$OUTPUT_DIR_VIDEO" || true
)

section "✅ Formatting completed"

# ---------- [5/5] Verify the generated code ----------
section "➡️ [5/5] Verifying generated code…"

# `analysis_options.yaml` excludes `lib/open_api/**`, so `dart analyze` cannot
# see a compile error in generated code — a model whose field is missing from its
# constructor analyses clean and only fails once something imports the library.
# These tests import it, so they compile the whole generated tree, and they also
# assert the post-generation fixes above actually behave.
(
  cd "$PKG_DIR"
  if command -v flutter >/dev/null; then
    flutter test test/src/open_api
  else
    dart test test/src/open_api
  fi
)

section "✅ Generated code compiles and post-generation fixes hold"

# ---------- summary ----------
section "🎉 All done!"
echo "• Spec:   $CHAT_DIR/$SPEC_PATH"
echo "• Client: $OUTPUT_DIR_VIDEO"
echo ""