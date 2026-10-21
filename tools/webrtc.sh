#!/usr/bin/env bash
#
# Runs a check on the WebRTC packages in webrtc/. They are not members of the
# pub workspace, so melos exec does not see them.
#
# Usage:
#   tools/webrtc.sh <command> [package]
#
# Commands:
#   bootstrap       flutter pub get in each package and its example.
#   analyze         flutter analyze.
#   format          dart format lib/ and test/.
#   format-verify   dart format lib/ and test/, failing on changes.
#   imports-verify  import_sorter, failing on changes. Skips dart_webrtc.
#   test            flutter test, in packages that have a test/ folder.
#
# Without a package, the command runs in every package under webrtc/.

set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
command="${1:-}"
package="${2:-}"

if [[ -n "$package" ]]; then
  packages=("$root/webrtc/$package")
else
  packages=("$root"/webrtc/*/)
fi

format_dirs() {
  local dirs=(lib)
  [[ -d test ]] && dirs+=(test)
  echo "${dirs[@]}"
}

for dir in "${packages[@]}"; do
  dir="${dir%/}"
  if [[ ! -f "$dir/pubspec.yaml" ]]; then
    echo "No package at $dir" >&2
    exit 1
  fi

  echo "▶ $command: ${dir#"$root"/}"
  cd "$dir"

  case "$command" in
    bootstrap)
      flutter pub get
      if [[ -f example/pubspec.yaml ]]; then
        (cd example && flutter pub get)
      fi
      ;;
    analyze)
      flutter analyze
      ;;
    format)
      # shellcheck disable=SC2046
      dart format $(format_dirs)
      ;;
    format-verify)
      # shellcheck disable=SC2046
      dart format --set-exit-if-changed $(format_dirs)
      ;;
    imports-verify)
      # The imported dart_webrtc source does not pass import_sorter yet
      # (FLU-1039).
      if [[ "$(basename "$dir")" == dart_webrtc ]]; then
        echo "Imports not sorted yet, skipping."
      else
        dart run import_sorter:main --no-comments --exit-if-changed
      fi
      ;;
    test)
      if [[ -d test ]]; then
        flutter test
      else
        echo "No test/ folder, skipping."
      fi
      ;;
    *)
      echo "Unknown command: $command" >&2
      exit 64
      ;;
  esac
done
