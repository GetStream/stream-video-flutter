#!/usr/bin/env bash
# Phase 4 — Android in-call checks. Run with both clients already in the call.
# Every check is a log assertion scoped to lines produced after its own action,
# so nothing can pass on a stale event. No screenshot interpretation required.
#
# Step order is deliberate. Chat runs LAST because it is the only step that
# opens a modal sheet, and a sheet that fails to dismiss would invalidate every
# check after it. in_call_guard runs before each risky step so a dropped call is
# reported once, clearly, instead of cascading.
cd "$(dirname "$0")" && . ./lib.sh
. "$SMOKE_DIR/env.sh"
android_geometry || exit 1

echo "== android: in-call checks =="

# The reconnect step cuts the emulator's network. If this script dies between
# the cut and the restore — Ctrl-C, a harness timeout, a kill — the emulator is
# left with no connectivity and nothing on screen says why: every later run just
# fails to log in. The trap restores it on ANY exit path, and is a no-op when
# the network was never cut.
NET_CUT=0
restore_network() {
  [ "${NET_CUT:-0}" = 1 ] || return 0
  NET_CUT=0
  info "restoring network"
  adb shell svc wifi enable >/dev/null 2>&1
  adb shell svc data enable >/dev/null 2>&1
}
trap restore_network EXIT
trap 'restore_network; exit 130' INT TERM

# This script assumes a freshly joined call with the plain call screen showing —
# which android_join.sh guarantees. Do not run it twice against the same call:
# the chat step deliberately leaves the chat sheet open, and a second run's
# early taps would land on that sheet instead of the control bar.
shot "09-android-precheck-state"

# --- peer visible ----------------------------------------------------------
assert_two_participants "peer-seen-android" "Android sees the iOS participant" "$ANDROID_LOG"

# --- microphone input reaching the peer ------------------------------------
# Runs before the mute checks, while Android is still unmuted. Needs the
# emulator's host-microphone access and audible sound from the host — see
# MIC_HINT in lib.sh and the prerequisites in SKILL.md.
#
# The assertion reads the *iOS* log while *Android* speaks. That is not a
# mistake: the SFU reports a participant's level and dominance to the other
# participants, not back to the speaker, so Android never sees its own.
#
# Do not try to assert audio levels instead. They arrive as high-frequency
# events that update call state without logging, and `audioLevel:` only shows
# up incidentally inside the state dumps that track publish/unpublish print —
# so during a speech window there is usually nothing to match, working
# microphone or not. Dominant speaker is the low-frequency, logged signal.
if in_call_guard "dominant-speaker-a2b"; then
  IOS_M=$(logline "$IOS_LOG")
  speak_start 30
  assert_mic "dominant-speaker-a2b" "Android's speech makes iOS mark it the dominant speaker" \
    "$IOS_LOG" "\[sfuDominantSpeakerChanged\]" "$IOS_M" 35
  speak_stop
  shot "09b-android-speaking"
  anr_check "audio-android"
fi

# --- mute / unmute + speaking while muted ----------------------------------
M=$(logline "$ANDROID_LOG"); tap $A_MIC $A_BAR_Y
wait_log "$ANDROID_LOG" "sfuTrackUnpublished.*audio" 20 "$M"
assert_log_since "mute-android" "Mute unpublishes the audio track" "$ANDROID_LOG" "sfuTrackUnpublished.*audio" "$M"
sleep 1; shot "10-android-muted"

# Still muted: the recognizer must be armed, and must fire on speech. Both can
# only be checked here — detection is only active while the user is muted.
if grep -q "^PASS.mute-android" "$RESULTS"; then
  M=$(logline "$ANDROID_LOG")
  if wait_log "$ANDROID_LOG" "SV:SpeakingWhileMutedRecognition.*\[startRecognition\]" 15 "$M"; then
    pass "swm-detection-started-android" "Muting starts speaking-while-muted detection"
  else
    fail "swm-detection-started-android" "muting did not start speaking-while-muted detection"
  fi

  M=$(logline "$ANDROID_LOG")
  speak_start 25
  # The recognizer logs its transitions; the app turns them into a snackbar,
  # which is not observable from a log.
  assert_mic "swm-detect-android" "Speech while muted is detected" "$ANDROID_LOG" \
    "SV:SpeakingWhileMutedRecognition.*isSpeakingWhileMuted: true" "$M" 30
  speak_stop
  shot "10b-android-speaking-while-muted"
  # Detection succeeded, which means the app has just shown its floating
  # "You are muted. Unmute to speak." snackbar — and that sits over the bottom
  # control bar, so the very next tap lands on the snackbar instead of the mic
  # button. Wait for it to expire, or unmute, camera-on and the filter step all
  # fail for a reason that has nothing to do with them.
  sleep 6
else
  skip "swm-detection-started-android" "mute did not take effect"
  skip "swm-detect-android" "mute did not take effect"
fi

M=$(logline "$ANDROID_LOG"); tap $A_MIC $A_BAR_Y
wait_log "$ANDROID_LOG" "sfuTrackPublished.*audio" 20 "$M"
assert_log_since "unmute-android" "Unmute republishes the audio track" "$ANDROID_LOG" "sfuTrackPublished.*audio" "$M"
# Unmuting must also tear the detection down, or it keeps listening for the
# rest of the call.
if wait_log "$ANDROID_LOG" "SV:SpeakingWhileMutedRecognition.*\[stopRecognition\]" 15 "$M"; then
  pass "swm-detection-stopped-android" "Unmuting stops speaking-while-muted detection"
else
  fail "swm-detection-stopped-android" "detection still running after unmute"
fi
anr_check "mute-android"

# --- camera off / on -------------------------------------------------------
M=$(logline "$ANDROID_LOG"); tap $A_CAM $A_BAR_Y
wait_log "$ANDROID_LOG" "sfuTrackUnpublished.*video" 20 "$M"
assert_log_since "camera-off-android" "Camera off unpublishes the video track" "$ANDROID_LOG" "sfuTrackUnpublished.*video" "$M"
sleep 1; shot "11-android-camera-off"

M=$(logline "$ANDROID_LOG"); tap $A_CAM $A_BAR_Y
wait_log "$ANDROID_LOG" "sfuTrackPublished.*video" 25 "$M"
assert_log_since "camera-on-android" "Camera on republishes the video track" "$ANDROID_LOG" "sfuTrackPublished.*video" "$M"
anr_check "camera-android"

# --- reaction --------------------------------------------------------------
M=$(logline "$ANDROID_LOG")
tap $A_MORE $A_BAR_Y; sleep 2
tap $A_REACT_X $A_REACT_Y; sleep 3
if tail -n "+$M" "$ANDROID_LOG" | grep -qiE "reaction"; then
  pass "reaction-android" "Reaction sent and echoed back"
else
  fail "reaction-android" "no reaction event in log"; shot "err-reaction"
fi

# --- video filter ----------------------------------------------------------
# Selecting a filter does NOT close the options sheet (selecting a reaction
# does). The sheet is therefore still open when this step ends, and the stats
# step below relies on that — do not add a MORE tap between them.
M=$(logline "$ANDROID_LOG")
tap $A_MORE $A_BAR_Y; sleep 2
tap $A_BLUR_X $A_BLUR_Y; sleep 4
assert_log_since "filter-android" "Blur filter initialised its frame processor" "$ANDROID_LOG" \
  "registerBlurEffectProcessors|VideoFrameProcessorWithBitmapFilter" "$M"
shot "12-android-filter"

# --- stats screen ----------------------------------------------------------
# Sheet is already open from the filter step; tap Stats directly.
tap $A_STATS_X $A_STATS_Y; sleep 4
shot "13-android-stats"
tap $A_STATS_BACK_X $A_TOP_Y; sleep 3        # top-LEFT back arrow (see lib.sh)
# Honest scope: this proves the stats route opens and closes without hanging or
# dropping the call. The numbers on it are for a human to read in shot 13.
if anr_check "stats-android" && in_call_guard "stats-android"; then
  pass "stats-android" "Stats screen opened and closed with the call intact (values in shot 13)"
fi

# The sheet is still open after returning from stats. Close it so the bottom
# control bar is reachable for the steps below.
tap $A_MORE $A_BAR_Y; sleep 2
shot "13b-android-sheet-closed"

# --- picture in picture ----------------------------------------------------
if in_call_guard "pip-android"; then
  adb shell input keyevent KEYCODE_HOME
  if wait_pip 15; then
    pass "pip-android" "Entered Picture-in-Picture"
  else
    fail "pip-android" "no PiP transition observed"
  fi
  shot "15-android-pip"

  # Restore by re-launching the activity. This resumes the existing task; it must
  # NOT restart the process (a restart would drop the call), so verify after.
  adb shell am start -n "$ANDROID_PKG/io.getstream.video.flutter.dogfooding.MainActivity" >/dev/null 2>&1
  sleep 6
  if in_call_guard "pip-restore-android"; then
    pass "pip-restore-android" "Restored from PiP with the call still connected"
  fi
fi

# --- reconnect -------------------------------------------------------------
if in_call_guard "reconnect-detect-android"; then
  M=$(logline "$ANDROID_LOG")
  info "cutting network"
  # Flag first: if the disable lands and the script dies before the restore, the
  # trap must know the network is down. Setting it after would lose that race.
  NET_CUT=1
  adb shell svc wifi disable; adb shell svc data disable
  if wait_log "$ANDROID_LOG" "scheduling restartICE|\[reconnect\] isConnecting" 45 "$M"; then
    pass "reconnect-detect-android" "Network loss detected; ICE restart / reconnect scheduled"
  else
    fail "reconnect-detect-android" "no reconnect attempt after network loss"
  fi
  sleep 2; shot "16-android-reconnecting"

  M=$(logline "$ANDROID_LOG")
  # Same restore the trap would do; doing it here clears the flag so the trap
  # becomes a no-op on normal exit.
  restore_network
  # Assert RECOVERY, not the strategy. Whether the SDK picks a fast reconnect or
  # a full rejoin legitimately varies with how long the outage lasted, so
  # requiring "fast" produces flaky failures. The strategy is reported as info.
  if wait_log "$ANDROID_LOG" "sfuJoinResponse" 120 "$M"; then
    STRAT=$(tail -n "+$M" "$ANDROID_LOG" | grep -oE "fast reconnecting|migrate|rejoin" | head -1)
    pass "reconnect-recover-android" "Recovered and rejoined the SFU (${STRAT:-full rejoin})"
  else
    fail "reconnect-recover-android" "did not rejoin the SFU after network restore"
  fi
  sleep 3; shot "17-android-reconnected"
  anr_check "reconnect-android"
fi

# --- chat: send from Android and prove iOS receives it ---------------------
# (LAST — opens a modal sheet.)
#
# Delivery is asserted HERE, not in finish.sh, and that ordering is load
# bearing: the sender also gets a message.new event for its own message, so the
# only window in which a message.new on iOS can *only* be the Android message
# is the one before iOS has sent anything of its own (step 6).
if in_call_guard "chat-send-android"; then
  CHAT_MSG="smoke_android_$$"
  echo "CHAT_MSG_ANDROID=$CHAT_MSG" >>"$SMOKE_DIR/env.sh"
  tap $A_CHAT $A_BAR_Y; sleep 3
  tap $A_CHAT_INPUT_X $A_CHAT_INPUT_Y; sleep 3        # composer, keyboard closed
  M=$(logline "$ANDROID_LOG"); IOS_M=$(logline "$IOS_LOG")
  if android_chat_send "$CHAT_MSG" "$M"; then
    pass "chat-send-android" "Android chat message accepted by the API"
  else
    fail "chat-send-android" "Android chat message was never sent (send tap did not land)"
  fi
  shot "14-android-chat"
  anr_check "chat-android"
  # iOS side of the same message. Only meaningful if the send happened.
  if grep -q "^PASS.chat-send-android" "$RESULTS"; then
    assert_chat_delivered "chat-a2b" "Android -> iOS chat message delivered" "$IOS_LOG" "$IOS_M" 25
  else
    skip "chat-a2b" "no Android message was sent, delivery cannot be judged"
  fi
  # Mark the Android log AFTER its own message.new echo has landed, so the
  # iOS -> Android check in finish.sh cannot be satisfied by Android's own echo.
  wait_log "$ANDROID_LOG" "Event received: message\.new" 15 "$M" || true
  echo "ANDROID_CHAT_MARK=$(logline "$ANDROID_LOG")" >>"$SMOKE_DIR/env.sh"

  # The keyboard is still open after sending, and it covers the top bar that
  # finish.sh needs for END CALL. Exactly ONE back press closes the keyboard and
  # leaves the sheet open with the top bar visible.
  #
  # Do NOT add a second back press: it would close the sheet, and a third would
  # leave the call. One is sufficient and safe.
  adb shell input keyevent KEYCODE_BACK; sleep 2
  shot "14b-android-chat-after-back"
fi

echo "OK android checks — now run the iOS check sequence from SKILL.md step 6"
