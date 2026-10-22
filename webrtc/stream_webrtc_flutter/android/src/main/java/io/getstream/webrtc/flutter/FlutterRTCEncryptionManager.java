package io.getstream.webrtc.flutter;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.webrtc.EncryptionManager;
import org.webrtc.RtpReceiver;
import org.webrtc.RtpSender;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;
import io.getstream.webrtc.flutter.utils.AnyThreadSink;

/** Bridges {@link EncryptionManager} to Dart using Stream's implementation via a per-instance event channel. */
class FlutterRTCEncryptionManager {

  /** Dart sends -1 when it wants native to infer audio vs video from RTP. */
  private static final int TRACK_TYPE_UNSPECIFIED = -1;

  private final StateProvider stateProvider;
  private final ConcurrentHashMap<String, Handle> handles = new ConcurrentHashMap<>();

  /**
   * Releases native managers off the platform thread.
   *
   * <p>Disposing joins the manager's frame-crypto worker, so doing it inline
   * would block the Android main thread for as long as that worker takes to
   * drain — an ANR if it is mid-frame or wedged. Nothing after teardown needs
   * the manager, so the join can finish in the background.
   */
  private final ExecutorService disposeExecutor =
      Executors.newSingleThreadExecutor(
          runnable -> {
            Thread thread = new Thread(runnable, "E2EEManagerDispose");
            thread.setDaemon(true);
            return thread;
          });

  FlutterRTCEncryptionManager(StateProvider stateProvider) {
    this.stateProvider = stateProvider;
  }

  private static class Handle implements EventChannel.StreamHandler {
    final EncryptionManager manager;
    final EventChannel eventChannel;
    @Nullable volatile EventChannel.EventSink sink;

    Handle(EncryptionManager manager, EventChannel eventChannel) {
      this.manager = manager;
      this.eventChannel = eventChannel;
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
      sink = new AnyThreadSink(events);
    }

    @Override
    public void onCancel(Object arguments) {
      sink = null;
    }

    void send(Map<String, Object> event) {
      final EventChannel.EventSink target = sink;
      if (target != null) {
        target.success(event);
      }
    }

    /**
     * Detaches the event channel. Must run on the platform thread, and must
     * happen before {@link #releaseNative()} so no event races the teardown.
     */
    void detach() {
      eventChannel.setStreamHandler(null);
      sink = null;
      manager.setObserver(null);
    }

    /** Releases the native manager. Blocks on its frame-crypto worker. */
    void releaseNative() {
      manager.dispose();
    }
  }

  /**
   * @return {@code true} when {@code call} was an encryption-manager method,
   *     handled (successfully or with an error) by this class.
   */
  boolean handleMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    final String method = call.method;
    if (method == null || !method.startsWith("encryptionManager")) {
      return false;
    }

    switch (method) {
      case "encryptionManagerCreate":
        create(call, result);
        return true;
      case "encryptionManagerSetKey":
        setKey(call, result);
        return true;
      case "encryptionManagerSetSharedKey":
        setSharedKey(call, result);
        return true;
      case "encryptionManagerRemoveKey":
        removeKey(call, result);
        return true;
      case "encryptionManagerRemoveAllKeys":
        removeAllKeys(call, result);
        return true;
      case "encryptionManagerRemoveSharedKey":
        removeSharedKey(call, result);
        return true;
      case "encryptionManagerEncrypt":
        encrypt(call, result);
        return true;
      case "encryptionManagerDecrypt":
        decrypt(call, result);
        return true;
      case "encryptionManagerEnablePerformanceReporting":
        enablePerformanceReporting(call, result);
        return true;
      case "encryptionManagerRequestKeyState":
        requestKeyState(call, result);
        return true;
      case "encryptionManagerDispose":
        dispose(call, result);
        return true;
      default:
        return false;
    }
  }

  /** Releases every manager, e.g. when the plugin detaches from the engine. */
  void disposeAll() {
    final List<Handle> pending = new ArrayList<>(handles.values());
    handles.clear();
    for (Handle handle : pending) {
      handle.detach();
      disposeExecutor.execute(handle::releaseNative);
    }
  }

  // MARK: - Methods

  private void create(MethodCall call, Result result) {
    final String userId = call.argument("userId");
    if (userId == null || userId.isEmpty()) {
      result.error("encryptionManagerCreateFailed", "userId is required", null);
      return;
    }

    final Integer algorithmValue = call.argument("algorithm");
    final EncryptionManager.Algorithm algorithm =
        algorithmValue != null && algorithmValue == EncryptionManager.Algorithm.AES_256_GCM.getValue()
            ? EncryptionManager.Algorithm.AES_256_GCM
            : EncryptionManager.Algorithm.AES_128_GCM;

    try {
      final String managerId = UUID.randomUUID().toString();
      final EncryptionManager manager = EncryptionManager.create(userId, algorithm);
      final EventChannel eventChannel =
          new EventChannel(stateProvider.getMessenger(), "FlutterWebRTC/e2ee/" + managerId);
      final Handle handle = new Handle(manager, eventChannel);

      eventChannel.setStreamHandler(handle);
      manager.setObserver(event -> handle.send(eventToMap(event)));
      handles.put(managerId, handle);

      final Map<String, Object> response = new HashMap<>();
      response.put("managerId", managerId);
      result.success(response);
    } catch (Exception e) {
      result.error("encryptionManagerCreateFailed", e.getMessage(), null);
    }
  }

  private void setKey(MethodCall call, Result result) {
    final EncryptionManager manager = requireManager(call, result);
    if (manager == null) {
      return;
    }
    final String userId = call.argument("userId");
    final Integer keyIndex = call.argument("keyIndex");
    final byte[] rawKey = call.argument("rawKey");
    if (userId == null || keyIndex == null || rawKey == null) {
      result.error(call.method + "Failed", "userId, keyIndex and rawKey are required", null);
      return;
    }
    try {
      manager.setKey(userId, keyIndex, rawKey);
      result.success(null);
    } catch (Exception e) {
      result.error(call.method + "Failed", e.getMessage(), null);
    }
  }

  private void setSharedKey(MethodCall call, Result result) {
    final EncryptionManager manager = requireManager(call, result);
    if (manager == null) {
      return;
    }
    final Integer keyIndex = call.argument("keyIndex");
    final byte[] rawKey = call.argument("rawKey");
    if (keyIndex == null || rawKey == null) {
      result.error(call.method + "Failed", "keyIndex and rawKey are required", null);
      return;
    }
    try {
      manager.setSharedKey(keyIndex, rawKey);
      result.success(null);
    } catch (Exception e) {
      result.error(call.method + "Failed", e.getMessage(), null);
    }
  }

  private void removeKey(MethodCall call, Result result) {
    final EncryptionManager manager = requireManager(call, result);
    if (manager == null) {
      return;
    }
    final String userId = call.argument("userId");
    final Integer keyIndex = call.argument("keyIndex");
    if (userId == null || keyIndex == null) {
      result.error(call.method + "Failed", "userId and keyIndex are required", null);
      return;
    }
    try {
      manager.removeKey(userId, keyIndex);
      result.success(null);
    } catch (Exception e) {
      result.error(call.method + "Failed", e.getMessage(), null);
    }
  }

  private void removeAllKeys(MethodCall call, Result result) {
    final EncryptionManager manager = requireManager(call, result);
    if (manager == null) {
      return;
    }
    final String userId = call.argument("userId");
    if (userId == null) {
      result.error(call.method + "Failed", "userId is required", null);
      return;
    }
    try {
      manager.removeAllKeys(userId);
      result.success(null);
    } catch (Exception e) {
      result.error(call.method + "Failed", e.getMessage(), null);
    }
  }

  private void removeSharedKey(MethodCall call, Result result) {
    final EncryptionManager manager = requireManager(call, result);
    if (manager == null) {
      return;
    }
    final Integer keyIndex = call.argument("keyIndex");
    if (keyIndex == null) {
      result.error(call.method + "Failed", "keyIndex is required", null);
      return;
    }
    try {
      manager.removeSharedKey(keyIndex);
      result.success(null);
    } catch (Exception e) {
      result.error(call.method + "Failed", e.getMessage(), null);
    }
  }

  private void encrypt(MethodCall call, Result result) {
    final EncryptionManager manager = requireManager(call, result);
    if (manager == null) {
      return;
    }

    final PeerConnectionObserver pco = requireObserver(call, result);
    if (pco == null) {
      return;
    }

    final String senderId = call.argument("rtpSenderId");
    if (senderId == null) {
      result.error(call.method + "Failed", "rtpSenderId is required", null);
      return;
    }

    final RtpSender sender = pco.getRtpSenderById(senderId);
    if (sender == null) {
      result.error(call.method + "Failed", "sender " + senderId + " not found", null);
      return;
    }

    try {
      manager.encrypt(sender, call.argument("codec"), trackType(call));
      result.success(null);
    } catch (Exception e) {
      result.error(call.method + "Failed", e.getMessage(), null);
    }
  }

  private void decrypt(MethodCall call, Result result) {
    final EncryptionManager manager = requireManager(call, result);
    if (manager == null) {
      return;
    }

    final PeerConnectionObserver pco = requireObserver(call, result);
    if (pco == null) {
      return;
    }

    final String receiverId = call.argument("rtpReceiverId");
    final String userId = call.argument("userId");
    if (receiverId == null || userId == null || userId.isEmpty()) {
      result.error(call.method + "Failed", "rtpReceiverId and userId are required", null);
      return;
    }

    final RtpReceiver receiver = pco.getRtpReceiverById(receiverId);
    if (receiver == null) {
      result.error(call.method + "Failed", "receiver " + receiverId + " not found", null);
      return;
    }

    try {
      manager.decrypt(receiver, userId, trackType(call));
      result.success(null);
    } catch (Exception e) {
      result.error(call.method + "Failed", e.getMessage(), null);
    }
  }

  private void enablePerformanceReporting(MethodCall call, Result result) {
    final EncryptionManager manager = requireManager(call, result);
    if (manager == null) {
      return;
    }
    final Boolean enabled = call.argument("enabled");
    try {
      manager.enablePerformanceReporting(Boolean.TRUE.equals(enabled));
      result.success(null);
    } catch (Exception e) {
      result.error(call.method + "Failed", e.getMessage(), null);
    }
  }

  private void requestKeyState(MethodCall call, Result result) {
    final EncryptionManager manager = requireManager(call, result);
    if (manager == null) {
      return;
    }
    try {
      manager.requestKeyState();
      result.success(null);
    } catch (Exception e) {
      result.error(call.method + "Failed", e.getMessage(), null);
    }
  }

  private void dispose(MethodCall call, Result result) {
    final String managerId = call.argument("managerId");
    final Handle handle = managerId == null ? null : handles.remove(managerId);
    if (handle != null) {
      handle.detach();
      // Off the platform thread: releasing joins the frame-crypto worker.
      disposeExecutor.execute(handle::releaseNative);
    }
    // Disposing an unknown manager is not an error: Dart may retry teardown.
    // Answering before the join completes is fine — the handle is already out
    // of the registry, so nothing can reach it again.
    result.success(null);
  }

  // MARK: - Helpers

  @Nullable
  private EncryptionManager requireManager(MethodCall call, Result result) {
    final String managerId = call.argument("managerId");
    final Handle handle = managerId == null ? null : handles.get(managerId);
    if (handle == null) {
      result.error(
          call.method + "Failed", "EncryptionManager " + managerId + " not found", null);
      return null;
    }
    return handle.manager;
  }

  @Nullable
  private PeerConnectionObserver requireObserver(MethodCall call, Result result) {
    final String peerConnectionId = call.argument("peerConnectionId");
    final PeerConnectionObserver pco =
        peerConnectionId == null ? null : stateProvider.getPeerConnectionObserver(peerConnectionId);
    if (pco == null) {
      result.error(
          call.method + "Failed", "peerConnection " + peerConnectionId + " not found", null);
      return null;
    }
    return pco;
  }

  /** Maps Dart's {@code trackType} to the enum, or {@code null} to let RTP decide. */
  @Nullable
  private static EncryptionManager.TrackType trackType(MethodCall call) {
    final Integer value = call.argument("trackType");
    if (value == null || value == TRACK_TYPE_UNSPECIFIED) {
      return null;
    }
    for (EncryptionManager.TrackType type : EncryptionManager.TrackType.values()) {
      if (type.getValue() == value) {
        return type;
      }
    }
    return null;
  }

  // MARK: - Event serialization

  private static Map<String, Object> eventToMap(EncryptionManager.E2eeEvent event) {
    final Map<String, Object> map = new HashMap<>();
    map.put("type", event.type.getValue());
    map.put("name", event.name);
    map.put("userId", event.userId);
    if (event.trackType != null) {
      map.put("trackType", event.trackType.getValue());
    }
    if (event.keyIndex != null) {
      map.put("keyIndex", event.keyIndex);
    }
    if (event.version != null) {
      map.put("version", event.version);
    }
    if (event.reason != null) {
      map.put("reason", event.reason);
    }
    if (event.keyState != null) {
      map.put("keyState", keyStateToMap(event.keyState));
    }
    if (event.encode != null) {
      map.put("encode", perfToList(event.encode));
    }
    if (event.decode != null) {
      map.put("decode", perfToList(event.decode));
    }
    return map;
  }

  private static Map<String, Object> keyStateToMap(EncryptionManager.KeyStateReport report) {
    final List<Object> perUserKeys = new ArrayList<>();
    for (EncryptionManager.UserKey key : report.perUserKeys) {
      final Map<String, Object> entry = new HashMap<>();
      entry.put("userId", key.userId);
      entry.put("keyIndex", key.keyIndex);
      entry.put("fingerprint", key.fingerprint);
      perUserKeys.add(entry);
    }

    final List<Object> sharedKeys = new ArrayList<>();
    for (EncryptionManager.SharedKey key : report.sharedKeys) {
      final Map<String, Object> entry = new HashMap<>();
      entry.put("keyIndex", key.keyIndex);
      entry.put("fingerprint", key.fingerprint);
      entry.put("isActive", key.isActive);
      sharedKeys.add(entry);
    }

    final Map<String, Object> map = new HashMap<>();
    map.put("perUserKeys", perUserKeys);
    map.put("sharedKeys", sharedKeys);
    return map;
  }

  private static List<Object> perfToList(List<EncryptionManager.TrackPerf> samples) {
    final List<Object> list = new ArrayList<>();
    for (EncryptionManager.TrackPerf sample : samples) {
      final Map<String, Object> entry = new HashMap<>();
      entry.put("userId", sample.userId);
      if (sample.trackType != null) {
        entry.put("trackType", sample.trackType.getValue());
      }
      if (sample.codec != null) {
        entry.put("codec", sample.codec);
      }
      entry.put("fps", sample.fps);
      entry.put("maxCryptoMs", sample.maxCryptoMs);
      list.add(entry);
    }
    return list;
  }
}
