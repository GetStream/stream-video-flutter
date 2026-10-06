#!/usr/bin/env bash
# Phase 6 — cross-platform assertions for the plain call, leave, deep link,
# leak checks. Run after the agent has finished the iOS check sequence and
# tapped iOS end-call.
#
# The summary lives in report.sh, not here: the run continues into an encrypted
# round after this, and the report has to cover both.
cd "$(dirname "$0")" && . ./lib.sh
. "$SMOKE_DIR/env.sh"
android_geometry || exit 1

echo "== cross-platform =="

# --- iOS side, asserted from its flutter run log ---------------------------
assert_log "join-ios"          "iOS joined the same call"                      "$IOS_LOG" "sfuJoinResponse"
assert_log "publish-audio-ios" "iOS published its audio track"                 "$IOS_LOG" "\[publishAudioTrack\]"
assert_two_participants "peer-seen-ios" "iOS sees the Android participant" "$IOS_LOG"
# The branch-specific path: iOS must mute at the audio-device-module level and
# keep capturing, not stop the track. Without this, speaking-while-muted
# detection cannot fire on iOS/macOS.
assert_log "adm-mute-ios"      "iOS mute goes through the Apple ADM path"      "$IOS_LOG" "setAppleAdmMicrophoneMuted\] muted: true"
assert_log "adm-unmute-ios"    "iOS unmute releases the ADM mute"              "$IOS_LOG" "setAppleAdmMicrophoneMuted\] muted: false"

# --- chat: iOS send, and delivery back to Android -------------------------
# The Android -> iOS direction is asserted in android_checks.sh, in the only
# window where a message.new on iOS can only be the Android message.
#
# The iOS send is matched case-insensitively: the iOS keyboard autocapitalises
# the first character of whatever the agent types (Smoke_ios_1).
# Match the outgoing request body, not just the text anywhere in the log, so
# the check cannot pass on a message that only reached the composer.
assert_log "chat-send-ios" "iOS chat message accepted by the API" "$IOS_LOG" \
  "(Message\(.*, [Ss]moke_ios_1, regular|\"text\":\"[Ss]moke_ios_1\")"
# Receipt on Android is the WS event, not the text — a receiving client never
# logs the body of a message it receives. ANDROID_CHAT_MARK was recorded after
# Android's own message.new echo, so a match here is the iOS message.
if grep -q "^PASS.chat-send-ios" "$RESULTS" 2>/dev/null; then
  assert_chat_delivered "chat-b2a" "iOS -> Android chat message delivered" \
    "$ANDROID_LOG" "${ANDROID_CHAT_MARK:-1}" 25
else
  skip "chat-b2a" "no iOS message was sent, delivery cannot be judged"
fi

# --- leave + teardown ------------------------------------------------------
echo "== teardown =="
# android_checks.sh ends with the chat sheet open, stacked on top of the
# options sheet. Both are modal: a tap outside a sheet is eaten by its scrim
# and only dismisses that sheet, so a single END CALL tap never reaches the
# button — it just closes the chat sheet and the call keeps running (which is
# what made leave/service/notification all fail together). tap_until re-taps
# until the log confirms the leave: the first taps peel off the sheets, the
# last one lands on END CALL. Do not replace this with a bare tap.
if tap_until $A_END_X $A_TOP_Y "$ANDROID_LOG" "\[leave\] reason|\[clear\] src: disconnect" 4 12; then
  pass "leave-android" "Android left the call cleanly"
else
  fail "leave-android" "Android leave not observed"
  shot "err-leave-android"
fi
sleep 4
# A feedback modal appears after leaving; dismiss it so the app is left usable.
dismiss_feedback

# --- deep link join --------------------------------------------------------
# Runs after the call is over so a link cannot disturb the in-call checks, and
# before the leak checks so those still assert on a finished call.
#
# The link is delivered straight to the activity: a debug build is not a
# verified App Links handler, so a browsable VIEW intent opens Chrome instead
# (see `deeplink` in lib.sh).
echo "== deep link =="
M=$(logline "$ANDROID_LOG")
deeplink "https://pronto.getstream.io/join/$CALL_ID"
if ! wait_log "$ANDROID_LOG" "callCid: default:$CALL_ID" 30 "$M"; then
  fail "deeplink-route-android" "call link did not open the lobby for $CALL_ID"
  shot "err-deeplink"
elif ! router_ok "$M"; then
  fail "deeplink-route-android" "the link resolved the call but the router showed an error"
  shot "err-deeplink-router"
else
  pass "deeplink-route-android" "Call link opens the lobby for the linked call"
fi
sleep 2; shot "21-android-deeplink-lobby"

# By label, not by coordinate. This lobby is the callExists=true variant, whose
# E2EE card renders as a one-line banner rather than the switch-plus-subtitle of
# the create case, so the join button does not sit where it sits in step 3.
M=$(logline "$ANDROID_LOG")
if ui_tap "Start a test call" 20 && wait_log "$ANDROID_LOG" "sfuJoinResponse" 40 "$M"; then
  pass "deeplink-join-android" "Joined the call reached through the link"
else
  fail "deeplink-join-android" "could not join from the link's lobby"
fi

# Leave again, so the leak checks below judge a torn-down call. This also
# exercises the pop path that a link-built navigation stack produces.
M=$(logline "$ANDROID_LOG")
if ! tap_until $A_END_X $A_TOP_Y "$ANDROID_LOG" "\[leave\] reason|\[clear\] src: disconnect" 4 12; then
  fail "deeplink-leave-android" "leaving the linked call failed"
elif ! router_ok "$M"; then
  fail "deeplink-leave-android" "leaving the linked call emptied the navigation stack"
else
  pass "deeplink-leave-android" "Left the linked call without emptying the navigation stack"
fi
sleep 3
dismiss_feedback
echo "== no-leak checks =="

# Only the Stream CALL foreground service counts, and it gets a settle window:
# teardown is asynchronous, and the app also runs unrelated short-lived
# services, so "any ServiceRecord, one second after leaving" is a race that
# reports normal teardown as a leak. On a real leak the dump is saved for a
# human — do not diagnose it from this script.
if wait_call_service_gone 25; then
  pass "no-service-leak" "No call foreground service left running after leaving"
else
  call_service_dump >"$SMOKE_DIR/service-leak.txt"
  adb shell dumpsys activity services "$ANDROID_PKG" 2>/dev/null >>"$SMOKE_DIR/service-leak.txt"
  fail "no-service-leak" "call foreground service still alive 25s after leaving (dump: $SMOKE_DIR/service-leak.txt)"
fi

if [ "$(adb shell dumpsys notification 2>/dev/null | grep -c "pkg=$ANDROID_PKG")" = "0" ]; then
  pass "no-notif-leak" "No ongoing-call notification left behind"
else
  fail "no-notif-leak" "ongoing-call notification leaked after leaving"
fi

assert_log "leave-ios" "iOS left the call cleanly" "$IOS_LOG" "\[leave\] reason|\[clear\] src: disconnect"
shot "20-android-after-leave"

echo "OK finish — now run the encrypted round from SKILL.md step 7"
