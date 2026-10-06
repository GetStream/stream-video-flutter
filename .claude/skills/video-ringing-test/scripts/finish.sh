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

printf '%-34s %-11s %s\n' "CHECK" "RESULT" "WHAT IT PROVES"
printf '%-34s %-11s %s\n' "$(printf '%.34s' "$DASH")" "$(printf '%.11s' "$DASH")" \
  "$(printf '%.44s' "$DASH")"
while IFS=$'\t' read -r result id desc; do
  [ -n "${id:-}" ] || continue
  printf '%-34s %-11s %s\n' "$id" "$result" "$desc"
done <"$DEDUPED"

P=$(grep -c '^PASS' "$DEDUPED" || true)
F=$(grep -c '^FAIL' "$DEDUPED" || true)
S=$(grep -c '^SKIP' "$DEDUPED" || true)
K=$(grep -c '^KNOWN-FAIL' "$DEDUPED" || true)
# ---- scenario matrix -------------------------------------------------------
# The per-check table above is the evidence; this is the answer. A scenario counts
# as PASS only when every check carrying its suffix passed — one FAIL anywhere in
# it makes the scenario FAIL, which is the only reading that is safe to act on.
echo
printf '%-14s %-14s %-14s %-14s\n' "" "accept" "decline" "timeout"
printf '%-14s %-14s %-14s %-14s\n' "$(printf '%.14s' "$DASH")" \
  "$(printf '%.14s' "$DASH")" "$(printf '%.14s' "$DASH")" "$(printf '%.14s' "$DASH")"

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

for state in foreground background terminated; do
  printf '%-14s ' "$state"
  for action in accept decline timeout; do
    scenario_cell "$state-$action"
  done
  printf '\n'
done

echo
echo "$P passed, $F failed, $S skipped, $K known-fail"
echo "logs: $ANDROID_LOG   shots: $SHOTS"

if [ "$API" -lt 37 ]; then
  echo
  echo "note: API $API — the Android 17 ringing foreground service was not exercised."
  echo "      Re-run on an API 37 emulator to cover ring-fgs-*."
fi

[ "$F" = "0" ]
