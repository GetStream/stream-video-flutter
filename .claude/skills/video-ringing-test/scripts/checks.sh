#!/usr/bin/env bash
# Phase 2 — one ring, one app state, one outcome.
#
# Usage: checks.sh <app-state>-<action>
#
#   app-state: foreground | background | terminated
#   action:    accept | decline | timeout
#
# The two are orthogonal: the app state decides how the ring is surfaced, the
# action decides how it ends, and each combination is a separate ring. Every
# invocation places exactly one real ringing call and sets its state up from
# scratch, so the order does not matter and a single case can be retried alone.
cd "$(dirname "$0")" && . ./lib.sh
. "$RING_DIR/env.sh" 2>/dev/null || true
derive_pkg || exit 1
android_geometry >/dev/null || exit 1

CASE="${1:-}"
APP_STATE="${CASE%-*}"
ACTION="${CASE##*-}"

case "$APP_STATE" in foreground|background|terminated) ;; *) APP_STATE="" ;; esac
case "$ACTION" in accept|decline|timeout) ;; *) ACTION="" ;; esac
if [ -z "$APP_STATE" ] || [ -z "$ACTION" ]; then
  echo "usage: checks.sh <foreground|background|terminated>-<accept|decline|timeout>" >&2
  exit 2
fi

API="${ANDROID_API:-$(adb shell getprop ro.build.version.sdk | tr -d '\r')}"
# From env.sh, written by install.sh. Falls back to the log only when a run skipped
# install.sh entirely.
if [ -n "${TELECOM_ENABLED:-}" ]; then
  TELECOM_ON="$TELECOM_ENABLED"
else
  TELECOM_ON=0; telecom_enabled_in_app && TELECOM_ON=1
fi

echo "== ring: $APP_STATE / $ACTION =="

[ -f "$RING_DIR/logcat.pid" ] || start_logcat

# A timeout is judged by a missed-call notification appearing, so any left over
# from an earlier case has to go first or the assertion passes without this ring
# having produced anything.
[ "$ACTION" = "timeout" ] && clear_notifications

# --- put the app into the state under test ----------------------------------
case "$APP_STATE" in
  foreground)
    launch_app
    pid_of_app >/dev/null || { fail "state-$CASE" "app is not running"; exit 1; }
    ;;
  background)
    launch_app; background_app
    pid_of_app >/dev/null || { fail "state-$CASE" "app died when backgrounded"; exit 1; }
    ;;
  terminated)
    # The only state where the push itself has to start the process.
    if kill_app; then
      pass "state-$CASE" "app process killed before the ring"
    else
      fail "state-$CASE" "could not kill the app; the cold start is not being tested"
      exit 1
    fi
    ;;
esac

MARK=$(logline "$ANDROID_LOG")

# --- place the ring from the caller app -------------------------------------
if [ "$RING_CALLER_PLATFORM" = "android" ]; then
  if ring_from_caller_app "$RING_CALLEE"; then
    pass "ring-placed-$CASE" "caller app created a ringing call via Direct Call"
  else
    fail "ring-placed-$CASE" "the caller app could not create a ringing call"
    stop_logcat; exit 1
  fi
else
  # The agent places the ring on the simulator while this waits. Printed as one
  # unmistakable line so it cannot be lost in the scrollback.
  echo
  echo "  >>> RING NOW from the iOS simulator: Direct Call -> '$RING_CALLEE' -> Call"
  echo "  >>> (SKILL.md step 3b — dismiss the feedback modal first). Waiting up to 90s."
  echo
  if wait_probe incoming_notification_present 90; then
    pass "ring-placed-$CASE" "ring from the iOS caller reached the device"
  else
    fail "ring-placed-$CASE" "no ring arrived within 90s"
    shot "err-$CASE-no-ring"; stop_logcat; exit 1
  fi
fi

# --- the ring was surfaced --------------------------------------------------
# A live dumpsys probe, not a log pattern: IncomingCallBroadcastReceiver logs only
# on failure, so there is no "call incoming" line to grep. Reading current state
# also means a stale event from an earlier ring cannot satisfy it.
if wait_probe incoming_notification_present 45; then
  # The clock every later resolution step is budgeted against. Stamped here rather
  # than before the wait: this is the first moment the ring is provably on screen,
  # and the ~25s the caller gives it starts running from about now. Without this
  # stamp _ring_action falls back to a blind three attempts and can grind for
  # minutes on a call that is already dead.
  RING_START=$(date +%s)
  pass "ring-delivered-$CASE" "the incoming call was surfaced on the device"
else
  fail "ring-delivered-$CASE" "no incoming call notification within 45s of the ring"
  shot "err-$CASE-delivery"; stop_logcat; exit 1
fi

# The ring also has to reach Dart, which is what an integrator's app sees. Kept
# separate so a native-only or Dart-only failure stays distinguishable.
assert_log_since "ring-event-$CASE" "the ringing event reached Dart" \
  "$ANDROID_LOG" "ActionCallIncoming|handleRingingFlowNotifications" "$MARK"

CALL_ID=$(last_call_id)
[ -n "$CALL_ID" ] && echo "CALL_ID=$CALL_ID" >>"$RING_DIR/env.sh"

if [ "$APP_STATE" = "terminated" ]; then
  if pid_of_app >/dev/null; then
    pass "cold-start-$CASE" "the push started the app process from dead"
  else
    fail "cold-start-$CASE" "no app process after the push"
  fi
fi

# --- Telecom ----------------------------------------------------------------
if [ "$TELECOM_ON" = "1" ]; then
  if wait_log "$ANDROID_LOG" "\[onCallRegistered\].*incoming=true" 30 "$MARK"; then
    pass "telecom-register-$CASE" "call registered with the Telecom stack"
  else
    fail "telecom-register-$CASE" "call never reached Telecom"
  fi
  assert_probe "telecom-live-$CASE" "Telecom holds a self-managed call while ringing" \
    telecom_call_present 15
else
  skip "telecom-register-$CASE" "Telecom not enabled in the app config"
  skip "telecom-live-$CASE" "Telecom not enabled in the app config"
fi

# --- Android 17 ringing foreground service ----------------------------------
# Gated on API 37 in the SDK, so anything lower is a SKIP rather than a FAIL. This
# asserts the mechanism the fix changes, not that the ringtone is audible: audio
# cannot be heard over adb.
if [ "$API" -ge 37 ]; then
  assert_probe "ring-fgs-$CASE" "ringing service is in the foreground" \
    ringing_service_foreground 20
  assert_probe "ring-fgs-type-$CASE" "ringing service runs as phoneCall, not shortService" \
    ringing_service_type_phonecall 20
else
  skip "ring-fgs-$CASE" "API $API is below 37; the ringing service stays gated off"
  skip "ring-fgs-type-$CASE" "API $API is below 37"
fi

shot "20-$CASE-ringing"

# --- resolve the ring -------------------------------------------------------
RMARK=$(logline "$ANDROID_LOG")
case "$ACTION" in
  accept)
    if accept_ring; then
      pass "accept-$CASE" "accepted from the ringing UI"
    else
      fail "accept-$CASE" "could not accept from the ringing UI"; shot "err-$CASE-accept"
    fi
    if [ "$TELECOM_ON" = "1" ]; then
      # source=APP separates our own accept from a system-originated one, and
      # onIsCallAnswered cannot be reached by a ring timing out.
      if wait_log "$ANDROID_LOG" "\[onIsCallAnswered\].*source=APP" 20 "$RMARK"; then
        pass "telecom-answer-$CASE" "Telecom recorded the answer as app-initiated"
      else
        fail "telecom-answer-$CASE" "Telecom did not record the answer"
      fi
    else
      skip "telecom-answer-$CASE" "Telecom not enabled in the app config"
    fi
    ;;

  decline)
    if decline_ring; then
      pass "decline-$CASE" "declined from the ringing UI"
    else
      fail "decline-$CASE" "could not decline from the ringing UI"; shot "err-$CASE-decline"
    fi
    if [ "$TELECOM_ON" = "1" ]; then
      # cause=6 is DisconnectCause.REJECTED, verified against android-37.0.
      if wait_log "$ANDROID_LOG" "\[onIsCallDisconnected\].*cause=6" 20 "$RMARK"; then
        pass "telecom-reject-$CASE" "Telecom disconnected the call as REJECTED"
      else
        fail "telecom-reject-$CASE" "Telecom did not record a rejection"
      fi
    else
      skip "telecom-reject-$CASE" "Telecom not enabled in the app config"
    fi
    ;;

  timeout)
    info "letting the ring time out — nothing is tapped"
    if wait_log "$ANDROID_LOG" "\[reject\] reason: timeout" 90 "$RMARK"; then
      pass "timeout-$CASE" "an unanswered ring times out and rejects the call"
    else
      fail "timeout-$CASE" "the ring never timed out"
    fi

    # The user-visible result of a ring nobody answered.
    assert_probe "missed-notif-$CASE" "a missed call notification is shown" \
      missed_notification_present 30

    if [ "$TELECOM_ON" = "1" ]; then
      if wait_log "$ANDROID_LOG" "\[onIsCallDisconnected\]" 30 "$RMARK"; then
        pass "telecom-timeout-$CASE" "Telecom is disconnected when the ring times out"
      else
        fail "telecom-timeout-$CASE" "Telecom still held the call after the timeout"
      fi
    else
      skip "telecom-timeout-$CASE" "Telecom not enabled in the app config"
    fi
    ;;
esac

# --- the ring must not outlive its resolution -------------------------------
# accept_ring/decline_ring wait on the call's own transition, so the foreground
# service is what still needs checking here.
if [ "$API" -ge 37 ]; then
  assert_probe_clears "ring-fgs-stopped-$CASE" "ringing foreground service stopped" \
    ringing_service_foreground 30
else
  skip "ring-fgs-stopped-$CASE" "API $API is below 37"
fi

# Leave a known state for the next case: an accepted call is still running.
if [ "$ACTION" = "accept" ]; then
  cancel_ring "$CALL_ID" >/dev/null 2>&1 || true
  sleep 3
fi

shot "30-$CASE-resolved"
echo "OK ring/$CASE"
