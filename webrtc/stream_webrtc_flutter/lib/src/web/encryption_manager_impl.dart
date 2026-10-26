import 'dart:typed_data';

import 'package:webrtc_interface/webrtc_interface.dart';

import '../e2ee/encryption_manager.dart';
import '../e2ee/encryption_types.dart';

/// The browser path would need Encoded Transform plus a worker implementing
/// the JS wire format; that is the JS SDK's job, not this plugin's.
bool get encryptionManagerIsSupported => false;

/// Builds the unsupported-platform [EncryptionManager].
EncryptionManager createEncryptionManager({
  required String userId,
  required EncryptionAlgorithm algorithm,
}) {
  return EncryptionManagerWeb._(userId, algorithm);
}

/// Placeholder that reports the platform cannot encrypt.
///
/// Constructing it succeeds so callers can branch on
/// [EncryptionManager.isSupported]; every operation throws.
class EncryptionManagerWeb implements EncryptionManager {
  EncryptionManagerWeb._(this.userId, this.algorithm);

  @override
  final String userId;

  @override
  final EncryptionAlgorithm algorithm;

  bool _disposed = false;

  @override
  bool get isDisposed => _disposed;

  @override
  Stream<E2eeEvent> get events => const Stream<E2eeEvent>.empty();

  Never _unsupported() {
    throw UnsupportedError(
      'EncryptionManager is only available on Android, iOS and macOS. '
      'Check EncryptionManager.isSupported before creating one.',
    );
  }

  @override
  Future<void> setKey(String userId, int keyIndex, Uint8List rawKey) =>
      _unsupported();

  @override
  Future<void> setSharedKey(int keyIndex, Uint8List rawKey) => _unsupported();

  @override
  Future<void> removeKey(String userId, int keyIndex) => _unsupported();

  @override
  Future<void> removeAllKeys(String userId) => _unsupported();

  @override
  Future<void> removeSharedKey(int keyIndex) => _unsupported();

  @override
  Future<void> encrypt(
    RTCRtpSender sender, {
    String? codec,
    E2eeTrackType? trackType,
  }) => _unsupported();

  @override
  Future<void> decrypt(
    RTCRtpReceiver receiver, {
    required String userId,
    E2eeTrackType? trackType,
  }) => _unsupported();

  @override
  Future<void> enablePerformanceReporting(bool enabled) => _unsupported();

  @override
  Future<void> requestKeyState() => _unsupported();

  @override
  Future<void> dispose() async {
    _disposed = true;
  }
}
