#!/usr/bin/env bash
# Phase 2 (multi-device run) — one ring to a user signed in on two devices,
# answered on one of them.
#
# Usage: elsewhere.sh <app-state>-<action>
#
#   app-state: foreground | background | terminated   (both callee devices)
#   action:    accept | decline                         (on the primary callee)
#
# Both callee emulators are logged in as the same user, so one ring rings both.
# The primary resolves it through its ringing UI exactly as checks.sh does; the
# assertions that matter are about the OTHER device, whose ring has to end
# because the user answered elsewhere — not because it timed out on its own.
#
# Results carry the suffix `-<app-state>-<action>-elsewhere`, and the second
# device's checks the prefix `dev2-`.
cd "$(dirname "$0")" && . ./lib.sh
. "$RING_DIR/env.sh" 2>/dev/null || true
derive_pkg || exit 1
android_geometry >/dev/null || exit 1

ARG="${1:-}"
APP_STATE="${ARG%-*}"
ACTION="${ARG##*-}"

case "$APP_STATE" in foreground|background|terminated) ;; *) APP_STATE="" ;; esac
case "$ACTION" in accept|decline) ;; *) ACTION="" ;; esac
if [ -z "$APP_STATE" ] || [ -z "$ACTION" ]; then
  echo "usage: elsewhere.sh <foreground|background|terminated>-<accept|decline>" >&2
  exit 2
fi
CASE="$APP_STATE-$ACTION-elsewhere"

if [ "${RING_MULTI_DEVICE:-0}" != "1" ] || [ -z "${RING_CALLEE2_SERIAL:-}" ]; then
  echo "FATAL: no second callee device. Run the multi-device setup first:" >&2
  echo "       RING_MULTI_DEVICE=1 .claude/skills/video-ringing-test/scripts/preflight.sh" >&2
  echo "       .claude/skills/video-ringing-test/scripts/install.sh" >&2
  exit 1
fi

API="${ANDROID_API:-$(adb shell getprop ro.build.version.sdk | tr -d '\r')}"
API2="${ANDROID_API2:-$(adb -s "$RING_CALLEE2_SERIAL" shell getprop ro.build.version.sdk | tr -d '\r')}"
if [ -n "${TELECOM_ENABLED:-}" ]; then
  TELECOM_ON="$TELECOM_ENABLED"
else
  TELECOM_ON=0; telecom_enabled_in_app && TELECOM_ON=1
fi

# How long the other device gets to drop its ring once the primary has answered.
# The answer travels primary -> coordinator -> WebSocket -> the other device, so
# this is seconds, not the ~24s a ring lives. The reason check below is what
# tells a real "answered elsewhere" apart from the other device's own timeout.
ELSEWHERE_WINDOW="${ELSEWHERE_WINDOW:-15}"

echo "== ring elsewhere: $APP_STATE / $ACTION on $RING_CALLEE_SERIAL, watching $RING_CALLEE2_SERIAL =="

logcat_alive "$RING_DIR/logcat.pid" || start_logcat
logcat_alive "$RING_DIR/callee2-logcat.pid" || start_callee2_logcat

# --- put both callee devices into the state under test ----------------------
# enter_state <check-prefix> — runs against the current ANDROID_SERIAL.
enter_state() {
  local p="$1"
  case "$APP_STATE" in
    foreground)
      launch_app
      pid_of_app >/dev/null || { fail "${p}state-$CASE" "app is not running"; return 1; }
      ;;
    background)
      launch_app; background_app
      pid_of_app >/dev/null || { fail "${p}state-$CASE" "app died when backgrounded"; return 1; }
      ;;
    terminated)
      # The push has to start the process — and, on the other device, the revived
      # process has to connect before it can hear that the call was answered.
      if kill_app; then
        pass "${p}state-$CASE" "app process killed before the ring"
      else
        fail "${p}state-$CASE" "could not kill the app; the cold start is not being tested"
        return 1
      fi
      ;;
  esac
}

on_callee2 enter_state "dev2-" || exit 1
enter_state "" || exit 1

MARK=$(logline "$ANDROID_LOG")
MARK2=$(logline "$CALLEE2_LOG")

# --- place the ring from the caller app -------------------------------------
if [ "$RING_CALLER_PLATFORM" = "android" ]; then
  if ring_from_caller_app "$RING_CALLEE"; then
    pass "ring-placed-$CASE" "caller app created a ringing call via Direct Call"
  else
    fail "ring-placed-$CASE" "the caller app could not create a ringing call"
    exit 1
  fi
else
  echo
  echo "  >>> RING NOW from the iOS simulator: Direct Call -> '$RING_CALLEE' -> Call"
  echo "  >>> (SKILL.md step 3b — dismiss the feedback modal first). Waiting up to 90s."
  echo
  if wait_probe incoming_notification_present 90; then
    pass "ring-placed-$CASE" "ring from the iOS caller reached the device"
  else
    fail "ring-placed-$CASE" "no ring arrived within 90s"
    shot "err-$CASE-no-ring"; exit 1
  fi
fi

# --- the ring reached BOTH devices -------------------------------------------
if wait_probe incoming_notification_present 45; then
  RING_START=$(date +%s)
  pass "ring-delivered-$CASE" "the incoming call was surfaced on the primary device"
else
  fail "ring-delivered-$CASE" "no incoming call notification within 45s of the ring"
  shot "err-$CASE-delivery"; exit 1
fi

CALL_ID=$(last_call_id)
[ -n "$CALL_ID" ] && echo "CALL_ID=$CALL_ID" >>"$RING_DIR/env.sh"

# Without the second device ringing there is nothing for this case to observe, so
# the call is ended rather than resolved and the case stops here.
if on_callee2 wait_probe incoming_notification_present 20; then
  pass "dev2-ring-delivered-$CASE" "the same ring was surfaced on the second device"
else
  fail "dev2-ring-delivered-$CASE" "the second device never rang — nothing to observe"
  on_callee2 shot "err-dev2-$CASE-delivery"
  cancel_ring "$CALL_ID" >/dev/null 2>&1 || true
  exit 1
fi

if [ "$APP_STATE" = "terminated" ]; then
  if pid_of_app >/dev/null; then
    pass "cold-start-$CASE" "the push started the app process from dead"
  else
    fail "cold-start-$CASE" "no app process after the push"
  fi
  if on_callee2 pid_of_app >/dev/null; then
    pass "dev2-cold-start-$CASE" "the push started the second device's app from dead"
  else
    fail "dev2-cold-start-$CASE" "no app process on the second device after the push"
  fi
fi

# Baselines on the second device, so that "cleared" below means something: a
# Telecom call or a foreground service that was never there cannot be released.
# Probes only — every second here comes out of the ring's ~24s lifetime.
if [ "$TELECOM_ON" = "1" ]; then
  on_callee2 assert_probe "dev2-telecom-live-$CASE" \
    "the second device holds a self-managed Telecom call while ringing" telecom_call_present 5
else
  skip "dev2-telecom-live-$CASE" "Telecom not enabled in the app config"
fi
if [ "$API2" -ge 37 ]; then
  on_callee2 assert_probe "dev2-ring-fgs-$CASE" \
    "the second device's ringing service is in the foreground" ringing_service_foreground 5
else
  skip "dev2-ring-fgs-$CASE" "API $API2 is below 37; the ringing service stays gated off"
fi

# --- resolve the ring on the primary ----------------------------------------
RMARK=$(logline "$ANDROID_LOG")
RMARK2=$(logline "$CALLEE2_LOG")
RESOLVED=0
case "$ACTION" in
  accept)
    if accept_ring; then
      RESOLVED=1; pass "accept-$CASE" "accepted from the primary device's ringing UI"
    else
      fail "accept-$CASE" "could not accept from the ringing UI"; shot "err-$CASE-accept"
    fi
    if [ "$TELECOM_ON" = "1" ]; then
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
      RESOLVED=1; pass "decline-$CASE" "declined from the primary device's ringing UI"
    else
      fail "decline-$CASE" "could not decline from the ringing UI"; shot "err-$CASE-decline"
    fi
    if [ "$TELECOM_ON" = "1" ]; then
      if wait_log "$ANDROID_LOG" "\[onIsCallDisconnected\].*cause=6" 20 "$RMARK"; then
        pass "telecom-reject-$CASE" "Telecom disconnected the call as REJECTED"
      else
        fail "telecom-reject-$CASE" "Telecom did not record a rejection"
      fi
    else
      skip "telecom-reject-$CASE" "Telecom not enabled in the app config"
    fi
    ;;
esac

# --- the other device stops ringing -----------------------------------------
if [ "$RESOLVED" != "1" ]; then
  # Without an answer on the primary, the second device ending its ring proves
  # nothing — it would only be its own timeout. The scenario is already FAIL.
  for c in dev2-ring-ended dev2-end-reason dev2-telecom-ended dev2-fgs-stopped dev2-not-joined; do
    skip "$c-$CASE" "the ring was not resolved on the primary device"
  done
else
  # The user-visible half: the incoming call notification goes away. A live
  # dumpsys probe, so a stale event from an earlier ring cannot satisfy it.
  on_callee2 assert_probe_clears "dev2-ring-ended-$CASE" \
    "the second device stopped ringing within ${ELSEWHERE_WINDOW}s of the $ACTION" \
    incoming_notification_present "$ELSEWHERE_WINDOW"
  on_callee2 shot "25-dev2-$CASE-after-$ACTION"

  if [ "$TELECOM_ON" = "1" ]; then
    on_callee2 assert_probe_clears "dev2-telecom-ended-$CASE" \
      "the second device released its Telecom call" telecom_call_present 15
  else
    skip "dev2-telecom-ended-$CASE" "Telecom not enabled in the app config"
  fi

  if [ "$API2" -ge 37 ]; then
    on_callee2 assert_probe_clears "dev2-fgs-stopped-$CASE" \
      "the second device's ringing foreground service stopped" ringing_service_foreground 15
  else
    skip "dev2-fgs-stopped-$CASE" "API $API2 is below 37"
  fi

  # Why it stopped. The other device has to have learned that this user answered
  # — through the coordinator event or the Call's own handling of it — and must
  # not have timed out on its own. The ring dying by itself also clears the
  # notification, so ring-ended alone cannot tell the two apart.
  #
  # Dart lines: debugPrint throttling makes them lag, so the positive match gets a
  # generous wait, and the negative one is judged only once the ring is past the
  # point where a timeout of its own would have been logged.
  #
  # ORDER decides, not presence: once the Call rejects with user-responded-elsewhere
  # and leaves, its pending incoming-call timer still settles and logs
  # `[reject] reason: timeout` ~200ms later. Only a timeout logged BEFORE the
  # elsewhere signal means the device gave up on its own.
  REASON="on (another|other) device|user-responded-elsewhere|Call (accepted|rejected) event: .*by: $RING_CALLEE"
  wait_log "$CALLEE2_LOG" "$REASON" 30 "$RMARK2"
  while [ $(( $(date +%s) - RING_START )) -lt $(( RING_TTL + 10 )) ]; do sleep 1; done
  HEARD_AT=$(tail -n "+$RMARK2" "$CALLEE2_LOG" 2>/dev/null | grep -nE "$REASON" | head -1 | cut -d: -f1)
  TIMEOUT_AT=$(tail -n "+$RMARK2" "$CALLEE2_LOG" 2>/dev/null \
    | grep -nE "\[reject\] reason: timeout" | head -1 | cut -d: -f1)
  if [ -z "$HEARD_AT" ]; then
    fail "dev2-end-reason-$CASE" "the second device never learned of the $ACTION on the primary"
  elif [ -n "$TIMEOUT_AT" ] && [ "$TIMEOUT_AT" -lt "$HEARD_AT" ]; then
    fail "dev2-end-reason-$CASE" "the second device timed out on its own before hearing of the $ACTION"
  else
    pass "dev2-end-reason-$CASE" "the second device ended its ring because the user answered elsewhere"
  fi

  # Answered elsewhere must not mean joined here. Absence in a lagging log can
  # only under-report, so this cannot fail a correct run — it catches the other
  # device picking the call up as well.
  if tail -n "+$RMARK2" "$CALLEE2_LOG" 2>/dev/null \
     | grep -qE "lifecycleCallJoining|lifecycleCallJoined|sfuJoinResponse"; then
    fail "dev2-not-joined-$CASE" "the second device joined the call too"
  else
    pass "dev2-not-joined-$CASE" "the second device did not join the call"
  fi
fi

# --- leave a known state for the next case ----------------------------------
if [ "$ACTION" = "accept" ]; then
  cancel_ring "$CALL_ID" >/dev/null 2>&1 || true
  sleep 3
fi

shot "30-$CASE-resolved"
on_callee2 shot "30-dev2-$CASE-resolved"
echo "OK ring/$CASE"
