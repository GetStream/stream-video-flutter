#!/bin/bash

# Fast fail the script on failures.
set -e

# Runs this package's browser-only tests in Chrome. `flutter test` on the VM
# skips every `@TestOn('browser')` file, and the rest import `dart:io` and so
# cannot be compiled for the web, so only those files are passed.
files=$(grep -rlE "^@TestOn\('browser'\)" test || true)

if [ -z "$files" ]; then
  echo "No browser tests"
  exit 0
fi

# shellcheck disable=SC2086 # one argument per file
flutter test --platform chrome $files
