import 'dart:typed_data';

import 'package:webrtc_interface/webrtc_interface.dart';

import '../native/encryption_manager_impl.dart'
    if (dart.library.js_interop) '../web/encryption_manager_impl.dart';
import 'encryption_types.dart';

/// Attaches AES-GCM end-to-end encryption to RTP senders and receivers.
///
/// One manager holds every key for a call and wraps senders and receivers
/// with the native encoded transform.
///
/// ## Usage
///
/// ```dart
/// final e2ee = EncryptionManager.create(userId: myUserId);
/// await e2ee.setSharedKey(0, keyBytes); // 16 bytes for AES-128
///
/// // Publishing.
/// await e2ee.encrypt(sender, codec: 'vp8', trackType: E2eeTrackType.video);
///
/// // Subscribing. Match the receiver by `track.id`, never by identity.
/// await e2ee.decrypt(receiver, userId: remoteUserId,
///     trackType: E2eeTrackType.video);
/// ```
abstract class EncryptionManager {
  /// Creates a manager that encrypts outgoing frames as [userId].
  ///
  /// [userId] must be non-empty and must be the local user's id — remote
  /// participants select a decryption key by it.
  factory EncryptionManager.create({
    required String userId,
    EncryptionAlgorithm algorithm = EncryptionAlgorithm.aes128Gcm,
  }) {
    if (userId.isEmpty) {
      throw ArgumentError.value(userId, 'userId', 'must not be empty');
    }
    return createEncryptionManager(userId: userId, algorithm: algorithm);
  }

  /// Whether the running platform can attach encoded transforms.
  ///
  /// `true` on Android, iOS and macOS; `false` on web, Windows and Linux,
  /// where every other method throws [UnsupportedError].
  static bool get isSupported => encryptionManagerIsSupported;

  /// The local user id passed to [EncryptionManager.create].
  String get userId;

  /// The key size this manager was created with.
  EncryptionAlgorithm get algorithm;

  /// Whether [dispose] has run. A disposed manager rejects every call.
  bool get isDisposed;

  /// Diagnostic `e2ee.*` events for this manager.
  Stream<E2eeEvent> get events;

  /// Registers [rawKey] at [keyIndex] for a single user.
  ///
  /// [rawKey] must be exactly [EncryptionAlgorithm.keyLengthBytes] long and
  /// [keyIndex] must be in `0..255`.
  Future<void> setKey(String userId, int keyIndex, Uint8List rawKey);

  /// Registers [rawKey] at [keyIndex] for every participant.
  ///
  /// This is the passphrase-style setup: every participant derives the same
  /// bytes and calls this with the same index.
  Future<void> setSharedKey(int keyIndex, Uint8List rawKey);

  /// Drops the key registered for [userId] at [keyIndex].
  Future<void> removeKey(String userId, int keyIndex);

  /// Drops every key registered for [userId].
  Future<void> removeAllKeys(String userId);

  /// Drops the shared key at [keyIndex].
  Future<void> removeSharedKey(int keyIndex);

  /// Encrypts everything [sender] publishes from now on.
  ///
  /// Attach this right after `addTransceiver`, before the first frame is
  /// encoded, otherwise the opening frames leave in cleartext.
  ///
  /// [codec] is an exact lowercase pin — `opus`, `vp8`, `vp9` or `h264`.
  /// Passing `null` reads the codec from each frame instead.
  ///
  /// [trackType] groups replay windows. Pass
  /// [E2eeTrackType.screenShare] explicitly so a screen share and a camera
  /// from the same user do not share one window; `null` lets native pick
  /// audio vs video from the sender.
  Future<void> encrypt(
    RTCRtpSender sender, {
    String? codec,
    E2eeTrackType? trackType,
  });

  /// Decrypts everything [receiver] delivers from now on.
  ///
  /// [userId] is the *remote* participant's id — it selects the key that
  /// participant encrypted with. Passing the local user's id here decrypts
  /// with the wrong key and yields `e2ee.decryption_failed`.
  ///
  /// [trackType] groups replay windows the same way it does for [encrypt].
  Future<void> decrypt(
    RTCRtpReceiver receiver, {
    required String userId,
    E2eeTrackType? trackType,
  });

  /// Starts or stops periodic `e2ee.perf_report` events on [events].
  Future<void> enablePerformanceReporting(bool enabled);

  /// Requests one `e2ee.key_state` event on [events].
  Future<void> requestKeyState();

  /// Releases the native manager and closes [events].
  ///
  /// Senders and receivers already attached keep the transform they were
  /// given; this only stops new attachments and frees the key store.
  Future<void> dispose();
}
