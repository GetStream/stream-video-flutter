#!/usr/bin/env bash
# Cleanup — stop everything the run owns and put the emulator back the way it
# was found. Safe to run at any time, including when nothing is running.
#
# The phases in between launch and finish do not clean up after themselves on
# purpose: a failed phase is usually retried, and killing the apps would cost
# another full build. This is the escape hatch for when a run is abandoned
# instead of retried.
cd "$(dirname "$0")" && . ./lib.sh
[ -f "$SMOKE_DIR/env.sh" ] && . "$SMOKE_DIR/env.sh"

echo "== stop =="
stop_all_bg

# android_checks.sh restores the network through a trap, but a SIGKILL (or a
# terminal closed on the run) leaves no chance for the trap to fire. Re-enabling
# an already-enabled radio is a no-op, so this is unconditional.
if adb devices 2>/dev/null | grep -q "device$"; then
  adb shell svc wifi enable >/dev/null 2>&1
  adb shell svc data enable >/dev/null 2>&1
  echo "  emulator network enabled"
fi

echo "  logs and screenshots kept in $SMOKE_DIR"
echo "OK stop"
