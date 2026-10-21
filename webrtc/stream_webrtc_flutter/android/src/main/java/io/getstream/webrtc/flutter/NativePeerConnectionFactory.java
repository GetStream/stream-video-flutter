package io.getstream.webrtc.flutter;

import android.content.Context;
import android.media.AudioAttributes;
import android.media.AudioManager;
import android.media.MediaRecorder;
import android.media.audiofx.AcousticEchoCanceler;
import android.media.audiofx.NoiseSuppressor;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.nio.ByteBuffer;
import java.util.Collection;
import java.util.List;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Supplier;

import org.webrtc.EglBase;
import org.webrtc.PeerConnectionFactory;
import org.webrtc.PeerConnectionFactory.Options;
import org.webrtc.audio.JavaAudioDeviceModule;

import io.getstream.webrtc.flutter.audio.AudioBufferMixer;
import io.getstream.webrtc.flutter.audio.AudioProcessingFactoryProvider;
import io.getstream.webrtc.flutter.audio.AudioUtils;
import io.getstream.webrtc.flutter.audio.LocalAudioTrack;
import io.getstream.webrtc.flutter.audio.PlaybackSamplesReadyCallbackAdapter;
import io.getstream.webrtc.flutter.audio.RecordSamplesReadyCallbackAdapter;
import io.getstream.webrtc.flutter.audio.SpeechActivityDetector;
import io.getstream.webrtc.flutter.utils.ConstraintsMap;
import io.getstream.webrtc.flutter.utils.EglUtils;
import org.webrtc.video.CustomVideoDecoderFactory;
import org.webrtc.video.CustomVideoEncoderFactory;

/**
 * Owns one PeerConnectionFactory and its associated audio + video state.
 */
public class NativePeerConnectionFactory {

    private static final String TAG = "NativePeerConnectionFactory";
    /** Live factory registry. Required to coordinate access to the
     *  process-global ExternalAudioProcessingFactory for noise cancellation: only one
     *  non-suspended factory may hold the external APM at a time. */
    private static final Set<NativePeerConnectionFactory> liveFactories =
            java.util.Collections.newSetFromMap(new ConcurrentHashMap<>());

    /** Inputs for a single NativePeerConnectionFactory build. */
    public static final class BuildContext {
        @NonNull
        public Context context;
        public boolean bypassVoiceProcessing;
        public int networkIgnoreMask;
        public boolean forceSWCodec;
        @NonNull
        public List<String> forceSWCodecList;
        @Nullable
        public ConstraintsMap androidAudioConfiguration;
        @Nullable
        public Integer audioSampleRate;
        @Nullable
        public Integer audioOutputSampleRate;
        @Nullable
        public AudioProcessingFactoryProvider audioProcessingFactoryProvider;
        @NonNull
        public StateProvider stateProvider;
        /**
         * Returns true when no local audio track in the process is currently
         * unmuted. Used by the audio-buffer-callback to gate screen-audio
         * mixing. The supplier is invoked from the audio device module's
         * capture thread.
         */
        @NonNull
        public Supplier<Boolean> isMicrophoneMutedSupplier;
        /**
         * Returns the process-wide collection of {@link LocalTrack}s.
         */
        @NonNull
        public Supplier<Collection<LocalTrack>> localTracksSupplier;
    }

    @NonNull
    public final String id;
    @NonNull
    public final PeerConnectionFactory factory;
    @NonNull
    public final JavaAudioDeviceModule adm;
    @NonNull
    public final GetUserMediaImpl getUserMediaImpl;

    /** True iff this factory was built with the external audio processing
     *  factory (e.g. noise cancellation). Set at build time; immutable. */
    public final boolean usesExternalApm;

    /** Audio-suspended flag — flipped via {@link #setAudioSuspended(boolean)}
     *  from the suspendAudio/resumeAudio method-channel handlers. Suspended
     *  factories are invisible to the external-APM grant logic when *another*
     *  factory is being built, so the new factory can claim the shared global
     *  APM. */
    private volatile boolean audioSuspended = false;
    @NonNull
    public final RecordSamplesReadyCallbackAdapter recordSamplesAdapter;
    @NonNull
    public final PlaybackSamplesReadyCallbackAdapter playbackSamplesAdapter;
    @NonNull
    public final CustomVideoEncoderFactory videoEncoderFactory;
    @NonNull
    public final CustomVideoDecoderFactory videoDecoderFactory;
    public final boolean bypassVoiceProcessing;
    @Nullable
    public final ConstraintsMap audioConfigSnapshot;
    @Nullable
    public final Integer audioSampleRate;
    @Nullable
    public final Integer audioOutputSampleRate;

    /** PCs created from this factory; populated by MethodCallHandlerImpl. */
    public final Set<String> ownedPcIds = ConcurrentHashMap.newKeySet();

    /**
     * IDs of tracks created via this factory.
     */
    public final Set<String> ownedTrackIds = ConcurrentHashMap.newKeySet();

    /** IDs of streams created via this factory. */
    public final Set<String> ownedStreamIds = ConcurrentHashMap.newKeySet();

    private volatile boolean disposed = false;

    private NativePeerConnectionFactory(
            @NonNull String id,
            @NonNull PeerConnectionFactory factory,
            @NonNull JavaAudioDeviceModule adm,
            @NonNull GetUserMediaImpl getUserMediaImpl,
            @NonNull RecordSamplesReadyCallbackAdapter recordSamplesAdapter,
            @NonNull PlaybackSamplesReadyCallbackAdapter playbackSamplesAdapter,
            @NonNull CustomVideoEncoderFactory videoEncoderFactory,
            @NonNull CustomVideoDecoderFactory videoDecoderFactory,
            boolean bypassVoiceProcessing,
            @Nullable ConstraintsMap audioConfigSnapshot,
            @Nullable Integer audioSampleRate,
            @Nullable Integer audioOutputSampleRate,
            boolean usesExternalApm) {
        this.id = id;
        this.factory = factory;
        this.adm = adm;
        this.getUserMediaImpl = getUserMediaImpl;
        this.recordSamplesAdapter = recordSamplesAdapter;
        this.playbackSamplesAdapter = playbackSamplesAdapter;
        this.videoEncoderFactory = videoEncoderFactory;
        this.videoDecoderFactory = videoDecoderFactory;
        this.bypassVoiceProcessing = bypassVoiceProcessing;
        this.audioConfigSnapshot = audioConfigSnapshot;
        this.audioSampleRate = audioSampleRate;
        this.audioOutputSampleRate = audioOutputSampleRate;
        this.usesExternalApm = usesExternalApm;
    }

    private static boolean anyActiveFactoryHoldsExternalApm() {
        for (NativePeerConnectionFactory f : liveFactories) {
            if (f.usesExternalApm && !f.audioSuspended && !f.disposed) {
                return true;
            }
        }
        return false;
    }

    public boolean isAudioSuspended() {
        return audioSuspended;
    }

    public void setAudioSuspended(boolean value) {
        this.audioSuspended = value;
    }

    /**
     * Builds a fresh factory + ADM bundle.
     */
    @NonNull
    public static NativePeerConnectionFactory build(@NonNull String id, @NonNull BuildContext ctx) {
        Log.i(TAG, "[build] id: " + id
                + " bypassVoiceProcessing: " + ctx.bypassVoiceProcessing
                + " audioSampleRate: " + ctx.audioSampleRate
                + " audioOutputSampleRate: " + ctx.audioOutputSampleRate);

        final GetUserMediaImpl getUserMediaImpl =
                new GetUserMediaImpl(ctx.stateProvider, ctx.context);
        getUserMediaImpl.setAudioChannelCount(ctx.bypassVoiceProcessing ? 2 : 1);

        AudioAttributes audioAttributes = null;
        if (ctx.androidAudioConfiguration != null) {
            Integer usageType = AudioUtils.getAudioAttributesUsageTypeForString(
                    ctx.androidAudioConfiguration.getString("androidAudioAttributesUsageType"));
            Integer contentType = AudioUtils.getAudioAttributesContentTypeFromString(
                    ctx.androidAudioConfiguration.getString("androidAudioAttributesContentType"));

            if (usageType != null && contentType != null) {
                audioAttributes = new AudioAttributes.Builder()
                        .setUsage(usageType)
                        .setContentType(contentType)
                        .build();
            }
        }

        final JavaAudioDeviceModule.Builder admBuilder = JavaAudioDeviceModule.builder(ctx.context);
        final boolean isDeviceSupportHWAec = AcousticEchoCanceler.isAvailable();
        final boolean isDeviceSupportHWNs = NoiseSuppressor.isAvailable();

        if (audioAttributes != null) {
            admBuilder.setAudioAttributes(audioAttributes);
        }

        final RecordSamplesReadyCallbackAdapter recordSamplesAdapter =
                new RecordSamplesReadyCallbackAdapter();
        final PlaybackSamplesReadyCallbackAdapter playbackSamplesAdapter =
                new PlaybackSamplesReadyCallbackAdapter();

        if (ctx.bypassVoiceProcessing) {
            admBuilder.setUseHardwareAcousticEchoCanceler(false)
                    .setUseHardwareNoiseSuppressor(false)
                    .setUseStereoInput(true)
                    .setUseStereoOutput(true)
                    .setAudioSource(MediaRecorder.AudioSource.MIC);
        } else {
            admBuilder
                    .setUseHardwareAcousticEchoCanceler(isDeviceSupportHWAec)
                    .setUseHardwareNoiseSuppressor(isDeviceSupportHWNs)
                    .setAudioSource(MediaRecorder.AudioSource.VOICE_COMMUNICATION);
        }

        // Configure audio sample rates if specified. Allows high-quality audio
        // playback instead of defaulting to WebRtcAudioManager's queried rate.
        if (ctx.audioSampleRate != null) {
            Log.i(TAG, "Setting audio sample rate (both input and output) to: "
                    + ctx.audioSampleRate + " Hz");
            admBuilder.setSampleRate(ctx.audioSampleRate);
        }

        // audioOutputSampleRate takes precedence over audioSampleRate for
        // output.
        if (ctx.audioOutputSampleRate != null) {
            Log.i(TAG, "Setting audio output sample rate to: "
                    + ctx.audioOutputSampleRate + " Hz");
            admBuilder.setOutputSampleRate(ctx.audioOutputSampleRate);
        } else if (ctx.bypassVoiceProcessing
                && ctx.audioSampleRate == null
                && ctx.audioOutputSampleRate == null) {
            // When bypassVoiceProcessing is enabled, use the device's native
            // optimal sample rate. This prevents the default behavior which
            // may use a low sample rate based on audio mode.
            AudioManager am = (AudioManager) ctx.context.getSystemService(Context.AUDIO_SERVICE);
            if (am != null) {
                String nativeSampleRateStr =
                        am.getProperty(AudioManager.PROPERTY_OUTPUT_SAMPLE_RATE);
                int nativeSampleRate = 48000; // fallback default
                if (nativeSampleRateStr != null) {
                    try {
                        nativeSampleRate = Integer.parseInt(nativeSampleRateStr);
                    } catch (NumberFormatException e) {
                        Log.w(TAG, "Failed to parse native sample rate, using default: "
                                + e.getMessage());
                    }
                }
                Log.i(TAG, "bypassVoiceProcessing enabled with no explicit sample rate"
                        + " - using device's native optimal rate: " + nativeSampleRate + " Hz");
                admBuilder.setOutputSampleRate(nativeSampleRate);
            } else {
                Log.w(TAG, "AudioManager not available, defaulting to 48000 Hz output");
                admBuilder.setOutputSampleRate(48000);
            }
        }

        admBuilder.setSamplesReadyCallback(recordSamplesAdapter);
        admBuilder.setPlaybackSamplesReadyCallback(playbackSamplesAdapter);

        recordSamplesAdapter.addCallback(getUserMediaImpl.inputSamplesInterceptor);
        recordSamplesAdapter.addCallback(audioSamples -> {
            // only iterate tracks owned by THIS factory's getUserMediaImpl.
            for (LocalTrack track : ctx.localTracksSupplier.get()) {
                if (!(track instanceof LocalAudioTrack)) continue;
                final String trackId;
                try {
                    trackId = track.id();
                } catch (Throwable t) {
                    continue;
                }
                if (!getUserMediaImpl.ownsTrack(trackId)) continue;
                try {
                    ((LocalAudioTrack) track).onWebRtcAudioRecordSamplesReady(audioSamples);
                } catch (Throwable t) {
                    Log.w(TAG, "[recordSamplesAdapter] track delivery failed for "
                            + trackId + ": " + t);
                }
            }
        });

        // Speaking-while-muted detector. Posts onSpeechActivityChanged events through
        // FlutterWebRTCPlugin's eventSink.
        final SpeechActivityDetector speechDetector = new SpeechActivityDetector(speaking -> {
            FlutterWebRTCPlugin plugin = FlutterWebRTCPlugin.sharedSingleton;
            if (plugin == null) return;
            ConstraintsMap event = new ConstraintsMap();
            event.putString("event", "onSpeechActivityChanged");
            event.putString("type", speaking ? "started" : "ended");
            plugin.sendEvent(event.toMap());
        });
        recordSamplesAdapter.addCallback(speechDetector);

        // Audio buffer callback for screen-audio mixing.
        admBuilder.setAudioBufferCallback(
                (audioBuffer, audioFormat, channelCount, sampleRate, bytesRead, captureTimeNs) -> {
                    boolean micMuted = isMicrophoneMutedForFactory(getUserMediaImpl,
                            ctx.localTracksSupplier);
                    if (!micMuted && bytesRead > 0 && getUserMediaImpl.isScreenAudioEnabled()) {
                        try {
                            ByteBuffer screenAudioBuffer =
                                    getUserMediaImpl.getScreenAudioBytes(bytesRead);
                            if (screenAudioBuffer != null && screenAudioBuffer.remaining() > 0) {
                                AudioBufferMixer.mixScreenAudioWithMicrophone(
                                        audioBuffer,
                                        screenAudioBuffer,
                                        bytesRead);
                            }
                        } catch (Throwable t) {
                            Log.w(TAG, "[audioBufferCallback] screen-audio mix failed: " + t);
                        }
                    }
                    return captureTimeNs;
                });

        final JavaAudioDeviceModule adm = admBuilder.createAudioDeviceModule();

        if (!ctx.bypassVoiceProcessing && isDeviceSupportHWNs) {
            adm.setNoiseSuppressorEnabled(true);
        }

        getUserMediaImpl.audioDeviceModule = adm;

        EglBase.Context eglContext = EglUtils.getRootEglBaseContext();

        CustomVideoEncoderFactory videoEncoderFactory =
                new CustomVideoEncoderFactory(eglContext, true, true);
        CustomVideoDecoderFactory videoDecoderFactory =
                new CustomVideoDecoderFactory(eglContext);

        videoDecoderFactory.setForceSWCodec(ctx.forceSWCodec);
        videoDecoderFactory.setForceSWCodecList(ctx.forceSWCodecList);

        // TODO: Disabled software encoding for now, only using software decoding. See FLU-120
        // videoEncoderFactory.setForceSWCodec(forceSWCodec);
        // videoEncoderFactory.setForceSWCodecList(forceSWCodecList);

        final Options options = new Options();
        options.networkIgnoreMask = ctx.networkIgnoreMask;

        // Decide whether THIS factory should be wired to the external audio
        // processing factory (noise cancellation).
        // The ExternalAudioProcessingFactory is process-global, so
        // only one factory may hold it at a time. 
        final boolean wantsExternalApm = ctx.audioProcessingFactoryProvider != null;
        final boolean grantExternalApm =
                wantsExternalApm && !anyActiveFactoryHoldsExternalApm();
        if (wantsExternalApm && !grantExternalApm) {
            Log.i(TAG, "[build] external APM skipped for factory " + id
                    + " — another non-suspended factory holds the global APM."
                    + " Suspend its audio first to grant external processing here.");
        }

        PeerConnectionFactory.Builder pcFactoryBuilder = PeerConnectionFactory.builder()
                .setOptions(options)
                .setVideoEncoderFactory(videoEncoderFactory)
                .setVideoDecoderFactory(videoDecoderFactory)
                .setAudioDeviceModule(adm);
                
        if (grantExternalApm) {
            pcFactoryBuilder.setAudioProcessingFactory(
                    ctx.audioProcessingFactoryProvider.getFactory());
        }
        PeerConnectionFactory factory = pcFactoryBuilder.createPeerConnectionFactory();

        getUserMediaImpl.setPeerConnectionFactory(factory);

        final NativePeerConnectionFactory nf = new NativePeerConnectionFactory(
                id,
                factory,
                adm,
                getUserMediaImpl,
                recordSamplesAdapter,
                playbackSamplesAdapter,
                videoEncoderFactory,
                videoDecoderFactory,
                ctx.bypassVoiceProcessing,
                ctx.androidAudioConfiguration,
                ctx.audioSampleRate,
                ctx.audioOutputSampleRate,
                grantExternalApm);
        liveFactories.add(nf);
        return nf;
    }

    /**
     * Releases the factory, the ADM, and clears the GetUserMediaImpl audio
     * device module reference. Camera work in flight on
     * {@link #getUserMediaImpl}, an open or a release, uses a video source on
     * this factory, so then the factory and ADM are freed on the camera
     * thread once that work is done, instead of here under it.
     */
    public void dispose() {
        if (disposed) {
            return;
        }
        disposed = true;
        liveFactories.remove(this);

        try {
            getUserMediaImpl.audioDeviceModule = null;
        } catch (Throwable t) {
            Log.w(TAG, "[dispose] clearing getUserMediaImpl.audioDeviceModule: " + t);
        }

        final Runnable free = () -> {
            try {
                factory.dispose();
            } catch (Throwable t) {
                Log.w(TAG, "[dispose] factory.dispose: " + t);
            }

            try {
                adm.release();
            } catch (Throwable t) {
                Log.w(TAG, "[dispose] adm.release: " + t);
            }
        };

        if (getUserMediaImpl.freeFactoryAfterCameraOpens(free)) {
            free.run();
        } else {
            Log.i(TAG, "[dispose] camera work in flight; freeing the factory after it");
        }
    }

    public boolean isDisposed() {
        return disposed;
    }

    private static boolean isMicrophoneMutedForFactory(
            GetUserMediaImpl getUserMediaImpl,
            Supplier<Collection<LocalTrack>> tracksSupplier) {
        for (LocalTrack track : tracksSupplier.get()) {
            if (!(track instanceof LocalAudioTrack)) continue;
            final String trackId;
            try {
                trackId = track.id();
            } catch (Throwable t) {
                continue;
            }
            if (!getUserMediaImpl.ownsTrack(trackId)) continue;
            try {
                if (track.enabled()) {
                    return false;
                }
            } catch (Throwable t) {
                // Native ref already gone; treat as muted.
            }
        }
        return true;
    }
}
