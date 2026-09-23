#!/usr/bin/env bash
# Phase 7 — Android: create an END-TO-END ENCRYPTED call and print its id + key.
#
# This is a second, separate call, and it is deliberately not the call the rest
# of the run uses. Encryption sits on top of the ordinary publish/subscribe
# path, so running every check inside an encrypted call would exercise more
# code — but it would also mean a single E2EE regression turns the whole report
# red and hides whatever else broke. The plain call stays the diagnostic
# baseline; this round adds the encrypted path on top of it.
#
# Runs after finish.sh, with both apps back on their home screens.
cd "$(dirname "$0")" && . ./lib.sh
. "$SMOKE_DIR/env.sh"
android_geometry || exit 1

echo "== android: encrypted call =="

# finish.sh leaves a feedback modal behind on some paths; clear it before the
# home screen is touched, or the first tap is eaten by the modal's scrim.
dismiss_feedback

if ! tap_until_ui $A_START_NEW_X $A_START_NEW_Y "End-to-end encryption" 4 15; then
  fail "e2ee-lobby-android" "lobby did not open for the encrypted call"
  shot "err-e2ee-lobby"; exit 1
fi

# The switch is the one lobby control with no semantics label of its own, so it
# is addressed by coordinate. Its EFFECT is read back from the tree: the card's
# subtitle changes from "Encrypt this call with a shared key" to "Only people
# with the key can join", which is the app confirming the mode it will create
# the call with.
adb shell input tap $A_E2EE_SW_X $A_E2EE_SW_Y; sleep 3
if ! ui_wait "Only people with the key can join" 10; then
  fail "e2ee-enable-android" "the encryption switch did not turn on"
  shot "err-e2ee-switch"; exit 1
fi
pass "e2ee-enable-android" "Lobby switch arms end-to-end encryption before creation"

# Read the key the app generated rather than typing one in: that exercises the
# app's own key generation, and the value is what the iOS side has to be given.
# It is the only EditText on the lobby screen.
E2EE_KEY=$(ui_field EditText)
if [ -z "$E2EE_KEY" ]; then
  fail "e2ee-key-android" "no shared key field appeared after enabling encryption"
  shot "err-e2ee-key"; exit 1
fi
pass "e2ee-key-android" "Lobby generated a shared key ($E2EE_KEY)"
shot "22-android-e2ee-lobby"

# Enabling encryption grows the card and pushes the join button off the bottom.
ui_scroll_to "Start a test call" 4 || {
  fail "e2ee-join-android" "join button never came into view"; shot "err-e2ee-scroll"; exit 1
}

M=$(logline "$ANDROID_LOG")
ui_tap "Start a test call" 20 || {
  fail "e2ee-join-android" "could not tap the lobby join button"; exit 1
}
if wait_log "$ANDROID_LOG" "sfuJoinResponse" 45 "$M"; then
  pass "e2ee-join-android" "Android joined the encrypted call"
else
  fail "e2ee-join-android" "Android did not join the encrypted call"
  shot "err-e2ee-join"; exit 1
fi

# The manager has to be attached before any peer connection exists, so this
# line landing at all is the ordering constraint holding.
assert_log_since "e2ee-manager-android" "Android attached its encryption manager before joining" \
  "$ANDROID_LOG" "\[setE2EEManager\] userId:" "$M"
# One per published track. This is the assertion that outgoing media is actually
# encrypted: the SDK refuses to publish cleartext when an encryptor fails, so a
# miss here means either no encryptor or a refused publish.
if wait_log "$ANDROID_LOG" "\[attachEncryptor\] attached" 25 "$M"; then
  pass "e2ee-encrypt-android" "Android encrypts the frames it publishes"
else
  fail "e2ee-encrypt-android" "no encryptor attached to Android's published tracks"
fi

E2EE_CALL_ID=$(grep -oE "callCid: default:[a-z0-9]+" "$ANDROID_LOG" | tail -1 | sed 's/.*://')
if [ -z "$E2EE_CALL_ID" ]; then fail "e2ee-callid" "could not extract the encrypted call id"; exit 1; fi

# Same conditional-replace as android_join.sh: the redirection creates the temp
# file whether or not grep matched, so an unconditional mv turns a grep failure
# into a truncated env.sh and drops ANDROID_SERIAL for every later phase.
if grep -vE '^(E2EE_CALL_ID|E2EE_KEY|E2EE_MARK)=' "$SMOKE_DIR/env.sh" >"$SMOKE_DIR/env.tmp" 2>/dev/null \
   && [ -s "$SMOKE_DIR/env.tmp" ]; then
  mv "$SMOKE_DIR/env.tmp" "$SMOKE_DIR/env.sh"
else
  rm -f "$SMOKE_DIR/env.tmp"
fi
{
  echo "E2EE_CALL_ID=$E2EE_CALL_ID"
  echo "E2EE_KEY=$E2EE_KEY"
  # Marked before iOS joins, so the assertions in e2ee_verify.sh cannot be
  # satisfied by anything this script already did — and, on the iOS side, not by
  # the PLAIN call either: that log already contains an sfuJoinResponse, so an
  # unscoped "iOS joined the encrypted call" would pass without iOS doing a
  # thing. The E2EE lines themselves cannot appear in a plain call, but they are
  # scoped to the same mark rather than relying on that.
  echo "E2EE_MARK=$(logline "$ANDROID_LOG")"
  echo "IOS_E2EE_MARK=$(logline "$IOS_LOG")"
} >>"$SMOKE_DIR/env.sh"

sleep 3
shot "23-android-e2ee-in-call"

echo
echo "E2EE_CALL_ID=$E2EE_CALL_ID"
echo "E2EE_KEY=$E2EE_KEY"
echo "OK encrypted call created — now run the iOS encrypted-join sequence from SKILL.md step 8"
