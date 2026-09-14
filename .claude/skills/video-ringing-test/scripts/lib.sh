#!/usr/bin/env bash
# Shared helpers for the ringing smoke test.
# Sourced by every phase script. Never run directly.
#
# Reuses the video-smoke-test library for results, log assertions and input,
# then overrides what differs. Two deliberate differences from that skill:
#
#  * The app runs standalone (adb install + am start), not under `flutter run`.
#    `flutter run` owns the process, so killing the app to test a cold start
#    makes the tool detach and take the run with it.
#  * Taps resolve through uiautomator resource ids, not fixed coordinates. The
#    ringing UI is a full-screen activity and a notification, both of which move
#    with screen size and system font scale in ways the in-call control bar does
#    not.

set -u

RING_DIR="${RING_DIR:-/tmp/stream-video-ringing}"
SMOKE_DIR="$RING_DIR"   # redirect the reused library's output away from the smoke run

_SKILL_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
. "$_SKILL_ROOT/../../video-smoke-test/scripts/lib.sh"

ANDROID_LOG="$RING_DIR/android.log"
RESULTS="$RING_DIR/results.tsv"
SHOTS="$RING_DIR/shots"
mkdir -p "$SHOTS"

# ---------------------------------------------------------------- build mode
# Debug is the default because the release build needs `android/key.properties`,
# which is not in the repo. Debug does not weaken any check here: every
# assertion below reads either native logcat or a dumpsys probe, and neither is
# affected by the Dart build mode. Release additionally proves R8 kept the
# plugin (`consumer-rules.pro`) and that the timings hold without JIT warmup, so
# run it that way when a keystore is available.
RING_BUILD_MODE="${RING_BUILD_MODE:-debug}"
RING_FLAVOR="${RING_FLAVOR:-dev}"

# derive_pkg — sets ANDROID_PKG from the current RING_BUILD_MODE.
#
# Phase scripts must call this again after sourcing env.sh: lib.sh runs first and
# has already defaulted to debug by then, so a release run would otherwise drive
# the debug package and every probe would silently look at the wrong app.
derive_pkg() {
  case "$RING_BUILD_MODE" in
    debug)   ANDROID_PKG="io.getstream.video.flutter.dogfooding.debug" ;;
    release) ANDROID_PKG="io.getstream.video.flutter.dogfooding" ;;
    *) echo "FATAL: RING_BUILD_MODE must be debug or release" >&2; return 1 ;;
  esac
}
derive_pkg || return 1

# The activity class resolves against the manifest namespace, which does NOT carry
# the debug build's `.debug` applicationIdSuffix — so the component is
# `<pkg>.debug/<namespace>.MainActivity`, an easy thing to get subtly wrong. Ask
# the platform instead of hardcoding it, and keep the literal only as a fallback.
resolve_main_activity() {
  local resolved
  resolved=$(adb shell cmd package resolve-activity --brief "$ANDROID_PKG" 2>/dev/null \
    | tr -d '\r' | grep -E "^$ANDROID_PKG/" | head -1)
  if [ -n "$resolved" ]; then
    echo "$resolved"
  else
    echo "$ANDROID_PKG/io.getstream.video.flutter.dogfooding.MainActivity"
  fi
}

# Users. The callee lives on the emulator; the caller only ever exists as a
# token used to place the ring over REST. Both need a digit or underscore — the
# emulator IME autocorrects plain words, which the smoke test found the hard way.
RING_CALLEE="${RING_CALLEE:-ring_callee1}"
RING_CALLER="${RING_CALLER:-ring_caller1}"
# Where the caller app runs.
#   android — a second emulator, fully scripted (default)
#   ios     — the iOS simulator; the ring is placed by the agent through the
#             simulator tool while checks.sh waits for it, because there is no
#             CLI that injects taps into a simulator.
RING_CALLER_PLATFORM="${RING_CALLER_PLATFORM:-android}"

RING_ENV="${RING_ENV:-pronto}"
RING_TOKEN_HOST="${RING_TOKEN_HOST:-pronto.getstream.io}"
RING_COORDINATOR="${RING_COORDINATOR:-https://video.stream-io-api.com}"

# ---------------------------------------------------------------- logcat
# Native tags carry the assertions that matter. Dart lines arrive through
# `debugPrint`, which throttles to roughly 1KB/s: under `Priority.debug` they
# lag seconds behind reality, so anything timing-sensitive must assert on a
# native tag or a dumpsys probe instead.
RING_LOG_TAGS="StreamTelecomManager:V StreamTelecomRepo:V IncomingCallService:V \
IncomingCallReceiver:V IncomingCallNotification:V flutter:V"

start_logcat() {
  stop_logcat
  adb logcat -c >/dev/null 2>&1 || true
  # shellcheck disable=SC2086
  adb logcat -v time $RING_LOG_TAGS "*:S" >"$ANDROID_LOG" 2>&1 &
  echo $! >"$RING_DIR/logcat.pid"
  sleep 1
}

stop_logcat() {
  if [ -f "$RING_DIR/logcat.pid" ]; then
    kill "$(cat "$RING_DIR/logcat.pid")" 2>/dev/null || true
    rm -f "$RING_DIR/logcat.pid"
  fi
  pkill -f "adb logcat -v time StreamTelecomManager" 2>/dev/null || true
}

# ---------------------------------------------------------------- app state
# `am kill`, never `force-stop`. force-stop puts the package into the stopped
# state, after which whether FCM still reaches it is version dependent — the run
# would then be measuring the harness. `am kill` drops the process and leaves the
# package runnable, which is what a user swiping the app away actually does.
kill_app() {
  # HOME first, then poll. `am kill` is refused while the process is foreground or
  # still perceptible, which it is for a while after a call ends — two fixed
  # attempts reported "could not kill the app" for a process that died moments
  # later, so this retries until it is actually gone.
  adb shell input keyevent KEYCODE_HOME >/dev/null 2>&1
  sleep 2
  local i
  for i in $(seq 1 12); do
    pid_of_app >/dev/null || return 0
    adb shell am kill "$ANDROID_PKG" >/dev/null 2>&1
    sleep 2
  done
  ! pid_of_app >/dev/null
}

pid_of_app() {
  local p
  p=$(adb shell pidof "$ANDROID_PKG" 2>/dev/null | tr -d '\r')
  [ -n "$p" ] && echo "$p"
}

background_app() {
  adb shell input keyevent KEYCODE_HOME >/dev/null 2>&1
  sleep 2
}

# Waits for the activity's FIRST FRAME, not a fixed interval. The debug Flutter
# build needs 10-25s to draw on a loaded host, and a fixed sleep taps into a
# window that does not exist yet: the field never takes focus, `input text` goes
# nowhere, and the KEYCODE_BACK meant to hide the keyboard backgrounds the app
# instead — after which every later tap lands on the launcher and the login
# check fails for a reason that has nothing to do with the SDK.
# ActivityTaskManager is not in RING_LOG_TAGS, so this reads the device buffer
# directly rather than $ANDROID_LOG.
launch_app() {
  local i
  adb shell am start -n "$(resolve_main_activity)" >/dev/null 2>&1
  for i in $(seq 1 60); do
    if adb logcat -d 2>/dev/null | grep -q "Displayed .*$ANDROID_PKG/"; then
      sleep 2; return 0
    fi
    sleep 1
  done
  sleep 3
}

# ---------------------------------------------------------------- ui by id
# dump_ui — writes the current hierarchy to $RING_DIR/ui.xml
# uiautomator occasionally returns an empty dump while a window is animating in,
# so this retries rather than reporting "control not found" for a timing problem.
dump_ui() {
  local i
  for i in 1 2 3 4 5; do
    if adb shell uiautomator dump /sdcard/ring-ui.xml >/dev/null 2>&1 \
       && adb shell cat /sdcard/ring-ui.xml 2>/dev/null | tr -d '\r' >"$RING_DIR/ui.xml" \
       && [ -s "$RING_DIR/ui.xml" ]; then
      return 0
    fi
    sleep 1
  done
  return 1
}

# ui_has_res <full-resource-id> — e.g. ui_has_res com.android.systemui:id/btn_clear_all
ui_has_res() {
  dump_ui || return 1
  grep -q "resource-id=\"$1\"" "$RING_DIR/ui.xml"
}

# tap_res <full-resource-id> — taps the centre of the first matching node.
tap_res() {
  local id="$1" node bounds x1 y1 x2 y2 cx cy
  dump_ui || return 1
  node=$(tr '>' '\n' <"$RING_DIR/ui.xml" | grep "resource-id=\"$id\"" | head -1)
  [ -n "$node" ] || return 1
  bounds=$(printf '%s' "$node" | grep -oE 'bounds="\[[0-9]+,[0-9]+\]\[[0-9]+,[0-9]+\]"' | head -1)
  [ -n "$bounds" ] || return 1
  bounds=$(printf '%s' "$bounds" | grep -oE '[0-9]+' | tr '\n' ' ')
  read -r x1 y1 x2 y2 <<<"$bounds"
  cx=$(( (x1 + x2) / 2 )); cy=$(( (y1 + y2) / 2 ))
  adb shell input tap "$cx" "$cy" >/dev/null 2>&1
}

# ui_has <resource-id-suffix>  — app-scoped, e.g. ui_has ivAcceptCall
ui_has() { ui_has_res "$ANDROID_PKG:id/$1"; }

# Dismisses every dismissible notification.
#
# Run before a ring whose outcome is judged by a notification appearing: a
# missed-call notification from an earlier state would otherwise satisfy the
# assertion without this ring producing one. The ringing service's own notification
# is flagged NO_CLEAR and survives, which is fine — there is no ring in flight yet.
clear_notifications() {
  expand_shade
  if ui_has_res "com.android.systemui:id/btn_clear_all"; then
    tap_res "com.android.systemui:id/btn_clear_all"
    sleep 1
  fi
  collapse_shade
}

# tap_id <resource-id-suffix>
# Resolves the node's bounds from the hierarchy and taps its centre. Preferred
# over a coordinate for every ringing control: the full-screen activity and the
# notification both reflow with screen size and font scale.
tap_id() { tap_res "$ANDROID_PKG:id/$1"; }

# tap_text <label-regex>
# Standard notification action buttons carry no app resource id, only a label, so
# accept and decline in the shade can only be addressed this way.
#
# Matched as a SUBSTRING, never as the whole attribute: the platform wraps action
# labels in Unicode bidi isolates and prefixes an icon glyph, so the decline button
# is actually `text="<LRI><icon> <FSI>Decline<PDI><PDI>"`. An exact match finds
# nothing and reports the button as absent.
tap_text() {
  local want="$1" node bounds x1 y1 x2 y2 cx cy
  # One dump, not four. expand_shade already waits 2s for the shade to settle, and a
  # dump costs 2s on an idle device and ~11s on a loaded one — so re-dumping to "wait
  # out the animation" spent 6-33s waiting for something that finished in ~300ms, out
  # of a ring that only lives ~25s. Transient absence is handled by _ring_action's
  # own retry, which is deadline-bounded.
  dump_ui || return 1
  # Restricted to Button nodes. The label alone is not enough: the notification's
  # app-name line reads "Stream Video Calls (Flutter)", so a bare match on "Video"
  # hit that TextView and tapped the notification body, which merely launched the
  # app while the ring went on to time out.
  node=$(tr '>' '\n' <"$RING_DIR/ui.xml" \
    | grep -E 'class="[^"]*Button[^"]*"' \
    | grep -E "text=\"[^\"]*($want)[^\"]*\"" | head -1)
  [ -n "$node" ] || { info "no node with text '$want' on screen"; return 1; }
  bounds=$(printf '%s' "$node" | grep -oE 'bounds="\[[0-9]+,[0-9]+\]\[[0-9]+,[0-9]+\]"' | head -1)
  [ -n "$bounds" ] || return 1
  bounds=$(printf '%s' "$bounds" | grep -oE '[0-9]+' | tr '\n' ' ')
  read -r x1 y1 x2 y2 <<<"$bounds"
  cx=$(( (x1 + x2) / 2 )); cy=$(( (y1 + y2) / 2 ))
  adb shell input tap "$cx" "$cy" >/dev/null 2>&1
}

# tap_id_until <resource-id-suffix> <regex> [attempts] [timeout]
# Same contract as the smoke test's tap_until, addressed by id.
tap_id_until() {
  local id="$1" pat="$2" tries="${3:-3}" t="${4:-15}" i M
  for i in $(seq 1 "$tries"); do
    M=$(logline "$ANDROID_LOG")
    if tap_id "$id" && wait_log "$ANDROID_LOG" "$pat" "$t" "$M"; then return 0; fi
    info "retry $i/$tries: tap on '$id' produced no '$pat'"
    sleep 1
  done
  return 1
}

expand_shade() {
  adb shell cmd statusbar expand-notifications >/dev/null 2>&1
  sleep 2
}
collapse_shade() {
  adb shell cmd statusbar collapse >/dev/null 2>&1
  sleep 1
}

# ---------------------------------------------------------------- ring
# The ring is placed by a real second instance of the app through its "Direct
# Call" button, not over REST. That keeps the test on the path an integrator
# actually uses — call creation, ring targeting and the caller's own call state
# all go through the SDK rather than being simulated by an HTTP request.
#
# Coordinates are unavoidable here. Flutter does not publish a semantics tree to
# uiautomator unless an accessibility service is running, so the home screen and
# the Direct Call dialog cannot be addressed by resource id the way the native
# ringing UI can.

# adbc — adb against the caller device.
adbc() { adb -s "$RING_CALLER_SERIAL" "$@"; }

# caller_geometry — reads the CALLER's own screen size.
#
# The caller must never be scaled by the callee's factors: the two emulators can
# have entirely different shapes (a 1080x2424 phone next to a 2076x2152
# foldable), and the app does not merely scale between them — dogfooding
# constrains its content to kMaxWidthRegularScreen, so on a wide screen the
# column is centred rather than stretched. Caller coordinates are therefore
# ABSOLUTE DEVICE PIXELS, discovered by calibrate.sh, not reference-space values.
caller_geometry() {
  local size
  size=$(adbc shell wm size 2>/dev/null | tr -d '\r' | awk -F': ' '{print $2}')
  CW=${size%x*}; CH=${size#*x}
  if [ -z "$CW" ] || [ -z "$CH" ]; then
    echo "FATAL: cannot read the caller's screen size" >&2; return 1
  fi
  info "caller geometry ${CW}x${CH}"
}

# Taps a text field until the IME actually comes up.
#
# Needed because the app's FIRST FRAME is its splash screen, not the form: the
# activity reports "Displayed" while "Stream Meetings" is still on screen, and a
# tap aimed at the username field lands on the splash. Waiting a fixed interval
# only moves the race — on a fresh install the splash lingers far longer than on
# a warm start. Flutter publishes no semantics tree, so the field cannot be found
# by id; the IME coming up is the one observable proof the tap reached a field.
tap_until_ime() {
  local i
  for i in $(seq 1 20); do
    tap "$1" "$2"; sleep 3
    adb shell dumpsys input_method 2>/dev/null | grep -q "mInputShown=true" && return 0
  done
  return 1
}

tapc_until_ime() {
  local i
  for i in $(seq 1 20); do
    tapc "$1" "$2"; sleep 3
    adbc shell dumpsys input_method 2>/dev/null | grep -q "mInputShown=true" && return 0
  done
  return 1
}

# Hides the soft keyboard, but only once it is actually showing.
#
# A blind KEYCODE_BACK after `input text` is the trap: if the IME has not come up
# yet — which happens whenever the app is slow to focus the field — BACK is
# delivered to the activity instead and BACKGROUNDS THE APP. Every later tap then
# lands on the launcher, and the login fails with "produced no connectUser" for a
# reason that has nothing to do with the SDK.
hide_keyboard() {
  local i
  for i in $(seq 1 20); do
    adb shell dumpsys input_method 2>/dev/null | grep -q "mInputShown=true" && break
    sleep 1
  done
  adb shell input keyevent KEYCODE_BACK >/dev/null 2>&1
}

hide_keyboard_caller() {
  local i
  for i in $(seq 1 20); do
    adbc shell dumpsys input_method 2>/dev/null | grep -q "mInputShown=true" && break
    sleep 1
  done
  adbc shell input keyevent KEYCODE_BACK >/dev/null 2>&1
}

# Absolute-pixel taps on the caller.
tapc() { adbc shell input tap "$1" "$2"; }

shotc() { adbc exec-out screencap -p >"$SHOTS/$1.png" 2>/dev/null; }

# Caller-side coordinates, in the same 1080x2424 reference space the smoke test
# verified. A_USER_*/A_SIGNUP_* come from there and are verified; the four below
# are DERIVED from the widget tree in dogfooding/lib/screens/home_screen.dart
# (Direct Call sits 8dp under Start New Call, both ~48dp tall) and have not been
# confirmed on a device. calibrate.sh screenshots each step so they can be
# corrected in one place. A wrong value fails loudly — ring_from_caller_app
# asserts getOrCreateCall in the caller's log rather than assuming the taps
# landed.
# Caller coordinates, ABSOLUTE DEVICE PIXELS on the caller emulator. There are no
# defaults worth shipping: they depend on the caller's screen, so calibrate.sh
# writes them here and lib.sh loads them. A run without this file stops with an
# actionable message rather than tapping blind.
CALLER_COORDS="$RING_DIR/caller-coords.sh"
# shellcheck source=/dev/null
[ -f "$CALLER_COORDS" ] && . "$CALLER_COORDS"

caller_calibrated() {
  [ -n "${C_USER_X:-}" ] && [ -n "${C_SIGNUP_X:-}" ] \
    && [ -n "${C_DIRECT_X:-}" ] && [ -n "${C_DLG_FIELD_X:-}" ] && [ -n "${C_DLG_CALL_X:-}" ]
}

require_caller_calibration() {
  caller_calibrated && return 0
  echo "FATAL: the caller's tap coordinates are not calibrated for this device." >&2
  echo "       Flutter screens cannot be addressed by resource id, and the caller's" >&2
  echo "       screen shape decides where its controls sit, so they must be measured." >&2
  echo "       Run: .claude/skills/video-ringing-test/scripts/calibrate.sh" >&2
  return 1
}

CALLER_LOG="$RING_DIR/caller.log"

start_caller_logcat() {
  stop_caller_logcat
  adbc logcat -c >/dev/null 2>&1 || true
  # shellcheck disable=SC2086
  adbc logcat -v time flutter:V "*:S" >"$CALLER_LOG" 2>&1 &
  echo $! >"$RING_DIR/caller-logcat.pid"
  sleep 1
}

stop_caller_logcat() {
  if [ -f "$RING_DIR/caller-logcat.pid" ]; then
    kill "$(cat "$RING_DIR/caller-logcat.pid")" 2>/dev/null || true
    rm -f "$RING_DIR/caller-logcat.pid"
  fi
}

# ring_from_caller_app [callee]
# Drives Direct Call on the caller emulator. Retries the whole sequence, because
# a single missed tap leaves the dialog in a half-filled state that a repeat of
# just the last tap cannot recover from.
ring_from_caller_app() {
  local callee="${1:-$RING_CALLEE}" i M
  require_caller_calibration || return 1
  for i in 1 2 3; do
    M=$(logline "$CALLER_LOG")
    adbc shell input keyevent KEYCODE_ESCAPE >/dev/null 2>&1   # close a stale dialog
    sleep 1
    # Dismiss the "We Value Your Feedback!" modal. The app raises it after EVERY
    # ended call and it covers the whole home screen, so from the second ring
    # onwards the Direct Call taps land on its star rating instead and no call is
    # ever created. ESCAPE does not close it — it is a Flutter dialog, invisible
    # to uiautomator, so the close button has to be tapped by coordinate. The tap
    # is unconditional: on the normal home screen that point is empty space.
    [ -n "${C_FEEDBACK_X:-}" ] && { tapc "$C_FEEDBACK_X" "$C_FEEDBACK_Y"; sleep 1; }
    tapc "$C_DIRECT_X" "$C_DIRECT_Y"; sleep 2
    tapc_until_ime "$C_DLG_FIELD_X" "$C_DLG_FIELD_Y" || continue
    adbc shell input text "$callee"; sleep 1
    hide_keyboard_caller                                        # keyboard hides the Call button
    sleep 1
    tapc "$C_DLG_CALL_X" "$C_DLG_CALL_Y"
    if wait_log "$CALLER_LOG" "getOrCreateCall" 25 "$M"; then
      return 0
    fi
    info "retry $i/3: Direct Call did not create a call"
    shotc "err-caller-direct-$i"
  done
  echo "FATAL: the caller app never created a ringing call." >&2
  echo "       Re-run calibrate.sh — its coordinates no longer match this device." >&2
  return 1
}

# Ends the call from the caller side. Used for teardown between states, and for
# the `cancel` check where the caller hanging up IS the behaviour under test.
# Goes over REST rather than through the caller UI: this is teardown, not a path
# the SDK is being judged on, and one deterministic request beats three taps that
# can miss.
cancel_ring() {
  local call_id="$1" caller="${2:-$RING_CALLER}" auth token api_key
  [ -n "$call_id" ] || return 0
  auth=$(curl -sS --max-time 20 \
    "https://$RING_TOKEN_HOST/api/auth/create-token?environment=$RING_ENV&user_id=$caller") || return 1
  token=$(printf '%s' "$auth" | sed -n 's/.*"token" *: *"\([^"]*\)".*/\1/p')
  api_key=$(printf '%s' "$auth" | sed -n 's/.*"apiKey" *: *"\([^"]*\)".*/\1/p')
  curl -sS --max-time 20 -o /dev/null \
    -X POST "$RING_COORDINATOR/video/call/default/$call_id/mark_ended?api_key=$api_key" \
    -H "Authorization: $token" -H "stream-auth-type: jwt" -H "Content-Type: application/json" \
    -d '{}'
}

# The call id is read off the callee's log rather than chosen by us, because the
# caller app now picks it.
last_call_id() {
  grep -oE "callCid: default:[A-Za-z0-9_-]+" "$ANDROID_LOG" | tail -1 | sed 's/.*://'
}

# ---------------------------------------------------------------- probes
# Every probe reads CURRENT state, never a historical logcat line. The smoke
# test's PiP trap applies with equal force here: logcat keeps an event forever,
# so a stale "notification posted" from an earlier ring passes a check that
# should have failed.

# telecom_call_present — a call for this package is LIVE in Telecom right now.
#
# Scoped to the `mCalls:` block. Grepping the whole dumpsys for the package matched
# the permanently-registered PhoneAccounts and the `>>>Target PhoneAccount` history
# lines, so it answered true with no call in flight at all — that made
# telecom-live-* a false pass and no-telecom-leak a false failure.
telecom_call_present() {
  adb shell dumpsys telecom 2>/dev/null | tr -d '\r' \
    | sed -n '/^  mCalls:/,/^  mCallAudioManager:/p' \
    | grep -qiE "$ANDROID_PKG|Call id"
}

# ringing_service_foreground — the ringing service is foreground with phoneCall
ringing_service_foreground() {
  adb shell dumpsys activity services "$ANDROID_PKG" 2>/dev/null | tr -d '\r' \
    | grep -A 25 "IncomingCallNotificationService" \
    | grep -qE "isForeground=true"
}

ringing_service_type_phonecall() {
  local block
  block=$(adb shell dumpsys activity services "$ANDROID_PKG" 2>/dev/null | tr -d '\r' \
    | grep -A 30 "IncomingCallNotificationService")
  # phoneCall is bit 4 of the FGS type mask. Platforms differ in how they print it
  # (`foregroundServiceType=`, `fgServiceTypes=`, a decimal mask, or a name list),
  # so match any of them and keep the raw block when nothing matches — guessing the
  # field name once already produced a false failure.
  # The field is `types=0x00000004`, a bitmask — not `foregroundServiceType=`, and
  # not a name. Bit 0x4 is FOREGROUND_SERVICE_TYPE_PHONE_CALL. Tested as a bit so a
  # combined mask (phoneCall|microphone) still matches.
  local mask
  mask=$(printf '%s' "$block" | grep -oE 'types=0x[0-9a-fA-F]+' | head -1 | sed 's/types=//')
  if [ -n "$mask" ] && [ $(( mask & 0x4 )) -ne 0 ]; then
    return 0
  fi
  printf '%s\n' "$block" >"$RING_DIR/fgs-type-raw.txt"
  return 1
}

# incoming_notification_present — an INCOMING-call notification is posted now.
#
# Matched on the incoming channel id, not merely on the package: declining
# legitimately leaves a missed-call notification behind, and a package-wide match
# counted that as a ring that never cleared.
INCOMING_CHANNEL="io.getstream.video_incoming_call_channel_id"
MISSED_CHANNEL="io.getstream.video_missed_call_channel_id"

incoming_notification_present() {
  adb shell dumpsys notification --noredact 2>/dev/null | tr -d '\r' \
    | grep -E "pkg=$ANDROID_PKG" | grep -q "channel=$INCOMING_CHANNEL"
}

missed_notification_present() {
  adb shell dumpsys notification --noredact 2>/dev/null | tr -d '\r' \
    | grep -E "pkg=$ANDROID_PKG" | grep -q "channel=$MISSED_CHANNEL"
}

# wait_probe <probe-fn> <timeout-seconds>
wait_probe() {
  local fn="$1" t="${2:-15}" i
  for i in $(seq 1 $((t * 2))); do
    if "$fn"; then return 0; fi
    sleep 0.5
  done
  return 1
}

# assert_probe <id> <desc> <probe-fn> [timeout]
assert_probe() {
  if wait_probe "$3" "${4:-15}"; then pass "$1" "$2"; else fail "$1" "$2"; fi
}

# assert_probe_clears <id> <desc> <probe-fn> [timeout]
assert_probe_clears() {
  local fn="$3" t="${4:-20}" i
  for i in $(seq 1 $((t * 2))); do
    if ! "$fn"; then pass "$1" "$2"; return 0; fi
    sleep 0.5
  done
  fail "$1" "$2"
}

# telecom_enabled_in_app — reads the app's own report rather than assuming.
# Without this a whole run can pass vacuously with Telecom switched off.
telecom_enabled_in_app() {
  grep -qE "\[init\] telecom enabled=true" "$ANDROID_LOG"
}

# ---------------------------------------------------------------- ringing ui
# The accept and decline controls live in two different places depending on how
# the ring was surfaced: the full-screen IncomingCallActivity
# (ivAcceptCall / ivDeclineCall) or the notification's RemoteViews
# (llAccept / llDecline). Try the activity first, then the shade, so a check
# does not have to know which one the system chose.
# A ring is always resolved through its notification here.
#
# Across the three app states this skill covers, Android surfaces the ring as a
# notification rather than the full-screen IncomingCallActivity: it only honours a
# full-screen intent over a keyguard, and none of these states locks the device. On
# Android 17 that notification is the ringing service's own foreground notification,
# posted with contentView=null and two standard action buttons — they carry no app
# resource id, so they are tapped by label.
#
# The resource-id path is kept for the case where the activity IS on top, which costs
# nothing and is the cheaper lookup when it applies.
#
# The success signal is a Dart lifecycle transition, not the notification
# disappearing: that notification is the foreground service's own, flagged
# NO_CLEAR|NO_DISMISS, so it legitimately outlives the action and waiting for it to
# vanish reported "could not decline" on declines that had worked.
# Bounded by the ring's own lifetime, not by an attempt count. A measured ring lives
# ~25s (17:55:06 ringing -> 17:55:31 caller cancel), while one attempt through the
# shade costs ~28s on an idle device and ~73s on a loaded one — five uiautomator dumps
# at 2-11s each, plus 18s of fixed waits. So a blind "for i in 1 2 3" spends 1.5-3.5
# minutes on attempts 2 and 3, which cannot possibly succeed because the call they are
# trying to answer died during attempt 1. That is not a slow test, it is a hang.
#
# checks.sh stamps RING_START the moment the ring is first seen; with no stamp the
# loop falls back to the old three attempts.
RING_TTL="${RING_TTL:-24}"

# True once the ring is past the point where anything on screen can still be tapped.
ring_expired() {
  [ -n "${RING_START:-}" ] || return 1
  [ $(( $(date +%s) - RING_START )) -ge "$RING_TTL" ]
}

_ring_action() {
  local activity_id="$1" label="$2" marker="$3" wait_s="${4:-12}" i M
  for i in 1 2 3; do
    if ring_expired; then
      info "giving up after attempt $((i - 1)): the ring is past its ~${RING_TTL}s lifetime"
      return 1
    fi
    M=$(logline "$ANDROID_LOG")

    if ui_has "$activity_id"; then
      tap_id "$activity_id"
      wait_log "$ANDROID_LOG" "$marker" "$wait_s" "$M" && return 0
    else
      # The shade is opened and left open: the action buttons are present once it is
      # up, and nothing is tapped to "expand" the notification first. An earlier
      # version tapped the first android:id/expand_button in the tree, which can
      # belong to an unrelated notification and reflows the shade mid-sequence.
      expand_shade
      if tap_text "$label"; then
        collapse_shade
        wait_log "$ANDROID_LOG" "$marker" "$wait_s" "$M" && return 0
      else
        collapse_shade
      fi
    fi
    info "retry $i/3: no '$marker' after resolving via '$activity_id'/'$label'"
  done
  return 1
}

# The labels are alternations because the notification names its answer action after
# the call type — a video call's accept button reads "Video", not "Accept" — and the
# app can override both through textAccept/textDecline.
# Joining, not "accepted": lifecycleCallAccepted is never logged on this path. An
# accept goes lifecycleCallConnecting -> lifecycleCallJoining -> sfuJoinResponse, and
# joining is the first of those that cannot be reached any other way from a ring.
accept_ring()  { _ring_action ivAcceptCall  "Accept|Answer|Video|Audio" \
                   "lifecycleCallJoining|lifecycleCallJoined|sfuJoinResponse"; }
# ActionCallDecline within a tight window is what separates a real decline from a
# ring that merely expired. A timeout ends up broadcasting the same event (the SDK
# ends an unaccepted call by declining it), so the event alone proves nothing — but
# the ring lives about 24s while a tapped decline lands in one or two, so a short
# wait after the tap cannot be satisfied by the timeout.
decline_ring() { _ring_action ivDeclineCall "Decline|Reject" "ActionCallDecline" 8; }
