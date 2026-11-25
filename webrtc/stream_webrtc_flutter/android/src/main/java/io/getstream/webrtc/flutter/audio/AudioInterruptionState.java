package io.getstream.webrtc.flutter.audio;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

/**
 * Whether the app's audio is interrupted, and the interruption starts and ends it reports: each
 * start is followed by exactly one end, and repeated starts or ends are dropped.
 *
 * <p>Plain Java, so it can be unit tested without Android.
 */
final class AudioInterruptionState {

    interface Listener {
        void onInterruptionStart();

        void onInterruptionEnd();
    }

    /** What a {@link #start()} or {@link #end()} did. */
    enum Outcome {
        /** The listener was told. */
        REPORTED,
        /** Nothing changed: an interruption was already active, or none was. */
        IGNORED,
        /** No listener is set, so nothing is tracked. */
        NO_LISTENER,
    }

    @Nullable
    private Listener listener;

    private boolean active = false;

    /** Sets the listener, or clears it with null. Either way no interruption is active after. */
    synchronized void setListener(@Nullable Listener listener) {
        this.listener = listener;
        active = false;
    }

    synchronized boolean isActive() {
        return active;
    }

    /** An interruption began. */
    @NonNull
    Outcome start() {
        final Listener current;
        synchronized (this) {
            if (listener == null) return Outcome.NO_LISTENER;
            if (active) return Outcome.IGNORED;
            active = true;
            current = listener;
        }
        current.onInterruptionStart();
        return Outcome.REPORTED;
    }

    /** The interruption ended. */
    @NonNull
    Outcome end() {
        final Listener current;
        synchronized (this) {
            if (listener == null) return Outcome.NO_LISTENER;
            if (!active) return Outcome.IGNORED;
            active = false;
            current = listener;
        }
        current.onInterruptionEnd();
        return Outcome.REPORTED;
    }
}
