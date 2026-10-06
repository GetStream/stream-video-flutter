#!/usr/bin/env bash
# Screenshots each step of the caller's Direct Call flow so the four derived
# coordinates in lib.sh can be corrected against a real device.
#
# Needed because Flutter does not publish a semantics tree to uiautomator unless
# an accessibility service is running, so the home screen and the Direct Call
# dialog cannot be addressed by resource id the way the native ringing UI can —
# they have to be tapped by coordinate, and a coordinate has to be verified.
#
# Run this once per AVD model. It places no call: the final Call button is not
# tapped.
cd "$(dirname "$0")" && . ./lib.sh
. "$RING_DIR/env.sh" 2>/dev/null || true
derive_pkg || exit 1
android_geometry || exit 1

[ "$RING_CALLER_PLATFORM" = "android" ] || {
  echo "calibrate.sh only applies to RING_CALLER_PLATFORM=android." >&2
  echo "For the iOS caller, screenshot the simulator and correct the table in SKILL.md." >&2
  exit 2
}
[ -n "${RING_CALLER_SERIAL:-}" ] || { echo "FATAL: run preflight.sh first" >&2; exit 1; }

echo "== calibrate: caller Direct Call flow =="
echo "  device: $RING_CALLER_SERIAL   reference scale: $SX/$SY"

adbc shell am start -n "$(resolve_main_activity)" >/dev/null 2>&1; sleep 4
adbc shell input keyevent KEYCODE_ESCAPE >/dev/null 2>&1; sleep 1
shotc "cal-1-home"
echo "  cal-1-home.png       — locate the 'Direct Call' button -> A_DIRECT_X/Y"

tapc $A_DIRECT_X $A_DIRECT_Y; sleep 2
shotc "cal-2-dialog"
echo "  cal-2-dialog.png     — did the dialog open? locate the 'User ID' field -> A_DLG_FIELD_X/Y"

tapc $A_DLG_FIELD_X $A_DLG_FIELD_Y; sleep 1
adbc shell input text "calibration_probe"; sleep 1
adbc shell input keyevent KEYCODE_BACK >/dev/null 2>&1; sleep 1
shotc "cal-3-filled"
echo "  cal-3-filled.png     — is the id in the field? locate the 'Call' button -> A_DLG_CALL_X/Y"

adbc shell input keyevent KEYCODE_ESCAPE >/dev/null 2>&1

cat <<EOF

Coordinates are in the 1080x2424 reference space, so divide a measured pixel by
the scale above before writing it into lib.sh:

  reference_x = measured_x / $SX
  reference_y = measured_y / $SY

Current values:
  A_DIRECT_X=$A_DIRECT_X      A_DIRECT_Y=$A_DIRECT_Y
  A_DLG_FIELD_X=$A_DLG_FIELD_X  A_DLG_FIELD_Y=$A_DLG_FIELD_Y
  A_DLG_CALL_X=$A_DLG_CALL_X   A_DLG_CALL_Y=$A_DLG_CALL_Y

Shots: $SHOTS
EOF
