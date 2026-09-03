#!/usr/bin/env bash
# Phase 1 — build and launch both apps, then block until both are actually up.
# First iOS run pays a CocoaPods + full compile cost (~10 min); later runs are fast.
cd "$(dirname "$0")" && . ./lib.sh
. "$SMOKE_DIR/env.sh"
cd "$(git rev-parse --show-toplevel)/dogfooding" || exit 1

echo "== launch =="

# Reap the previous run's background processes before starting new ones. An
# earlier run that was interrupted mid-phase never reached finish.sh, so its
# logcat and both flutter run supervisors are still alive — and the old logcat
# is still appending to the very file this run is about to truncate, which
# interleaves two runs' output in one log and makes every assertion suspect.
stop_all_bg

# Fresh logs so no assertion can match a previous run's output.
adb logcat -c >/dev/null 2>&1
: >"$ANDROID_LOG"; : >"$IOS_LOG"
# And fresh results. preflight truncates these too, but launch is the real
# start-of-run boundary: it wipes app state, so a relaunch after a failed
# attempt is a new run. Without this the summary table shows the abandoned
# attempt's rows — including its failures — alongside the real ones.
: >"$RESULTS"
nohup adb logcat >"$ANDROID_LOG" 2>&1 &
record_bg logcat $!

# Wipe Android app state so the login screen is guaranteed to be the first
# screen. Without this, a persisted session lands on Home instead and every
# subsequent tap coordinate is wrong.
adb shell pm clear "$ANDROID_PKG" >/dev/null 2>&1
# pm clear also wipes granted permissions. Granting here is not enough on its
# own — flutter's install resets them again — so this runs a second time below,
# once both apps are up.
grant_android_permissions

# Android: install+run via flutter so hot reload and Dart logs are available.
nohup flutter run --flavor dev -d "$ANDROID_SERIAL" \
  >"$SMOKE_DIR/android_run.log" 2>&1 &
record_bg android_run $!

nohup flutter run --flavor dev -d "$IOS_UDID" >"$IOS_LOG" 2>&1 &
record_bg ios_run $!

echo "  waiting for both apps (up to 15 min; iOS first build is the slow one)"

if wait_log "$SMOKE_DIR/android_run.log" "Dart VM Service on" 900; then
  pass "boot-android" "Android app launched"
else
  fail "boot-android" "Android app did not launch — see $SMOKE_DIR/android_run.log"
fi

if wait_log "$IOS_LOG" "Dart VM Service on" 900; then
  pass "boot-ios" "iOS app launched"
else
  if grep -qE "requires minimum platform version" "$IOS_LOG"; then
    fail "boot-ios" "iOS build failed on SPM platform floor — run: flutter config --no-enable-swift-package-manager"
  else
    fail "boot-ios" "iOS app did not launch — see $IOS_LOG"
  fi
fi

# The decisive grant: flutter's install has just reset runtime permissions, so
# this is the one that actually holds for the run. Without it the camera dialog
# appears on the first Start New Call and swallows the tap.
grant_android_permissions

sleep 4
shot "01-android-launched"
echo "OK launch"
