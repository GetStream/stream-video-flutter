import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/webrtc/peer_connection_factory.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/src/webrtc/traced_peer_connection.dart';

import '../call/fixtures/call_test_helpers.dart';
import '../call/fixtures/data.dart';

/// How [RtcManager] sums up the ICE state of its peer connections.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  _MockTracedStreamPeerConnection peerConnection({
    bool connected = false,
    bool noLocalCandidates = false,
  }) {
    final pc = _MockTracedStreamPeerConnection();
    when(() => pc.hasIceEverConnected).thenReturn(connected);
    when(() => pc.hasNoLocalCandidates).thenReturn(noLocalCandidates);
    return pc;
  }

  RtcManager buildManager({
    required _MockTracedStreamPeerConnection subscriber,
    _MockTracedStreamPeerConnection? publisher,
  }) {
    return RtcManager(
      sessionId: 'test-session',
      callCid: SampleCallData.defaultCid,
      publisherId: publisher == null ? null : 'test-publisher',
      publisher: publisher,
      subscriber: subscriber,
      publishOptions: const [],
      stateManager: createTestCallStateManager(),
      host: setupMockCallHost(),
      pcFactory: StreamPeerConnectionFactory(
        callCid: SampleCallData.defaultCid,
      ),
    );
  }

  test('ICE has connected once either peer connection connected', () {
    expect(
      buildManager(
        subscriber: peerConnection(),
        publisher: peerConnection(),
      ).hasIceEverConnected,
      isFalse,
    );
    expect(
      buildManager(
        subscriber: peerConnection(),
        publisher: peerConnection(connected: true),
      ).hasIceEverConnected,
      isTrue,
    );
    expect(
      buildManager(
        subscriber: peerConnection(connected: true),
        publisher: peerConnection(),
      ).hasIceEverConnected,
      isTrue,
    );
  });

  test('no local candidates when either peer connection gathered none', () {
    expect(
      buildManager(
        subscriber: peerConnection(),
        publisher: peerConnection(),
      ).hasNoLocalCandidates,
      isFalse,
    );
    expect(
      buildManager(
        subscriber: peerConnection(),
        publisher: peerConnection(noLocalCandidates: true),
      ).hasNoLocalCandidates,
      isTrue,
    );
  });

  test('without a publisher, only the subscriber counts', () {
    final manager = buildManager(
      subscriber: peerConnection(connected: true, noLocalCandidates: true),
    );

    expect(manager.hasIceEverConnected, isTrue);
    expect(manager.hasNoLocalCandidates, isTrue);
    expect(
      buildManager(subscriber: peerConnection()).hasIceEverConnected,
      isFalse,
    );
  });
}

class _MockTracedStreamPeerConnection extends Mock
    implements TracedStreamPeerConnection {
  @override
  Future<void> dispose() async {}
}
