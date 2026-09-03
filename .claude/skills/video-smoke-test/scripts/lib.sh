#!/usr/bin/env bash
# Shared helpers for the video SDK smoke test.
# Sourced by every phase script. Never run directly.

set -u

# ---------------------------------------------------------------- paths
SMOKE_DIR="${SMOKE_DIR:-/tmp/stream-video-smoke}"
mkdir -p "$SMOKE_DIR"

ANDROID_LOG="$SMOKE_DIR/android.log"     # adb logcat capture
IOS_LOG="$SMOKE_DIR/ios.log"             # flutter run stdout (iOS)
RESULTS="$SMOKE_DIR/results.tsv"
SHOTS="$SMOKE_DIR/shots"
mkdir -p "$SHOTS"

ANDROID_PKG="io.getstream.video.flutter.dogfooding.debug"

# ---------------------------------------------------------------- results
# Every check emits exactly one line. Nothing else writes to stdout with
# these prefixes, so the agent can read results without interpreting prose.
pass()  { printf 'PASS\t%s\t%s\n' "$1" "$2"; printf 'PASS\t%s\t%s\n' "$1" "$2" >>"$RESULTS"; }
fail()  { printf 'FAIL\t%s\t%s\n' "$1" "$2"; printf 'FAIL\t%s\t%s\n' "$1" "$2" >>"$RESULTS"; }
skip()  { printf 'SKIP\t%s\t%s\n' "$1" "$2"; printf 'SKIP\t%s\t%s\n' "$1" "$2" >>"$RESULTS"; }
known() { printf 'KNOWN-FAIL\t%s\t%s\n' "$1" "$2"; printf 'KNOWN-FAIL\t%s\t%s\n' "$1" "$2" >>"$RESULTS"; }
info()  { printf '..\t%s\n' "$1"; }

# assert_log <id> <description> <logfile> <extended-regex>
# Passes if the pattern appears anywhere in the log file.
assert_log() {
  local id="$1" desc="$2" logf="$3" pat="$4"
  if grep -qE "$pat" "$logf" 2>/dev/null; then pass "$id" "$desc"; else fail "$id" "$desc"; fi
}

# assert_log_since <id> <desc> <logfile> <regex> <start-line>
# Only looks at lines added after <start-line>. Use this so an assertion
# cannot be satisfied by an identical event from an earlier step.
assert_log_since() {
  local id="$1" desc="$2" logf="$3" pat="$4" from="$5"
  if tail -n "+$from" "$logf" 2>/dev/null | grep -qE "$pat"; then pass "$id" "$desc"; else fail "$id" "$desc"; fi
}

# wait_log <logfile> <regex> <timeout-seconds> [start-line]
# Returns 0 as soon as the pattern appears. Polls at 0.5s.
# Always prefer this over a fixed sleep.
wait_log() {
  local logf="$1" pat="$2" timeout="$3" from="${4:-1}"
  local deadline=$(( $(date +%s) + timeout ))
  while [ "$(date +%s)" -lt "$deadline" ]; do
    if tail -n "+$from" "$logf" 2>/dev/null | grep -qE "$pat"; then return 0; fi
    sleep 0.5
  done
  return 1
}

logline() { wc -l <"$1" 2>/dev/null | tr -d ' ' || echo 1; }

# in_call_guard <id>
# Fails fast if the app has dropped out of the call since it joined. Without
# this, one bad tap early on turns into a pile of confusing downstream failures
# instead of one clear message.
in_call_guard() {
  local id="$1" lastjoin lastleave
  lastjoin=$(grep -n "sfuJoinResponse" "$ANDROID_LOG" 2>/dev/null | tail -1 | cut -d: -f1)
  lastleave=$(grep -nE "\[leave\] reason|\[clear\] src: disconnect" "$ANDROID_LOG" 2>/dev/null | tail -1 | cut -d: -f1)
  if [ -n "$lastleave" ] && [ "${lastleave:-0}" -gt "${lastjoin:-0}" ]; then
    fail "$id" "app is no longer in the call (an earlier step dropped it) — remaining checks are invalid"
    shot "err-$id-not-in-call"
    return 1
  fi
  return 0
}

# assert_two_participants <id> <desc> <logfile>
# Name-independent peer check: at least two distinct user ids appeared in SFU
# participant state. Do not assert on SfuParticipantCount — the join response
# carries the count at join time, so the first client to join always sees 1.
assert_two_participants() {
  local id="$1" desc="$2" logf="$3" n
  # Exclude the placeholder ids the SDK logs ("0", "null") — counting them would
  # let a solo call pass this check.
  n=$(grep -oE "userId: [a-zA-Z0-9_]+" "$logf" 2>/dev/null | sort -u \
      | grep -cvE "userId: (0|null)$")
  if [ "${n:-0}" -ge 2 ]; then pass "$id" "$desc ($n participants seen)"
  else fail "$id" "$desc (only ${n:-0} participant seen)"; fi
}

# ---------------------------------------------------------------- android input
# Reference geometry: Pixel_10 AVD, 1080x2424. Coordinates below are the
# verified values for that device; SX/SY rescale them if the emulator differs
# in size but not in aspect ratio.
android_geometry() {
  local size w h
  size=$(adb shell wm size 2>/dev/null | tr -d '\r' | awk -F': ' '{print $2}')
  w=${size%x*}; h=${size#*x}
  if [ -z "$w" ] || [ -z "$h" ]; then echo "FATAL: cannot read screen size" >&2; return 1; fi
  SX=$(awk -v a="$w" 'BEGIN{printf "%.5f", a/1080}')
  SY=$(awk -v a="$h" 'BEGIN{printf "%.5f", a/2424}')
  local skew
  skew=$(awk -v x="$SX" -v y="$SY" 'BEGIN{d=x/y; if(d<1)d=1/d; printf "%.4f", d}')
  if awk -v s="$skew" 'BEGIN{exit !(s>1.02)}'; then
    echo "FATAL: emulator aspect ratio differs from the 1080x2424 reference (${w}x${h})." >&2
    echo "       Taps would land on the wrong controls. Use a Pixel_10-class AVD." >&2
    return 1
  fi
  info "android geometry ${w}x${h} (scale $SX/$SY)"
}

# tap <ref-x> <ref-y>  — coordinates in the 1080x2424 reference space
tap() {
  local x y
  x=$(awk -v a="$1" -v s="$SX" 'BEGIN{printf "%d", a*s}')
  y=$(awk -v a="$2" -v s="$SY" 'BEGIN{printf "%d", a*s}')
  adb shell input tap "$x" "$y"
}

shot() { adb exec-out screencap -p >"$SHOTS/$1.png" 2>/dev/null; }

# tap_until <ref-x> <ref-y> <logfile> <regex> [attempts] [per-attempt-timeout]
# Taps, then waits for the log to confirm the tap had its effect; retries if not.
#
# Use this for every navigation tap. A fixed `sleep` before a tap is a guess
# about how long a screen takes to build, and when the guess is short the tap
# lands on the previous screen — which is how a mistap on the login screen
# turned into "lobby did not open" three steps later.
tap_until() {
  local x="$1" y="$2" logf="$3" pat="$4" tries="${5:-3}" t="${6:-12}" i M
  for i in $(seq 1 "$tries"); do
    M=$(logline "$logf")
    tap "$x" "$y"
    if wait_log "$logf" "$pat" "$t" "$M"; then return 0; fi
    info "retry $i/$tries: tap ($x,$y) produced no '$pat'"
  done
  return 1
}

# wait_pip <timeout-seconds>
# Returns 0 once the app's task is actually in PiP. Polls, so it cannot lose a
# race against the PiP transition.
#
# The probe reads CURRENT state — the task's `mode=pinned` — and is verified to
# go true in PiP and false again after restore.
#
# Two traps to avoid here:
#  * Do NOT grep `windowingMode=pinned` out of `dumpsys activity activities`: it
#    lives on config lines long enough that the match fails in practice even
#    while the app is demonstrably in PiP.
#  * Do NOT accept a `PICTURE_IN_PICTURE_ENTER` line from logcat: the buffer
#    keeps it forever, so the check passes on a stale event from an earlier run
#    even when PiP never happened.
wait_pip() {
  local timeout="${1:-12}" deadline
  deadline=$(( $(date +%s) + timeout ))
  while [ "$(date +%s)" -lt "$deadline" ]; do
    if adb shell dumpsys activity activities 2>/dev/null \
         | grep -qE "Task\{.*$ANDROID_PKG.*mode=pinned"; then return 0; fi
    sleep 1
  done
  return 1
}

# Fails the run loudly if Android threw up an ANR dialog. Called between steps
# so a hang is reported as a finding instead of silently eating later taps.
anr_check() {
  local id="$1"
  if adb shell dumpsys window 2>/dev/null | grep -q "Application Not Responding"; then
    fail "$id" "ANR dialog appeared (app main thread blocked)"
    shot "anr-$id"
    adb shell input keyevent KEYCODE_DPAD_DOWN >/dev/null 2>&1
    return 1
  fi
  return 0
}

# ---------------------------------------------------------------- audio
# Every microphone-dependent check needs two things that live outside this
# repo: the emulator must be allowed to use the host microphone, and the host
# must actually be making a noise. Neither can be probed — the emulator console
# exposes no microphone command — so the checks play a sound, assert, and name
# the causes when they fail.
MIC_HINT="check, in this order: the emulator's Extended controls > Microphone > 'Enable Host Microphone Access' — restart the emulator after toggling it, the setting only takes effect on a fresh boot; macOS System Settings > Privacy & Security > Microphone, where the emulator must be allowed (macOS hands an unpermitted process silence, not an error); and the Mac's output volume plus an unmuted input"

# speak_start <seconds>
# Talks through the host's speakers so the emulator's host-microphone
# passthrough has something to hear. The detector on the Android side is an RMS
# threshold (-45 dBFS over 600ms), so any sustained sound works; speech is used
# because it is what the feature is for.
#
# Sets SPEAK_PID. Always pair with speak_stop, including on the failure path,
# or the run keeps talking through later checks.
speak_start() {
  local secs="${1:-10}" deadline
  SPEAK_PID=""
  if ! command -v say >/dev/null 2>&1; then
    info "no 'say' on this host — microphone checks need audible sound from the host"
    return 1
  fi
  deadline=$(( $(date +%s) + secs ))
  (
    while [ "$(date +%s)" -lt "$deadline" ]; do
      say -r 170 "one two three four five six seven eight nine ten" >/dev/null 2>&1
    done
  ) &
  SPEAK_PID=$!
  return 0
}

speak_stop() {
  if [ -n "${SPEAK_PID:-}" ]; then
    kill "$SPEAK_PID" 2>/dev/null
    # Reap it, or bash prints its own "Terminated: 15" job notice into the
    # middle of the check output.
    wait "$SPEAK_PID" 2>/dev/null
  fi
  # `say` is a child of the subshell, so it survives the kill above.
  pkill -x say 2>/dev/null
  SPEAK_PID=""
  return 0
}

# assert_mic <id> <desc> <logfile> <regex> <start-line> [timeout]
# A microphone-dependent assertion. A PASS is real news: it means sound from the
# host reached the emulator and travelled the whole path being checked.
#
# Absence is reported as KNOWN-FAIL, not FAIL, because it is almost always the
# environment. Microphone input into the emulator is intermittent: the same AVD
# instance delivered audio for two runs and then went silent for a third with no
# configuration change, and recovering it needs an emulator restart. A hard
# failure here would cry wolf often enough that people stop reading failures,
# which costs more than this check gains. Read a KNOWN-FAIL as "not verified
# this run" and check the prerequisites in SKILL.md.
assert_mic() {
  local id="$1" desc="$2" logf="$3" pat="$4" from="$5" t="${6:-25}"
  if wait_log "$logf" "$pat" "$t" "$from"; then
    pass "$id" "$desc"
  else
    known "$id" "$desc — not verified: no microphone input observed ($MIC_HINT)"
  fi
}

# ---------------------------------------------------------------- permissions
# grant_android_permissions
# Pre-grants every runtime permission the app asks for, so no system dialog can
# swallow a tap mid-run.
#
# Call this AFTER `flutter run` has installed the app. The install resets
# runtime permissions, so granting only before it silently does nothing: the
# camera dialog then appears on the first Start New Call, eats the tap, and the
# run dies at "Lobby did not open" with a dialog on screen.
grant_android_permissions() {
  local p missing=""
  for p in RECORD_AUDIO CAMERA POST_NOTIFICATIONS READ_PHONE_STATE BLUETOOTH_CONNECT; do
    adb shell pm grant "$ANDROID_PKG" "android.permission.$p" >/dev/null 2>&1
  done
  # Verify the two that gate the call. Every later coordinate depends on no
  # dialog being on screen, so a silent failure here must not stay silent.
  for p in RECORD_AUDIO CAMERA; do
    adb shell dumpsys package "$ANDROID_PKG" 2>/dev/null \
      | grep -q "android.permission.$p: granted=true" || missing="$missing $p"
  done
  if [ -n "$missing" ]; then
    info "WARN: permissions not granted:$missing — a system dialog may eat taps"
  fi
  return 0
}

# ---------------------------------------------------------------- deep links
# deeplink <url>
# Delivers a call link to the app. The component is named explicitly because a
# debug build is not a verified App Links handler (its signing fingerprint is
# not in the site's assetlinks.json), and a plain browsable VIEW intent then
# opens Chrome instead of the app — which looks exactly like a broken deep
# link. `adb shell pm get-app-links <pkg>` shows the verification state.
deeplink() {
  adb shell am start -a android.intent.action.VIEW -d "$1" \
    -n "$ANDROID_PKG/io.getstream.video.flutter.dogfooding.MainActivity" \
    >/dev/null 2>&1
}

# router_ok <start-line>
# False if the router rejected the location it was handed, or if a pop emptied
# the navigation stack. A link that resolves the call but leaves the user on an
# error screen must not pass, and popping the last page is what a link-built
# stack does when nothing was routed beneath it.
router_ok() {
  local from="$1"
  ! tail -n "+$from" "$ANDROID_LOG" 2>/dev/null \
    | grep -qE "GoException|no routes for location|popped the last page"
}

# ---------------------------------------------------------------- chat
# android_chat_send <message> <mark-line>
# Types <message> into the already-open Android chat composer and taps SEND
# until the outgoing message request is in the log. Returns 0 only when the
# send is confirmed, so a missed tap is a failure here instead of a mystery
# three checks later.
#
# Two traps this encodes:
#  * Whether the soft keyboard opens after `input text` is not under our
#    control (Gboard on this AVD sometimes shows only its floating toolbar),
#    and that moves the composer between y=2293 (keyboard closed) and y=1434
#    (keyboard open). One fixed tap missed the button, the text sat in the
#    composer as a draft, and a stray tap in finish.sh sent it a minute later.
#  * Never assert the send by grepping logcat for the bare message text:
#    logcat echoes the `input text <msg>` command itself, so that assertion
#    passes even when nothing was ever sent. Match the outgoing request body.
#
# Position order is deliberate: keyboard-open first. With the keyboard closed
# that spot is empty message list, so a miss is harmless; the keyboard-closed
# spot lands on a key when the keyboard IS open, which would corrupt the text.
android_chat_send() {
  local msg="$1" from="$2" i pat
  pat="I flutter.*(\"text\":\"$msg\"|, $msg, regular)"
  adb shell input text "$msg"; sleep 2
  for i in 1 2 3 4; do
    if [ $((i % 2)) = 1 ]; then tap $A_CHAT_SEND_X $A_CHAT_INPUT2_Y
    else                        tap $A_CHAT_SEND_X $A_CHAT_INPUT_Y; fi
    if wait_log "$ANDROID_LOG" "$pat" 8 "$from"; then return 0; fi
    info "retry $i/4: chat send tap produced no outgoing message request"
  done
  return 1
}

# assert_chat_delivered <id> <desc> <receiver-log> <mark-line> [timeout]
# Chat receipt is asserted from the receiver's WS event, NOT from the message
# text. No client logs the body of a message it RECEIVES, so grepping the peer
# log for the text can never pass — that is what made chat look like a
# "send-only" defect for a while: the assertion was wrong, not the SDK. The
# receiving client logs `Event received: message.new` and then POSTs
# channel/read; the event is the portable signal on both platforms.
#
# <mark-line> MUST be taken before the sender sends, and no other message may
# be in flight in that window: the sender also gets a message.new for its own
# message, so an unmarked window cannot tell the two apart.
assert_chat_delivered() {
  local id="$1" desc="$2" logf="$3" from="$4" t="${5:-25}"
  if wait_log "$logf" "Event received: message\.new" "$t" "$from"; then
    pass "$id" "$desc"
  else
    fail "$id" "$desc"
  fi
}

# ---------------------------------------------------------------- services
# call_service_dump — prints a line per Stream CALL foreground service that is
# alive right now (empty output means none).
#
# Deliberately specific. A bare `dumpsys activity services <pkg> | grep
# ServiceRecord` reports the app's unrelated short-lived services (push,
# WorkManager) and a call service that is merely still unwinding, so it cannot
# tell a real leak from normal teardown.
call_service_dump() {
  adb shell dumpsys activity services "$ANDROID_PKG" 2>/dev/null | tr -d '\r' | awk '
    /ServiceRecord\{/ { rec=$0; keep=(rec ~ /StreamCallService|StreamScreenShareService/); next }
    keep && /isForeground=true/ { print rec; keep=0 }
  '
}

# wait_call_service_gone <timeout-seconds>
# Returns 0 once no Stream call foreground service is left. Polls, because
# teardown is asynchronous — a single-shot check seconds after leaving is a
# race, not a finding.
wait_call_service_gone() {
  local timeout="${1:-25}" deadline
  deadline=$(( $(date +%s) + timeout ))
  while [ "$(date +%s)" -lt "$deadline" ]; do
    [ -z "$(call_service_dump)" ] && return 0
    sleep 2
  done
  return 1
}

# ---------------------------------------------------------------- background procs
# The run leaves three long-lived processes behind it: `adb logcat` and one
# `flutter run` per platform. They are recorded here as "<pid>\t<command>" and
# never killed unless the pid is STILL that command.
#
# A bare pid is not safe to kill later. The pid files live in $SMOKE_DIR, which
# survives across runs and reboots, so a stale file plus pid reuse means
# `kill $(cat ...)` can hit an unrelated process of the user's. Recording the
# command line makes the check possible; every kill path below goes through it.

# record_bg <name> <pid>
record_bg() {
  local name="$1" pid="$2" cmd
  cmd=$(ps -o command= -p "$pid" 2>/dev/null | head -1)
  printf '%s\t%s\n' "$pid" "$cmd" >"$SMOKE_DIR/$name.pid"
}

# proc_is <pid> <expected-command> — true only if that pid is alive AND its
# command line still contains what we recorded. An expected string with glob
# characters simply fails to match, which fails in the safe direction: we skip
# the kill rather than kill something unknown.
proc_is() {
  local pid="$1" want="$2" cmd
  [ -n "$pid" ] && [ -n "$want" ] || return 1
  case "$pid" in *[!0-9]*|'') return 1;; esac
  cmd=$(ps -o command= -p "$pid" 2>/dev/null | head -1)
  [ -n "$cmd" ] || return 1
  case "$cmd" in *"$want"*) return 0;; *) return 1;; esac
}

# proc_tree <pid> — "<pid>\t<command>" for every descendant, deepest last.
# Captured BEFORE the parent is signalled: once it dies its children are
# reparented to launchd and the pgrep -P link is gone.
proc_tree() {
  local pid="$1" child cmd
  for child in $(pgrep -P "$pid" 2>/dev/null); do
    cmd=$(ps -o command= -p "$child" 2>/dev/null | head -1)
    [ -n "$cmd" ] && printf '%s\t%s\n' "$child" "$cmd"
    proc_tree "$child"
  done
}

# kill_tree <pid> — stop a process and anything it spawned.
# `flutter run` is a supervisor: killing only the recorded pid leaves the gradle
# daemon, xcodebuild and the dart VM running. It gets a TERM and five seconds to
# reap its own children first; whatever is still standing after that is killed
# individually, each re-verified against the command captured up front.
kill_tree() {
  local pid="$1" kids line cpid ccmd i
  kids=$(proc_tree "$pid")
  kill "$pid" 2>/dev/null
  for i in 1 2 3 4 5 6 7 8 9 10; do
    kill -0 "$pid" 2>/dev/null || break
    sleep 0.5
  done
  kill -0 "$pid" 2>/dev/null && kill -9 "$pid" 2>/dev/null
  printf '%s\n' "$kids" | while IFS=$'\t' read -r cpid ccmd; do
    [ -n "$cpid" ] || continue
    proc_is "$cpid" "$ccmd" && kill "$cpid" 2>/dev/null
  done
  return 0
}

# stop_bg <name>... — stop recorded background processes and drop their pid
# files. Safe to call when nothing is running, and safe to call twice.
stop_bg() {
  local name pid cmd
  for name in "$@"; do
    [ -f "$SMOKE_DIR/$name.pid" ] || continue
    IFS=$'\t' read -r pid cmd <"$SMOKE_DIR/$name.pid"
    if [ -z "${cmd:-}" ]; then
      # Pre-verification pid file (bare number). Nothing proves this pid is
      # still ours, so leave it alone rather than kill a stranger.
      info "skipping $name: pid file has no command to verify against"
    elif proc_is "$pid" "$cmd"; then
      kill_tree "$pid"
      info "stopped $name (pid $pid)"
    fi
    rm -f "$SMOKE_DIR/$name.pid"
  done
}

# stop_all_bg — every background process the run owns.
stop_all_bg() { stop_bg logcat android_run ios_run; }

# ---------------------------------------------------------------- reference coords
# In-call bottom control bar (y=2300): more / share / mic / camera / people / chat
A_MORE=98;   A_SHARE=255; A_MIC=413;  A_CAM=570;  A_PEOPLE=841; A_CHAT=998
A_BAR_Y=2300
# Top bar (y=215)
A_END_X=998; A_TOP_Y=215
# Login screen (reached deterministically via `pm clear`)
A_USER_X=539;   A_USER_Y=1469
A_SIGNUP_X=539; A_SIGNUP_Y=1632
# Home screen
A_START_NEW_X=577; A_START_NEW_Y=1871
A_CALLID_X=350;    A_CALLID_Y=1683
A_JOIN_X=875;      A_JOIN_Y=1683
# Lobby
A_TESTCALL_X=538;  A_TESTCALL_Y=2084
# "Your meeting is live" banner chevron
A_BANNER_X=922;    A_BANNER_Y=945
# Options sheet
A_REACT_X=224;     A_REACT_Y=413      # first reaction (party popper)
A_BLUR_X=217;      A_BLUR_Y=688       # blur filter
A_STATS_X=202;     A_STATS_Y=1277
# Leave the stats screen with the top-LEFT back arrow, never the top-right X.
# The X sits ~16px from the call screen's END CALL button, so if the stats screen
# ever fails to open, that tap silently ends the call. The top-left position is
# the harmless layout-toggle button on the call screen.
A_STATS_BACK_X=73
# A "We Value Your Feedback!" modal appears after leaving a call on BOTH
# platforms. It blocks the home screen until dismissed.
A_FEEDBACK_X=973; A_FEEDBACK_Y=541
# Chat sheet
A_CHAT_INPUT_Y=2293      # composer, keyboard closed (also the SEND row)
A_CHAT_INPUT2_Y=1434     # composer, keyboard open (also the SEND row)
# The keyboard does not always open — android_chat_send taps both rows rather
# than assuming which one is live.
A_CHAT_INPUT_X=605
A_CHAT_SEND_X=974
