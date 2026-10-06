#!/usr/bin/env bash
# Phase 9 — assert the encrypted call from both sides, then tear it down.
# Run once the agent has joined the encrypted call on iOS with the shared key.
cd "$(dirname "$0")" && . ./lib.sh
. "$SMOKE_DIR/env.sh"
android_geometry || exit 1

E2EE_MARK="${E2EE_MARK:-1}"
IOS_E2EE_MARK="${IOS_E2EE_MARK:-1}"

echo "== encrypted call: both sides =="

# --- iOS side, scoped to after the encrypted call began --------------------
# The scope matters most for the join: the iOS log already holds the plain
# call's sfuJoinResponse, so an unscoped assertion would pass with iOS sitting
# on its home screen.
assert_log_since "e2ee-join-ios"    "iOS joined the encrypted call"          "$IOS_LOG" "sfuJoinResponse" "$IOS_E2EE_MARK"
assert_log_since "e2ee-manager-ios" "iOS attached its encryption manager"    "$IOS_LOG" "\[setE2EEManager\] userId:" "$IOS_E2EE_MARK"
assert_log_since "e2ee-encrypt-ios" "iOS encrypts the frames it publishes"   "$IOS_LOG" "\[attachEncryptor\] attached" "$IOS_E2EE_MARK"
# The half a single client cannot prove: a decryptor is only attached for a
# REMOTE track whose participant is already known, so this line existing at all
# means the peer's encrypted media arrived and was wired up to be decrypted.
# Together with the peer's own encryptor line, that is the round trip.
assert_log_since "e2ee-decrypt-ios" "iOS decrypts the peer's encrypted media" "$IOS_LOG" "\[attachDecryptor\] attached for userId:" "$IOS_E2EE_MARK"

# --- Android side, scoped to after iOS joined ------------------------------
if wait_log "$ANDROID_LOG" "\[attachDecryptor\] attached for userId:" 45 "$E2EE_MARK"; then
  pass "e2ee-decrypt-android" "Android decrypts the peer's encrypted media"
else
  fail "e2ee-decrypt-android" "Android never attached a decryptor for the peer"
fi
# No peer-seen check here on purpose. assert_two_participants counts distinct
# user ids across the WHOLE log, and both rounds use the same two users, so in
# this round it would pass on the plain call's participants without the peer
# ever arriving. e2ee-decrypt-android is the stronger claim anyway: it cannot
# be true unless the peer's media actually showed up.

# --- nothing fell back to cleartext, and nothing failed to decrypt ----------
# The positive checks above prove the machinery was wired up; these prove it
# then worked. Every one of these events means a frame did not come out the far
# side intact, and the SDK logs them at error/warn precisely so they are visible
# here. Scoped to this call so an earlier round cannot colour it.
E2EE_ERRS=$(tail -n "+$E2EE_MARK" "$ANDROID_LOG" 2>/dev/null \
  | grep -cE "\[e2ee\].*(missingKey|decryptionFailed|encryptionFailed|unsupportedVersion|decryptionStalled|unencryptedFrame)|\[attach(En|De)cryptor\] failed")
if [ "${E2EE_ERRS:-0}" = "0" ]; then
  pass "e2ee-clean-android" "No decryption failures or cleartext frames on Android"
else
  fail "e2ee-clean-android" "$E2EE_ERRS encryption/decryption error events during the encrypted call"
fi
IOS_ERRS=$(grep -cE "\[e2ee\].*(missingKey|decryptionFailed|encryptionFailed|unsupportedVersion|decryptionStalled|unencryptedFrame)|\[attach(En|De)cryptor\] failed" "$IOS_LOG" 2>/dev/null)
if [ "${IOS_ERRS:-0}" = "0" ]; then
  pass "e2ee-clean-ios" "No decryption failures or cleartext frames on iOS"
else
  fail "e2ee-clean-ios" "$IOS_ERRS encryption/decryption error events during the encrypted call"
fi

shot "24-android-e2ee-both"
anr_check "e2ee-android"

# --- leave -----------------------------------------------------------------
# No sheets are open in this round, but tap_until is still the right tool: it
# confirms from the log that the leave actually happened rather than assuming
# one tap landed.
M=$(logline "$ANDROID_LOG")
if tap_until $A_END_X $A_TOP_Y "$ANDROID_LOG" "\[leave\] reason|\[clear\] src: disconnect" 4 12; then
  pass "e2ee-leave-android" "Android left the encrypted call cleanly"
else
  fail "e2ee-leave-android" "Android did not leave the encrypted call"
  shot "err-e2ee-leave"
fi
sleep 3
dismiss_feedback
shot "25-android-after-e2ee-leave"

echo "OK encrypted round — now run report.sh"
