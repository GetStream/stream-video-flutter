#!/usr/bin/env bash
# Phase 2 — Android: log in, create a call, print the call ID.
# Starts from a wiped app so the login screen is guaranteed to be on screen.
cd "$(dirname "$0")" && . ./lib.sh
. "$SMOKE_DIR/env.sh"   # pins ANDROID_SERIAL
android_geometry || exit 1

echo "== android: login + create call =="
# The username MUST contain an underscore or digit. A plain dictionary-ish word
# gets silently rewritten by the emulator IME's autocorrect ("smokea" -> "smokes")
# and the run then asserts against the wrong user id.
USER_A=${1:-smoke_a1}

tap $A_USER_X $A_USER_Y; sleep 2
adb shell input text "$USER_A"; sleep 1
# The soft keyboard covers the sign-up button, so dismiss it before tapping.
adb shell input keyevent KEYCODE_BACK; sleep 2

# Coordinator WS health-check traffic only starts once the user is connected.
if tap_until $A_SIGNUP_X $A_SIGNUP_Y "$ANDROID_LOG" "handleHealthCheckEvent|connectUser" 3 25; then
  pass "login-android" "Android logged in as $USER_A"
else
  fail "login-android" "Android login did not complete"; shot "err-login"; exit 1
fi
anr_check "login-android"

# tap_until, not a fixed sleep: the home screen takes a variable moment to build
# after login, and a tap that lands early hits the login screen's Google button.
if tap_until $A_START_NEW_X $A_START_NEW_Y "$ANDROID_LOG" "getOrCreateCall" 4 15; then
  pass "lobby-android" "Lobby screen reached"
else
  fail "lobby-android" "Lobby did not open"; shot "err-lobby"; exit 1
fi
sleep 3
shot "02-android-lobby"

if tap_until $A_TESTCALL_X $A_TESTCALL_Y "$ANDROID_LOG" "sfuJoinResponse" 3 30; then
  pass "join-android" "Android joined the call"
else
  fail "join-android" "Android did not join"; shot "err-join"; exit 1
fi

CALL_ID=$(grep -oE "callCid: default:[a-z0-9]+" "$ANDROID_LOG" | tail -1 | sed 's/.*://')
if [ -z "$CALL_ID" ]; then fail "callid" "could not extract call id"; exit 1; fi
# Replace any CALL_ID from a previous run rather than appending a second one.
#
# The mv is conditional on purpose. The redirection creates env.tmp whether or
# not grep succeeds, so an unconditional mv turns any grep failure into a
# truncated env.sh — which silently drops ANDROID_SERIAL, and every later phase
# then runs bare `adb` and dies the moment a second device is attached. Keeping
# the old file on failure costs a duplicate CALL_ID line at worst, and the last
# one wins when it is sourced.
if grep -v '^CALL_ID=' "$SMOKE_DIR/env.sh" >"$SMOKE_DIR/env.tmp" 2>/dev/null \
   && [ -s "$SMOKE_DIR/env.tmp" ]; then
  mv "$SMOKE_DIR/env.tmp" "$SMOKE_DIR/env.sh"
else
  rm -f "$SMOKE_DIR/env.tmp"
fi
echo "CALL_ID=$CALL_ID" >>"$SMOKE_DIR/env.sh"

sleep 3
shot "03-android-in-call"
assert_log "publish-audio-android" "Android published its audio track" "$ANDROID_LOG" "\[publishAudioTrack\]"
assert_log "publish-video-android" "Android published its video track" "$ANDROID_LOG" "sfuTrackPublished.*video"

echo
echo "CALL_ID=$CALL_ID"
echo "OK android joined — now run the iOS join sequence from SKILL.md step 4"
