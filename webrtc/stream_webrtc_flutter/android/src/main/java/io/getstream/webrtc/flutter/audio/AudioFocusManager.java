package io.getstream.webrtc.flutter.audio;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.media.AudioManager;
import android.os.Build;
import android.telephony.PhoneStateListener;
import android.telephony.TelephonyCallback;
import android.telephony.TelephonyManager;
import android.util.Log;

public class AudioFocusManager {
    private static final String TAG = "AudioFocusManager";

    public enum InterruptionSource {
        AUDIO_FOCUS_ONLY,
        TELEPHONY_ONLY,
        AUDIO_FOCUS_AND_TELEPHONY
    }

    private final Context context;
    private final InterruptionSource interruptionSource;
    private final boolean monitorAudioFocus;
    private final boolean monitorTelephony;

    private TelephonyManager telephonyManager;
    private PhoneStateListener phoneStateListener;
    private TelephonyCallback telephonyCallback;

    private AudioFocusChangeListener focusChangeListener;
    private volatile boolean interruptionActive = false;

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

    public AudioFocusManager(Context context) {
        this(context, InterruptionSource.AUDIO_FOCUS_AND_TELEPHONY);
    }

    public AudioFocusManager(Context context, InterruptionSource interruptionSource) {
        this.context = context;
        this.interruptionSource = interruptionSource;
        this.monitorAudioFocus = interruptionSource == InterruptionSource.AUDIO_FOCUS_ONLY
                || interruptionSource == InterruptionSource.AUDIO_FOCUS_AND_TELEPHONY;
        this.monitorTelephony = interruptionSource == InterruptionSource.TELEPHONY_ONLY
                || interruptionSource == InterruptionSource.AUDIO_FOCUS_AND_TELEPHONY;

        if (monitorTelephony) {
            telephonyManager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
        }
    }

    public void setAudioFocusChangeListener(AudioFocusChangeListener listener) {
        this.focusChangeListener = listener;

        if (listener != null) {
            startMonitoring();
        } else {
            stopMonitoring();
        }
    }

    public void startMonitoring() {
        interruptionActive = false;
        if (monitorAudioFocus) {
            if (AudioSwitchManager.instance != null) {
                AudioSwitchManager.instance.setAudioFocusChangeListener(audioSwitchFocusListener);
                AudioSwitchManager.instance.requestAudioFocus();
            } else {
                Log.w(TAG, "AudioSwitchManager instance is null, cannot observe audio focus changes");
            }
        }

        if (monitorTelephony) {
            registerTelephonyListener();
        }
    }

    public void stopMonitoring() {
        if (monitorAudioFocus && AudioSwitchManager.instance != null) {
            AudioSwitchManager.instance.setAudioFocusChangeListener(null);
        }
        interruptionActive = false;

        if (monitorTelephony) {
            unregisterTelephonyListener();
        }
    }

    private void registerTelephonyListener() {
        if (telephonyManager == null) {
            Log.w(TAG, "TelephonyManager is null, cannot register telephony listener");
            return;
        }

        if (!hasTelephonyPermission()) {
            Log.w(TAG, "Missing phone state permission, telephony interruptions disabled");
            return;
        }

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                // Use TelephonyCallback for Android 12+ (API 31+)
                class CallStateCallback extends TelephonyCallback implements TelephonyCallback.CallStateListener {
                    @Override
                    public void onCallStateChanged(int state) {
                        handleCallStateChange(state);
                    }
                }
                telephonyCallback = new CallStateCallback();
                telephonyManager.registerTelephonyCallback(context.getMainExecutor(), telephonyCallback);
            } else {
                // Use PhoneStateListener for older Android versions
                phoneStateListener = new PhoneStateListener() {
                    @Override
                    public void onCallStateChanged(int state, String phoneNumber) {
                        handleCallStateChange(state);
                    }
                };
                telephonyManager.listen(phoneStateListener, PhoneStateListener.LISTEN_CALL_STATE);
            }
        } catch (SecurityException exception) {
            Log.w(TAG, "Unable to register telephony listener", exception);
            telephonyCallback = null;
            phoneStateListener = null;
        }
    }

    private void handleCallStateChange(int state) {
        switch (state) {
            case TelephonyManager.CALL_STATE_RINGING:
            case TelephonyManager.CALL_STATE_OFFHOOK:
                handleInterruptionStart("Phone call interruption began");
                break;
            case TelephonyManager.CALL_STATE_IDLE:
                handleInterruptionEnd("Phone call interruption ended");
                break;
        }
    }

    private void unregisterTelephonyListener() {
        if (telephonyManager == null) {
            return;
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && telephonyCallback != null) {
            telephonyManager.unregisterTelephonyCallback(telephonyCallback);
            telephonyCallback = null;
        } else if (phoneStateListener != null) {
            telephonyManager.listen(phoneStateListener, PhoneStateListener.LISTEN_NONE);
            phoneStateListener = null;
        }
    }

    private boolean hasTelephonyPermission() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return true;
        }

        if (context.checkSelfPermission(Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED) {
            return true;
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S
                && context.checkSelfPermission(
                        Manifest.permission.READ_PRECISE_PHONE_STATE) == PackageManager.PERMISSION_GRANTED) {
            return true;
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU
                && context.checkSelfPermission(
                        Manifest.permission.READ_BASIC_PHONE_STATE) == PackageManager.PERMISSION_GRANTED) {
            return true;
        }

        return false;
    }

    private void handleInterruptionStart(String logMessage) {
        if (focusChangeListener == null) {
            return;
        }

        if (interruptionActive) {
            Log.d(TAG, "Ignoring duplicate interruption start: " + logMessage);
            return;
        }

        Log.d(TAG, logMessage);
        interruptionActive = true;
        focusChangeListener.onInterruptionStart();
    }

    private void handleInterruptionEnd(String logMessage) {
        if (focusChangeListener == null) {
            return;
        }

        if (!interruptionActive) {
            Log.d(TAG, "Ignoring interruption end with no active interruption: " + logMessage);
            return;
        }

        Log.d(TAG, logMessage);
        interruptionActive = false;
        focusChangeListener.onInterruptionEnd();
    }

    public void notifyManualAudioFocusRegain() {
        if (!monitorAudioFocus) {
            return;
        }
        handleInterruptionEnd("Audio focus manually requested");
    }
}