#!/usr/bin/env bash
# Phase 0 — environment. Exits non-zero with a single actionable line if the run
# cannot be deterministic. Never guesses, never repairs beyond granting.
cd "$(dirname "$0")" && . ./lib.sh
cd "$(git rev-parse --show-toplevel)" || exit 1

: >"$RESULTS"
echo "== preflight =="

fatal() { echo "FATAL: $1" >&2; exit 1; }

# --- emulator ---------------------------------------------------------------
# Pinned for the same reason as the smoke test: a phone plugged in mid-run makes
# every bare `adb` ambiguous, and screenshots come back 0 bytes.
EMUS=$(adb devices | grep -oE "^emulator-[0-9]+" || true)
EMU_COUNT=$(printf '%s\n' "$EMUS" | grep -c . || true)

# The callee is always the first emulator. The caller is the second one when the
# ring comes from another Android instance; with RING_CALLER_PLATFORM=ios there
# is no second emulator and the ring is placed on the simulator instead.
if [ "$RING_CALLER_PLATFORM" = "android" ]; then
  [ "${EMU_COUNT:-0}" -ge 2 ] || fatal "RING_CALLER_PLATFORM=android needs two emulators \
(callee + caller); $EMU_COUNT booted.
       Start a second one, or use RING_CALLER_PLATFORM=ios to place the ring from the simulator."
  [ "$EMU_COUNT" -le 2 ] || fatal "$EMU_COUNT emulators booted; leave exactly two."
  RING_CALLEE_SERIAL=$(printf '%s\n' "$EMUS" | sed -n 1p)
  RING_CALLER_SERIAL=$(printf '%s\n' "$EMUS" | sed -n 2p)
else
  [ "${EMU_COUNT:-0}" -ge 1 ] \
    || fatal "no Android emulator running. Start one: \$ANDROID_HOME/emulator/emulator -avd <name> &"
  [ "$EMU_COUNT" -le 1 ] \
    || fatal "$EMU_COUNT emulators booted; leave exactly one for RING_CALLER_PLATFORM=ios."
  RING_CALLEE_SERIAL="$EMUS"
  RING_CALLER_SERIAL=""
fi
export ANDROID_SERIAL="$RING_CALLEE_SERIAL"

API=$(adb shell getprop ro.build.version.sdk | tr -d '\r')
REL=$(adb shell getprop ro.build.version.release | tr -d '\r')

# Telecom needs API 26. Below that every check would report the same skip, which
# is a waste of a run rather than a useful result.
[ "$API" -ge 26 ] \
  || fatal "emulator is API $API. Telecom needs API 26+; nothing here would exercise it."

# --- FCM ---------------------------------------------------------------------
# The push path is the whole point. Without Play services the ring never
# arrives and every check fails for one reason that has nothing to do with the SDK.
adb shell pm list packages 2>/dev/null | grep -q "com.google.android.gms" \
  || fatal "emulator has no Google Play services; FCM cannot deliver. Use a Play-enabled AVD."

# --- ios simulator (only when the caller runs there) ------------------------
if [ "$RING_CALLER_PLATFORM" = "ios" ]; then
  IOS_UDID=$(xcrun simctl list devices booted 2>/dev/null \
    | grep -oE '[0-9A-F]{8}-[0-9A-F-]{27}' | head -1)
  [ -n "$IOS_UDID" ] \
    || fatal "RING_CALLER_PLATFORM=ios but no booted simulator. Boot one:
       xcrun simctl boot 'iPhone 17' && open -a Simulator"
  IOS_MODEL=$(xcrun simctl list devices booted | grep "$IOS_UDID" | sed 's/ (.*//' | sed 's/^ *//')
  case "$IOS_MODEL" in
    "iPhone 17"|"iPhone 17 Pro"|"iPhone Air"|"iPhone 16"|"iPhone 16 Pro") ;;
    *) echo "WARN: booted simulator is '$IOS_MODEL'. The iOS coordinates in SKILL.md are for a" >&2
       echo "      402x874pt device (iPhone 17). Verify the panel reports 402x874 before tapping." >&2 ;;
  esac
  echo "  ios caller: $IOS_MODEL / $IOS_UDID"
fi

# --- network ----------------------------------------------------------------
curl -sS --max-time 15 -o /dev/null \
  "https://$RING_TOKEN_HOST/api/auth/create-token?environment=$RING_ENV&user_id=preflight_probe" \
  || fatal "token endpoint https://$RING_TOKEN_HOST unreachable; the caller cannot mint a token."

# --- build mode -------------------------------------------------------------
if [ "$RING_BUILD_MODE" = "release" ] && [ ! -f android/key.properties ] \
   && [ ! -f dogfooding/android/key.properties ]; then
  fatal "RING_BUILD_MODE=release needs dogfooding/android/key.properties (release signing).
       Either add it or run with the default RING_BUILD_MODE=debug — every check here
       reads native logcat or a dumpsys probe, so neither is weakened by debug."
fi

# --- permissions ------------------------------------------------------------
# A permission dialog on top of the ringing UI eats the accept tap, and a
# missing POST_NOTIFICATIONS means the incoming notification silently never
# appears — which reads exactly like a broken ringing flow.
grant_android_permissions

# USE_FULL_SCREEN_INTENT is an appop, not a runtime permission, so pm grant does
# not touch it. On API 34+ it can be off, and then the full-screen incoming call
# activity never launches while the app is backgrounded.
if [ "$API" -ge 34 ]; then
  adb shell appops set "$ANDROID_PKG" USE_FULL_SCREEN_INTENT allow >/dev/null 2>&1 \
    || info "WARN: could not set USE_FULL_SCREEN_INTENT; the full-screen checks may fail"
fi

# Keep the screen on and awake for the whole run.
adb shell svc power stayon true >/dev/null 2>&1 || true

# Take the device out of idle. A dozing emulator defers FCM, and the ring then never
# arrives — a failure that has nothing to do with the SDK. Restored by stop.sh.
adb shell dumpsys deviceidle disable >/dev/null 2>&1 || true

# --- record the environment for later phases --------------------------------
mkdir -p "$RING_DIR"
cat >"$RING_DIR/env.sh" <<EOF
export ANDROID_SERIAL=$ANDROID_SERIAL
export RING_CALLEE_SERIAL=$RING_CALLEE_SERIAL
export RING_CALLER_SERIAL=$RING_CALLER_SERIAL
export RING_CALLER_PLATFORM=$RING_CALLER_PLATFORM
export IOS_UDID=${IOS_UDID:-}
export RING_BUILD_MODE=$RING_BUILD_MODE
export RING_FLAVOR=$RING_FLAVOR
export RING_CALLEE=$RING_CALLEE
export RING_CALLER=$RING_CALLER
ANDROID_API=$API
EOF

echo "  android:  $REL (API $API)"
echo "  package:  $ANDROID_PKG  [$RING_BUILD_MODE/$RING_FLAVOR]"
echo "  callee:   $RING_CALLEE on $RING_CALLEE_SERIAL"
if [ "$RING_CALLER_PLATFORM" = "android" ]; then
  echo "  caller:   $RING_CALLER on $RING_CALLER_SERIAL (Direct Call, scripted)"
else
  echo "  caller:   $RING_CALLER on the iOS simulator (Direct Call, driven by the agent)"
fi
echo "  branch:   $(git rev-parse --abbrev-ref HEAD) @ $(git rev-parse --short HEAD)"
if [ "$API" -lt 37 ]; then
  echo "  note: API $API is below 37, so the Android 17 ringing foreground service"
  echo "        stays gated off. ring-fgs-* will report SKIP, which is correct here."
fi
echo "OK preflight"
