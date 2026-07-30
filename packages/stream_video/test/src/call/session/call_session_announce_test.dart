import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/session/call_session.dart';
import 'package:stream_video/src/call/session/call_session_config.dart';
import 'package:stream_video/src/call/stats/tracer.dart';
import 'package:stream_video/src/sfu/data/models/sfu_codec.dart';
import 'package:stream_video/src/sfu/data/models/sfu_publish_options.dart';
import 'package:stream_video/src/webrtc/peer_connection.dart';
import 'package:stream_video/src/webrtc/peer_connection_factory.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/src/webrtc/rtc_track/rtc_track_publish_options.dart';
import 'package:stream_video/src/webrtc/traced_peer_connection.dart';
import 'package:stream_video/src/ws/health/connection_state.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../../test_helpers.dart';
import '../fixtures/call_test_helpers.dart';
import '../fixtures/data.dart';

class _MockTracedStreamPeerConnection extends Mock
    implements TracedStreamPeerConnection {}

class _MockRTCPeerConnection extends Mock implements rtc.RTCPeerConnection {}

class _MockTransceiver extends Mock implements rtc.RTCRtpTransceiver {}

class _MockSender extends Mock implements rtc.RTCRtpSender {}

class _MockMediaStreamTrack extends Mock implements rtc.MediaStreamTrack {}

class _MockLocalAudioTrack extends Mock implements RtcLocalAudioTrack {}

const _testCodec = SfuCodec(
  name: 'opus',
  payloadType: 111,
  fmtpLine: '',
  clockRate: 48000,
  encodingParameters: '',
);

final _publishOption = SfuPublishOptions(
  id: 1,
  codec: _testCodec,
  trackType: SfuTrackType.audio,
);

CallSession _buildTestSession({
  required void Function(StreamPeerConnection, SfuReconnectionStrategy)
  onReconnectionNeeded,
}) {
  final callCid = SampleCallData.defaultCid;
  final stateManager = createTestCallStateManager();
  final streamVideo = setupMockStreamVideo();
  when(() => streamVideo.apiKey).thenReturn('test-api-key');

  final session = CallSession(
    callCid: callCid,
    sessionSeq: 0,
    sessionId: 'test-session',
    config: const CallSessionConfig(
      sfuName: 'test-sfu',
      sfuToken: 'test-token',
      sfuUrl: 'https://test.example.com',
      sfuWsEndpoint: 'wss://test.example.com/ws',
      rtcConfig: RTCConfiguration(),
    ),
    stateManager: stateManager,
    dynascaleManager: DynascaleManager(stateManager: stateManager),
    onReconnectionNeeded: onReconnectionNeeded,
    onSuspendedAudioTrackRecorded: (_) {},
    sdpEditor: MockSdpEditor(),
    networkMonitor: setupMockInternetConnection(),
    statsOptions: StatsOptions(
      enableRtcStats: false,
      reportingIntervalMs: 500,
    ),
    streamVideo: streamVideo,
    tracer: Tracer(null),
    pcFactory: StreamPeerConnectionFactory(callCid: callCid),
  );

  // The negotiation bails out early unless the SFU socket is up.
  session.sfuWS.connectionState = ConnectionState.connected;
  return session;
}

/// Wires a publisher wedged in `have-local-offer`, so the publisher watchdog
/// runs a recovery renegotiation — the only entry point that both drives
/// `_onRenegotiationNeeded` and reports what it returned.
///
/// The manager is real, so the announce is computed the way it is in
/// production. With [sendingTrack] there is one cached transceiver whose mid
/// resolves from nowhere (no live transceivers, no local description, no mid on
/// the transceiver itself), which is what makes the announce come back null.
({RtcManager rtcManager, _MockTracedStreamPeerConnection publisher})
_wireStalledPublisher(
  CallSession session, {
  required bool sendingTrack,
}) {
  final publisher = _MockTracedStreamPeerConnection();
  final pc = _MockRTCPeerConnection();

  when(() => publisher.pc).thenReturn(pc);
  when(() => publisher.type).thenReturn(StreamPeerType.publisher);
  when(() => publisher.tracer).thenReturn(Tracer(null));

  // Past "new", so the watchdog takes the signaling-stall branch.
  when(() => pc.iceConnectionState).thenReturn(
    rtc.RTCIceConnectionState.RTCIceConnectionStateChecking,
  );
  when(() => pc.signalingState).thenReturn(
    rtc.RTCSignalingState.RTCSignalingStateHaveLocalOffer,
  );
  when(pc.getTransceivers).thenAnswer((_) async => const []);
  when(pc.getLocalDescription).thenAnswer((_) async => null);

  when(publisher.createOffer).thenAnswer(
    (_) async => Result.success(rtc.RTCSessionDescription('v=0\r\n', 'offer')),
  );
  when(publisher.rollbackLocalDescription).thenAnswer(
    (_) async => const Result.success(null),
  );

  final rtcManager = RtcManager(
    sessionId: 'test-session',
    callCid: SampleCallData.defaultCid,
    publisherId: 'test-publisher',
    publisher: publisher,
    subscriber: _MockTracedStreamPeerConnection(),
    publishOptions: [_publishOption],
    stateManager: createTestCallStateManager(),
    streamVideo: setupMockStreamVideo(),
    pcFactory: StreamPeerConnectionFactory(callCid: SampleCallData.defaultCid),
  );

  if (sendingTrack) {
    final mediaTrack = _MockMediaStreamTrack();
    when(() => mediaTrack.id).thenReturn('media-track-id');
    when(() => mediaTrack.kind).thenReturn('audio');

    final sender = _MockSender();
    when(() => sender.track).thenReturn(mediaTrack);

    final transceiver = _MockTransceiver();
    when(() => transceiver.sender).thenReturn(sender);
    when(() => transceiver.mid).thenReturn('');

    final track = _MockLocalAudioTrack();
    when(() => track.trackId).thenReturn('local-audio');
    when(() => track.trackType).thenReturn(SfuTrackType.audio);
    when(() => track.mediaTrack).thenReturn(mediaTrack);

    rtcManager.transceiversManager.add(
      track,
      _publishOption,
      transceiver,
      const RtcTrackPublishOptions(),
    );
  }

  session.rtcManager = rtcManager;
  return (rtcManager: rtcManager, publisher: publisher);
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  group('publisher negotiation with an unresolvable track mid', () {
    test('rolls the offer back and escalates to a reconnect', () {
      fakeAsync((async) {
        final reconnects = <(StreamPeerConnection, SfuReconnectionStrategy)>[];
        final session = _buildTestSession(
          onReconnectionNeeded: (pc, strategy) =>
              reconnects.add((pc, strategy)),
        );

        // One track is sending but its mid cannot be resolved from anywhere.
        final wires = _wireStalledPublisher(session, sendingTrack: true);

        session.startPublisherConnectionCheck();
        async.elapse(const Duration(seconds: 16));
        async.flushMicrotasks();

        // The half-describable offer is dropped rather than announced...
        verify(wires.publisher.rollbackLocalDescription).called(1);

        // ...and the failure reaches the caller, which recovers by reconnecting
        // instead of leaving the track silently unpublished.
        expect(reconnects, hasLength(1));
        expect(reconnects.single.$1, same(wires.publisher));
        expect(reconnects.single.$2, SfuReconnectionStrategy.fast);
      });
    });

    test('an empty announce rolls back without failing the negotiation', () {
      fakeAsync((async) {
        final reconnects = <(StreamPeerConnection, SfuReconnectionStrategy)>[];
        final session = _buildTestSession(
          onReconnectionNeeded: (pc, strategy) =>
              reconnects.add((pc, strategy)),
        );

        // Nothing is sending — a no-op, not a broken announce.
        final wires = _wireStalledPublisher(session, sendingTrack: false);

        session.startPublisherConnectionCheck();
        async.elapse(const Duration(seconds: 16));
        async.flushMicrotasks();

        verify(wires.publisher.rollbackLocalDescription).called(1);
        expect(
          reconnects,
          isEmpty,
          reason: 'nothing to publish must not escalate to a rejoin',
        );
      });
    });
  });

  // The watchdog is not the path that matters in practice: the publisher's
  // `onRenegotiationNeeded` callback and `RtcManager`'s forced renegotiations
  // both invoke negotiation fire-and-forget, and the rollback returns the
  // publisher to `stable`, where the watchdog sees nothing to recover.
  group('a fire-and-forget renegotiation', () {
    test('escalates rather than leaving the track unpublished', () async {
      final reconnects = <(StreamPeerConnection, SfuReconnectionStrategy)>[];
      final session = _buildTestSession(
        onReconnectionNeeded: (pc, strategy) => reconnects.add((pc, strategy)),
      );

      final wires = _wireStalledPublisher(session, sendingTrack: true);

      await session.negotiateOrRecover(wires.publisher);

      verify(wires.publisher.rollbackLocalDescription).called(1);
      expect(reconnects, hasLength(1));
      expect(reconnects.single.$1, same(wires.publisher));
      expect(reconnects.single.$2, SfuReconnectionStrategy.fast);
    });

    test('does not escalate when there was nothing to announce', () async {
      final reconnects = <(StreamPeerConnection, SfuReconnectionStrategy)>[];
      final session = _buildTestSession(
        onReconnectionNeeded: (pc, strategy) => reconnects.add((pc, strategy)),
      );

      final wires = _wireStalledPublisher(session, sendingTrack: false);

      await session.negotiateOrRecover(wires.publisher);

      verify(wires.publisher.rollbackLocalDescription).called(1);
      expect(reconnects, isEmpty);
    });

    test('does not escalate on a failure that recovers on its own', () async {
      final reconnects = <(StreamPeerConnection, SfuReconnectionStrategy)>[];
      final session = _buildTestSession(
        onReconnectionNeeded: (pc, strategy) => reconnects.add((pc, strategy)),
      );

      final wires = _wireStalledPublisher(session, sendingTrack: true);

      // A dropped SFU socket fails the negotiation too, but the reconnect it
      // triggers on its own is the one that matters — escalating here would
      // stack a second one on top.
      session.sfuWS.connectionState = ConnectionState.disconnected;

      await session.negotiateOrRecover(wires.publisher);

      verifyNever(wires.publisher.rollbackLocalDescription);
      expect(reconnects, isEmpty);
    });
  });
}
