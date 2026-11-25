#!/bin/bash
#
# Runs the native unit tests of one package through its example app:
#
#   native-tests.sh android <package dir>   JVM unit tests in android/src/test
#   native-tests.sh ios <package dir>       RunnerTests of example/ios, on a simulator
#   native-tests.sh macos <package dir>     RunnerTests of example/macos
#
# A package without tests for the platform is skipped, so the script can run
# over every package. One with tests but no example app to run them in fails.

set -euo pipefail

if [ $# -ne 2 ]; then
  echo "Usage: $0 android|ios|macos <package dir>" >&2
  exit 2
fi

platform=$1
package=$(cd "$2" && pwd)
name=$(basename "$package")
example="$package/example"

skip() {
  echo "$name: $1, skipped"
  exit 0
}

case "$platform" in
  android)
    [ -d "$package/android/src/test" ] || skip "no Android unit tests"
    if [ ! -d "$example/android" ]; then
      echo "$name has Android unit tests but no example app to run them in" >&2
      exit 1
    fi
    # The config-only build generates the gradle wrapper and settings the
    # tests run through, without building the app.
    cd "$example"
    flutter build apk --config-only
    cd android
    ./gradlew ":$name:testDebugUnitTest" --console=plain
    ;;

  ios | macos)
    # The tests are the RunnerTests target the example's Runner scheme tests.
    scheme="$example/$platform/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme"
    if [ ! -f "$scheme" ] || ! grep -q '"RunnerTests"' "$scheme"; then
      skip "no $platform RunnerTests"
    fi
    cd "$example"
    if [ "$platform" = ios ]; then
      flutter build ios --config-only --no-codesign
      # Picked by id, so the device's iOS version does not have to be the
      # newest one installed.
      device=$(xcrun simctl list devices available | grep -m1 -oE '^ *iPhone .*\([0-9A-F-]{36}\)' | sed 's/^ *//' || true)
      udid=$(echo "$device" | grep -oE '[0-9A-F-]{36}' || true)
      if [ -z "$udid" ]; then
        echo "No available iPhone simulator" >&2
        exit 1
      fi
      echo "Running $name RunnerTests on $device"
      destination="platform=iOS Simulator,id=$udid"
    else
      flutter build macos --config-only
      destination="platform=macOS"
    fi
    cd "$platform"
    xcodebuild test -workspace Runner.xcworkspace -scheme Runner -configuration Debug \
      -destination "$destination" -only-testing:RunnerTests \
      CODE_SIGNING_ALLOWED=NO
    ;;

  *)
    echo "Unknown platform '$platform', expected android, ios or macos" >&2
    exit 2
    ;;
esac
