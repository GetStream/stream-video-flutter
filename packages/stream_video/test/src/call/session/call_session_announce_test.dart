// ignore_for_file: missing_override_of_must_be_overridden

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
  required OnReconnectionNeeded onReconnectionNeeded,
}) {
  final callCid = SampleCallData.defaultCid;
  final stateManager = createTestCallStateManager();
  final streamVideo = setupMockStreamVideo();
  when(() => streamVideo.apiKey).thenReturn('test-api-key');

  final session = CallSession(
    retryPolicy: const RetryPolicy(),
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
    statsOptions: const StatsOptions(
      enableRtcStats: false,
      reportingIntervalMs: 500,
    ),
    streamVideo: streamVideo,
    tracer: Tracer(null),
    pcFactory: StreamPeerConnectionFactory(callCid: callCid),
  );

  // The negotiation bails out early unless the SFU socket is up.
  _setSfuConnected(session, connected: true);
  return session;
}

/// Drives the SFU socket's connection state, which is otherwise only reachable
/// by actually connecting.
void _setSfuConnected(CallSession session, {required bool connected}) {
  final connectionState =
      session.sfuWS.client.connectionState as MutableConnectionStateEmitter;

  connectionState.value = connected
      ? const WebSocketConnectionState.connected(healthCheck: HealthCheckInfo())
      : const WebSocketConnectionState.disconnected(
          source: DisconnectionSource.userInitiated(),
        );
}

/// Wires a publisher wedged in `have-local-offer`, so the publisher watchdog
/// runs a recovery renegotiation — the only entry point that both drives
/// `_onRenegotiationNeeded` and reports what it returned.
///
/// The manager is real, so the announce is computed the way it is in
/// production. With [sendingTrack] there is one cached transceiver whose mid
/// resolves from nowhere (no live transceivers, no local description, no mid on
/// the transceiver itself), which is what makes the announce come back null.
/// With [idleTransceiver] there is one cached transceiver with no track on its
/// sender (a publisher that stopped sending). With neither, the publisher has
/// no transceivers at all, as for a subscribe-only client.
({RtcManager rtcManager, _MockTracedStreamPeerConnection publisher})
_wireStalledPublisher(
  CallSession session, {
  required bool sendingTrack,
  bool idleTransceiver = false,
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

  // The offer names the sending track (so it is part of this negotiation —
  // not a publish that landed mid-flight) but carries no a=mid for it, which
  // makes the mid genuinely unresolvable.
  when(publisher.createOffer).thenAnswer(
    (_) async => Result.success(
      rtc.RTCSessionDescription(
        [
          'v=0\r\n',
          'o=- 1 2 IN IP4 127.0.0.1\r\n',
          's=-\r\n',
          't=0 0\r\n',
          'm=audio 9 UDP/TLS/RTP/SAVPF 111\r\n',
          'c=IN IP4 0.0.0.0\r\n',
          'a=sendonly\r\n',
          'a=msid:stream-id media-track-id\r\n',
        ].join(),
        'offer',
      ),
    ),
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

  if (sendingTrack || idleTransceiver) {
    final mediaTrack = _MockMediaStreamTrack();
    when(() => mediaTrack.id).thenReturn('media-track-id');
    when(() => mediaTrack.kind).thenReturn('audio');

    final sender = _MockSender();
    when(() => sender.track).thenReturn(sendingTrack ? mediaTrack : null);

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
        final reconnects =
            <
              (
                StreamPeerConnection,
                SfuReconnectionStrategy,
                ReconnectionNeededReason,
              )
            >[];
        final session = _buildTestSession(
          onReconnectionNeeded: (pc, strategy, reason) =>
              reconnects.add((pc, strategy, reason)),
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
        expect(reconnects.single.$3, ReconnectionNeededReason.stuck);
      });
    });

    test('an empty announce rolls back without failing the negotiation', () {
      fakeAsync((async) {
        final reconnects =
            <
              (
                StreamPeerConnection,
                SfuReconnectionStrategy,
                ReconnectionNeededReason,
              )
            >[];
        final session = _buildTestSession(
          onReconnectionNeeded: (pc, strategy, reason) =>
              reconnects.add((pc, strategy, reason)),
        );

        // Nothing is sending — a no-op, not a broken announce.
        final wires = _wireStalledPublisher(
          session,
          sendingTrack: false,
          idleTransceiver: true,
        );

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

  // A subscribe-only client's publisher has no transceivers, so an offer would
  // carry no BUNDLE group and `max-bundle` would reject it in
  // setLocalDescription — failing fast reconnect into a full rejoin.
  group('a publisher with no transceivers', () {
    test('is not negotiated by the watchdog', () {
      fakeAsync((async) {
        final reconnects =
            <
              (
                StreamPeerConnection,
                SfuReconnectionStrategy,
                ReconnectionNeededReason,
              )
            >[];
        final session = _buildTestSession(
          onReconnectionNeeded: (pc, strategy, reason) =>
              reconnects.add((pc, strategy, reason)),
        );

        final wires = _wireStalledPublisher(session, sendingTrack: false);

        session.startPublisherConnectionCheck();
        async.elapse(const Duration(seconds: 16));
        async.flushMicrotasks();

        verifyNever(wires.publisher.createOffer);
        verifyNever(wires.publisher.rollbackLocalDescription);
        expect(reconnects, isEmpty);
      });
    });

    test('is not negotiated on renegotiation or ICE restart', () async {
      final reconnects =
          <
            (
              StreamPeerConnection,
              SfuReconnectionStrategy,
              ReconnectionNeededReason,
            )
          >[];
      final session = _buildTestSession(
        onReconnectionNeeded: (pc, strategy, reason) =>
            reconnects.add((pc, strategy, reason)),
      );

      final wires = _wireStalledPublisher(session, sendingTrack: false);

      await session.negotiateOrRecover(wires.publisher);

      verifyNever(wires.publisher.createOffer);
      verifyNever(wires.publisher.rollbackLocalDescription);
      expect(reconnects, isEmpty);
    });
  });

  // The watchdog is not the path that matters in practice: the publisher's
  // `onRenegotiationNeeded` callback and `RtcManager`'s forced renegotiations
  // both invoke negotiation fire-and-forget, and the rollback returns the
  // publisher to `stable`, where the watchdog sees nothing to recover.
  group('a fire-and-forget renegotiation', () {
    test('escalates rather than leaving the track unpublished', () async {
      final reconnects =
          <
            (
              StreamPeerConnection,
              SfuReconnectionStrategy,
              ReconnectionNeededReason,
            )
          >[];
      final session = _buildTestSession(
        onReconnectionNeeded: (pc, strategy, reason) =>
            reconnects.add((pc, strategy, reason)),
      );

      final wires = _wireStalledPublisher(session, sendingTrack: true);

      await session.negotiateOrRecover(wires.publisher);

      verify(wires.publisher.rollbackLocalDescription).called(1);
      expect(reconnects, hasLength(1));
      expect(reconnects.single.$1, same(wires.publisher));
      expect(reconnects.single.$2, SfuReconnectionStrategy.fast);
      expect(reconnects.single.$3, ReconnectionNeededReason.stuck);
    });

    test('does not escalate when there was nothing to announce', () async {
      final reconnects =
          <
            (
              StreamPeerConnection,
              SfuReconnectionStrategy,
              ReconnectionNeededReason,
            )
          >[];
      final session = _buildTestSession(
        onReconnectionNeeded: (pc, strategy, reason) =>
            reconnects.add((pc, strategy, reason)),
      );

      final wires = _wireStalledPublisher(
        session,
        sendingTrack: false,
        idleTransceiver: true,
      );

      await session.negotiateOrRecover(wires.publisher);

      verify(wires.publisher.rollbackLocalDescription).called(1);
      expect(reconnects, isEmpty);
    });

    test('does not escalate on a failure that recovers on its own', () async {
      final reconnects =
          <
            (
              StreamPeerConnection,
              SfuReconnectionStrategy,
              ReconnectionNeededReason,
            )
          >[];
      final session = _buildTestSession(
        onReconnectionNeeded: (pc, strategy, reason) =>
            reconnects.add((pc, strategy, reason)),
      );

      final wires = _wireStalledPublisher(session, sendingTrack: true);

      // A dropped SFU socket fails the negotiation too, but the reconnect it
      // triggers on its own is the one that matters — escalating here would
      // stack a second one on top.
      _setSfuConnected(session, connected: false);

      await session.negotiateOrRecover(wires.publisher);

      verifyNever(wires.publisher.rollbackLocalDescription);
      expect(reconnects, isEmpty);
    });
  });
}
