import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/logger/impl/tagged_logger.dart';
import 'package:stream_video/src/webrtc/e2ee/call_e2ee.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_interface/stream_webrtc_interface.dart';

import '../../../fixtures/webrtc_capabilities.dart';

class _MockCallState extends Mock implements CallState {}

// ignore: subtype_of_sealed_class, a fake for the tests
class _EngineWithoutEncryption extends Fake implements WebRtcEngine {
  int createdManagers = 0;

  @override
  WebRtcCapabilities get capabilities =>
      webRtcCapabilitiesOf(PlatformType.android).copyWith(
        supportsEncryption: false,
      );

  @override
  EncryptionManager createEncryptionManager({
    required String userId,
    EncryptionAlgorithm algorithm = EncryptionAlgorithm.aes128Gcm,
  }) {
    createdManagers++;
    throw UnsupportedError('no encryption');
  }
}

void main() {
  final callCid = StreamCallCid(cid: 'default:e2ee');

  late _EngineWithoutEncryption engine;
  late CallE2ee e2ee;

  setUp(() {
    engine = _EngineWithoutEncryption();
    WebRtcEngine.instance = engine;

    final state = _MockCallState();
    when(() => state.currentUserId).thenReturn('alice');
    when(() => state.preferences).thenReturn(
      DefaultCallPreferences(
        encryptionKeyResolver: (_) async =>
            CallEncryptionKey.shared(bytes: Uint8List(16)),
      ),
    );

    e2ee = CallE2ee(
      callCid: callCid,
      state: () => state,
      session: () => null,
      logger: taggedLogger(tag: 'test'),
    );
  });

  tearDown(WebRtcEngine.debugUnregister);

  test(
    'a key for an engine that cannot encrypt fails the join instead of '
    'joining unencrypted',
    () async {
      final result = await e2ee.resolve();

      expect(result.isFailure, isTrue);
      expect(e2ee.manager, isNull);
      expect(engine.createdManagers, 0);
    },
  );
}
