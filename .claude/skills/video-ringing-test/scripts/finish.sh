#!/usr/bin/env bash
# Phase 3 — leak checks, summary table, teardown.
cd "$(dirname "$0")" && . ./lib.sh
. "$RING_DIR/env.sh" 2>/dev/null || true
derive_pkg || exit 1

API="${ANDROID_API:-$(adb shell getprop ro.build.version.sdk | tr -d '\r')}"
echo "== finish =="

# --- leaks -------------------------------------------------------------------
# Judged only now, when every ring is over. Polls rather than sampling once: a
# service still unwinding a moment after the last teardown is normal, and a
# single sample would report it as a leak.
assert_probe_clears "no-ring-service-leak" "no ringing foreground service left running" \
  ringing_service_foreground 25

assert_probe_clears "no-notif-leak" "no incoming call notification left posted" \
  incoming_notification_present 25

if grep -qE "\[init\] telecom enabled=true" "$ANDROID_LOG"; then
  assert_probe_clears "no-telecom-leak" "no call left registered in the Telecom stack" \
    telecom_call_present 25
else
  skip "no-telecom-leak" "Telecom not enabled in the app config"
fi

# --- crashes ----------------------------------------------------------------
# One targeted check, not a general log trawl. This is the regression that the
# initData return type caused, and it is invisible unless something looks for it.
if grep -qE "is not a subtype of type" "$ANDROID_LOG"; then
  fail "no-channel-type-error" "a platform channel type cast failed (see android.log)"
else
  pass "no-channel-type-error" "no platform channel type errors"
fi

if grep -qE "FATAL EXCEPTION|E AndroidRuntime" "$ANDROID_LOG"; then
  fail "no-native-crash" "a native crash was logged (see android.log)"
else
  pass "no-native-crash" "no native crashes"
fi

# --- the callee's second device (multi-device run) --------------------------
# Same leak and crash checks, against the device that only ever watched its ring
# being answered elsewhere. A ring it never released is exactly what this run is
# looking for, so it is judged here as well as per case.
if [ "${RING_MULTI_DEVICE:-0}" = "1" ] && [ -n "${RING_CALLEE2_SERIAL:-}" ]; then
  on_callee2 assert_probe_clears "dev2-no-ring-service-leak" \
    "no ringing foreground service left running on the second device" ringing_service_foreground 25
  on_callee2 assert_probe_clears "dev2-no-notif-leak" \
    "no incoming call notification left posted on the second device" incoming_notification_present 25
  if [ "${TELECOM_ENABLED:-0}" = "1" ]; then
    on_callee2 assert_probe_clears "dev2-no-telecom-leak" \
      "no call left registered in the second device's Telecom stack" telecom_call_present 25
  else
    skip "dev2-no-telecom-leak" "Telecom not enabled in the app config"
  fi
  if grep -qE "is not a subtype of type" "$CALLEE2_LOG"; then
    fail "dev2-no-channel-type-error" "a platform channel type cast failed (see callee2.log)"
  else
    pass "dev2-no-channel-type-error" "no platform channel type errors on the second device"
  fi
  if grep -qE "FATAL EXCEPTION|E AndroidRuntime" "$CALLEE2_LOG"; then
    fail "dev2-no-native-crash" "a native crash was logged (see callee2.log)"
  else
    pass "dev2-no-native-crash" "no native crashes on the second device"
  fi
  stop_callee2_logcat
fi

stop_logcat

# --- summary ----------------------------------------------------------------
echo
DASH="--------------------------------------------------"
# Deduplicated on check id, keeping the LAST result. results.tsv is append-only and
# only truncated by preflight.sh, so a case that failed and was then retried leaves
# both lines behind — reporting every one of them counts historical attempts as
# current failures and makes a clean run look broken.
DEDUPED="$RING_DIR/results-final.tsv"
awk -F'\t' '{ last[$2] = $0; order[$2] = (order[$2] ? order[$2] : ++n) }
  END { for (id in last) printf "%d\t%s\n", order[id], last[id] }' "$RESULTS" \
  | sort -n | cut -f2- >"$DEDUPED"

# Elsewhere ids carry a longer suffix and a dev2- prefix, so the column grows.
W=34
[ "${RING_MULTI_DEVICE:-0}" = "1" ] && W=50
printf "%-${W}s %-11s %s\n" "CHECK" "RESULT" "WHAT IT PROVES"
printf "%-${W}s %-11s %s\n" "$(printf "%.${W}s" "$DASH")" "$(printf '%.11s' "$DASH")" \
  "$(printf '%.44s' "$DASH")"
while IFS=$'\t' read -r result id desc; do
  [ -n "${id:-}" ] || continue
  printf "%-${W}s %-11s %s\n" "$id" "$result" "$desc"
done <"$DEDUPED"

P=$(grep -c '^PASS' "$DEDUPED" || true)
F=$(grep -c '^FAIL' "$DEDUPED" || true)
S=$(grep -c '^SKIP' "$DEDUPED" || true)
K=$(grep -c '^KNOWN-FAIL' "$DEDUPED" || true)
# ---- scenario matrix -------------------------------------------------------
# The per-check table above is the evidence; this is the answer. A scenario counts
# as PASS only when every check carrying its suffix passed — one FAIL anywhere in
# it makes the scenario FAIL, which is the only reading that is safe to act on.
scenario_cell() {
  local suffix="$1" total fails
  total=$(awk -F'\t' -v s="-$suffix" '$2 ~ (s "$")' "$DEDUPED" | wc -l | tr -d ' ')
  [ "$total" = "0" ] && { printf '%-14s' "-"; return; }
  fails=$(awk -F'\t' -v s="-$suffix" '$2 ~ (s "$") && ($1 == "FAIL")' "$DEDUPED" | wc -l | tr -d ' ')
  if [ "$fails" = "0" ]; then
    printf '%-14s' "PASS $total/$total"
  else
    printf '%-14s' "FAIL $((total - fails))/$total"
  fi
}

# matrix <case-suffix> <action...> — one row per app state, one column per action.
matrix() {
  local tail="$1" state action; shift
  echo
  printf '%-14s' ""
  for action in "$@"; do printf ' %-14s' "$action"; done; printf '\n'
  printf '%.14s' "$DASH"
  for action in "$@"; do printf ' %.14s' "$DASH"; done; printf '\n'
  for state in foreground background terminated; do
    printf '%-14s ' "$state"
    for action in "$@"; do
      scenario_cell "$state-$action$tail"; printf ' '
    done
    printf '\n'
  done
}

# A multi-device run only has elsewhere cases, and a regular run has none, so one
# matrix per run. The core suffix `-<state>-<action>` never matches an elsewhere
# id, which always ends in `-elsewhere`.
if [ "${RING_MULTI_DEVICE:-0}" = "1" ]; then
  echo
  echo "answered on the primary — did the second device stop ringing?"
  matrix "-elsewhere" accept decline
else
  matrix "" accept decline timeout
fi

echo
echo "$P passed, $F failed, $S skipped, $K known-fail"
echo "logs: $ANDROID_LOG   shots: $SHOTS"
[ "${RING_MULTI_DEVICE:-0}" = "1" ] && echo "second device log: $CALLEE2_LOG"

if [ "$API" -lt 37 ]; then
  echo
  echo "note: API $API — the Android 17 ringing foreground service was not exercised."
  echo "      Re-run on an API 37 emulator to cover ring-fgs-*."
fi

[ "$F" = "0" ]
