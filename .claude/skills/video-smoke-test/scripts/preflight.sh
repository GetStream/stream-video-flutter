#!/usr/bin/env bash
# Phase 0 — environment. Exits non-zero with a single actionable line if the
# run cannot be deterministic. Never guesses.
cd "$(dirname "$0")" && . ./lib.sh
cd "$(git rev-parse --show-toplevel)/dogfooding" || exit 1

: >"$RESULTS"
echo "== preflight =="

fatal() { echo "FATAL: $1" >&2; exit 1; }

# --- android emulator -------------------------------------------------------
# Pin the target explicitly. Every script below runs bare `adb`, which aborts
# with "more than one device/emulator" the moment a phone gets plugged in
# mid-run — screenshots come back 0 bytes and unrelated checks fail. Exporting
# ANDROID_SERIAL makes adb unambiguous for the whole run.
EMUS=$(adb devices | grep -oE "^emulator-[0-9]+" || true)
EMU_COUNT=$(printf '%s\n' "$EMUS" | grep -c . || true)
[ "${EMU_COUNT:-0}" -ge 1 ] \
  || fatal "no Android emulator running. Start one: \$ANDROID_HOME/emulator/emulator -avd <name> &"
if [ "$EMU_COUNT" -gt 1 ]; then
  fatal "$EMU_COUNT emulators running; cannot pick one. Leave exactly one booted."
fi
export ANDROID_SERIAL="$EMUS"
if adb devices | grep -vE "^(List|emulator-|$)" | grep -q "device$"; then
  echo "  note: a physical Android device is attached and will be ignored (pinned to $ANDROID_SERIAL)"
fi
android_geometry || exit 1

adb shell pm list packages 2>/dev/null | grep -q "com.google.android.gms" \
  || fatal "emulator has no Google Play services; FCM-dependent paths will misbehave. Use a Play-enabled AVD."

# --- ios simulator ----------------------------------------------------------
IOS_UDID=$(xcrun simctl list devices booted 2>/dev/null | grep -oE '[0-9A-F]{8}-[0-9A-F-]{27}' | head -1)
[ -n "$IOS_UDID" ] \
  || fatal "no booted iOS simulator. Boot one: xcrun simctl boot 'iPhone 17' && open -a Simulator"

IOS_MODEL=$(xcrun simctl list devices booted | grep "$IOS_UDID" | sed 's/ (.*//' | sed 's/^ *//')
case "$IOS_MODEL" in
  "iPhone 17"|"iPhone 17 Pro"|"iPhone Air"|"iPhone 16"|"iPhone 16 Pro")
    ;;
  *)
    echo "WARN: booted simulator is '$IOS_MODEL'. The iOS tap coordinates in SKILL.md are" >&2
    echo "      for a 402x874pt device (iPhone 17). Verify the panel reports 402x874" >&2
    echo "      before tapping, or boot an iPhone 17." >&2
    ;;
esac

# --- swift package manager must be off (otherwise the iOS build cannot link) -
if grep -q '"enable-swift-package-manager": *true' ~/.config/flutter/settings 2>/dev/null; then
  echo "  fixing: flutter SPM support is on; the dogfooding iOS build fails with it"
  flutter config --no-enable-swift-package-manager >/dev/null 2>&1
fi

# --- pre-grant iOS permissions so no system dialog can eat a tap ------------
# Bundle id differs per flavor; read it off the simulator if the app is already
# installed, else fall back to the dev-flavor default.
IOS_BUNDLE=$(xcrun simctl listapps "$IOS_UDID" 2>/dev/null \
  | grep -oE 'io\.getstream\.video\.flutter\.dogfooding[A-Za-z.]*' | sort -u | head -1)
IOS_BUNDLE=${IOS_BUNDLE:-io.getstream.video.flutter.dogfooding}
for svc in microphone camera notifications; do
  xcrun simctl privacy "$IOS_UDID" grant "$svc" "$IOS_BUNDLE" >/dev/null 2>&1
done
echo "  ios permissions pre-granted for $IOS_BUNDLE"

# --- android permissions, same reason ---------------------------------------
# READ_PHONE_STATE matters as much as the obvious ones: without it the app
# raises a "make and manage phone calls" dialog on the first Start New Call,
# which swallows the tap and derails the run.
grant_android_permissions

# --- microphone prerequisite -------------------------------------------------
# The audio checks need real sound to reach the emulator, which depends on two
# things that cannot be read back: host microphone access on the AVD (the
# emulator console has no microphone command) and macOS granting the emulator
# microphone access. So this only reminds; the checks name both causes when they
# fail. Never make it a hard failure — the rest of the run is valid regardless.
if command -v say >/dev/null 2>&1; then
  echo "  audio checks will speak through the host's speakers"
  echo "  they need the AVD's 'Enable Host Microphone Access' (Extended controls > Microphone)"
else
  echo "  WARN: no 'say' on this host — the microphone-dependent checks will fail"
fi

cat >"$SMOKE_DIR/env.sh" <<EOF
export ANDROID_SERIAL=$ANDROID_SERIAL
IOS_UDID=$IOS_UDID
IOS_BUNDLE=$IOS_BUNDLE
IOS_MODEL="$IOS_MODEL"
EOF

echo "  android: $(adb shell getprop ro.build.version.release | tr -d '\r') (API $(adb shell getprop ro.build.version.sdk | tr -d '\r'))"
echo "  ios:     $IOS_MODEL / $IOS_UDID"
echo "  branch:  $(git rev-parse --abbrev-ref HEAD) @ $(git rev-parse --short HEAD)"
echo "OK preflight"
