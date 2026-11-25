package io.getstream.webrtc.flutter.audio;

import androidx.annotation.NonNull;

/**
 * Whether WebRTC holds audio focus for the call's audio, or has asked for it, and what to do
 * when focus handling is switched on or off while the call's audio runs.
 *
 * <p>Plain Java, so it can be unit tested without Android.
 */
final class AudioFocusHolding {

    /** What to do with the audio focus after focus handling was switched. */
    enum Action {
        /** Request focus for the call's audio. */
        REQUEST,
        /** Give up the focus held for the call's audio. */
        ABANDON,
        /** Nothing: focus is already as it should be, or no call's audio runs. */
        NONE,
    }

    private boolean held = false;

    boolean isHeld() {
        return held;
    }

    /**
     * The call's audio started, and AudioSwitch requests focus for it when focus is
     * {@code managed}.
     */
    void onStart(boolean managed) {
        held = managed;
    }

    /**
     * A focus request was made for the call's audio. Focus counts as held unless the request was
     * refused; a refused request leaves an earlier one registered, so it clears nothing. Holding
     * too much is safe: giving up focus no one holds does nothing.
     */
    void onRequested(boolean refused) {
        if (!refused) held = true;
    }

    /** The focus held for the call's audio was given up. */
    void onAbandoned() {
        held = false;
    }

    /** Focus handling was switched to {@code managed} while the call's audio is {@code active}. */
    @NonNull
    Action onManagedChanged(boolean managed, boolean active) {
        if (!active) return Action.NONE;
        if (managed && !held) return Action.REQUEST;
        if (!managed && held) return Action.ABANDON;
        return Action.NONE;
    }

    /** The call's audio stopped; returns whether focus held for it has to be given up. */
    boolean onStop() {
        boolean wasHeld = held;
        held = false;
        return wasHeld;
    }
}
