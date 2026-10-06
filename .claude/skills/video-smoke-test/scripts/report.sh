#!/usr/bin/env bash
# Phase 10 — summary and teardown. The last thing a run does.
#
# Split out of finish.sh so there is exactly ONE place that prints the report,
# even though the run now has two calls to get through (the plain one, then the
# encrypted one). Every phase appends to the same results file, so this reads
# the whole run regardless of which phases ran.
cd "$(dirname "$0")" && . ./lib.sh
. "$SMOKE_DIR/env.sh" 2>/dev/null || true

# --- the one assertion that has to live here -------------------------------
# iOS leaves the encrypted call AFTER e2ee_verify.sh has run — that script needs
# the peer still in the call to assert the decryptors — so this is the first
# script that can judge it. Scoped to the encrypted round, or the plain call's
# leave would satisfy it.
assert_log_since "e2ee-leave-ios" "iOS left the encrypted call cleanly" \
  "$IOS_LOG" "\[leave\] reason|\[clear\] src: disconnect" "${IOS_E2EE_MARK:-1}"

# --- stop background processes --------------------------------------------
# stop_all_bg, not `kill $(cat *.pid)`: the pid files outlive the run, so after
# a reboot or a long gap those numbers belong to whatever the OS handed them to
# next. Each pid is re-checked against the command it was started with, and the
# flutter run children (gradle, xcodebuild, dart) are stopped too instead of
# being orphaned.
stop_all_bg

echo
echo "=============== SMOKE TEST SUMMARY ==============="
# `grep -c` prints 0 AND exits 1 when there is no match, so a `|| echo 0`
# fallback here printed the count twice. It already prints a number.
count() { local n; n=$(grep -c "^$1" "$RESULTS" 2>/dev/null); printf '%s' "${n:-0}"; }
printf 'passed:      %s\n' "$(count PASS)"
printf 'failed:      %s\n' "$(count FAIL)"
printf 'known-fail:  %s\n' "$(count KNOWN-FAIL)"
printf 'skipped:     %s\n' "$(count SKIP)"
echo

# The report table. Generated here rather than assembled by hand afterwards, so
# what the user reads is exactly what the checks recorded, in the order they
# ran. Relay it verbatim; see the Reporting section in SKILL.md.
echo "| check | what it verifies | result |"
echo "|---|---|---|"
while IFS=$'\t' read -r res id desc; do
  case "$res" in
    PASS)       mark="works" ;;
    FAIL)       mark="**FAILED**" ;;
    KNOWN-FAIL) mark="not verified" ;;
    SKIP)       mark="not run" ;;
    *)          mark="$res" ;;
  esac
  printf '| `%s` | %s | %s |\n' "$id" "$desc" "$mark"
done <"$RESULTS"
echo
echo "screenshots: $SHOTS"
echo "logs:        $ANDROID_LOG  $IOS_LOG"
echo "=================================================="
grep -q '^FAIL' "$RESULTS" 2>/dev/null && exit 1 || exit 0
