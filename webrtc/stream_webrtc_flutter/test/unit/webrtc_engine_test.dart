// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart';

class _FakeEncryptionManager extends Fake implements EncryptionManager {
  _FakeEncryptionManager(this.userId, this.algorithm);

  @override
  final String userId;

  @override
  final EncryptionAlgorithm algorithm;
}

class _FakeEngine extends Fake implements WebRtcEngine {
  _FakeEngine({required this.supportsEncryption});

  @override
  final bool supportsEncryption;

  @override
  EncryptionManager createEncryptionManager({
    required String userId,
    EncryptionAlgorithm algorithm = EncryptionAlgorithm.aes128Gcm,
  }) => _FakeEncryptionManager(userId, algorithm);
}

void main() {
  tearDown(WebRtcEngine.debugUnregister);

  group('WebRtcEngine.instance', () {
    test('throws a StateError while no engine is registered', () {
      WebRtcEngine.debugUnregister();

      expect(WebRtcEngine.isRegistered, isFalse);
      expect(() => WebRtcEngine.instance, throwsStateError);
    });

    test('returns the registered engine', () {
      final engine = _FakeEngine(supportsEncryption: false);
      WebRtcEngine.instance = engine;

      expect(WebRtcEngine.isRegistered, isTrue);
      expect(WebRtcEngine.instance, same(engine));
    });
  });

  group('EncryptionManager', () {
    test('isSupported asks the registered engine', () {
      WebRtcEngine.instance = _FakeEngine(supportsEncryption: true);
      expect(EncryptionManager.isSupported, isTrue);

      WebRtcEngine.instance = _FakeEngine(supportsEncryption: false);
      expect(EncryptionManager.isSupported, isFalse);
    });

    test('create builds the manager in the registered engine', () {
      WebRtcEngine.instance = _FakeEngine(supportsEncryption: true);

      final manager = EncryptionManager.create(
        userId: 'alice',
        algorithm: EncryptionAlgorithm.aes256Gcm,
      );

      expect(manager, isA<_FakeEncryptionManager>());
      expect(manager.userId, 'alice');
      expect(manager.algorithm, EncryptionAlgorithm.aes256Gcm);
    });

    test('create rejects an empty user id', () {
      WebRtcEngine.instance = _FakeEngine(supportsEncryption: true);

      expect(
        () => EncryptionManager.create(userId: ''),
        throwsArgumentError,
      );
    });
  });

  group('NativeWebRtcEngine', () {
    const noPerCallFactory = WebRtcCapabilities(
      supportsPerCallFactory: false,
      supportsAudioPlayoutPause: false,
      supportsAudioOutputSelection: false,
      supportsCameraSwitch: false,
      switchesAudioInputInPlace: false,
      selectsAudioOutputPerElement: false,
      supportsBroadcastExtension: false,
      supportsScreenShareSourceSelection: false,
      omitsEarpieceFromEnumeration: false,
      usesExactDeviceIdConstraints: false,
      reportsAudioInterruptions: false,
      supportsSystemManagedAudioFocus: false,
      needsRemoteAudioReattach: false,
    );

    tearDown(() => debugWebRtcCapabilitiesOverride = null);

    test('reports the capabilities override', () {
      debugWebRtcCapabilitiesOverride = noPerCallFactory;

      expect(NativeWebRtcEngine().capabilities, noPerCallFactory);
    });

    test('builds no per-call factory where the platform has none', () {
      debugWebRtcCapabilitiesOverride = noPerCallFactory;

      expect(
        NativeWebRtcEngine().createPeerConnectionFactory(),
        throwsUnsupportedError,
      );
    });
  });
}
