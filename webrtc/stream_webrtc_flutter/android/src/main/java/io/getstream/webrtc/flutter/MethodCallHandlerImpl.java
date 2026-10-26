package io.getstream.webrtc.flutter;

import static io.getstream.webrtc.flutter.utils.MediaConstraintsUtils.parseMediaConstraints;

import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.SurfaceTexture;
import android.hardware.Camera;
import android.hardware.Camera.CameraInfo;
import android.media.AudioManager;
import android.media.AudioDeviceInfo;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.util.LongSparseArray;
import android.view.Surface;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;

import io.getstream.webrtc.flutter.audio.AudioDeviceKind;
import io.getstream.webrtc.flutter.audio.AudioProcessingFactoryProvider;
import io.getstream.webrtc.flutter.audio.AudioProcessingController;
import io.getstream.webrtc.flutter.audio.AudioSwitchManager;
import io.getstream.webrtc.flutter.audio.AudioFocusManager;
import io.getstream.webrtc.flutter.audio.AudioUtils;
import io.getstream.webrtc.flutter.audio.LocalAudioTrack;
import io.getstream.webrtc.flutter.record.AudioChannel;
import io.getstream.webrtc.flutter.record.FrameCapturer;
import io.getstream.webrtc.flutter.utils.AnyThreadResult;
import io.getstream.webrtc.flutter.utils.Callback;
import io.getstream.webrtc.flutter.utils.ConstraintsArray;
import io.getstream.webrtc.flutter.utils.ConstraintsMap;
import io.getstream.webrtc.flutter.utils.ObjectType;
import io.getstream.webrtc.flutter.utils.PermissionUtils;
import io.getstream.webrtc.flutter.utils.Utils;
import io.getstream.webrtc.flutter.video.VideoCapturerInfo;
import io.getstream.webrtc.flutter.video.camera.CameraUtils;
import io.getstream.webrtc.flutter.video.camera.Point;
import io.getstream.webrtc.flutter.video.LocalVideoTrack;
import com.twilio.audioswitch.AudioDevice;

import org.webrtc.AudioTrack;
import org.webrtc.CryptoOptions;
import org.webrtc.DtmfSender;
import org.webrtc.IceCandidate;
import org.webrtc.Logging;
import org.webrtc.Logging.Severity;
import org.webrtc.Loggable;
import org.webrtc.MediaConstraints;
import org.webrtc.MediaConstraints.KeyValuePair;
import org.webrtc.MediaStream;
import org.webrtc.MediaStreamTrack;
import org.webrtc.PeerConnection;
import org.webrtc.PeerConnection.BundlePolicy;
import org.webrtc.PeerConnection.CandidateNetworkPolicy;
import org.webrtc.PeerConnection.ContinualGatheringPolicy;
import org.webrtc.PeerConnection.IceServer;
import org.webrtc.PeerConnection.IceServer.Builder;
import org.webrtc.PeerConnection.IceTransportsType;
import org.webrtc.PeerConnection.KeyType;
import org.webrtc.PeerConnection.RTCConfiguration;
import org.webrtc.PeerConnection.RtcpMuxPolicy;
import org.webrtc.PeerConnection.SdpSemantics;
import org.webrtc.PeerConnection.TcpCandidatePolicy;
import org.webrtc.PeerConnectionFactory;
import org.webrtc.PeerConnectionFactory.InitializationOptions;
import org.webrtc.PeerConnectionFactory.Options;
import org.webrtc.RtpCapabilities;
import org.webrtc.RtpSender;
import org.webrtc.SdpObserver;
import org.webrtc.SessionDescription;
import org.webrtc.SessionDescription.Type;
import org.webrtc.VideoTrack;
import org.webrtc.audio.JavaAudioDeviceModule;

import java.io.File;
import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.RejectedExecutionException;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.view.TextureRegistry;
import io.flutter.view.TextureRegistry.SurfaceTextureEntry;

public class MethodCallHandlerImpl implements MethodCallHandler, StateProvider {
  static public final String TAG = "FlutterWebRTCPlugin";

  private final ConcurrentHashMap<String, PeerConnectionObserver> mPeerConnectionObservers = new ConcurrentHashMap<>();
  private final BinaryMessenger messenger;
  private final Context context;
  private final TextureRegistry textures;
  private final ConcurrentHashMap<String, MediaStream> localStreams = new ConcurrentHashMap<>();
  private final ConcurrentHashMap<String, LocalTrack> localTracks = new ConcurrentHashMap<>();
  private final LongSparseArray<FlutterRTCVideoRenderer> renders = new LongSparseArray<>();

  private CameraUtils cameraUtils;

  private AudioFocusManager audioFocusManager;

  /**
   * Common Stream implementation for AES-GCM end-to-end encryption,
   * used across all Stream SDKs (JS, iOS, Android, Flutter).
   * This is independent of per-call factories: the manager owns keys,
   * not media.
   */
  private final FlutterRTCEncryptionManager encryptionManager;

  private Activity activity;

  public AudioProcessingFactoryProvider audioProcessingFactoryProvider;

  private final ConcurrentHashMap<String, Double> trackVolumeCache = new ConcurrentHashMap<>();
  private final ConcurrentHashMap<String, Double> pausedTrackVolumes = new ConcurrentHashMap<>();
  private volatile boolean isAudioPlayoutPaused = false;

  public static class LogSink implements Loggable {
    @Override
    public void onLogMessage(String message, Severity sev, String tag) {
      ConstraintsMap params = new ConstraintsMap();
      params.putString("event", "onLogData");
      params.putString("data", message);
      FlutterWebRTCPlugin.sharedSingleton.sendEvent(params.toMap());
    }
  }

  ExecutorService executor = Executors.newSingleThreadExecutor();

  /**
   * Runs the camera and microphone part of {@link #getSources}, which is slow
   * enough (camera HAL queries) to stall the UI when run on the main thread.
   */
  private final ExecutorService deviceEnumerationExecutor =
      Executors.newSingleThreadExecutor(r -> new Thread(r, "DeviceEnumeration"));

  /**
   * Camera entries of {@link #getSources}, reused while the number of cameras
   * stays the same. Only touched on {@link #deviceEnumerationExecutor}.
   */
  @Nullable
  private List<ConstraintsMap> cachedCameraSources;
  Handler mainHandler = new Handler(Looper.getMainLooper());

  /**
   * Closes peer connections off the main thread. Closing is a synchronous call
   * into WebRTC's signaling thread that waits for the whole teardown, hundreds
   * of milliseconds with media running, and since Flutter 3.29 the main thread
   * also runs Dart. Single-threaded so factory disposal can wait for pending
   * closes by queueing behind them.
   */
  private final ExecutorService peerConnectionCloseExecutor =
      Executors.newSingleThreadExecutor(r -> new Thread(r, "PeerConnectionClose"));

  /**
   * Peer connections being disposed: closing on peerConnectionCloseExecutor,
   * then freed on the main thread. They are already out of
   * mPeerConnectionObservers, so audio shutdown and engine detach find them
   * here. Main thread only.
   */
  private final Map<String, PeerConnectionObserver> disposingPeerConnections = new HashMap<>();

  public static LogSink logSink = new LogSink();

  MethodCallHandlerImpl(Context context, BinaryMessenger messenger, TextureRegistry textureRegistry) {
    this.context = context;
    this.textures = textureRegistry;
    this.messenger = messenger;
    this.encryptionManager = new FlutterRTCEncryptionManager(this);
  }

  static private void resultError(String method, String error, Result result) {
    String errorMsg = method + "(): " + error;
    result.error(method, errorMsg, null);
    Log.d(TAG, errorMsg);
  }

  /**
   * Disposes peer connections, tracks, streams, and every
   * registered {@link NativePeerConnectionFactory}.
   * PCs must be released before their owning factory is disposed,
   * otherwise libwebrtc native state crashes when the factory's ADM is already disposed.
   */
  void dispose() {
    encryptionManager.disposeAll();
    deviceEnumerationExecutor.shutdown();

    // Peer connections closed or disposed from Dart may still be closing on
    // peerConnectionCloseExecutor. Wait for them and free them here, or the
    // factories below are freed under them. Their pending main-thread posts
    // then find nothing to do.
    peerConnectionCloseExecutor.shutdown();
    String notClosed = null;
    try {
      if (!peerConnectionCloseExecutor.awaitTermination(5, TimeUnit.SECONDS)) {
        notClosed = "timed out";
      }
    } catch (InterruptedException e) {
      Thread.currentThread().interrupt();
      notClosed = "interrupted";
    }
    // A connection still inside close() uses its factory's native state, so
    // freeing either is a use-after-free. When the wait fails, leak the peer
    // connections and the factories instead.
    final boolean closed = notClosed == null;
    if (closed) {
      for (final PeerConnectionObserver pco : disposingPeerConnections.values()) {
        try {
          pco.dispose();
        } catch (Throwable t) {
          Log.w(TAG, "dispose: peer connection dispose failed: " + t);
        }
      }
    } else {
      Log.w(TAG, "dispose: " + notClosed + " waiting for peer connections to close;"
          + " leaking them and their factories");
    }
    disposingPeerConnections.clear();

    if (AudioSwitchManager.instance != null) {
      AudioSwitchManager.instance.setAudioFocusChangeListener(null);
    }
    if (audioFocusManager != null) {
      audioFocusManager.setAudioFocusChangeListener(null);
      audioFocusManager = null;
    }

    try {
      if (closed) {
        for (final PeerConnectionObserver connection : mPeerConnectionObservers.values()) {
          peerConnectionDispose(connection);
        }
      }
      mPeerConnectionObservers.clear();

      for (final LocalTrack track : localTracks.values()) {
        try {
          track.dispose();
        } catch (Exception e) {
          Log.e(TAG, "dispose: error disposing local track", e);
        }
      }
      localTracks.clear();

      for (final MediaStream mediaStream : localStreams.values()) {
        try {
          streamDispose(mediaStream);
          mediaStream.dispose();
        } catch (Exception e) {
          Log.e(TAG, "dispose: error disposing media stream", e);
        }
      }
      localStreams.clear();
    } catch (Exception e) {
      Log.e(TAG, "dispose: error disposing resources", e);
    }

    if (closed) {
      for (NativePeerConnectionFactory nf : factories.values()) {
        try {
          nf.dispose();
        } catch (Throwable t) {
          Log.w(TAG, "[dispose] native factory dispose failed: " + t);
        }
      }
    }

    factories.clear();
    pcFactoryId.clear();
  }

  /**
   * Resolves a {@code factoryId} to a {@link NativePeerConnectionFactory}.
   */
  @Nullable
  private NativePeerConnectionFactory resolveFactory(@Nullable String factoryId) {
    if (factoryId == null || factoryId.isEmpty()) {
      return null;
    }
    return factories.get(factoryId);
  }

  /**
   * Resolves the {@link NativePeerConnectionFactory} that owns the capturer/audio source
   * for {@code trackId}.
   *
   * Returns {@code null} when no registered factory owns the track.
   */
  @Nullable
  private NativePeerConnectionFactory resolveFactoryForTrack(@Nullable String trackId) {
    if (trackId == null) return null;
    for (NativePeerConnectionFactory nf : factories.values()) {
      if (nf.ownedTrackIds.contains(trackId)) return nf;
      if (nf.getUserMediaImpl != null && nf.getUserMediaImpl.ownsTrack(trackId)) {
        return nf;
      }
    }
    return null;
  }

  /**
   * Resolves the {@link NativePeerConnectionFactory} that owns the local
   * {@link MediaStream} registered under {@code streamId}.
   *
   * Returns {@code null} when no registered factory owns the stream.
   */
  @Nullable
  private NativePeerConnectionFactory resolveFactoryForStream(@Nullable String streamId) {
    if (streamId == null) return null;
    for (NativePeerConnectionFactory nf : factories.values()) {
      if (nf.ownedStreamIds.contains(streamId)) return nf;
    }
    return null;
  }

  /**
   * Resolves the {@link NativePeerConnectionFactory} that owns the {@code MediaRecorder}
   * registered under {@code recorderId}.
   *
   * Returns {@code null} when no registered factory owns the recorder.
   */
  @Nullable
  private NativePeerConnectionFactory resolveFactoryForRecorder(int recorderId) {
    for (NativePeerConnectionFactory nf : factories.values()) {
      if (nf.getUserMediaImpl != null && nf.getUserMediaImpl.ownsRecorder(recorderId)) {
        return nf;
      }
    }
    return null;
  }

  /**
   * Pushes the preferred audio input device to every active
   * {@link NativePeerConnectionFactory}'s {@link GetUserMediaImpl}.
   */
  private void broadcastPreferredInputDevice(@Nullable String deviceId) {
    if (deviceId == null) {
      return;
    }
    for (NativePeerConnectionFactory nf : factories.values()) {
      if (nf.getUserMediaImpl != null) {
        nf.getUserMediaImpl.setPreferredInputDevice(deviceId);
      }
    }
  }

  /**
   * Builds a fresh per-call {@link NativePeerConnectionFactory} from the supplied options
   * map and registers it under a fresh UUID.
   */
  @NonNull
  private String createPeerConnectionFactoryHandler(@NonNull ConstraintsMap options) {
    boolean bypassVoiceProcessing = false;
    if (options.hasKey("bypassVoiceProcessing")
        && options.getType("bypassVoiceProcessing") == ObjectType.Boolean) {
      bypassVoiceProcessing = options.getBoolean("bypassVoiceProcessing");
    }

    int networkIgnoreMask = Options.ADAPTER_TYPE_UNKNOWN;
    if (options.hasKey("networkIgnoreMask")
        && options.getType("networkIgnoreMask") == ObjectType.Array) {
      ConstraintsArray ignoredAdapters = options.getArray("networkIgnoreMask");
      if (ignoredAdapters != null) {
        for (Object adapter : ignoredAdapters.toArrayList()) {
          switch (adapter.toString()) {
            case "adapterTypeEthernet":
              networkIgnoreMask += Options.ADAPTER_TYPE_ETHERNET;
              break;
            case "adapterTypeWifi":
              networkIgnoreMask += Options.ADAPTER_TYPE_WIFI;
              break;
            case "adapterTypeCellular":
              networkIgnoreMask += Options.ADAPTER_TYPE_CELLULAR;
              break;
            case "adapterTypeVpn":
              networkIgnoreMask += Options.ADAPTER_TYPE_VPN;
              break;
            case "adapterTypeLoopback":
              networkIgnoreMask += Options.ADAPTER_TYPE_LOOPBACK;
              break;
            case "adapterTypeAny":
              networkIgnoreMask += Options.ADAPTER_TYPE_ANY;
              break;
          }
        }
      }
    }

    boolean forceSWCodec = false;
    if (options.hasKey("forceSWCodec")
        && options.getType("forceSWCodec") == ObjectType.Boolean) {
      forceSWCodec = options.getBoolean("forceSWCodec");
    }

    List<String> forceSWCodecList = new ArrayList<>();
    if (options.hasKey("forceSWCodecList")
        && options.getType("forceSWCodecList") == ObjectType.Array) {
      List<Object> array = options.getListArray("forceSWCodecList");
      for (Object v : array) {
        forceSWCodecList.add(v.toString());
      }
    } else {
      // HW codecs disabled for VP9 / AV1.
      forceSWCodecList.add("VP9");
      forceSWCodecList.add("AV1");
    }

    ConstraintsMap androidAudioConfiguration = null;
    if (options.hasKey("androidAudioConfiguration")
        && options.getType("androidAudioConfiguration") == ObjectType.Map) {
      androidAudioConfiguration = options.getMap("androidAudioConfiguration");
    }

    Integer audioSampleRate = null;
    if (options.hasKey("audioSampleRate")
        && options.getType("audioSampleRate") == ObjectType.Number) {
      audioSampleRate = options.getInt("audioSampleRate");
    }

    Integer audioOutputSampleRate = null;
    if (options.hasKey("audioOutputSampleRate")
        && options.getType("audioOutputSampleRate") == ObjectType.Number) {
      audioOutputSampleRate = options.getInt("audioOutputSampleRate");
    }

    // TODO: Audio switch manager is global and the latest configuration is applied to all factories. Check if can be handled better.
    if (androidAudioConfiguration != null && AudioSwitchManager.instance != null) {
      AudioSwitchManager.instance.setAudioConfiguration(
          androidAudioConfiguration.toMap());
    }

    final NativePeerConnectionFactory.BuildContext ctx = new NativePeerConnectionFactory.BuildContext();
    ctx.context = context;
    ctx.bypassVoiceProcessing = bypassVoiceProcessing;
    ctx.networkIgnoreMask = networkIgnoreMask;
    ctx.forceSWCodec = forceSWCodec;
    ctx.forceSWCodecList = forceSWCodecList;
    ctx.androidAudioConfiguration = androidAudioConfiguration;
    ctx.audioSampleRate = audioSampleRate;
    ctx.audioOutputSampleRate = audioOutputSampleRate;
    ctx.audioProcessingFactoryProvider = audioProcessingFactoryProvider;
    ctx.stateProvider = this;
    ctx.isMicrophoneMutedSupplier = this::isMicrophoneMuted;
    ctx.localTracksSupplier = () -> localTracks.values();

    final String factoryId = java.util.UUID.randomUUID().toString();
    final NativePeerConnectionFactory nf = NativePeerConnectionFactory.build(factoryId, ctx);
    factories.put(factoryId, nf);
    Log.i(TAG, "[createPeerConnectionFactory] built id: " + factoryId);
    return factoryId;
  }

  /**
   * Disposes the {@link NativePeerConnectionFactory} registered under {@code factoryId}.
   * Defensively disposes any peer connections still owned by the factory.
   */
  private void disposePeerConnectionFactoryHandler(@NonNull String factoryId) {
    final NativePeerConnectionFactory nf = factories.remove(factoryId);
    if (nf == null) {
      Log.w(TAG, "[disposePeerConnectionFactory] unknown factoryId: " + factoryId);
      return;
    }

    Log.i(TAG, "[disposePeerConnectionFactory] disposing id: " + factoryId
        + ", ownedPcs: " + nf.ownedPcIds.size()
        + ", ownedTracks: " + nf.ownedTrackIds.size()
        + ", ownedStreams: " + nf.ownedStreamIds.size());

    // Build the full set of trackIds that will become invalid the moment
    // the factory's peer goes away.
    final java.util.Set<String> dyingTrackIds =
        new java.util.HashSet<>(nf.ownedTrackIds);

    for (String pcId : nf.ownedPcIds) {
      final PeerConnectionObserver pco = mPeerConnectionObservers.get(pcId);
      if (pco == null) continue;

      dyingTrackIds.addAll(pco.remoteTracks.keySet());
      for (MediaStream s : pco.remoteStreams.values()) {
        for (VideoTrack t : s.videoTracks) {
          try { dyingTrackIds.add(t.id()); } catch (Throwable ignored) {}
        }
        for (AudioTrack t : s.audioTracks) {
          try { dyingTrackIds.add(t.id()); } catch (Throwable ignored) {}
        }
      }
    }

    // 1. Detach every renderer still bound to a dying track.
    if (!dyingTrackIds.isEmpty()) {
      for (int i = 0; i < renders.size(); i++) {
        final FlutterRTCVideoRenderer renderer = renders.valueAt(i);
        if (renderer == null) continue;
        try {
          renderer.detachIfRenderingAny(dyingTrackIds);
        } catch (Throwable t) {
          Log.w(TAG, "[disposePeerConnectionFactory] renderer detach failed: " + t);
        }
      }
    }

    // 2. Defensively dispose any PCs the SDK forgot.
    for (String pcId : new ArrayList<>(nf.ownedPcIds)) {
      try {
        peerConnectionDispose(pcId);
      } catch (Throwable t) {
        Log.w(TAG, "[disposePeerConnectionFactory] pc dispose failed: " + t);
      }
    }
    nf.ownedPcIds.clear();

    // 3. Evict every track wrapper this factory created.
    final GetUserMediaImpl gumImplForDispose = nf.getUserMediaImpl;
    for (String trackId : new ArrayList<>(nf.ownedTrackIds)) {
      LocalTrack lt = localTracks.remove(trackId);
      if (lt != null) {
        try {
          lt.setEnabled(false);
        } catch (Throwable t) {
          // Native peer may already be gone; ignore.
        }
      }
      if (gumImplForDispose != null) {
        try {
          // No-op for trackIds without a capturer (audio tracks etc.).
          gumImplForDispose.removeVideoCapturer(trackId);
        } catch (Throwable t) {
          Log.w(TAG, "[disposePeerConnectionFactory] removeVideoCapturer failed for "
              + trackId + ": " + t);
        }
      }
    }
    nf.ownedTrackIds.clear();

    // 4. Evict every stream wrapper this factory created.
    for (String streamId : new ArrayList<>(nf.ownedStreamIds)) {
      localStreams.remove(streamId);
    }
    nf.ownedStreamIds.clear();

    // 5. Tear down the native factory itself.
    try {
      nf.dispose();
    } catch (Throwable t) {
      Log.w(TAG, "[disposePeerConnectionFactory] factory dispose failed: " + t);
    }
  }

  /**
   * Checks if the microphone is muted by examining all local audio tracks.
   * Returns true if all audio tracks are disabled or if there are no audio
   * tracks.
   */
  private boolean isMicrophoneMuted() {
    for (LocalTrack track : localTracks.values()) {
      if (track instanceof LocalAudioTrack) {
        if (track.enabled()) {
          return false;
        }
      }
    }
    return true;
  }

  /**
   * {@link NativePeerConnectionFactory} registry, keyed by factoryId.
   */
  private final ConcurrentHashMap<String, NativePeerConnectionFactory> factories =
      new ConcurrentHashMap<>();

  /**
   * Maps a peer connection id to the factoryId of the {@link NativePeerConnectionFactory}
   * that built it.
   */
  private final ConcurrentHashMap<String, String> pcFactoryId =
      new ConcurrentHashMap<>();

  /**
   * Snapshot of the arguments passed to the most-recent {@code initialize(...)}
   * call. Used as the build defaults for the implicit factory, since the
   * implicit factory is built lazily on first use rather than eagerly during
   * {@code initialize}.
   */
  @Nullable
  private InitializeSnapshot initializeSnapshot;

  /**
   * Immutable snapshot of {@code initialize(...)} arguments that affect
   * {@link NativePeerConnectionFactory} construction. 
   */
  private static final class InitializeSnapshot {
    final boolean bypassVoiceProcessing;
    final int networkIgnoreMask;
    final boolean forceSWCodec;
    final List<String> forceSWCodecList;
    @Nullable final ConstraintsMap androidAudioConfiguration;
    @Nullable final Integer audioSampleRate;
    @Nullable final Integer audioOutputSampleRate;

    InitializeSnapshot(boolean bypassVoiceProcessing, int networkIgnoreMask,
        boolean forceSWCodec, List<String> forceSWCodecList,
        @Nullable ConstraintsMap androidAudioConfiguration,
        @Nullable Integer audioSampleRate, @Nullable Integer audioOutputSampleRate) {
      this.bypassVoiceProcessing = bypassVoiceProcessing;
      this.networkIgnoreMask = networkIgnoreMask;
      this.forceSWCodec = forceSWCodec;
      this.forceSWCodecList = forceSWCodecList;
      this.androidAudioConfiguration = androidAudioConfiguration;
      this.audioSampleRate = audioSampleRate;
      this.audioOutputSampleRate = audioOutputSampleRate;
    }
  }

  /**
   * Static one-shot bootstrap + per-process state setup. Snapshots the build
   * defaults that the implicit factory will use.
   * Calling {@code initialize} again refreshes the snapshot but does
   * NOT rebuild already-built factories.
   */
  private void initialize(boolean bypassVoiceProcessing, int networkIgnoreMask, boolean forceSWCodec,
      List<String> forceSWCodecList,
      @Nullable ConstraintsMap androidAudioConfiguration, Severity logSeverity, @Nullable Integer audioSampleRate,
      @Nullable Integer audioOutputSampleRate) {
    // Static libwebrtc bootstrap.
    PeerConnectionFactory.initialize(
        InitializationOptions.builder(context)
            .setEnableInternalTracer(true)
            .setInjectableLogger(logSink, logSeverity)
            .createInitializationOptions());

    if (androidAudioConfiguration != null && AudioSwitchManager.instance != null) {
      AudioSwitchManager.instance.setAudioConfiguration(androidAudioConfiguration.toMap());
    }

    // FlutterRTCFrameCryptor + FlutterDataPacketCryptor are deactivated
    // until per-factory wiring lands.
    // if (frameCryptor == null) {
    //   frameCryptor = new FlutterRTCFrameCryptor(this);
    // }
    // if (dataPacketCryptor == null) {
    //   dataPacketCryptor = new FlutterDataPacketCryptor(frameCryptor);
    // }

    if (cameraUtils == null) {
      cameraUtils = new CameraUtils(
          trackId -> {
            final NativePeerConnectionFactory nf = resolveFactoryForTrack(trackId);
            return nf != null ? nf.getUserMediaImpl : null;
          }, activity);
    }

    initializeSnapshot = new InitializeSnapshot(bypassVoiceProcessing, networkIgnoreMask,
        forceSWCodec, forceSWCodecList, androidAudioConfiguration,
        audioSampleRate, audioOutputSampleRate);
  }

  @Override
  public void onMethodCall(MethodCall call, @NonNull Result notSafeResult) {

    final AnyThreadResult result = new AnyThreadResult(notSafeResult);
    switch (call.method) {
      case "initialize": {
        int networkIgnoreMask = Options.ADAPTER_TYPE_UNKNOWN;
        Map<String, Object> options = call.argument("options");
        ConstraintsMap constraintsMap = new ConstraintsMap(options);
        if (constraintsMap.hasKey("networkIgnoreMask")
                && constraintsMap.getType("networkIgnoreMask") == ObjectType.Array) {
          final ConstraintsArray ignoredAdapters = constraintsMap.getArray("networkIgnoreMask");
          if (ignoredAdapters != null) {
            for (Object adapter : ignoredAdapters.toArrayList()) {
              switch (adapter.toString()) {
                case "adapterTypeEthernet":
                  networkIgnoreMask += Options.ADAPTER_TYPE_ETHERNET;
                  break;
                case "adapterTypeWifi":
                  networkIgnoreMask += Options.ADAPTER_TYPE_WIFI;
                  break;
                case "adapterTypeCellular":
                  networkIgnoreMask += Options.ADAPTER_TYPE_CELLULAR;
                  break;
                case "adapterTypeVpn":
                  networkIgnoreMask += Options.ADAPTER_TYPE_VPN;
                  break;
                case "adapterTypeLoopback":
                  networkIgnoreMask += Options.ADAPTER_TYPE_LOOPBACK;
                  break;
                case "adapterTypeAny":
                  networkIgnoreMask += Options.ADAPTER_TYPE_ANY;
                  break;
              }
            }

          }
        }
        boolean forceSWCodec = false;
        if (constraintsMap.hasKey("forceSWCodec")
                && constraintsMap.getType("forceSWCodec") == ObjectType.Boolean) {
          final boolean v = constraintsMap.getBoolean("forceSWCodec");
          forceSWCodec = v;
        }
        List<String> forceSWCodecList = new ArrayList<>();
        if(constraintsMap.hasKey("forceSWCodecList")
                && constraintsMap.getType("forceSWCodecList") == ObjectType.Array) {
          final List<Object> array = constraintsMap.getListArray("forceSWCodecList");
          for(Object v : array) {
            forceSWCodecList.add(v.toString());
          }
        } else {
          // disable HW Codec for VP9 and AV1 by default.
          forceSWCodecList.add("VP9");
          forceSWCodecList.add("AV1");
        }

        ConstraintsMap androidAudioConfiguration = null;
        if (constraintsMap.hasKey("androidAudioConfiguration")
                && constraintsMap.getType("androidAudioConfiguration") == ObjectType.Map) {
            androidAudioConfiguration = constraintsMap.getMap("androidAudioConfiguration");
        }
        boolean enableBypassVoiceProcessing = false;
        if(options.get("bypassVoiceProcessing") != null) {
          enableBypassVoiceProcessing = (boolean)options.get("bypassVoiceProcessing");
        }

        Severity logSeverity = Severity.LS_NONE;
        if (constraintsMap.hasKey("logSeverity")
                && constraintsMap.getType("logSeverity") == ObjectType.String) {
          String logSeverityStr = constraintsMap.getString("logSeverity");
          logSeverity = str2LogSeverity(logSeverityStr);
        }

        Integer audioSampleRate = null;
        if (constraintsMap.hasKey("audioSampleRate")
                && constraintsMap.getType("audioSampleRate") == ObjectType.Number) {
          audioSampleRate = constraintsMap.getInt("audioSampleRate");
        }

        Integer audioOutputSampleRate = null;
        if (constraintsMap.hasKey("audioOutputSampleRate")
                && constraintsMap.getType("audioOutputSampleRate") == ObjectType.Number) {
          audioOutputSampleRate = constraintsMap.getInt("audioOutputSampleRate");
        }

        initialize(enableBypassVoiceProcessing, networkIgnoreMask, forceSWCodec, forceSWCodecList,
            androidAudioConfiguration, logSeverity, audioSampleRate, audioOutputSampleRate);
        result.success(null);
        break;
      }
      case "setVideoEffects": {
        String trackId = call.argument("trackId");
        List<String> names = call.argument("names");

        final NativePeerConnectionFactory nf = resolveFactoryForTrack(trackId);
        if (nf == null) {
          resultError("setVideoEffects", "No factory owns trackId: " + trackId, result);
          break;
        }
        nf.getUserMediaImpl.setVideoEffect(trackId, names);
        result.success(null);
        break;
      }
      case "handleCallInterruptionCallbacks": {
        String interruptionSource = call.argument("androidInterruptionSource");
        AudioFocusManager.InterruptionSource source;

        switch (interruptionSource) {
          case "audioFocusOnly":
            source = AudioFocusManager.InterruptionSource.AUDIO_FOCUS_ONLY;
            break;
          case "telephonyOnly":
            source = AudioFocusManager.InterruptionSource.TELEPHONY_ONLY;
            break;
          case "audioFocusAndTelephony":
            source = AudioFocusManager.InterruptionSource.AUDIO_FOCUS_AND_TELEPHONY;
            break;
          default:
            source = AudioFocusManager.InterruptionSource.AUDIO_FOCUS_AND_TELEPHONY;
            break;
        }

        if (audioFocusManager != null) {
          audioFocusManager.setAudioFocusChangeListener(null);
          audioFocusManager = null;
        }

        audioFocusManager = new AudioFocusManager(context, source);

        audioFocusManager.setAudioFocusChangeListener(new AudioFocusManager.AudioFocusChangeListener() {
          @Override
          public void onInterruptionStart() {
            ConstraintsMap params = new ConstraintsMap();
            params.putString("event", "onInterruptionStart");
            FlutterWebRTCPlugin.sharedSingleton.sendEvent(params.toMap());
          }

          @Override
          public void onInterruptionEnd() {
            ConstraintsMap params = new ConstraintsMap();
            params.putString("event", "onInterruptionEnd");
            FlutterWebRTCPlugin.sharedSingleton.sendEvent(params.toMap());
          }
        });
        result.success(null);
        break;
      }
      case "createPeerConnection": {
        Map<String, Object> constraints = call.argument("constraints");
        Map<String, Object> configuration = call.argument("configuration");
        String factoryId = call.argument("factoryId");  // optional
        try {
          String peerConnectionId = peerConnectionInit(
              new ConstraintsMap(configuration),
              new ConstraintsMap((constraints)),
              factoryId);
          ConstraintsMap res = new ConstraintsMap();
          res.putString("peerConnectionId", peerConnectionId);
          result.success(res.toMap());
        } catch (IllegalArgumentException e) {
          resultError("createPeerConnection", e.getMessage(), result);
        }
        break;
      }
      case "createPeerConnectionFactory": {
        Map<String, Object> options = call.argument("options");
        ConstraintsMap optionsMap =
            new ConstraintsMap(options != null ? options : new HashMap<>());
        String factoryId = createPeerConnectionFactoryHandler(optionsMap);
        ConstraintsMap res = new ConstraintsMap();
        res.putString("factoryId", factoryId);
        result.success(res.toMap());
        break;
      }
      case "disposePeerConnectionFactory": {
        String factoryId = call.argument("factoryId");
        if (factoryId == null) {
          resultError("disposePeerConnectionFactory",
              "factoryId argument is required", result);
          break;
        }
        // A getUserMedia arriving from here on must not open a camera on a
        // factory that is going away; one already opening is handled by the
        // factory's dispose.
        final NativePeerConnectionFactory disposingNf = factories.get(factoryId);
        if (disposingNf != null) {
          disposingNf.getUserMediaImpl.beginDispose();
        }
        // Peer connections of this factory may still be closing on
        // peerConnectionCloseExecutor. Queueing behind them waits for them, and
        // their main-thread cleanup is posted ahead of this disposal.
        // Posted runnables run outside MethodChannel's try/catch, so reply
        // with an error instead of crashing and leaving Dart waiting.
        peerConnectionCloseExecutor.execute(() -> mainHandler.post(() -> {
          try {
            disposePeerConnectionFactoryHandler(factoryId);
          } catch (Throwable t) {
            Log.e(TAG, "disposePeerConnectionFactory failed", t);
            resultError("disposePeerConnectionFactory", t.toString(), result);
            return;
          }
          result.success(null);
        }));
        break;
      }
      case "getUserMedia": {
        Map<String, Object> constraints = call.argument("constraints");
        String factoryId = call.argument("factoryId");  // optional
        ConstraintsMap constraintsMap = new ConstraintsMap(constraints);
        getUserMedia(constraintsMap, factoryId, result);
        break;
      }
      case "createLocalMediaStream": {
        String factoryId = call.argument("factoryId");
        createLocalMediaStream(factoryId, result);
        break;
      }
      case "getSources":
        getSources(result);
        break;
      case "createOffer": {
        String peerConnectionId = call.argument("peerConnectionId");
        Map<String, Object> constraints = call.argument("constraints");
        peerConnectionCreateOffer(peerConnectionId, new ConstraintsMap(constraints), result);
        break;
      }
      case "createAnswer": {
        String peerConnectionId = call.argument("peerConnectionId");
        Map<String, Object> constraints = call.argument("constraints");
        peerConnectionCreateAnswer(peerConnectionId, new ConstraintsMap(constraints), result);
        break;
      }
      case "mediaStreamGetTracks": {
        String streamId = call.argument("streamId");
        MediaStream stream = getStreamForId(streamId, "");
        final NativePeerConnectionFactory streamFactory =
            resolveFactoryForStream(streamId);
        Map<String, Object> resultMap = new HashMap<>();
        List<Object> audioTracks = new ArrayList<>();
        List<Object> videoTracks = new ArrayList<>();
        for (AudioTrack track : stream.audioTracks) {
          localTracks.put(track.id(), new LocalAudioTrack(track));
          if (streamFactory != null) {
            streamFactory.ownedTrackIds.add(track.id());
          }
          Map<String, Object> trackMap = new HashMap<>();
          trackMap.put("enabled", track.enabled());
          trackMap.put("id", track.id());
          trackMap.put("kind", track.kind());
          trackMap.put("label", track.id());
          trackMap.put("readyState", "live");
          trackMap.put("remote", false);
          audioTracks.add(trackMap);
        }
        for (VideoTrack track : stream.videoTracks) {
          localTracks.put(track.id(), new LocalVideoTrack(track));
          if (streamFactory != null) {
            streamFactory.ownedTrackIds.add(track.id());
          }
          Map<String, Object> trackMap = new HashMap<>();
          trackMap.put("enabled", track.enabled());
          trackMap.put("id", track.id());
          trackMap.put("kind", track.kind());
          trackMap.put("label", track.id());
          trackMap.put("readyState", "live");
          trackMap.put("remote", false);
          videoTracks.add(trackMap);
        }
        resultMap.put("audioTracks", audioTracks);
        resultMap.put("videoTracks", videoTracks);
        result.success(resultMap);
        break;
      }
      case "addStream": {
        String streamId = call.argument("streamId");
        String peerConnectionId = call.argument("peerConnectionId");
        peerConnectionAddStream(streamId, peerConnectionId, result);
        break;
      }
      case "removeStream": {
        String streamId = call.argument("streamId");
        String peerConnectionId = call.argument("peerConnectionId");
        peerConnectionRemoveStream(streamId, peerConnectionId, result);
        break;
      }
      case "setLocalDescription": {
        String peerConnectionId = call.argument("peerConnectionId");
        Map<String, Object> description = call.argument("description");
        peerConnectionSetLocalDescription(new ConstraintsMap(description), peerConnectionId,
                result);
        break;
      }
      case "setRemoteDescription": {
        String peerConnectionId = call.argument("peerConnectionId");
        Map<String, Object> description = call.argument("description");
        peerConnectionSetRemoteDescription(new ConstraintsMap(description), peerConnectionId,
                result);
        break;
      }
      case "sendDtmf": {
        String peerConnectionId = call.argument("peerConnectionId");
        String tone = call.argument("tone");
        int duration = call.argument("duration");
        int gap = call.argument("gap");
        PeerConnection peerConnection = getPeerConnection(peerConnectionId);
        if (peerConnection != null) {
          RtpSender audioSender = null;
          for (RtpSender sender : peerConnection.getSenders()) {

            if (sender != null && sender.track() != null && sender.track().kind().equals("audio")) {
              audioSender = sender;
            }
          }
          if (audioSender != null) {
            DtmfSender dtmfSender = audioSender.dtmf();
            dtmfSender.insertDtmf(tone, duration, gap);
          }
          result.success("success");
        } else {
          resultError("dtmf", "peerConnection is null", result);
        }
        break;
      }
      case "addCandidate": {
        String peerConnectionId = call.argument("peerConnectionId");
        Map<String, Object> candidate = call.argument("candidate");
        peerConnectionAddICECandidate(new ConstraintsMap(candidate), peerConnectionId, result);
        break;
      }
      case "getStats": {
        String peerConnectionId = call.argument("peerConnectionId");
        String trackId = call.argument("trackId");
        peerConnectionGetStats(trackId, peerConnectionId, result);
        break;
      }
      case "createDataChannel": {
        String peerConnectionId = call.argument("peerConnectionId");
        String label = call.argument("label");
        Map<String, Object> dataChannelDict = call.argument("dataChannelDict");
        createDataChannel(peerConnectionId, label, new ConstraintsMap(dataChannelDict), result);
        break;
      }
      case "dataChannelGetBufferedAmount": {
        String peerConnectionId = call.argument("peerConnectionId");
        String dataChannelId = call.argument("dataChannelId");
        dataChannelGetBufferedAmount(peerConnectionId, dataChannelId, result);
        break;
      }
      case "dataChannelSend": {
        String peerConnectionId = call.argument("peerConnectionId");
        String dataChannelId = call.argument("dataChannelId");
        String type = call.argument("type");
        Boolean isBinary = type.equals("binary");
        ByteBuffer byteBuffer;
        if (isBinary) {
          byteBuffer = ByteBuffer.wrap(call.argument("data"));
        } else {
            String data = call.argument("data");
            byteBuffer = ByteBuffer.wrap(data.getBytes(StandardCharsets.UTF_8));
        }
        dataChannelSend(peerConnectionId, dataChannelId, byteBuffer, isBinary);
        result.success(null);
        break;
      }
      case "dataChannelClose": {
        String peerConnectionId = call.argument("peerConnectionId");
        String dataChannelId = call.argument("dataChannelId");
        dataChannelClose(peerConnectionId, dataChannelId);
        result.success(null);
        break;
      }
      case "streamDispose": {
        String streamId = call.argument("streamId");
        streamDispose(streamId);
        result.success(null);
        break;
      }
      case "mediaStreamTrackSetEnable": {
        String trackId = call.argument("trackId");
        Boolean enabled = call.argument("enabled");
        String peerConnectionId = call.argument("peerConnectionId");
        mediaStreamTrackSetEnabled(trackId, enabled, peerConnectionId);
        result.success(null);
        break;
      }
      case "mediaStreamAddTrack": {
        String streamId = call.argument("streamId");
        String trackId = call.argument("trackId");
        mediaStreamAddTrack(streamId, trackId, result);
        for (int i = 0; i < renders.size(); i++) {
          FlutterRTCVideoRenderer renderer = renders.valueAt(i);
          if (renderer.checkMediaStream(streamId, "local")) {
            LocalTrack track = localTracks.get(trackId);
            if (track != null && track.kind().equals("video")) {
              renderer.setVideoTrack((VideoTrack) track.track);
            }
          }
        }
        break;
      }
      case "mediaStreamRemoveTrack": {
        String streamId = call.argument("streamId");
        String trackId = call.argument("trackId");
        mediaStreamRemoveTrack(streamId, trackId, result);
        removeStreamForRendererById(streamId);
        break;
      }
      case "trackDispose": {
        String trackId = call.argument("trackId");
        trackDispose(trackId);
        result.success(null);
        break;
      }
      case "trackClone": {
        String trackId = call.argument("trackId");
        String peerConnectionId = call.argument("peerConnectionId");

        final NativePeerConnectionFactory nf = resolveFactoryForTrack(trackId);
        if (nf == null) {
          resultError("trackClone", "No factory owns trackId: " + trackId, result);
          break;
        }
        ConstraintsMap map = nf.getUserMediaImpl.cloneTrack(trackId);

        result.success(map.toMap());
        break;
      }
      case "restartIce": {
        String peerConnectionId = call.argument("peerConnectionId");
        restartIce(peerConnectionId);
        result.success(null);
        break;
      }
      case "peerConnectionClose": {
        String peerConnectionId = call.argument("peerConnectionId");
        peerConnectionCloseAsync(peerConnectionId, result);
        break;
      }
      case "peerConnectionDispose": {
        String peerConnectionId = call.argument("peerConnectionId");
        peerConnectionDisposeAsync(peerConnectionId, result);
        break;
      }
      case "createVideoRenderer": {
        TextureRegistry.SurfaceProducer producer = textures.createSurfaceProducer();
        FlutterRTCVideoRenderer render = new FlutterRTCVideoRenderer(producer);
        renders.put(producer.id(), render);

        EventChannel eventChannel =
                new EventChannel(
                        messenger,
                        "FlutterWebRTC/Texture" + producer.id());

        eventChannel.setStreamHandler(render);
        render.setEventChannel(eventChannel);
        render.setId((int) producer.id());

        ConstraintsMap params = new ConstraintsMap();
        params.putInt("textureId", (int) producer.id());
        result.success(params.toMap());
        break;
      }
      case "videoRendererDispose": {
        int textureId = call.argument("textureId");
        FlutterRTCVideoRenderer render = renders.get(textureId);
        if (render == null) {
          resultError("videoRendererDispose", "render [" + textureId + "] not found !", result);
          return;
        }
        render.Dispose();
        renders.delete(textureId);
        result.success(null);
        break;
      }
      case "videoRendererSetSrcObject": {
        int textureId = call.argument("textureId");
        String streamId = call.argument("streamId");
        String ownerTag = call.argument("ownerTag");
        String trackId = call.argument("trackId");
        FlutterRTCVideoRenderer render = renders.get(textureId);
        if (render == null) {
          resultError("videoRendererSetSrcObject", "render [" + textureId + "] not found !", result);
          return;
        }
        MediaStream stream = null;
        if (ownerTag.equals("local")) {
          stream = localStreams.get(streamId);
        } else {
          stream = getStreamForId(streamId, ownerTag);
        }
        if (trackId != null && !trackId.equals("0")){
          render.setStream(stream, trackId, ownerTag);
        } else {
          render.setStream(stream, ownerTag);
        }
        result.success(null);
        break;
      }
      case "mediaStreamTrackHasTorch": {
        String trackId = call.argument("trackId");
        cameraUtils.hasTorch(trackId, result);
        break;
      }
      case "mediaStreamTrackSetTorch": {
        String trackId = call.argument("trackId");
        boolean torch = call.argument("torch");
        cameraUtils.setTorch(trackId, torch, result);
        break;
      }
      case "mediaStreamTrackSetZoom": {
        String trackId = call.argument("trackId");
        double zoomLevel = call.argument("zoomLevel");
        cameraUtils.setZoom(trackId, zoomLevel, result);
        break;
      }
      case "mediaStreamTrackSetFocusMode": {
        cameraUtils.setFocusMode(call, result);
        break;
      }
      case "mediaStreamTrackSetFocusPoint":{
        Map<String, Object> focusPoint = call.argument("focusPoint");
        Boolean reset = (Boolean)focusPoint.get("reset");
        Double x = null;
        Double y = null;
        if (reset == null || !reset) {
          x =  (Double)focusPoint.get("x");
          y =  (Double)focusPoint.get("y");
        }
        cameraUtils.setFocusPoint(call, new Point(x, y), result);
        break;
      }
      case "mediaStreamTrackSetExposureMode": {
        cameraUtils.setExposureMode(call, result);
        break;
      }
      case "mediaStreamTrackSetExposurePoint": {
        Map<String, Object> exposurePoint = call.argument("exposurePoint");
        Boolean reset = (Boolean)exposurePoint.get("reset");
        Double x = null;
        Double y = null;
        if (reset == null || !reset) {
          x =  (Double)exposurePoint.get("x");
          y =  (Double)exposurePoint.get("y");
        }
        cameraUtils.setExposurePoint(call, new Point(x, y), result);
        break;
      }
      case "mediaStreamTrackSwitchCamera": {
        String trackId = call.argument("trackId");
        final NativePeerConnectionFactory nf = resolveFactoryForTrack(trackId);
        if (nf == null) {
          resultError("mediaStreamTrackSwitchCamera",
              "No factory owns trackId: " + trackId, result);
          break;
        }
        nf.getUserMediaImpl.switchCamera(trackId, result);
        break;
      }
      case "setVolume": {
        String trackId = call.argument("trackId");
        double volume = call.argument("volume");
        String peerConnectionId = call.argument("peerConnectionId");
        mediaStreamTrackSetVolume(trackId, volume, peerConnectionId);
        result.success(null);
        break;
      }
      case "selectAudioOutput": {
        String deviceId = call.argument("deviceId");
        AudioSwitchManager.instance.selectAudioOutput(AudioDeviceKind.fromTypeName(deviceId));
        result.success(null);
        break;
      }
      case "regainAndroidAudioFocus": {
        if (AudioSwitchManager.instance == null) {
          resultError("regainAndroidAudioFocus",
              "AudioSwitch manager is not initialized. Ensure plugin is attached before requesting focus.", result);
          break;
        }
        AudioSwitchManager.instance.requestAudioFocus();
        if (audioFocusManager != null) {
          audioFocusManager.notifyManualAudioFocusRegain();
        }
        result.success(null);
        break;
      }
      case "clearAndroidCommunicationDevice": {
        AudioSwitchManager.instance.clearCommunicationDevice();
        result.success(null);
        break;
      }
      case "setMicrophoneMute":
        boolean mute = call.argument("mute");
        AudioSwitchManager.instance.setMicrophoneMute(mute);
        result.success(null);
        break;
      case "selectAudioInput":
        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.LOLLIPOP_MR1) {
          String deviceId = call.argument("deviceId");
          broadcastPreferredInputDevice(deviceId);
          result.success(null);
        } else {
          result.notImplemented();
        }
        break;
      case "setAndroidAudioConfiguration": {
        Map<String, Object> configuration = call.argument("configuration");
        AudioSwitchManager.instance.setAudioConfiguration(configuration);
        result.success(null);
        break;
      }
      case "enableSpeakerphone":
        boolean enable = call.argument("enable");
        AudioSwitchManager.instance.enableSpeakerphone(enable);
        result.success(null);
        break;
      case "enableSpeakerphoneButPreferBluetooth":
        AudioSwitchManager.instance.enableSpeakerButPreferBluetooth();
        result.success(null);
        break;
      case "requestCapturePermission": {
        // The mediaProjectionData captured by requestCapturePermission lives
        // on the GetUserMediaImpl instance, so the subsequent getDisplayMedia
        // must target the same factory. Accept an optional factoryId so the
        // SDK can pin both calls to the per-call factory.
        String factoryId = call.argument("factoryId");
        NativePeerConnectionFactory nf = resolveFactory(factoryId);
        if (nf == null) {
          resultError("requestCapturePermission",
              "unknown factoryId " + factoryId, result);
          break;
        }
        Boolean fullScreenOnlyArg = call.argument("fullScreenOnly");
        boolean fullScreenOnly = fullScreenOnlyArg != null && fullScreenOnlyArg;
        nf.getUserMediaImpl.requestCapturePermission(result, fullScreenOnly);
        break;
      }
      case "getDisplayMedia": {
        Map<String, Object> constraints = call.argument("constraints");
        String factoryId = call.argument("factoryId");
        ConstraintsMap constraintsMap = new ConstraintsMap(constraints);
        getDisplayMedia(constraintsMap, factoryId, result);
        break;
      }
      case "startRecordToFile":
        //This method can a lot of different exceptions
        //so we should notify plugin user about them
        try {
          String path = call.argument("path");
          VideoTrack videoTrack = null;
          String videoTrackId = call.argument("videoTrackId");
          String peerConnectionId = call.argument("peerConnectionId");
          if (videoTrackId != null) {
            MediaStreamTrack track = getTrackForId(videoTrackId, peerConnectionId);
            if (track instanceof VideoTrack) {
              videoTrack = (VideoTrack) track;
            }
          }
          AudioChannel audioChannel = null;
          if (call.hasArgument("audioChannel")
                  && call.argument("audioChannel") != null) {
            audioChannel = AudioChannel.values()[(Integer) call.argument("audioChannel")];
          }
          Integer recorderId = call.argument("recorderId");
          if (videoTrack != null || audioChannel != null) {
            // For audio-only recording with no video track, the recorder
            // can't be tied to a specific call. 
            final NativePeerConnectionFactory nf = videoTrack != null
                ? resolveFactoryForTrack(videoTrack.id())
                : null;
            if (nf == null) {
              resultError("startRecordToFile",
                  "No factory owns the requested track (or audio-only recording "
                      + "is not supported without a videoTrack).",
                  result);
              break;
            }
            nf.getUserMediaImpl.startRecordingToFile(path, recorderId, videoTrack, audioChannel);
            result.success(null);
          } else {
            resultError("startRecordToFile", "No tracks", result);
          }
        } catch (Exception e) {
          resultError("startRecordToFile", e.getMessage(), result);
        }
        break;
      case "stopRecordToFile":
        Integer recorderId = call.argument("recorderId");
        String albumName = call.argument("albumName");
        final NativePeerConnectionFactory _recFactory =
            resolveFactoryForRecorder(recorderId);
        if (_recFactory == null) {
          resultError("stopRecordToFile",
              "No factory owns recorderId: " + recorderId, result);
          break;
        }
        _recFactory.getUserMediaImpl
            .stopRecording(recorderId, albumName, () -> result.success(null));
        break;
      case "captureFrame": {
        String path = call.argument("path");
        String videoTrackId = call.argument("trackId");
        String peerConnectionId = call.argument("peerConnectionId");
        if (videoTrackId != null) {
          MediaStreamTrack track = getTrackForId(videoTrackId, peerConnectionId);
          if (track instanceof VideoTrack) {
            new FrameCapturer((VideoTrack) track, new File(path), result);
          } else {
            resultError("captureFrame", "It's not video track", result);
          }
        } else {
          resultError("captureFrame", "Track is null", result);
        }
        break;
      }
      case "getLocalDescription": {
        String peerConnectionId = call.argument("peerConnectionId");
        PeerConnection peerConnection = getPeerConnection(peerConnectionId);
        if (peerConnection != null) {
          SessionDescription sdp = peerConnection.getLocalDescription();
          if (sdp == null) {
            result.success(null);
          } else {
            ConstraintsMap params = new ConstraintsMap();
            params.putString("sdp", sdp.description);
            params.putString("type", sdp.type.canonicalForm());
            result.success(params.toMap());
          }
        } else {
          resultError("getLocalDescription", "peerConnection is null", result);
        }
        break;
      }
      case "getRemoteDescription": {
        String peerConnectionId = call.argument("peerConnectionId");
        PeerConnection peerConnection = getPeerConnection(peerConnectionId);
        if (peerConnection != null) {
          SessionDescription sdp = peerConnection.getRemoteDescription();
          if (null == sdp) {
            result.success(null);
          } else {
            ConstraintsMap params = new ConstraintsMap();
            params.putString("sdp", sdp.description);
            params.putString("type", sdp.type.canonicalForm());
            result.success(params.toMap());
          }
        } else {
          resultError("getRemoteDescription", "peerConnection is null", result);
        }
        break;
      }
      case "setConfiguration": {
        String peerConnectionId = call.argument("peerConnectionId");
        Map<String, Object> configuration = call.argument("configuration");
        PeerConnection peerConnection = getPeerConnection(peerConnectionId);
        if (peerConnection != null) {
          peerConnectionSetConfiguration(new ConstraintsMap(configuration), peerConnection);
          result.success(null);
        } else {
          resultError("setConfiguration", "peerConnection is null", result);
        }
        break;
      }
      case "addTrack": {
        String peerConnectionId = call.argument("peerConnectionId");
        String trackId = call.argument("trackId");
        List<String> streamIds = call.argument("streamIds");
        addTrack(peerConnectionId, trackId, streamIds, result);
        break;
      }
      case "removeTrack": {
        String peerConnectionId = call.argument("peerConnectionId");
        String senderId = call.argument("senderId");

        removeTrack(peerConnectionId, senderId, result);
        break;
      }
      case "addTransceiver": {
        String peerConnectionId = call.argument("peerConnectionId");
        Map<String, Object> transceiverInit = call.argument("transceiverInit");
        if (call.hasArgument("trackId")) {
          String trackId = call.argument("trackId");
          addTransceiver(peerConnectionId, trackId, transceiverInit, result);
        } else if (call.hasArgument("mediaType")) {
          String mediaType = call.argument("mediaType");
          addTransceiverOfType(peerConnectionId, mediaType, transceiverInit, result);
        } else {
          resultError("addTransceiver", "Incomplete parameters", result);
        }
        break;
      }
      case "rtpTransceiverSetDirection": {
        String peerConnectionId = call.argument("peerConnectionId");
        String direction = call.argument("direction");
        String transceiverId = call.argument("transceiverId");
        rtpTransceiverSetDirection(peerConnectionId, direction, transceiverId, result);
        break;
      }
      case "rtpTransceiverGetDirection": {
        String peerConnectionId = call.argument("peerConnectionId");
        String transceiverId = call.argument("transceiverId");
        rtpTransceiverGetDirection(peerConnectionId, transceiverId, result);
        break;
      }
      case "rtpTransceiverGetCurrentDirection": {
        String peerConnectionId = call.argument("peerConnectionId");
        String transceiverId = call.argument("transceiverId");
        rtpTransceiverGetCurrentDirection(peerConnectionId, transceiverId, result);
        break;
      }
      case "rtpTransceiverStop": {
        String peerConnectionId = call.argument("peerConnectionId");
        String transceiverId = call.argument("transceiverId");
        rtpTransceiverStop(peerConnectionId, transceiverId, result);
        break;
      }
      case "rtpSenderSetParameters": {
        String peerConnectionId = call.argument("peerConnectionId");
        String rtpSenderId = call.argument("rtpSenderId");
        Map<String, Object> parameters = call.argument("parameters");
        rtpSenderSetParameters(peerConnectionId, rtpSenderId, parameters, result);
        break;
      }
      case "rtpSenderReplaceTrack": {
        String peerConnectionId = call.argument("peerConnectionId");
        String rtpSenderId = call.argument("rtpSenderId");
        String trackId = call.argument("trackId");
        rtpSenderSetTrack(peerConnectionId, rtpSenderId, trackId, true, result);
        break;
      }
      case "rtpSenderSetTrack": {
        String peerConnectionId = call.argument("peerConnectionId");
        String rtpSenderId = call.argument("rtpSenderId");
        String trackId = call.argument("trackId");
        rtpSenderSetTrack(peerConnectionId, rtpSenderId, trackId, false, result);
        break;
      }
      case "rtpSenderSetStreams": {
        String peerConnectionId = call.argument("peerConnectionId");
        String rtpSenderId = call.argument("rtpSenderId");
        List<String> streamIds = call.argument("streamIds");
        rtpSenderSetStreams(peerConnectionId, rtpSenderId, streamIds, result);
        break;
      }
      case "getSenders": {
        String peerConnectionId = call.argument("peerConnectionId");
        getSenders(peerConnectionId, result);
        break;
      }
      case "getReceivers": {
        String peerConnectionId = call.argument("peerConnectionId");
        getReceivers(peerConnectionId, result);
        break;
      }
      case "getTransceivers": {
        String peerConnectionId = call.argument("peerConnectionId");
        getTransceivers(peerConnectionId, result);
        break;
      }
      case "setPreferredInputDevice": {
        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.LOLLIPOP_MR1) {
          String deviceId = call.argument("deviceId");
          broadcastPreferredInputDevice(deviceId);
          result.success(null);
        } else {
          result.notImplemented();
        }
        break;
      }
      case "getRtpSenderCapabilities": {
        String kind = call.argument("kind");
        String factoryId = call.argument("factoryId");
        NativePeerConnectionFactory nf = resolveFactory(factoryId);
        if (nf == null) {
          resultError("getRtpSenderCapabilities",
              "unknown factoryId " + factoryId, result);
          break;
        }
        MediaStreamTrack.MediaType mediaType = MediaStreamTrack.MediaType.MEDIA_TYPE_AUDIO;
        if (kind.equals("video")) {
          mediaType = MediaStreamTrack.MediaType.MEDIA_TYPE_VIDEO;
        }
        RtpCapabilities capabilities = nf.factory.getRtpSenderCapabilities(mediaType);
        result.success(capabilitiestoMap(capabilities).toMap());
        break;
      }
      case "getRtpReceiverCapabilities": {
        String kind = call.argument("kind");
        String factoryId = call.argument("factoryId");
        NativePeerConnectionFactory nf = resolveFactory(factoryId);
        if (nf == null) {
          resultError("getRtpReceiverCapabilities",
              "unknown factoryId " + factoryId, result);
          break;
        }
        MediaStreamTrack.MediaType mediaType = MediaStreamTrack.MediaType.MEDIA_TYPE_AUDIO;
        if (kind.equals("video")) {
          mediaType = MediaStreamTrack.MediaType.MEDIA_TYPE_VIDEO;
        }
        RtpCapabilities capabilities = nf.factory.getRtpReceiverCapabilities(mediaType);
        result.success(capabilitiestoMap(capabilities).toMap());
        break;
      }
      case "setCodecPreferences": {
        String peerConnectionId = call.argument("peerConnectionId");
        List<Map<String, Object>> codecs = call.argument("codecs");
        String transceiverId = call.argument("transceiverId");
        rtpTransceiverSetCodecPreferences(peerConnectionId, transceiverId, codecs, result);
        break;
      }
      case "getSignalingState": {
        String peerConnectionId = call.argument("peerConnectionId");
        PeerConnection pc = getPeerConnection(peerConnectionId);
        if (pc == null) {
          resultError("getSignalingState", "peerConnection is null", result);
        } else {
          ConstraintsMap params = new ConstraintsMap();
          params.putString("state", Utils.signalingStateString(pc.signalingState()));
          result.success(params.toMap());
        }
        break;
      }
      case "getIceGatheringState": {
        String peerConnectionId = call.argument("peerConnectionId");
        PeerConnection pc = getPeerConnection(peerConnectionId);
        if (pc == null) {
          resultError("getIceGatheringState", "peerConnection is null", result);
        } else {
          ConstraintsMap params = new ConstraintsMap();
          params.putString("state", Utils.iceGatheringStateString(pc.iceGatheringState()));
          result.success(params.toMap());
        }
        break;
      }
      case "getIceConnectionState": {
       String peerConnectionId = call.argument("peerConnectionId");
       PeerConnection pc = getPeerConnection(peerConnectionId);
        if (pc == null) {
          resultError("getIceConnectionState", "peerConnection is null", result);
        } else {
          ConstraintsMap params = new ConstraintsMap();
          params.putString("state", Utils.iceConnectionStateString(pc.iceConnectionState()));
          result.success(params.toMap());
        }
        break;
      }
      case "getConnectionState": {
        String peerConnectionId = call.argument("peerConnectionId");
        PeerConnection pc = getPeerConnection(peerConnectionId);
        if (pc == null) {
          resultError("getConnectionState", "peerConnection is null", result);
        } else {
          ConstraintsMap params = new ConstraintsMap();
          params.putString("state", Utils.connectionStateString(pc.connectionState()));
          result.success(params.toMap());
        }
        break;
      }
      case "pauseAudioPlayout": {
        executor.execute(() -> {
          pauseAudioPlayoutInternal();
          mainHandler.post(() -> {
            result.success(null);
          });
        });
        break;
      }
      case "resumeAudioPlayout": {
        executor.execute(() -> {
          resumeAudioPlayoutInternal();
          mainHandler.post(() -> {
            result.success(null);
          });
        });
        break;
      }
      case "startLocalRecording": {
        final String factoryId = call.argument("factoryId");
        final NativePeerConnectionFactory nf = resolveFactory(factoryId);
        if (nf == null) {
          resultError("startLocalRecording", "unknown factoryId " + factoryId, result);
          break;
        }
        final JavaAudioDeviceModule adm = nf.adm;
        executor.execute(() -> {
          adm.prewarmRecording();
          mainHandler.post(() -> {
            result.success(null);
          });
        });
        break;
      }
      case "stopLocalRecording": {
        final String factoryId = call.argument("factoryId");
        final NativePeerConnectionFactory nf = resolveFactory(factoryId);
        if (nf == null) {
          resultError("stopLocalRecording", "unknown factoryId " + factoryId, result);
          break;
        }
        final JavaAudioDeviceModule adm = nf.adm;
        executor.execute(() -> {
          adm.requestStopRecording();
          mainHandler.post(() -> {
            result.success(null);
          });
        });
        break;
      }
      case "setLogSeverity": {
        //now it's possible to setup logSeverity only via PeerConnectionFactory.initialize method
        //Log.d(TAG, "no implementation for 'setLogSeverity'");
        break;
      }
      case "suspendAudioPeerConnectionFactory": {
        final String factoryId = call.argument("factoryId");
        final NativePeerConnectionFactory nf = resolveFactory(factoryId);
        if (nf == null) {
          resultError("suspendAudioPeerConnectionFactory",
              "unknown factoryId " + factoryId, result);
          break;
        }
        final JavaAudioDeviceModule adm = nf.adm;
        nf.setAudioSuspended(true);
        executor.execute(() -> {
          try {
            adm.setSpeakerMute(true);
          } catch (Throwable t) {
            Log.w(TAG, "[suspendAudioPeerConnectionFactory] setSpeakerMute: " + t);
          }
          mainHandler.post(() -> result.success(null));
        });
        break;
      }
      case "resumeAudioPeerConnectionFactory": {
        final String factoryId = call.argument("factoryId");
        final NativePeerConnectionFactory nf = resolveFactory(factoryId);
        if (nf == null) {
          resultError("resumeAudioPeerConnectionFactory",
              "unknown factoryId " + factoryId, result);
          break;
        }
        final JavaAudioDeviceModule adm = nf.adm;
        nf.setAudioSuspended(false);
        executor.execute(() -> {
          try {
            adm.setSpeakerMute(false);
          } catch (Throwable t) {
            Log.w(TAG, "[resumeAudioPeerConnectionFactory] setSpeakerMute: " + t);
          }
          mainHandler.post(() -> result.success(null));
        });
        break;
      }
      default:
        if (encryptionManager.handleMethodCall(call, result)) {
          break;
        }
        result.notImplemented();
        break;
    }
  }

  private ConstraintsMap capabilitiestoMap(RtpCapabilities capabilities) {
    ConstraintsMap capabilitiesMap = new ConstraintsMap();
    ConstraintsArray codecArr = new ConstraintsArray();
    for(RtpCapabilities.CodecCapability codec : capabilities.codecs){
      ConstraintsMap codecMap = new ConstraintsMap();
      codecMap.putString("mimeType", codec.mimeType);
      codecMap.putInt("clockRate", codec.clockRate);
      if(codec.numChannels != null)
        codecMap.putInt("channels", codec.numChannels);
      List<String> sdpFmtpLineArr = new ArrayList<>();
      for(Map.Entry<String, String> entry : codec.parameters.entrySet()) {
        if(entry.getKey().length() > 0) {
          sdpFmtpLineArr.add(entry.getKey() + "=" + entry.getValue());
        } else {
          sdpFmtpLineArr.add(entry.getValue());
        }
      }
      if(sdpFmtpLineArr.size() > 0)
        codecMap.putString("sdpFmtpLine", String.join(";", sdpFmtpLineArr));
      codecArr.pushMap(codecMap);
    }
    ConstraintsArray headerExtensionsArr = new ConstraintsArray();
    for(RtpCapabilities.HeaderExtensionCapability headerExtension : capabilities.headerExtensions){
      ConstraintsMap headerExtensionMap = new ConstraintsMap();
      headerExtensionMap.putString("uri", headerExtension.getUri());
      headerExtensionMap.putInt("id", headerExtension.getPreferredId());
      headerExtensionMap.putBoolean("encrypted", headerExtension.getPreferredEncrypted());
      headerExtensionsArr.pushMap(headerExtensionMap);
    }
    capabilitiesMap.putArray("codecs", codecArr.toArrayList());
    capabilitiesMap.putArray("headerExtensions", headerExtensionsArr.toArrayList());
    ConstraintsArray fecMechanismsArr = new ConstraintsArray();
    capabilitiesMap.putArray("fecMechanisms", fecMechanismsArr.toArrayList());
    return capabilitiesMap;
  }

  private PeerConnection getPeerConnection(String id) {
    PeerConnectionObserver pco = mPeerConnectionObservers.get(id);
    return (pco == null) ? null : pco.getPeerConnection();
  }

  private void pauseAudioPlayoutInternal() {
    isAudioPlayoutPaused = true;

    for (PeerConnectionObserver observer : mPeerConnectionObservers.values()) {
      for (Map.Entry<String, MediaStreamTrack> entry : observer.remoteTracks.entrySet()) {
        MediaStreamTrack track = entry.getValue();
        if (track instanceof AudioTrack) {
          String trackId = track.id();
          if (!pausedTrackVolumes.containsKey(trackId)) {
            double previousVolume = trackVolumeCache.getOrDefault(trackId, 1.0);
            pausedTrackVolumes.put(trackId, previousVolume);
          }
          try {
            ((AudioTrack) track).setVolume(0.0);
          } catch (Exception e) {
            Log.e(TAG, "pauseAudioPlayoutInternal: setVolume failed for track " + track.id(), e);
          }
        }
      }
    }
  }

  private void resumeAudioPlayoutInternal() {
    isAudioPlayoutPaused = false;

    if (pausedTrackVolumes.isEmpty()) {
      return;
    }

    Map<String, Double> volumesToRestore = new HashMap<>(pausedTrackVolumes);
    pausedTrackVolumes.clear();

    for (Map.Entry<String, Double> entry : volumesToRestore.entrySet()) {
      String trackId = entry.getKey();
      double targetVolume = entry.getValue();
      MediaStreamTrack track = getTrackForId(trackId, null);
      if (track instanceof AudioTrack) {
        try {
          ((AudioTrack) track).setVolume(targetVolume);
          trackVolumeCache.put(trackId, targetVolume);
        } catch (Exception e) {
          Log.e(TAG, "resumeAudioPlayoutInternal: setVolume failed for track " + trackId, e);
        }
      }
    }
  }

  private List<IceServer> createIceServers(ConstraintsArray iceServersArray) {
    final int size = (iceServersArray == null) ? 0 : iceServersArray.size();
    List<IceServer> iceServers = new ArrayList<>(size);
    for (int i = 0; i < size; i++) {
      ConstraintsMap iceServerMap = iceServersArray.getMap(i);
      boolean hasUsernameAndCredential =
              iceServerMap.hasKey("username") && iceServerMap.hasKey("credential");
      if (iceServerMap.hasKey("url")) {
        if (hasUsernameAndCredential) {
          iceServers.add(IceServer.builder(iceServerMap.getString("url"))
                  .setUsername(iceServerMap.getString("username"))
                  .setPassword(iceServerMap.getString("credential")).createIceServer());
        } else {
          iceServers.add(
                  IceServer.builder(iceServerMap.getString("url")).createIceServer());
        }
      } else if (iceServerMap.hasKey("urls")) {
        switch (iceServerMap.getType("urls")) {
          case String:
            if (hasUsernameAndCredential) {
              iceServers.add(IceServer.builder(iceServerMap.getString("urls"))
                      .setUsername(iceServerMap.getString("username"))
                      .setPassword(iceServerMap.getString("credential")).createIceServer());
            } else {
              iceServers.add(IceServer.builder(iceServerMap.getString("urls"))
                      .createIceServer());
            }
            break;
          case Array:
            ConstraintsArray urls = iceServerMap.getArray("urls");
            List<String> urlsList = new ArrayList<>();

            for (int j = 0; j < urls.size(); j++) {
              urlsList.add(urls.getString(j));
            }

            Builder builder = IceServer.builder(urlsList);

            if (hasUsernameAndCredential) {
              builder
                      .setUsername(iceServerMap.getString("username"))
                      .setPassword(iceServerMap.getString("credential"));
            }

            iceServers.add(builder.createIceServer());

            break;
        }
      }
    }
    return iceServers;
  }

  private RTCConfiguration parseRTCConfiguration(ConstraintsMap map) {
    ConstraintsArray iceServersArray = null;
    if (map != null) {
      iceServersArray = map.getArray("iceServers");
    }
    List<IceServer> iceServers = createIceServers(iceServersArray);
    RTCConfiguration conf = new RTCConfiguration(iceServers);
    if (map == null) {
      return conf;
    }

    // iceTransportPolicy (public api)
    if (map.hasKey("iceTransportPolicy")
            && map.getType("iceTransportPolicy") == ObjectType.String) {
      final String v = map.getString("iceTransportPolicy");
      if (v != null) {
        switch (v) {
          case "all": // public
            conf.iceTransportsType = IceTransportsType.ALL;
            break;
          case "relay": // public
            conf.iceTransportsType = IceTransportsType.RELAY;
            break;
          case "nohost":
            conf.iceTransportsType = IceTransportsType.NOHOST;
            break;
          case "none":
            conf.iceTransportsType = IceTransportsType.NONE;
            break;
        }
      }
    }

    // bundlePolicy (public api)
    if (map.hasKey("bundlePolicy")
            && map.getType("bundlePolicy") == ObjectType.String) {
      final String v = map.getString("bundlePolicy");
      if (v != null) {
        switch (v) {
          case "balanced": // public
            conf.bundlePolicy = BundlePolicy.BALANCED;
            break;
          case "max-compat": // public
            conf.bundlePolicy = BundlePolicy.MAXCOMPAT;
            break;
          case "max-bundle": // public
            conf.bundlePolicy = BundlePolicy.MAXBUNDLE;
            break;
        }
      }
    }

    // rtcpMuxPolicy (public api)
    if (map.hasKey("rtcpMuxPolicy")
            && map.getType("rtcpMuxPolicy") == ObjectType.String) {
      final String v = map.getString("rtcpMuxPolicy");
      if (v != null) {
        switch (v) {
          case "negotiate": // public
            conf.rtcpMuxPolicy = RtcpMuxPolicy.NEGOTIATE;
            break;
          case "require": // public
            conf.rtcpMuxPolicy = RtcpMuxPolicy.REQUIRE;
            break;
        }
      }
    }

    // FIXME: peerIdentity of type DOMString (public api)
    // FIXME: certificates of type sequence<RTCCertificate> (public api)

    // iceCandidatePoolSize of type unsigned short, defaulting to 0
    if (map.hasKey("iceCandidatePoolSize")
            && map.getType("iceCandidatePoolSize") == ObjectType.Number) {
      final int v = map.getInt("iceCandidatePoolSize");
      if (v > 0) {
        conf.iceCandidatePoolSize = v;
      }
    }

    // sdpSemantics
    if (map.hasKey("sdpSemantics")
            && map.getType("sdpSemantics") == ObjectType.String) {
      final String v = map.getString("sdpSemantics");
      if (v != null) {
        switch (v) {
          case "plan-b":
            conf.sdpSemantics = SdpSemantics.PLAN_B;
            break;
          case "unified-plan":
            conf.sdpSemantics = SdpSemantics.UNIFIED_PLAN;
            break;
        }
      }
    }

    // maxIPv6Networks
    if (map.hasKey("maxIPv6Networks")
            && map.getType("maxIPv6Networks") == ObjectType.Number) {
      conf.maxIPv6Networks = map.getInt("maxIPv6Networks");
    }

    // === below is private api in webrtc ===

    // tcpCandidatePolicy (private api)
    if (map.hasKey("tcpCandidatePolicy")
            && map.getType("tcpCandidatePolicy") == ObjectType.String) {
      final String v = map.getString("tcpCandidatePolicy");
      if (v != null) {
        switch (v) {
          case "enabled":
            conf.tcpCandidatePolicy = TcpCandidatePolicy.ENABLED;
            break;
          case "disabled":
            conf.tcpCandidatePolicy = TcpCandidatePolicy.DISABLED;
            break;
        }
      }
    }

    // candidateNetworkPolicy (private api)
    if (map.hasKey("candidateNetworkPolicy")
            && map.getType("candidateNetworkPolicy") == ObjectType.String) {
      final String v = map.getString("candidateNetworkPolicy");
      if (v != null) {
        switch (v) {
          case "all":
            conf.candidateNetworkPolicy = CandidateNetworkPolicy.ALL;
            break;
          case "low_cost":
            conf.candidateNetworkPolicy = CandidateNetworkPolicy.LOW_COST;
            break;
        }
      }
    }

    // KeyType (private api)
    if (map.hasKey("keyType")
            && map.getType("keyType") == ObjectType.String) {
      final String v = map.getString("keyType");
      if (v != null) {
        switch (v) {
          case "RSA":
            conf.keyType = KeyType.RSA;
            break;
          case "ECDSA":
            conf.keyType = KeyType.ECDSA;
            break;
        }
      }
    }

    // continualGatheringPolicy (private api)
    if (map.hasKey("continualGatheringPolicy")
            && map.getType("continualGatheringPolicy") == ObjectType.String) {
      final String v = map.getString("continualGatheringPolicy");
      if (v != null) {
        switch (v) {
          case "gather_once":
            conf.continualGatheringPolicy = ContinualGatheringPolicy.GATHER_ONCE;
            break;
          case "gather_continually":
            conf.continualGatheringPolicy = ContinualGatheringPolicy.GATHER_CONTINUALLY;
            break;
        }
      }
    }

    // audioJitterBufferMaxPackets (private api)
    if (map.hasKey("audioJitterBufferMaxPackets")
            && map.getType("audioJitterBufferMaxPackets") == ObjectType.Number) {
      final int v = map.getInt("audioJitterBufferMaxPackets");
      if (v > 0) {
        conf.audioJitterBufferMaxPackets = v;
      }
    }

    // iceConnectionReceivingTimeout (private api)
    if (map.hasKey("iceConnectionReceivingTimeout")
            && map.getType("iceConnectionReceivingTimeout") == ObjectType.Number) {
      final int v = map.getInt("iceConnectionReceivingTimeout");
      conf.iceConnectionReceivingTimeout = v;
    }

    // iceBackupCandidatePairPingInterval (private api)
    if (map.hasKey("iceBackupCandidatePairPingInterval")
            && map.getType("iceBackupCandidatePairPingInterval") == ObjectType.Number) {
      final int v = map.getInt("iceBackupCandidatePairPingInterval");
      conf.iceBackupCandidatePairPingInterval = v;
    }

    // audioJitterBufferFastAccelerate (private api)
    if (map.hasKey("audioJitterBufferFastAccelerate")
            && map.getType("audioJitterBufferFastAccelerate") == ObjectType.Boolean) {
      final boolean v = map.getBoolean("audioJitterBufferFastAccelerate");
      conf.audioJitterBufferFastAccelerate = v;
    }

    // pruneTurnPorts (private api)
    if (map.hasKey("pruneTurnPorts")
            && map.getType("pruneTurnPorts") == ObjectType.Boolean) {
      final boolean v = map.getBoolean("pruneTurnPorts");
      conf.pruneTurnPorts = v;
    }

    // presumeWritableWhenFullyRelayed (private api)
    if (map.hasKey("presumeWritableWhenFullyRelayed")
            && map.getType("presumeWritableWhenFullyRelayed") == ObjectType.Boolean) {
      final boolean v = map.getBoolean("presumeWritableWhenFullyRelayed");
      conf.presumeWritableWhenFullyRelayed = v;
    }
    // cryptoOptions
    if (map.hasKey("cryptoOptions")
            && map.getType("cryptoOptions") == ObjectType.Map) {
      final ConstraintsMap cryptoOptions = map.getMap("cryptoOptions");
      conf.cryptoOptions = CryptoOptions.builder()
              .setEnableGcmCryptoSuites(cryptoOptions.hasKey("enableGcmCryptoSuites") && cryptoOptions.getBoolean("enableGcmCryptoSuites"))
              .setRequireFrameEncryption(cryptoOptions.hasKey("requireFrameEncryption") && cryptoOptions.getBoolean("requireFrameEncryption"))
              .setEnableEncryptedRtpHeaderExtensions(cryptoOptions.hasKey("enableEncryptedRtpHeaderExtensions") && cryptoOptions.getBoolean("enableEncryptedRtpHeaderExtensions"))
              .setEnableAes128Sha1_32CryptoCipher(cryptoOptions.hasKey("enableAes128Sha1_32CryptoCipher") && cryptoOptions.getBoolean("enableAes128Sha1_32CryptoCipher"))
              .createCryptoOptions();
    }
    if (map.hasKey("enableCpuOveruseDetection")
            && map.getType("enableCpuOveruseDetection") == ObjectType.Boolean) {
      final boolean v = map.getBoolean("enableCpuOveruseDetection");
      conf.enableCpuOveruseDetection = v;
    }
    return conf;
  }

  public String peerConnectionInit(ConstraintsMap configuration, ConstraintsMap constraints) {
    return peerConnectionInit(configuration, constraints, null);
  }

  /**
   * Builds a fresh peer connection against {@code factoryId}'s {@link
   * NativePeerConnectionFactory}, or against the implicit factory when {@code factoryId}
   * is null. 
   *
   * <p>Every PC is registered in {@link #pcFactoryId} and {@link NativePeerConnectionFactory#ownedPcIds}.
   * The implicit factory uses these registrations as its refcount.
   */
  public String peerConnectionInit(ConstraintsMap configuration,
      ConstraintsMap constraints, @Nullable String factoryId) {
    final NativePeerConnectionFactory nf = resolveFactory(factoryId);
    if (nf == null) {
      throw new IllegalArgumentException(
          "createPeerConnection: unknown factoryId " + factoryId);
    }

    String peerConnectionId = getNextStreamUUID();
    RTCConfiguration conf = parseRTCConfiguration(configuration);
    PeerConnectionObserver observer = new PeerConnectionObserver(conf, this, messenger, peerConnectionId);
    PeerConnection peerConnection
            = nf.factory.createPeerConnection(
            conf,
            parseMediaConstraints(constraints),
            observer);
    observer.setPeerConnection(peerConnection);
    mPeerConnectionObservers.put(peerConnectionId, observer);

    pcFactoryId.put(peerConnectionId, factoryId);
    nf.ownedPcIds.add(peerConnectionId);

    return peerConnectionId;
  }

  @Override
  public boolean putLocalStream(String streamId, MediaStream stream) {
    localStreams.put(streamId, stream);
    return true;
  }

  @Override
  public boolean putLocalTrack(String trackId, LocalTrack track) {
    localTracks.put(trackId, track);
    final NativePeerConnectionFactory nf = resolveFactoryForTrack(trackId);
    if (nf != null) {
      nf.ownedTrackIds.add(trackId);
    }
    return true;
  }

  @Override
  public LocalTrack getLocalTrack(String trackId) {
    return localTracks.get(trackId);
  }

  public MediaStreamTrack getRemoteTrack(String trackId) {
    for (Entry<String, PeerConnectionObserver> entry : mPeerConnectionObservers.entrySet()) {
      PeerConnectionObserver pco = entry.getValue();
      MediaStreamTrack track = pco.remoteTracks.get(trackId);
      if (track == null) {
        track = pco.getTransceiversTrack(trackId);
      }
      if (track != null) {
        return track;
      }
    }
    return null;
  }

  @Override
  public String getNextStreamUUID() {
    String uuid;

    do {
      uuid = UUID.randomUUID().toString();
    } while (getStreamForId(uuid, "") != null);

    return uuid;
  }

  @Override
  public String getNextTrackUUID() {
    String uuid;

    do {
      uuid = UUID.randomUUID().toString();
    } while (getTrackForId(uuid, null) != null);

    return uuid;
  }

  @Override
  public PeerConnectionObserver getPeerConnectionObserver(String peerConnectionId) {
    return mPeerConnectionObservers.get(peerConnectionId);
  }

  @Nullable
  @Override
  public Activity getActivity() {
    return activity;
  }

  @Nullable
  @Override
  public Context getApplicationContext() {
    return context;
  }

  @Override
  public BinaryMessenger getMessenger() {
    return messenger;
  }

  MediaStream getStreamForId(String id, String peerConnectionId) {
    MediaStream stream = null;
    if (peerConnectionId.length() > 0) {
      PeerConnectionObserver pco = mPeerConnectionObservers.get(peerConnectionId);
      if (pco != null) {
        stream = pco.remoteStreams.get(id);
      }
    } else {
      for (Entry<String, PeerConnectionObserver> entry : mPeerConnectionObservers
              .entrySet()) {
        PeerConnectionObserver pco = entry.getValue();
        stream = pco.remoteStreams.get(id);
        if (stream != null) {
          break;
        }
      }
    }
    if (stream == null) {
      stream = localStreams.get(id);
    }

    return stream;
  }

  public MediaStreamTrack getTrackForId(String trackId, String peerConnectionId) {
    LocalTrack localTrack = localTracks.get(trackId);
    MediaStreamTrack mediaStreamTrack = null;
    if (localTrack == null) {
      for (Entry<String, PeerConnectionObserver> entry : mPeerConnectionObservers.entrySet()) {
        if (peerConnectionId != null && entry.getKey().compareTo(peerConnectionId) != 0)
          continue;

        PeerConnectionObserver pco = entry.getValue();
        mediaStreamTrack = pco.remoteTracks.get(trackId);

        if (mediaStreamTrack == null) {
          mediaStreamTrack = pco.getTransceiversTrack(trackId);
        }

        if (mediaStreamTrack != null) {
          break;
        }
      }
    } else {
      mediaStreamTrack = localTrack.track;
    }

    return mediaStreamTrack;
  }


  public void getUserMedia(ConstraintsMap constraints, Result result) {
    getUserMedia(constraints, null, result);
  }

  public void getUserMedia(ConstraintsMap constraints, @Nullable String factoryId,
      Result result) {
    final NativePeerConnectionFactory nf = resolveFactory(factoryId);
    if (nf == null) {
      resultError("getUserMedia",
          "unknown factoryId " + factoryId, result);
      return;
    }

    String streamId = getNextStreamUUID();
    MediaStream mediaStream = nf.factory.createLocalMediaStream(streamId);

    if (mediaStream == null) {
      // XXX The following does not follow the getUserMedia() algorithm
      // specified by
      // https://www.w3.org/TR/mediacapture-streams/#dom-mediadevices-getusermedia
      // with respect to distinguishing the various causes of failure.
      resultError("getUserMediaFailed", "Failed to create new media stream", result);
      return;
    }

    nf.ownedStreamIds.add(streamId);
    nf.getUserMediaImpl.getUserMedia(constraints, result, mediaStream);
  }

  public void getDisplayMedia(ConstraintsMap constraints, Result result) {
    getDisplayMedia(constraints, null, result);
  }

  public void getDisplayMedia(ConstraintsMap constraints, @Nullable String factoryId,
      Result result) {
    final NativePeerConnectionFactory nf = resolveFactory(factoryId);
    if (nf == null) {
      resultError("getDisplayMedia",
          "unknown factoryId " + factoryId, result);
      return;
    }

    String streamId = getNextStreamUUID();
    MediaStream mediaStream = nf.factory.createLocalMediaStream(streamId);

    if (mediaStream == null) {
      // XXX The following does not follow the getUserMedia() algorithm
      // specified by
      // https://www.w3.org/TR/mediacapture-streams/#dom-mediadevices-getusermedia
      // with respect to distinguishing the various causes of failure.
      resultError("getDisplayMedia", "Failed to create new media stream", result);
      return;
    }

    nf.ownedStreamIds.add(streamId);
    nf.getUserMediaImpl.getDisplayMedia(constraints, result, mediaStream);
  }

  public void getSources(Result result) {
    final Result safeResult = new AnyThreadResult(result);

    // AudioSwitch is driven from the main thread, so read its devices here.
    final List<ConstraintsMap> audioOutputSources = getAudioOutputSources();

    try {
      deviceEnumerationExecutor.execute(() -> {
        try {
          ConstraintsArray array = new ConstraintsArray();
          for (ConstraintsMap source : getCameraSources()) {
            array.pushMap(source);
          }
          for (ConstraintsMap source : getAudioInputSources()) {
            array.pushMap(source);
          }
          for (ConstraintsMap source : audioOutputSources) {
            array.pushMap(source);
          }

          ConstraintsMap map = new ConstraintsMap();
          map.putArray("sources", array.toArrayList());
          safeResult.success(map.toMap());
        } catch (Throwable t) {
          resultError("getSources", "Failed to enumerate devices: " + t, safeResult);
        }
      });
    } catch (RejectedExecutionException e) {
      resultError("getSources", "Device enumeration is shut down", safeResult);
    }
  }

  private List<ConstraintsMap> getCameraSources() {
    final int cameraCount = Camera.getNumberOfCameras();
    if (cachedCameraSources != null && cachedCameraSources.size() == cameraCount) {
      return cachedCameraSources;
    }

    List<ConstraintsMap> sources = new ArrayList<>();
    for (int i = 0; i < cameraCount; ++i) {
      ConstraintsMap info = getCameraInfo(i);
      if (info != null) {
        sources.add(info);
      }
    }

    // Keep failed lookups out of the cache so they are retried next time.
    if (sources.size() == cameraCount) {
      cachedCameraSources = sources;
    }
    return sources;
  }

  private List<ConstraintsMap> getAudioInputSources() {
    List<ConstraintsMap> sources = new ArrayList<>();

    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
      ConstraintsMap audio = new ConstraintsMap();
      audio.putString("label", "Audio");
      audio.putString("deviceId", "audio-1");
      audio.putString("kind", "audioinput");
      audio.putString("groupId", "microphone");
      sources.add(audio);
      return sources;
    }

    android.media.AudioManager audioManager = ((android.media.AudioManager) context
            .getSystemService(Context.AUDIO_SERVICE));
    final AudioDeviceInfo[] devices = audioManager.getDevices(android.media.AudioManager.GET_DEVICES_INPUTS);
    for (AudioDeviceInfo device : devices) {
      if (device.getType() == AudioDeviceInfo.TYPE_BUILTIN_MIC || device.getType() == AudioDeviceInfo.TYPE_BLUETOOTH_SCO ||
              device.getType() == AudioDeviceInfo.TYPE_WIRED_HEADSET) {
        ConstraintsMap audio = new ConstraintsMap();
        audio.putString("label", AudioUtils.getAudioDeviceLabel(device));
        audio.putString("deviceId", AudioUtils.getAudioDeviceId(device));
        audio.putString("groupId", AudioUtils.getAudioGroupId(device));
        audio.putString("kind", "audioinput");
        sources.add(audio);
      }
    }
    return sources;
  }

  private List<ConstraintsMap> getAudioOutputSources() {
    List<ConstraintsMap> sources = new ArrayList<>();

    List<? extends AudioDevice> audioOutputs = AudioSwitchManager.instance.availableAudioDevices();
    for (AudioDevice audioOutput : audioOutputs) {
      ConstraintsMap audioOutputMap = new ConstraintsMap();
      audioOutputMap.putString("label", audioOutput.getName());
      audioOutputMap.putString("deviceId", AudioDeviceKind.fromAudioDevice(audioOutput).typeName);
      audioOutputMap.putString("groupId", AudioDeviceKind.fromAudioDevice(audioOutput).typeName);
      audioOutputMap.putString("kind", "audiooutput");
      sources.add(audioOutputMap);
    }
    return sources;
  }

  private void createLocalMediaStream(@Nullable String factoryId, Result result) {
    final NativePeerConnectionFactory nf = resolveFactory(factoryId);
    if (nf == null) {
      resultError("createLocalMediaStream",
          "unknown factoryId " + factoryId, result);
      return;
    }
    
    String streamId = getNextStreamUUID();
    MediaStream mediaStream = nf.factory.createLocalMediaStream(streamId);
    localStreams.put(streamId, mediaStream);
    nf.ownedStreamIds.add(streamId);

    if (mediaStream == null) {
      resultError("createLocalMediaStream", "Failed to create new media stream", result);
      return;
    }
    Map<String, Object> resultMap = new HashMap<>();
    resultMap.put("streamId", mediaStream.getId());
    result.success(resultMap);
  }

  public void trackDispose(final String trackId) {
    LocalTrack track = localTracks.get(trackId);
    if (track == null) {
      Log.d(TAG, "trackDispose() track is null");
      final NativePeerConnectionFactory ownerNf = resolveFactoryForTrack(trackId);
      if (ownerNf != null) {
        ownerNf.ownedTrackIds.remove(trackId);
      }
      return;
    }

    removeTrackForRendererById(trackId);
    try {
      track.setEnabled(false);
    } catch (Throwable t) {
      // Native peer may already be gone if the factory was disposed
      // before this trackDispose call landed. Ignore.
    }

    final NativePeerConnectionFactory nf = resolveFactoryForTrack(trackId);
    if (track instanceof LocalVideoTrack) {
      if (nf != null) {
        nf.getUserMediaImpl.removeVideoCapturer(trackId);
      } else {
        Log.w(TAG, "[trackDispose] no factory owns trackId " + trackId
            + "; capturer cleanup skipped");
      }
    }

    localTracks.remove(trackId);
    if (nf != null) {
      nf.ownedTrackIds.remove(trackId);
    }
  }

  public void mediaStreamTrackSetEnabled(final String id, final boolean enabled, String peerConnectionId) {
    MediaStreamTrack track = getTrackForId(id, peerConnectionId);

    if (track == null) {
      Log.d(TAG, "mediaStreamTrackSetEnabled() track is null");
      return;
    }
    try {
      if (track.enabled() == enabled) {
        return;
      }
      track.setEnabled(enabled);
    } catch (Throwable t) {
      Log.w(TAG, "mediaStreamTrackSetEnabled() track " + id + " stale: " + t);
    }
  }

  public void mediaStreamTrackSetVolume(final String id, final double volume, String peerConnectionId) {
    MediaStreamTrack track = getTrackForId(id, null);
    if (track instanceof AudioTrack) {
      Log.d(TAG, "setVolume(): " + id + "," + volume);
      try {
        ((AudioTrack) track).setVolume(volume);
        trackVolumeCache.put(id, volume);
        if (!pausedTrackVolumes.isEmpty() && pausedTrackVolumes.containsKey(id)) {
          pausedTrackVolumes.put(id, volume);
          ((AudioTrack) track).setVolume(0.0);
        }
      } catch (Exception e) {
        Log.e(TAG, "setVolume(): error", e);
      }
    } else {
      Log.w(TAG, "setVolume(): track not found: " + id);
    }
  }

  public void mediaStreamAddTrack(final String streamId, final String trackId, Result result) {
    MediaStream mediaStream = localStreams.get(streamId);
    if (mediaStream != null) {
      MediaStreamTrack track = getTrackForId(trackId, null);//localTracks.get(trackId);
      if (track != null) {
        String kind = track.kind();
        if (kind.equals("audio")) {
          mediaStream.addTrack((AudioTrack) track);
          result.success(null);
        } else if (kind.equals("video")) {
          mediaStream.addTrack((VideoTrack) track);
          result.success(null);
        } else {
          resultError("mediaStreamAddTrack", "mediaStreamAddTrack() track [" + trackId + "] has unsupported type: " + kind, result);
        }
      } else {
        resultError("mediaStreamAddTrack", "mediaStreamAddTrack() track [" + trackId + "] is null", result);
      }
    } else {
      resultError("mediaStreamAddTrack", "mediaStreamAddTrack() stream [" + streamId + "] is null", result);
    }
  }

  public void mediaStreamRemoveTrack(final String streamId, final String trackId, Result result) {
    MediaStream mediaStream = localStreams.get(streamId);
    if (mediaStream != null) {
      LocalTrack track = localTracks.get(trackId);
      if (track != null) {
        String kind = track.kind();
        if (kind.equals("audio")) {
          mediaStream.removeTrack((AudioTrack) track.track);
          result.success(null);
        } else if (kind.equals("video")) {
          mediaStream.removeTrack((VideoTrack) track.track);
          result.success(null);
        } else {
          resultError("mediaStreamRemoveTrack", "mediaStreamRemoveTrack() track [" + trackId + "] has unsupported type: " + kind, result);
        }
      } else {
        resultError("mediaStreamRemoveTrack", "mediaStreamRemoveTrack() track [" + trackId + "] is null", result);
      }
    } else {
      resultError("mediaStreamRemoveTrack", "mediaStreamRemoveTrack() stream [" + streamId + "] is null", result);
    }
  }

  public void mediaStreamTrackRelease(final String streamId, final String _trackId) {
    MediaStream stream = localStreams.get(streamId);
    if (stream == null) {
      Log.d(TAG, "mediaStreamTrackRelease() stream is null");
      return;
    }
    LocalTrack track = localTracks.get(_trackId);
    if (track == null) {
      Log.d(TAG, "mediaStreamTrackRelease() track is null");
      return;
    }
    track.setEnabled(false); // should we do this?
    localTracks.remove(_trackId);
    if (track.kind().equals("audio")) {
      stream.removeTrack((AudioTrack) track.track);
    } else if (track.kind().equals("video")) {
      stream.removeTrack((VideoTrack) track.track);
      final NativePeerConnectionFactory nf = resolveFactoryForTrack(_trackId);
      if (nf != null) {
        nf.getUserMediaImpl.removeVideoCapturer(_trackId);
      } else {
        Log.w(TAG, "[mediaStreamTrackRelease] no factory owns trackId "
            + _trackId + "; capturer cleanup skipped");
      }
    }
  }

  public ConstraintsMap getCameraInfo(int index) {
    CameraInfo info = new CameraInfo();

    try {
      Camera.getCameraInfo(index, info);
    } catch (Exception e) {
      Logging.e("CameraEnumerationAndroid", "getCameraInfo failed on index " + index, e);
      return null;
    }
    ConstraintsMap params = new ConstraintsMap();
    String facing = info.facing == 1 ? "front" : "back";
    params.putString("label",
            "Camera " + index + ", Facing " + facing + ", Orientation " + info.orientation);
    params.putString("deviceId", "" + index);
    params.putString("facing", facing);
    params.putString("kind", "videoinput");
    params.putString("groupId", "camera");
    return params;
  }

  private MediaConstraints defaultConstraints() {
    MediaConstraints constraints = new MediaConstraints();
    // TODO video media
    constraints.mandatory.add(new KeyValuePair("OfferToReceiveAudio", "true"));
    constraints.mandatory.add(new KeyValuePair("OfferToReceiveVideo", "true"));
    constraints.optional.add(new KeyValuePair("DtlsSrtpKeyAgreement", "true"));
    return constraints;
  }

  public void peerConnectionSetConfiguration(ConstraintsMap configuration,
                                             PeerConnection peerConnection) {
    if (peerConnection == null) {
      Log.d(TAG, "peerConnectionSetConfiguration() peerConnection is null");
      return;
    }
    peerConnection.setConfiguration(parseRTCConfiguration(configuration));
  }

  public void peerConnectionAddStream(final String streamId, final String id, Result result) {
    MediaStream mediaStream = localStreams.get(streamId);
    if (mediaStream == null) {
      Log.d(TAG, "peerConnectionAddStream() mediaStream is null");
      return;
    }
    PeerConnection peerConnection = getPeerConnection(id);
    if (peerConnection != null) {
      boolean res = peerConnection.addStream(mediaStream);
      Log.d(TAG, "addStream" + result);
      result.success(res);
    } else {
      resultError("peerConnectionAddStream", "peerConnection is null", result);
    }
  }

  public void peerConnectionRemoveStream(final String streamId, final String id, Result result) {
    MediaStream mediaStream = localStreams.get(streamId);
    if (mediaStream == null) {
      Log.d(TAG, "peerConnectionRemoveStream() mediaStream is null");
      return;
    }
    PeerConnection peerConnection = getPeerConnection(id);
    if (peerConnection != null) {
      peerConnection.removeStream(mediaStream);
      result.success(null);
    } else {
      resultError("peerConnectionRemoveStream", "peerConnection is null", result);
    }
  }

  public void peerConnectionCreateOffer(
          String id,
          ConstraintsMap constraints,
          final Result result) {
    PeerConnection peerConnection = getPeerConnection(id);

    if (peerConnection != null) {
      peerConnection.createOffer(new SdpObserver() {
        @Override
        public void onCreateFailure(String s) {
          resultError("peerConnectionCreateOffer", "WEBRTC_CREATE_OFFER_ERROR: " + s, result);
        }

        @Override
        public void onCreateSuccess(final SessionDescription sdp) {
          ConstraintsMap params = new ConstraintsMap();
          params.putString("sdp", sdp.description);
          params.putString("type", sdp.type.canonicalForm());
          result.success(params.toMap());
        }

        @Override
        public void onSetFailure(String s) {
        }

        @Override
        public void onSetSuccess() {
        }
      }, parseMediaConstraints(constraints));
    } else {
      resultError("peerConnectionCreateOffer", "WEBRTC_CREATE_OFFER_ERROR", result);
    }
  }

  public void peerConnectionCreateAnswer(
          String id,
          ConstraintsMap constraints,
          final Result result) {
    PeerConnection peerConnection = getPeerConnection(id);

    if (peerConnection != null) {
      peerConnection.createAnswer(new SdpObserver() {
        @Override
        public void onCreateFailure(String s) {
          resultError("peerConnectionCreateAnswer", "WEBRTC_CREATE_ANSWER_ERROR: " + s, result);
        }

        @Override
        public void onCreateSuccess(final SessionDescription sdp) {
          ConstraintsMap params = new ConstraintsMap();
          params.putString("sdp", sdp.description);
          params.putString("type", sdp.type.canonicalForm());
          result.success(params.toMap());
        }

        @Override
        public void onSetFailure(String s) {
        }

        @Override
        public void onSetSuccess() {
        }
      }, parseMediaConstraints(constraints));
    } else {
      resultError("peerConnectionCreateAnswer", "peerConnection is null", result);
    }
  }

  public void peerConnectionSetLocalDescription(ConstraintsMap sdpMap, final String id,
                                                final Result result) {
    PeerConnection peerConnection = getPeerConnection(id);
    if (peerConnection != null) {
      SessionDescription sdp = new SessionDescription(
              Type.fromCanonicalForm(sdpMap.getString("type")),
              sdpMap.getString("sdp")
      );

      peerConnection.setLocalDescription(new SdpObserver() {
        @Override
        public void onCreateSuccess(final SessionDescription sdp) {
        }

        @Override
        public void onSetSuccess() {
          result.success(null);
        }

        @Override
        public void onCreateFailure(String s) {
        }

        @Override
        public void onSetFailure(String s) {
          resultError("peerConnectionSetLocalDescription", "WEBRTC_SET_LOCAL_DESCRIPTION_ERROR: " + s, result);
        }
      }, sdp);
    } else {
      resultError("peerConnectionSetLocalDescription", "WEBRTC_SET_LOCAL_DESCRIPTION_ERROR: peerConnection is null", result);
    }
  }

  public void peerConnectionSetRemoteDescription(final ConstraintsMap sdpMap, final String id,
                                                 final Result result) {
    PeerConnection peerConnection = getPeerConnection(id);
    if (peerConnection != null) {
      SessionDescription sdp = new SessionDescription(
              Type.fromCanonicalForm(sdpMap.getString("type")),
              sdpMap.getString("sdp")
      );

      peerConnection.setRemoteDescription(new SdpObserver() {
        @Override
        public void onCreateSuccess(final SessionDescription sdp) {
        }

        @Override
        public void onSetSuccess() {
          result.success(null);
        }

        @Override
        public void onCreateFailure(String s) {
        }

        @Override
        public void onSetFailure(String s) {
          resultError("peerConnectionSetRemoteDescription", "WEBRTC_SET_REMOTE_DESCRIPTION_ERROR: " + s, result);
        }
      }, sdp);
    } else {
      resultError("peerConnectionSetRemoteDescription", "WEBRTC_SET_REMOTE_DESCRIPTION_ERROR: peerConnection is null", result);
    }
  }

  public void peerConnectionAddICECandidate(ConstraintsMap candidateMap, final String id,
                                            final Result result) {
    boolean res = false;
    PeerConnection peerConnection = getPeerConnection(id);
    if (peerConnection != null) {
      int sdpMLineIndex = 0;
      if (!candidateMap.isNull("sdpMLineIndex")) {
        sdpMLineIndex = candidateMap.getInt("sdpMLineIndex");
      }
      IceCandidate candidate = new IceCandidate(
          candidateMap.getString("sdpMid"),
          sdpMLineIndex,
          candidateMap.getString("candidate"));
      res = peerConnection.addIceCandidate(candidate);
    } else {
      resultError("peerConnectionAddICECandidate", "peerConnection is null", result);
    }
    result.success(res);
  }

  public void peerConnectionGetStats(String trackId, String id, final Result result) {
    PeerConnectionObserver pco = mPeerConnectionObservers.get(id);
    if (pco == null || pco.getPeerConnection() == null) {
      resultError("peerConnectionGetStats", "peerConnection is null", result);
    } else {
      if(trackId == null || trackId.isEmpty()) {
        pco.getStats(result);
      } else {
        pco.getStatsForTrack(trackId, result);
      }
    }
  }

  public void restartIce(final String id) {
    PeerConnectionObserver pco = mPeerConnectionObservers.get(id);
    if (pco == null || pco.getPeerConnection() == null) {
      Log.d(TAG, "restartIce() peerConnection is null");
    } else {
      pco.restartIce();
    }
  }

  /**
   * Closes the peer connection off the main thread and replies once it is
   * closed. The connection stays registered: only a dispose unregisters it.
   */
  private void peerConnectionCloseAsync(final String id, final Result result) {
    final PeerConnectionObserver pco = mPeerConnectionObservers.get(id);
    if (pco == null || pco.getPeerConnection() == null) {
      if (!replyAfterPendingClose(id, result)) {
        Log.d(TAG, "peerConnectionClose() peerConnection is null");
        result.success(null);
      }
      return;
    }
    peerConnectionCloseExecutor.execute(() -> {
      final Throwable closeError = closeNativeQuietly(pco, "peerConnectionClose");
      mainHandler.post(() -> {
        Throwable error = closeError;
        try {
          pco.onClosed();
        } catch (Throwable t) {
          Log.w(TAG, "peerConnectionClose() cleanup failed", t);
          if (error == null) {
            error = t;
          }
        }
        replyClosed("peerConnectionClose", error, result);
      });
    });
  }

  /**
   * Closes the peer connection off the main thread, then frees it on the main
   * thread (see {@link PeerConnectionObserver#dispose()}) and replies. It is
   * unregistered right away, so no call made meanwhile can reach it; a repeat
   * close or dispose waits for this one instead.
   */
  private void peerConnectionDisposeAsync(final String id, final Result result) {
    final PeerConnectionObserver pco = mPeerConnectionObservers.get(id);
    if (pco == null || pco.getPeerConnection() == null) {
      if (!replyAfterPendingClose(id, result)) {
        // Nothing native to tear down: same bookkeeping as the synchronous path.
        peerConnectionDispose(id);
        result.success(null);
      }
      return;
    }
    mPeerConnectionObservers.remove(id);
    disposingPeerConnections.put(id, pco);
    peerConnectionCloseExecutor.execute(() -> {
      final Throwable closeError = closeNativeQuietly(pco, "peerConnectionDispose");
      mainHandler.post(() -> {
        Throwable error = closeError;
        // Already freed if the engine detached meanwhile.
        if (disposingPeerConnections.remove(id) != null) {
          // Dispose even after a failed close: it is the only chance to free it.
          try {
            pco.dispose();
          } catch (Throwable t) {
            Log.w(TAG, "peerConnectionDispose() dispose failed", t);
            if (error == null) {
              error = t;
            }
          }
          try {
            onPeerConnectionDisposed(id);
          } catch (Throwable t) {
            Log.w(TAG, "peerConnectionDispose() cleanup failed", t);
            if (error == null) {
              error = t;
            }
          }
        }
        replyClosed("peerConnectionDispose", error, result);
      });
    });
  }

  /**
   * A close or dispose for a connection that a dispose is still closing on
   * peerConnectionCloseExecutor (see {@link #disposingPeerConnections}).
   * Replies once that close is done, so the reply still means closed; the
   * running dispose does the bookkeeping. Returns false if none is running.
   */
  private boolean replyAfterPendingClose(final String id, final Result result) {
    if (!disposingPeerConnections.containsKey(id)) {
      return false;
    }
    peerConnectionCloseExecutor.execute(() -> mainHandler.post(() -> result.success(null)));
    return true;
  }

  /** Runs {@link PeerConnectionObserver#closeNative()}, returning what it threw. */
  private static Throwable closeNativeQuietly(PeerConnectionObserver pco, String method) {
    try {
      pco.closeNative();
      return null;
    } catch (Throwable t) {
      Log.w(TAG, method + "() close failed", t);
      return t;
    }
  }

  /**
   * Replies to a close or dispose from a posted runnable. Those run outside
   * MethodChannel's try/catch, so a failure is reported as an error reply
   * instead of crashing the looper and leaving Dart waiting.
   */
  private static void replyClosed(String method, Throwable error, Result result) {
    if (error == null) {
      result.success(null);
    } else {
      resultError(method, error.toString(), result);
    }
  }

  public void peerConnectionDispose(final String id) {
    PeerConnectionObserver pco = mPeerConnectionObservers.get(id);
    if (pco != null) {
      if (peerConnectionDispose(pco)) {

        mPeerConnectionObservers.remove(id);
      }
    } else {
      Log.d(TAG, "peerConnectionDispose() peerConnectionObserver is null");
    }
    onPeerConnectionDisposed(id);
  }

  /** Factory bookkeeping and audio-routing shutdown after a dispose. */
  private void onPeerConnectionDisposed(final String id) {
    // Drop the PC from per-call factory bookkeeping.
    final String factoryId = pcFactoryId.remove(id);
    if (factoryId != null) {
      final NativePeerConnectionFactory nf = factories.get(factoryId);
      if (nf != null) {
        nf.ownedPcIds.remove(id);
      }
    }

    if (mPeerConnectionObservers.isEmpty() && disposingPeerConnections.isEmpty()) {
      AudioSwitchManager.instance.stop();
    }
  }

  public boolean peerConnectionDispose(final PeerConnectionObserver pco) {
    if (pco.getPeerConnection() == null) {
      Log.d(TAG, "peerConnectionDispose() peerConnection is null");
    } else {
      pco.dispose();
      return true;
    }
    return false;
  }

  public void streamDispose(final String streamId) {
    MediaStream stream = localStreams.get(streamId);
    if (stream != null) {
      streamDispose(stream);
      localStreams.remove(streamId);
      removeStreamForRendererById(streamId);
    } else {
      Log.d(TAG, "streamDispose() mediaStream is null");
    }
    final NativePeerConnectionFactory nf = resolveFactoryForStream(streamId);
    if (nf != null) {
      nf.ownedStreamIds.remove(streamId);
    }
  }

  public void streamDispose(final MediaStream stream) {
    List<VideoTrack> videoTracks = stream.videoTracks;
    for (VideoTrack track : videoTracks) {
      String trackIdSafe;
      try {
        trackIdSafe = track.id();
      } catch (Throwable t) {
        trackIdSafe = null;
      }
      if (trackIdSafe != null) {
        localTracks.remove(trackIdSafe);
        final NativePeerConnectionFactory nf = resolveFactoryForTrack(trackIdSafe);
        if (nf != null) {
          try {
            nf.getUserMediaImpl.removeVideoCapturer(trackIdSafe);
          } catch (Throwable t) {
            Log.w(TAG, "[streamDispose] removeVideoCapturer failed: " + t);
          }
        } else {
          Log.w(TAG, "[streamDispose] no factory owns trackId "
              + trackIdSafe + "; capturer cleanup skipped");
        }
      }
      try {
        stream.removeTrack(track);
      } catch (Throwable t) {
        Log.w(TAG, "[streamDispose] stream.removeTrack(video) failed: " + t);
      }
    }
    List<AudioTrack> audioTracks = stream.audioTracks;
    for (AudioTrack track : audioTracks) {
      String trackIdSafe;
      try {
        trackIdSafe = track.id();
      } catch (Throwable t) {
        trackIdSafe = null;
      }
      if (trackIdSafe != null) {
        localTracks.remove(trackIdSafe);
      }
      try {
        stream.removeTrack(track);
      } catch (Throwable t) {
        Log.w(TAG, "[streamDispose] stream.removeTrack(audio) failed: " + t);
      }
    }
  }

  private void removeStreamForRendererById(String streamId) {
    for (int i = 0; i < renders.size(); i++) {
      FlutterRTCVideoRenderer renderer = renders.valueAt(i);
      if (renderer.checkMediaStream(streamId, "local")) {
        renderer.setStream(null, "");
      }
    }
  }

  private void removeTrackForRendererById(String trackId) {
    for (int i = 0; i < renders.size(); i++) {
      FlutterRTCVideoRenderer renderer = renders.valueAt(i);
      if (renderer.checkVideoTrack(trackId, "local")) {
        renderer.setStream(null, null);
      }
    }
  }

  private Severity str2LogSeverity(String severity) {
    switch (severity) {
      case "verbose":
        return Severity.LS_VERBOSE;
      case "info":
        return Severity.LS_INFO;
      case "warning":
        return Severity.LS_WARNING;
      case "error":
        return Severity.LS_ERROR;
      case "none":
      default:
        return Severity.LS_NONE;
    }
  }

  public void createDataChannel(final String peerConnectionId, String label, ConstraintsMap config,
                                Result result) {
    // Forward to PeerConnectionObserver which deals with DataChannels
    // because DataChannel is owned by PeerConnection.
    PeerConnectionObserver pco
            = mPeerConnectionObservers.get(peerConnectionId);
    if (pco == null || pco.getPeerConnection() == null) {
      Log.d(TAG, "createDataChannel() peerConnection is null");
    } else {
      pco.createDataChannel(label, config, result);
    }
  }

  public void dataChannelSend(String peerConnectionId, String dataChannelId, ByteBuffer bytebuffer,
                              Boolean isBinary) {
    // Forward to PeerConnectionObserver which deals with DataChannels
    // because DataChannel is owned by PeerConnection.
    PeerConnectionObserver pco
            = mPeerConnectionObservers.get(peerConnectionId);
    if (pco == null || pco.getPeerConnection() == null) {
      Log.d(TAG, "dataChannelSend() peerConnection is null");
    } else {
      pco.dataChannelSend(dataChannelId, bytebuffer, isBinary);
    }
  }

  public void dataChannelGetBufferedAmount(String peerConnectionId, String dataChannelId, Result result) {
    PeerConnectionObserver pco
            = mPeerConnectionObservers.get(peerConnectionId);
    if (pco == null || pco.getPeerConnection() == null) {
      Log.d(TAG, "dataChannelGetBufferedAmount() peerConnection is null");
      resultError("dataChannelGetBufferedAmount", "peerConnection is null", result);
    } else {
      pco.dataChannelGetBufferedAmount(dataChannelId, result);
    }
  }

  public void dataChannelClose(String peerConnectionId, String dataChannelId) {
    // Forward to PeerConnectionObserver which deals with DataChannels
    // because DataChannel is owned by PeerConnection.
    PeerConnectionObserver pco
            = mPeerConnectionObservers.get(peerConnectionId);
    if (pco == null || pco.getPeerConnection() == null) {
      Log.d(TAG, "dataChannelClose() peerConnection is null");
    } else {
      pco.dataChannelClose(dataChannelId);
    }
  }

  public void setActivity(Activity activity) {
    this.activity = activity;
  }

  public void addTrack(String peerConnectionId, String trackId, List<String> streamIds, Result result) {
    PeerConnectionObserver pco = mPeerConnectionObservers.get(peerConnectionId);
    LocalTrack track = localTracks.get(trackId);
    if (track == null) {
      resultError("addTrack", "track is null", result);
      return;
    }
    if (pco == null || pco.getPeerConnection() == null) {
      resultError("addTrack", "peerConnection is null", result);
    } else {
      pco.addTrack(track.track, streamIds, result);
    }
  }

  public void removeTrack(String peerConnectionId, String senderId, Result result) {
    PeerConnectionObserver pco = mPeerConnectionObservers.get(peerConnectionId);
    if (pco == null || pco.getPeerConnection() == null) {
      resultError("removeTrack", "peerConnection is null", result);
    } else {
      pco.removeTrack(senderId, result);
    }
  }

  public void addTransceiver(String peerConnectionId, String trackId, Map<String, Object> transceiverInit,
                             Result result) {
    PeerConnectionObserver pco = mPeerConnectionObservers.get(peerConnectionId);
    LocalTrack track = localTracks.get(trackId);
    if (track == null) {
      resultError("addTransceiver", "track is null", result);
      return;
    }
    if (pco == null || pco.getPeerConnection() == null) {
      resultError("addTransceiver", "peerConnection is null", result);
    } else {
      pco.addTransceiver(track.track, transceiverInit, result);
    }
  }

  public void addTransceiverOfType(String peerConnectionId, String mediaType, Map<String, Object> transceiverInit,
                                   Result result) {
    PeerConnectionObserver pco = mPeerConnectionObservers.get(peerConnectionId);
    if (pco == null || pco.getPeerConnection() == null) {
      resultError("addTransceiverOfType", "peerConnection is null", result);
    } else {
      pco.addTransceiverOfType(mediaType, transceiverInit, result);
    }
  }

  public void rtpTransceiverSetDirection(String peerConnectionId, String direction, String transceiverId, Result result) {
    PeerConnectionObserver pco = mPeerConnectionObservers.get(peerConnectionId);
    if (pco == null || pco.getPeerConnection() == null) {
      resultError("rtpTransceiverSetDirection", "peerConnection is null", result);
    } else {
      pco.rtpTransceiverSetDirection(direction, transceiverId, result);
    }
  }

  public void rtpTransceiverSetCodecPreferences(String peerConnectionId, String transceiverId, List<Map<String, Object>> codecs, Result result) {
    PeerConnectionObserver pco = mPeerConnectionObservers.get(peerConnectionId);
    if (pco == null || pco.getPeerConnection() == null) {
      resultError("setCodecPreferences", "peerConnection is null", result);
    } else {
      pco.rtpTransceiverSetCodecPreferences(transceiverId, codecs, result);
    }
  }

  public void rtpTransceiverGetDirection(String peerConnectionId, String transceiverId, Result result) {
    PeerConnectionObserver pco = mPeerConnectionObservers.get(peerConnectionId);
    if (pco == null || pco.getPeerConnection() == null) {
      resultError("rtpTransceiverSetDirection", "peerConnection is null", result);
    } else {
      pco.rtpTransceiverGetDirection(transceiverId, result);
    }
  }

  public void rtpTransceiverGetCurrentDirection(String peerConnectionId, String transceiverId, Result result) {
    PeerConnectionObserver pco = mPeerConnectionObservers.get(peerConnectionId);
    if (pco == null || pco.getPeerConnection() == null) {
      resultError("rtpTransceiverSetDirection", "peerConnection is null", result);
    } else {
      pco.rtpTransceiverGetCurrentDirection(transceiverId, result);
    }
  }

  public void rtpTransceiverStop(String peerConnectionId, String transceiverId, Result result) {
    PeerConnectionObserver pco = mPeerConnectionObservers.get(peerConnectionId);
    if (pco == null || pco.getPeerConnection() == null) {
      resultError("rtpTransceiverStop", "peerConnection is null", result);
    } else {
      pco.rtpTransceiverStop(transceiverId, result);
    }
  }

  public void rtpSenderSetParameters(String peerConnectionId, String rtpSenderId, Map<String, Object> parameters, Result result) {
    PeerConnectionObserver pco = mPeerConnectionObservers.get(peerConnectionId);
    if (pco == null || pco.getPeerConnection() == null) {
      resultError("rtpSenderSetParameters", "peerConnection is null", result);
    } else {
      pco.rtpSenderSetParameters(rtpSenderId, parameters, result);
    }
  }

  public void getSenders(String peerConnectionId, Result result) {
    PeerConnectionObserver pco = mPeerConnectionObservers.get(peerConnectionId);
    if (pco == null || pco.getPeerConnection() == null) {
      resultError("getSenders", "peerConnection is null", result);
    } else {
      pco.getSenders(result);
    }
  }

  public void getReceivers(String peerConnectionId, Result result) {
    PeerConnectionObserver pco = mPeerConnectionObservers.get(peerConnectionId);
    if (pco == null || pco.getPeerConnection() == null) {
      resultError("getReceivers", "peerConnection is null", result);
    } else {
      pco.getReceivers(result);
    }
  }

  public void getTransceivers(String peerConnectionId, Result result) {
    PeerConnectionObserver pco = mPeerConnectionObservers.get(peerConnectionId);
    if (pco == null || pco.getPeerConnection() == null) {
      resultError("getTransceivers", "peerConnection is null", result);
    } else {
      pco.getTransceivers(result);
    }
  }

  public void rtpSenderSetTrack(String peerConnectionId, String rtpSenderId, String trackId, boolean replace, Result result) {
    PeerConnectionObserver pco = mPeerConnectionObservers.get(peerConnectionId);
    if (pco == null || pco.getPeerConnection() == null) {
      resultError("rtpSenderSetTrack", "peerConnection is null", result);
    } else {
      MediaStreamTrack mediaStreamTrack = null;
      LocalTrack track = localTracks.get(trackId);
      if (trackId.length() > 0) {
        if (track == null) {
          resultError("rtpSenderSetTrack", "track is null", result);
          return;
        }
      }

      if(track != null) {
        mediaStreamTrack = track.track;
      }
      pco.rtpSenderSetTrack(rtpSenderId, mediaStreamTrack, result, replace);
    }
  }

  public void rtpSenderSetStreams(String peerConnectionId, String rtpSenderId, List<String> streamIds, Result result) {
    PeerConnectionObserver pco = mPeerConnectionObservers.get(peerConnectionId);
    if (pco == null || pco.getPeerConnection() == null) {
      resultError("rtpSenderSetStreams", "peerConnection is null", result);
    } else {
      pco.rtpSenderSetStreams(rtpSenderId, streamIds, result);
    }
  }

  @Override
  public void onRemoteAudioTrackAdded(AudioTrack track) {
    if (track == null) {
      return;
    }

    String trackId = track.id();
    trackVolumeCache.putIfAbsent(trackId, 1.0);

    if (isAudioPlayoutPaused) {
      double previousVolume = trackVolumeCache.getOrDefault(trackId, 1.0);
      pausedTrackVolumes.put(trackId, previousVolume);
      try {
        track.setVolume(0.0);
      } catch (Exception e) {
        Log.e(TAG, "onRemoteAudioTrackAdded: setVolume failed for track " + trackId, e);
      }
    }
  }

  @Override
  public void onRemoteAudioTrackRemoved(String trackId) {
    if (trackId == null) {
      return;
    }
    
    pausedTrackVolumes.remove(trackId);
    trackVolumeCache.remove(trackId);
  }

  public void reStartCamera() {
    final GetUserMediaImpl.IsCameraEnabled isEnabled = new GetUserMediaImpl.IsCameraEnabled() {
      @Override
      public boolean isEnabled(String id) {
        if (!localTracks.containsKey(id)) {
          return false;
        }
        return localTracks.get(id).enabled();
      }
    };

    // Restart cameras across every factory so none are left in a
    // suspended state after returning from background.
    for (NativePeerConnectionFactory nf : factories.values()) {
      if (nf.getUserMediaImpl != null) {
        nf.getUserMediaImpl.reStartCamera(isEnabled);
      }
    }
  }

  @RequiresApi(api = Build.VERSION_CODES.M)
  void requestPermissions(
          final ArrayList<String> permissions,
          final Callback successCallback,
          final Callback errorCallback) {
    PermissionUtils.Callback callback =
            (permissions_, grantResults) -> {
              List<String> grantedPermissions = new ArrayList<>();
              List<String> deniedPermissions = new ArrayList<>();

              for (int i = 0; i < permissions_.length; ++i) {
                String permission = permissions_[i];
                int grantResult = grantResults[i];

                if (grantResult == PackageManager.PERMISSION_GRANTED) {
                  grantedPermissions.add(permission);
                } else {
                  deniedPermissions.add(permission);
                }
              }

              // Success means that all requested permissions were granted.
              for (String p : permissions) {
                if (!grantedPermissions.contains(p)) {
                  // According to step 6 of the getUserMedia() algorithm
                  // "if the result is denied, jump to the step Permission
                  // Failure."
                  errorCallback.invoke(deniedPermissions);
                  return;
                }
              }
              successCallback.invoke(grantedPermissions);
            };

    final Activity activity = getActivity();
    final Context context = getApplicationContext();
    PermissionUtils.requestPermissions(
            context,
            activity,
            permissions.toArray(new String[permissions.size()]), callback);
  }
}
