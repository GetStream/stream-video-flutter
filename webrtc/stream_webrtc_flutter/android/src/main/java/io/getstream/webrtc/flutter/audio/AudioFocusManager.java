package io.getstream.webrtc.flutter.audio;

import android.media.AudioManager;
import android.util.Log;

/**
 * Reports interruptions of the call's audio from the audio focus WebRTC holds while it runs: a
 * loss starts one, and a gain, or WebRTC giving the focus up, ends it.
 */
public class AudioFocusManager {
    private static final String TAG = "AudioFocusManager";

    private final AudioInterruptionState interruptionState = new AudioInterruptionState();

    private final AudioManager.OnAudioFocusChangeListener audioSwitchFocusListener = focusChange -> {
        switch (focusChange) {
            case AudioManager.AUDIOFOCUS_LOSS:
            case AudioManager.AUDIOFOCUS_LOSS_TRANSIENT:
            case AudioManager.AUDIOFOCUS_LOSS_TRANSIENT_CAN_DUCK:
                handleInterruptionStart("Audio focus lost: " + focusChange);
                break;
            case AudioManager.AUDIOFOCUS_GAIN:
            case AudioManager.AUDIOFOCUS_GAIN_TRANSIENT:
            case AudioManager.AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK:
            case AudioManager.AUDIOFOCUS_GAIN_TRANSIENT_EXCLUSIVE:
                handleInterruptionEnd("Audio focus gained: " + focusChange);
                break;
            default:
                break;
        }
    };

    public interface AudioFocusChangeListener {
        void onInterruptionStart();

        void onInterruptionEnd();
    }

    public void setAudioFocusChangeListener(AudioFocusChangeListener listener) {
        if (listener != null) {
            interruptionState.setListener(new AudioInterruptionState.Listener() {
                @Override
                public void onInterruptionStart() {
                    listener.onInterruptionStart();
                }

                @Override
                public void onInterruptionEnd() {
                    listener.onInterruptionEnd();
                }
            });
            startMonitoring();
        } else {
            stopMonitoring();
            interruptionState.setListener(null);
        }
    }

    /**
     * Observes the audio focus WebRTC holds while a call's audio runs. Requests no focus itself:
     * an app that is in no call holds none.
     */
    private void startMonitoring() {
        if (AudioSwitchManager.instance != null) {
            AudioSwitchManager.instance.setAudioFocusChangeListener(audioSwitchFocusListener);
            AudioSwitchManager.instance.setAudioFocusReleasedListener(this::onAudioFocusReleased);
        } else {
            Log.w(TAG, "AudioSwitchManager instance is null, cannot observe audio focus changes");
        }
    }

    private void stopMonitoring() {
        if (AudioSwitchManager.instance != null) {
            AudioSwitchManager.instance.setAudioFocusChangeListener(null);
            AudioSwitchManager.instance.setAudioFocusReleasedListener(null);
        }
    }

    /**
     * WebRTC gave up its audio focus because the call's audio stopped or focus handling was
     * switched off, so no focus gain will end an interruption a focus loss started.
     */
    private void onAudioFocusReleased() {
        handleInterruptionEnd("Audio focus released");
    }

    private void handleInterruptionStart(String logMessage) {
        switch (interruptionState.start()) {
            case REPORTED:
                Log.d(TAG, logMessage);
                break;
            case IGNORED:
                Log.d(TAG, "Ignoring duplicate interruption start: " + logMessage);
                break;
            case NO_LISTENER:
                break;
        }
    }

    private void handleInterruptionEnd(String logMessage) {
        switch (interruptionState.end()) {
            case REPORTED:
                Log.d(TAG, logMessage);
                break;
            case IGNORED:
                Log.d(TAG, "Ignoring interruption end with no active interruption: " + logMessage);
                break;
            case NO_LISTENER:
                break;
        }
    }
}
