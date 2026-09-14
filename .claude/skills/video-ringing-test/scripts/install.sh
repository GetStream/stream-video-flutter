#!/usr/bin/env bash
# Phase 1 — build, install standalone, log in the callee, register for push.
#
# Deliberately does NOT use `flutter run`. The app has to survive being killed
# so a cold start from a push can be tested, and `flutter run` detaches the
# moment the process dies, taking the run with it.
cd "$(dirname "$0")" && . ./lib.sh
. "$RING_DIR/env.sh" 2>/dev/null || true
derive_pkg || exit 1
cd "$(git rev-parse --show-toplevel)/dogfooding" || exit 1
android_geometry || exit 1

echo "== install + register =="

# A wipe is required, not tidiness: the callee's FCM token is registered against
# whichever user logged in, and a leftover session from another user would leave
# the ring going to a device this run never looks at.
adb shell pm clear "$ANDROID_PKG" >/dev/null 2>&1 || true

APK="build/app/outputs/flutter-apk/app-$RING_FLAVOR-$RING_BUILD_MODE.apk"
echo "  building $RING_FLAVOR/$RING_BUILD_MODE (first run is slow)"
if ! flutter build apk "--$RING_BUILD_MODE" --flavor "$RING_FLAVOR" >"$RING_DIR/build.log" 2>&1; then
  echo "FATAL: build failed; see $RING_DIR/build.log" >&2
  tail -20 "$RING_DIR/build.log" >&2
  exit 1
fi
[ -f "$APK" ] || { echo "FATAL: expected APK at $APK" >&2; exit 1; }

adb install -r -d "$APK" >/dev/null 2>&1 || { echo "FATAL: adb install failed" >&2; exit 1; }

# The install resets runtime permissions, so the grant from preflight is gone.
# This is the grant that counts — the smoke test hit the same trap.
API=$(adb shell getprop ro.build.version.sdk | tr -d '\r')
grant_android_permissions
[ "$API" -lt 34 ] || adb shell appops set "$ANDROID_PKG" USE_FULL_SCREEN_INTENT allow >/dev/null 2>&1

start_logcat

# --- log in the callee ------------------------------------------------------
launch_app
if ! tap_until_ime $A_USER_X $A_USER_Y; then
  fail "login" "the username field never took focus"; shot "err-login-field"; exit 1
fi
adb shell input text "$RING_CALLEE"; sleep 1
hide_keyboard; sleep 2                           # keyboard covers the sign-up button

if tap_until $A_SIGNUP_X $A_SIGNUP_Y "$ANDROID_LOG" "handleHealthCheckEvent|connectUser" 3 30; then
  pass "login" "callee logged in as $RING_CALLEE"
else
  fail "login" "callee login did not complete"; shot "err-login"; exit 1
fi

# --- push registration -------------------------------------------------------
# The whole run depends on this: the ring is delivered to the device token
# registered here. If it never happens, every later check fails for one reason.
if wait_log "$ANDROID_LOG" "\[createDevice\]" 40; then
  pass "push-register" "device token registered with Stream"
else
  fail "push-register" "no createDevice call — the ring cannot reach this device"
  shot "err-register"; exit 1
fi

# --- Telecom opt-in ---------------------------------------------------------
# Reported, not assumed. With Telecom off the telecom-* checks would all pass
# vacuously by asserting nothing, which is worse than failing.
# Recorded into env.sh rather than re-derived later. The [init] line is only emitted
# when the app starts, and start_logcat clears logcat — so a later phase that
# restarts logging loses it and every telecom-* check silently degrades to SKIP.
if telecom_enabled_in_app; then
  pass "telecom-config" "Telecom enabled in the app config"
  echo "TELECOM_ENABLED=1" >>"$RING_DIR/env.sh"
else
  known "telecom-config" "Telecom NOT enabled — telecom-* checks will report SKIP"
  echo "TELECOM_ENABLED=0" >>"$RING_DIR/env.sh"
fi

shot "01-callee-logged-in"

# --- the caller app ---------------------------------------------------------
# A real second instance places the ring through Direct Call, so call creation
# and ring targeting go through the SDK instead of being simulated. The caller
# also has to exist server-side before it can create a ringing call — logging in
# here is what creates it, since minting a token does not.
if [ "$RING_CALLER_PLATFORM" = "android" ]; then
  echo "  installing the caller on $RING_CALLER_SERIAL"
  adbc shell pm clear "$ANDROID_PKG" >/dev/null 2>&1 || true
  adbc install -r -d "$APK" >/dev/null 2>&1 \
    || { fail "caller-install" "adb install on the caller failed"; exit 1; }
  for perm in RECORD_AUDIO CAMERA POST_NOTIFICATIONS READ_PHONE_STATE BLUETOOTH_CONNECT; do
    adbc shell pm grant "$ANDROID_PKG" "android.permission.$perm" >/dev/null 2>&1 || true
  done

  caller_geometry || exit 1
  require_caller_calibration || exit 1

  start_caller_logcat
  adbc shell am start -n "$(resolve_main_activity)" >/dev/null 2>&1; sleep 4
  if ! tapc_until_ime "$C_USER_X" "$C_USER_Y"; then
    fail "caller-login" "the caller's username field never took focus"
    shotc "err-caller-field"; exit 1
  fi
  adbc shell input text "$RING_CALLER"; sleep 1
  hide_keyboard_caller; sleep 2

  M=$(logline "$CALLER_LOG")
  tapc "$C_SIGNUP_X" "$C_SIGNUP_Y"
  if wait_log "$CALLER_LOG" "handleHealthCheckEvent|connectUser" 30 "$M"; then
    pass "caller-login" "caller logged in as $RING_CALLER"
  else
    fail "caller-login" "caller login did not complete; the ring cannot be placed"
    shotc "err-caller-login"; exit 1
  fi
  shotc "02-caller-home"
else
  # The simulator has no CLI that injects taps, so this half is the agent's.
  skip "caller-login" "iOS caller — log in as $RING_CALLER via SKILL.md step 2b"
  echo
  echo "  ACTION REQUIRED: log the iOS simulator in as '$RING_CALLER' now"
  echo "  (SKILL.md step 2b). The ring is placed from there in step 3."
fi

echo "OK installed and registered"
