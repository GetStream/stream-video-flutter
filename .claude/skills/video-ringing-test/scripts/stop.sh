#!/usr/bin/env bash
# Teardown for an abandoned run. Logs and screenshots are kept.
cd "$(dirname "$0")" && . ./lib.sh
. "$RING_DIR/env.sh" 2>/dev/null || true
derive_pkg || exit 1

stop_logcat

# End anything still ringing, so the next run does not start with a live call
# from this one. Best effort: the call ids come from env.sh.
if [ -f "$RING_DIR/env.sh" ]; then
  grep '^CALL_ID=' "$RING_DIR/env.sh" 2>/dev/null | sed 's/^CALL_ID=//' | while read -r cid; do
    [ -n "$cid" ] && cancel_ring "$cid" >/dev/null 2>&1 || true
  done
fi

adb shell am force-stop "$ANDROID_PKG" >/dev/null 2>&1 || true
adb shell cmd statusbar collapse >/dev/null 2>&1 || true
adb shell svc power stayon false >/dev/null 2>&1 || true
adb shell dumpsys deviceidle enable >/dev/null 2>&1 || true
adb shell input keyevent KEYCODE_WAKEUP >/dev/null 2>&1 || true

echo "stopped. logs kept in $RING_DIR"
