package io.getstream.webrtc.flutter.audio;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.media.AudioAttributes;
import android.media.AudioFocusRequest;
import android.media.AudioManager;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.twilio.audioswitch.AudioDevice;
import com.twilio.audioswitch.AudioSwitch;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import kotlin.Unit;
import kotlin.jvm.functions.Function2;

public class AudioSwitchManager {

    public static final String TAG = "AudioSwitchManager";

    @SuppressLint("StaticFieldLeak")
    public static AudioSwitchManager instance;
    @NonNull
    private final Context context;
    @NonNull
    private final AudioManager audioManager;

    // WeakReference to avoid memory leaks with Activity
    @Nullable
    private WeakReference<Activity> activityRef;

    /**
     * Marks the posted runnables that start or stop the call's audio, so a start cancels a
     * pending stop or start without also dropping other posted work, such as a device
     * selection.
     */
    private static final Object LIFECYCLE_TOKEN = new Object();

    public boolean loggingEnabled;
    private boolean isActive = false;

    /** Whether the call's audio is being started, when its settings already apply. */
    private boolean isActivating = false;

    /** The audio mode the device was in before the call's audio started, put back after. */
    private int modeBeforeCall = AudioManager.MODE_NORMAL;

    /** Whether audio focus is held for the call's audio, or has been asked for. */
    private final AudioFocusHolding focusHolding = new AudioFocusHolding();
    @NonNull
    public Function2<
            ? super List<? extends AudioDevice>,
            ? super AudioDevice,
            Unit> audioDeviceChangeListener = (devices, currentDevice) -> null;

    @NonNull
    private final ForwardingAudioFocusChangeListener audioFocusChangeListener = new ForwardingAudioFocusChangeListener();

    @Nullable
    private volatile Runnable audioFocusReleasedListener;

    @NonNull
    public List<Class<? extends AudioDevice>> preferredDeviceList;

    // AudioSwitch is not threadsafe, so all calls should be done on the main thread.
    private final Handler handler = new Handler(Looper.getMainLooper());

    @Nullable
    private AudioSwitch audioSwitch;

    /**
     * When true, AudioSwitchManager will request audio focus on start and abandon on stop.
     * <br />
     * Defaults to true.
     */
    private boolean manageAudioFocus = true;

    /**
     * The audio focus mode to use while started.
     * <br />
     * Defaults to AudioManager.AUDIOFOCUS_GAIN.
     */
    private int focusMode = AudioManager.AUDIOFOCUS_GAIN;

    /**
     * The audio mode to use while started.
     * <br />
     * Defaults to AudioManager.MODE_IN_COMMUNICATION.
     */
    private int audioMode = AudioManager.MODE_IN_COMMUNICATION;

    /**
     * The audio stream type to use when requesting audio focus on pre-O devices.
     * <br />
     * Defaults to AudioManager.STREAM_VOICE_CALL.
     * <br />
     * Refer to this <a href="https://source.android.com/docs/core/audio/attributes#compatibility">compatibility table</a>
     * to ensure that your values match between android versions.
     * <br />
     * Note: Manual audio routing may not work appropriately when using non-default values.
     */
    private int audioStreamType = AudioManager.STREAM_VOICE_CALL;

    /**
     * The audio attribute usage type to use when requesting audio focus on devices O and beyond.
     * <br />
     * Defaults to AudioAttributes.USAGE_VOICE_COMMUNICATION.
     * <br />
     * Refer to this <a href="https://source.android.com/docs/core/audio/attributes#compatibility">compatibility table</a>
     * to ensure that your values match between android versions.
     * <br />
     * Note: Manual audio routing may not work appropriately when using non-default values.
     */
    private int audioAttributeUsageType = AudioAttributes.USAGE_VOICE_COMMUNICATION;

    /**
     * The audio attribute content type to use when requesting audio focus on devices O and beyond.
     * <br />
     * Defaults to AudioAttributes.CONTENT_TYPE_SPEECH.
     * <br />
     * Refer to this <a href="https://source.android.com/docs/core/audio/attributes#compatibility">compatibility table</a>
     * to ensure that your values match between android versions.
     * <br />
     * Note: Manual audio routing may not work appropriately when using non-default values.
     */
    private int audioAttributeContentType = AudioAttributes.CONTENT_TYPE_SPEECH;

    /**
     * On certain Android devices, audio routing does not function properly and bluetooth microphones will not work
     * unless audio mode is set to [AudioManager.MODE_IN_COMMUNICATION] or [AudioManager.MODE_IN_CALL].
     *
     * AudioSwitchManager by default will not handle audio routing in those cases to avoid audio issues.
     *
     * If this set to true, AudioSwitchManager will attempt to do audio routing, though behavior is undefined.
     */
    private boolean forceHandleAudioRouting = false;

    public AudioSwitchManager(@NonNull Context context) {
        this.context = context;
        this.audioManager = (AudioManager) context.getSystemService(Context.AUDIO_SERVICE);

        preferredDeviceList = new ArrayList<>();
        preferredDeviceList.add(AudioDevice.BluetoothHeadset.class);
        preferredDeviceList.add(AudioDevice.WiredHeadset.class);
        preferredDeviceList.add(AudioDevice.Speakerphone.class);
        preferredDeviceList.add(AudioDevice.Earpiece.class);
        initAudioSwitch();
    }

    private void initAudioSwitch() {
        if (audioSwitch == null) {
            handler.removeCallbacksAndMessages(null);
            handler.postAtFrontOfQueue(() -> {
                audioSwitch = new AudioSwitch(
                        context,
                        loggingEnabled,
                        audioFocusChangeListener,
                        preferredDeviceList
                );
                audioSwitch.setManageAudioFocus(manageAudioFocus);
                audioSwitch.setFocusMode(focusMode);
                audioSwitch.setAudioMode(audioMode);
                audioSwitch.setAudioStreamType(audioStreamType);
                audioSwitch.setAudioAttributeContentType(audioAttributeContentType);
                audioSwitch.setAudioAttributeUsageType(audioAttributeUsageType);
                audioSwitch.setForceHandleAudioRouting(forceHandleAudioRouting);
                audioSwitch.start(audioDeviceChangeListener);
            });
        }
    }

    public void start() {
        if (audioSwitch != null) {
            // Called again for each audio track a call sends, so it leaves other posted work
            // in place.
            handler.removeCallbacksAndMessages(LIFECYCLE_TOKEN);
            postLifecycleAtFront(() -> {
                if (isActive) {
                    // A focus switch posted before a stop that was dropped above.
                    reconcileFocus();
                } else {
                    if (audioSwitch != null) {
                        modeBeforeCall = audioManager.getMode();
                        focusHolding.onStart(manageAudioFocus);
                        isActivating = true;
                        try {
                            ensureAudioConfigurationPersistsWith(() -> {
                                audioSwitch.activate();
                                isActive = true;
                            });
                        } finally {
                            isActivating = false;
                        }
                    }
                }
            });
        }
    }

    public void stop() {
        if (audioSwitch != null) {
            handler.removeCallbacksAndMessages(null);
            postLifecycleAtFront(() -> {
                if (isActive) {
                    Objects.requireNonNull(audioSwitch).deactivate();
                    isActive = false;
                    // AudioSwitch gives up only the focus it requested as it activated, not
                    // focus requested since. Giving up focus no one holds does nothing.
                    if (focusHolding.onStop()) {
                        abandonFocus();
                    }
                    // AudioSwitch puts back the mode it saw when it activated, which the
                    // call's own settings had already replaced.
                    audioManager.setMode(modeBeforeCall);
                    resetVolumeControlStream();

                    notifyAudioFocusReleased();
                }
            });
        }
    }

    private void postLifecycleAtFront(@NonNull Runnable runnable) {
        Message message = Message.obtain(handler, runnable);
        message.obj = LIFECYCLE_TOKEN;
        handler.sendMessageAtFrontOfQueue(message);
    }

    private void notifyAudioFocusReleased() {
        Runnable released = audioFocusReleasedListener;
        if (released != null) {
            released.run();
        }
    }

    public void setMicrophoneMute(boolean mute) {
        audioManager.setMicrophoneMute(mute);
    }

    @Nullable
    public AudioDevice selectedAudioDevice() {
        return Objects.requireNonNull(audioSwitch).getSelectedAudioDevice();
    }

    @NonNull
    public List<AudioDevice> availableAudioDevices() {
        return Objects.requireNonNull(audioSwitch).getAvailableAudioDevices();
    }

    public void selectAudioOutput(@NonNull Class<? extends AudioDevice> audioDeviceClass) {
        handler.post(() -> {
            List<AudioDevice> devices = availableAudioDevices();
            AudioDevice audioDevice = null;
            for (AudioDevice device : devices) {
                if (device.getClass().equals(audioDeviceClass)) {
                    audioDevice = device;
                    break;
                }
            }
            if (audioDevice != null) {
                final AudioDevice deviceToSelect = audioDevice;
                if (audioSwitch != null) {
                    ensureAudioConfigurationPersistsWith(() -> {
                        Objects.requireNonNull(audioSwitch).selectDevice(deviceToSelect);
                    });
                }
            }
        });
    }

    private void updatePreferredDeviceList(boolean speakerOn) {
        preferredDeviceList = new ArrayList<>();
        preferredDeviceList.add(AudioDevice.BluetoothHeadset.class);
        preferredDeviceList.add(AudioDevice.WiredHeadset.class);
        if (speakerOn) {
            preferredDeviceList.add(AudioDevice.Speakerphone.class);
            preferredDeviceList.add(AudioDevice.Earpiece.class);
        } else {
            preferredDeviceList.add(AudioDevice.Earpiece.class);
            preferredDeviceList.add(AudioDevice.Speakerphone.class);
        }
        handler.post(() -> {
            Objects.requireNonNull(audioSwitch).setPreferredDeviceList(preferredDeviceList);
        });
    }

    public void enableSpeakerphone(boolean enable) {
        updatePreferredDeviceList(enable);
        if (enable) {
            selectAudioOutput(AudioDevice.Speakerphone.class);
        } else {
            List<AudioDevice> devices = availableAudioDevices();
            AudioDevice audioDevice = null;
            for (AudioDevice device : devices) {
                if (device.getClass().equals(AudioDevice.BluetoothHeadset.class)) {
                    audioDevice = device;
                    break;
                } else if (device.getClass().equals(AudioDevice.WiredHeadset.class)) {
                    audioDevice = device;
                    break;
                } else if (device.getClass().equals(AudioDevice.Earpiece.class)) {
                    audioDevice = device;
                    break;
                }
            }
            if (audioDevice != null) {
                selectAudioOutput(audioDevice.getClass());
            } else {
                handler.post(() -> {
                    if (audioSwitch != null) {
                        ensureAudioConfigurationPersistsWith(() -> {
                            Objects.requireNonNull(audioSwitch).selectDevice(null);
                        });
                    }
                });
            }
        }
    }

    public void enableSpeakerButPreferBluetooth() {
        List<AudioDevice> devices = availableAudioDevices();
        AudioDevice audioDevice = null;
        for (AudioDevice device : devices) {
            if (device.getClass().equals(AudioDevice.BluetoothHeadset.class)) {
                audioDevice = device;
                break;
            } else if (device.getClass().equals(AudioDevice.WiredHeadset.class)) {
                audioDevice = device;
                break;
            }
        }

        if (audioDevice == null) {
            selectAudioOutput(AudioDevice.Speakerphone.class);
        } else {
            selectAudioOutput(audioDevice.getClass());
        }
    }

    public void selectAudioOutput(@Nullable AudioDeviceKind kind) {
        if (kind != null) {
            selectAudioOutput(kind.audioDeviceClass);
        }
    }

    public void setAudioConfiguration(Map<String, Object> configuration) {
        if (configuration == null) {
            return;
        }

        Boolean manageAudioFocus = null;
        if (configuration.get("manageAudioFocus") instanceof Boolean) {
            manageAudioFocus = (Boolean) configuration.get("manageAudioFocus");
        }
        setManageAudioFocus(manageAudioFocus);

        String audioMode = null;
        if (configuration.get("androidAudioMode") instanceof String) {
            audioMode = (String) configuration.get("androidAudioMode");
        }
        setAudioMode(audioMode);

        String focusMode = null;
        if (configuration.get("androidAudioFocusMode") instanceof String) {
            focusMode = (String) configuration.get("androidAudioFocusMode");
        }
        setFocusMode(focusMode);

        String streamType = null;
        if (configuration.get("androidAudioStreamType") instanceof String) {
            streamType = (String) configuration.get("androidAudioStreamType");
        }
        setAudioStreamType(streamType);

        String usageType = null;
        if (configuration.get("androidAudioAttributesUsageType") instanceof String) {
            usageType = (String) configuration.get("androidAudioAttributesUsageType");
        }
        setAudioAttributesUsageType(usageType);

        String contentType = null;
        if (configuration.get("androidAudioAttributesContentType") instanceof String) {
            contentType = (String) configuration.get("androidAudioAttributesContentType");
        }
        setAudioAttributesContentType(contentType);

        Boolean forceHandleAudioRouting = null;
        if (configuration.get("forceHandleAudioRouting") instanceof Boolean) {
            forceHandleAudioRouting = (Boolean) configuration.get("forceHandleAudioRouting");
        }
        setForceHandleAudioRouting(forceHandleAudioRouting);

        applyAudioManagerSettings();
    }

    /**
     * Switches whether WebRTC manages audio focus, also while a call's audio runs, such as for a
     * call the system's call framework holds and manages focus for.
     *
     * <p>Switched off while the call's audio runs, the focus held for it is given up, which ends an
     * interruption a focus loss started, and the audio mode and routing stay. Switched on, focus is
     * requested for it; a granted request is reported to the focus listener as a gain. While no
     * call's audio runs, it only applies to the next call. Null changes nothing.
     */
    public void setManageAudioFocus(@Nullable Boolean manage) {
        if (manage == null) {
            return;
        }
        // Set now, so a start or stop that drops the posted reconcile still sees it: start
        // reconciles itself, and stop gives up focus whatever this says.
        manageAudioFocus = manage;
        handler.post(this::reconcileFocus);
    }

    /** Brings AudioSwitch and the focus held for the call's audio in line with manageAudioFocus. */
    private void reconcileFocus() {
        if (audioSwitch != null) {
            Objects.requireNonNull(audioSwitch).setManageAudioFocus(manageAudioFocus);
        }

        switch (focusHolding.onManagedChanged(manageAudioFocus, isActive)) {
            case REQUEST:
                requestFocusForCall();
                break;
            case ABANDON:
                abandonFocus();
                focusHolding.onAbandoned();
                notifyAudioFocusReleased();
                break;
            case NONE:
                break;
        }
    }

    public void setAudioMode(@Nullable String audioModeString) {
        Integer audioMode = AudioUtils.getAudioModeForString(audioModeString);

        if (audioMode == null) {
            return;
        }
        this.audioMode = audioMode;
        if (audioSwitch != null) {
            Objects.requireNonNull(audioSwitch).setAudioMode(audioMode);
        }
    }

    public void setFocusMode(@Nullable String focusModeString) {
        Integer focusMode = AudioUtils.getFocusModeForString(focusModeString);

        if (focusMode == null) {
            return;
        }
        this.focusMode = focusMode;
        if (audioSwitch != null) {
            Objects.requireNonNull(audioSwitch).setFocusMode(focusMode);
        }
    }

    public void setAudioStreamType(@Nullable String streamTypeString) {
        Integer streamType = AudioUtils.getStreamTypeForString(streamTypeString);

        if (streamType == null) {
            return;
        }
        this.audioStreamType = streamType;
        if (audioSwitch != null) {
            Objects.requireNonNull(audioSwitch).setAudioStreamType(this.audioStreamType);
        }
    }

    public void setAudioAttributesUsageType(@Nullable String usageTypeString) {
        Integer usageType = AudioUtils.getAudioAttributesUsageTypeForString(usageTypeString);

        if (usageType == null) {
            return;
        }
        this.audioAttributeUsageType = usageType;
        if (audioSwitch != null) {
            Objects.requireNonNull(audioSwitch).setAudioAttributeUsageType(this.audioAttributeUsageType);
        }
    }

    public void setAudioAttributesContentType(@Nullable String contentTypeString) {
        Integer contentType = AudioUtils.getAudioAttributesContentTypeFromString(contentTypeString);

        if (contentType == null) {
            return;
        }
        this.audioAttributeContentType = contentType;
        if (audioSwitch != null) {
            Objects.requireNonNull(audioSwitch).setAudioAttributeContentType(this.audioAttributeContentType);
        }
    }

    public void setForceHandleAudioRouting(@Nullable Boolean force) {
        if (force != null) {
            this.forceHandleAudioRouting = force;
            if (audioSwitch != null) {
                Objects.requireNonNull(audioSwitch).setForceHandleAudioRouting(this.forceHandleAudioRouting);
            }
        }
    }

    /** Applies the call's audio mode; outside a call the device keeps the mode it is in. */
    private void applyAudioManagerSettings() {
        if (!isActive && !isActivating) {
            return;
        }
        audioManager.setMode(audioMode);
    }

    public void setActivity(@Nullable Activity activity) {
        this.activityRef = activity != null ? new WeakReference<>(activity) : null;
    }

    @Nullable
    private Activity getActivity() {
        return activityRef != null ? activityRef.get() : null;
    }

    private void applyVolumeControlStream() {
        if (!isActive && !isActivating) {
            return;
        }
        Activity activity = getActivity();
        if (activity != null && !activity.isFinishing() && !activity.isDestroyed()) {
            activity.setVolumeControlStream(audioStreamType);
        }
    }

    /** Lets the volume keys control the app's default stream again once the call's audio stops. */
    private void resetVolumeControlStream() {
        Activity activity = getActivity();
        if (activity != null && !activity.isFinishing() && !activity.isDestroyed()) {
            activity.setVolumeControlStream(AudioManager.USE_DEFAULT_STREAM_TYPE);
        }
    }

    private void applyAudioConfigurationSync() {
        if (audioSwitch == null) {
            return;
        }

        AudioSwitch localAudioSwitch = Objects.requireNonNull(audioSwitch);
        localAudioSwitch.setManageAudioFocus(manageAudioFocus);
        localAudioSwitch.setFocusMode(focusMode);
        localAudioSwitch.setAudioMode(audioMode);
        localAudioSwitch.setAudioStreamType(audioStreamType);
        localAudioSwitch.setAudioAttributeContentType(audioAttributeContentType);
        localAudioSwitch.setAudioAttributeUsageType(audioAttributeUsageType);
        localAudioSwitch.setForceHandleAudioRouting(forceHandleAudioRouting);
    }

    private void ensureAudioConfigurationPersistsWith(Runnable action) {
        applyAudioManagerSettings();

        action.run();
        applyAudioConfigurationSync();

        // Reapply the audio mode to ensure the audio is routed correctly.
        applyAudioManagerSettings();
        applyVolumeControlStream();
    }

    public void clearCommunicationDevice() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            audioManager.clearCommunicationDevice();
        }
    }

    public void setAudioFocusChangeListener(@Nullable AudioManager.OnAudioFocusChangeListener listener) {
        audioFocusChangeListener.setDelegate(listener);
    }

    /**
     * Sets the listener told when WebRTC gives up its audio focus because the call's audio
     * stopped, or clears it with null.
     */
    public void setAudioFocusReleasedListener(@Nullable Runnable listener) {
        audioFocusReleasedListener = listener;
    }

    /**
     * Requests audio focus again for the call's audio, such as after another app took it.
     *
     * <p>Does nothing while no call's audio runs or audio focus is not managed: an app in no call
     * holds no focus. A granted request is reported to the focus listener as a gain, since the
     * system reports none for it.
     */
    public void requestAudioFocus() {
        handler.post(() -> {
            if (audioSwitch == null || !isActive || !manageAudioFocus) {
                return;
            }
            requestFocusForCall();
        });
    }

    /**
     * Requests focus for the call's audio. AudioSwitch requests focus only when it activates, so
     * asking it to activate again requests nothing. The request has the same listener as
     * AudioSwitch's, so the system takes it for the same owner.
     */
    private void requestFocusForCall() {
        int result = requestFocus();
        focusHolding.onRequested(result == AudioManager.AUDIOFOCUS_REQUEST_FAILED);
        if (result == AudioManager.AUDIOFOCUS_REQUEST_GRANTED) {
            audioFocusChangeListener.onAudioFocusChange(AudioManager.AUDIOFOCUS_GAIN);
        }
    }

    @SuppressWarnings("deprecation")
    private int requestFocus() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            return audioManager.requestAudioFocus(focusRequest());
        }
        return audioManager.requestAudioFocus(audioFocusChangeListener, audioStreamType, focusMode);
    }

    /**
     * Gives up the focus held for the call's audio. The system finds the focus by its listener, the
     * same as AudioSwitch's, so this also gives up focus AudioSwitch requested.
     */
    @SuppressWarnings("deprecation")
    private void abandonFocus() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            audioManager.abandonAudioFocusRequest(focusRequest());
        } else {
            audioManager.abandonAudioFocus(audioFocusChangeListener);
        }
    }

    /** A focus request like AudioSwitch's, for API 26 and later. */
    @SuppressLint("NewApi")
    @NonNull
    private AudioFocusRequest focusRequest() {
        AudioAttributes attributes = new AudioAttributes.Builder()
                .setUsage(audioAttributeUsageType)
                .setContentType(audioAttributeContentType)
                .build();
        return new AudioFocusRequest.Builder(focusMode)
                .setAudioAttributes(attributes)
                .setAcceptsDelayedFocusGain(true)
                .setOnAudioFocusChangeListener(audioFocusChangeListener)
                .build();
    }

    private final class ForwardingAudioFocusChangeListener implements AudioManager.OnAudioFocusChangeListener {
        @Nullable
        private volatile AudioManager.OnAudioFocusChangeListener delegate;

        @Override
        public void onAudioFocusChange(int focusChange) {
            AudioManager.OnAudioFocusChangeListener current = delegate;
            if (current != null) {
                current.onAudioFocusChange(focusChange);
            }

            if (focusChange == AudioManager.AUDIOFOCUS_GAIN ||
                    focusChange == AudioManager.AUDIOFOCUS_GAIN_TRANSIENT ||
                    focusChange == AudioManager.AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK) {
                handler.post(() -> {
                    ensureAudioConfigurationPersistsWith(() -> {
                        // No action needed — just re-enforce current configuration
                    });
                });
            }
        }

        void setDelegate(@Nullable AudioManager.OnAudioFocusChangeListener delegate) {
            this.delegate = delegate;
        }
    }
}
