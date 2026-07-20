// ignore_for_file: missing_override_of_must_be_overridden

import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/protobuf/video/sfu/models/models.pbenum.dart';
import 'package:stream_video/src/call/session/call_session.dart';
import 'package:stream_video/src/call/session/call_session_config.dart';
import 'package:stream_video/src/call/stats/tracer.dart';
import 'package:stream_video/src/webrtc/peer_connection.dart';
import 'package:stream_video/src/webrtc/peer_connection_factory.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/src/webrtc/traced_peer_connection.dart';
import 'package:stream_video/src/ws/ws.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../../test_helpers.dart';
import '../fixtures/call_test_helpers.dart';
import '../fixtures/data.dart';

class MockRtcManager extends Mock implements RtcManager {}

class MockTracedStreamPeerConnection extends Mock
    implements TracedStreamPeerConnection {}

class MockRTCPeerConnection extends Mock implements rtc.RTCPeerConnection {}

MockStreamVideo _buildMockStreamVideo() {
  final mock = setupMockStreamVideo();
  when(() => mock.apiKey).thenReturn('test-api-key');
  return mock;
}

CallSession _buildTestSession({
  required void Function(StreamPeerConnection, SfuReconnectionStrategy)
  onReconnectionNeeded,
}) {
  final callCid = SampleCallData.defaultCid;
  final stateManager = createTestCallStateManager();

  return CallSession(
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
    streamVideo: _buildMockStreamVideo(),
    tracer: Tracer(null),
    pcFactory: StreamPeerConnectionFactory(callCid: callCid),
  );
}

({
  MockRtcManager rtcManager,
  MockTracedStreamPeerConnection publisher,
  MockRTCPeerConnection pc,
})
_wirePublisher(
  CallSession session, {
  required rtc.RTCIceConnectionState iceState,
}) {
  final rtcManager = MockRtcManager();
  final publisher = MockTracedStreamPeerConnection();
  final pc = MockRTCPeerConnection();

  when(() => rtcManager.publisher).thenReturn(publisher);
  when(() => publisher.pc).thenReturn(pc);
  when(() => pc.iceConnectionState).thenReturn(iceState);
  // close() will dispose the rtcManager — stub so the cast doesn't blow up.
  when(rtcManager.dispose).thenAnswer((_) async {});

  session.rtcManager = rtcManager;
  return (rtcManager: rtcManager, publisher: publisher, pc: pc);
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  group('CallSession.startPublisherConnectionCheck', () {
    test(
      'triggers rejoin via onReconnectionNeeded when ICE is still '
      '"new" after the delay',
      () {
        fakeAsync((async) {
          final reconnects =
              <(StreamPeerConnection, SfuReconnectionStrategy)>[];
          final session = _buildTestSession(
            onReconnectionNeeded: (pc, strategy) =>
                reconnects.add((pc, strategy)),
          );
          final wires = _wirePublisher(
            session,
            iceState: rtc.RTCIceConnectionState.RTCIceConnectionStateNew,
          );

          session.startPublisherConnectionCheck();

          // Just before the deadline → no callback yet.
          async.elapse(const Duration(seconds: 14));
          expect(reconnects, isEmpty);

          // Cross the deadline.
          async.elapse(const Duration(seconds: 1));
          expect(reconnects, hasLength(1));
          expect(reconnects.single.$1, same(wires.publisher));
          expect(reconnects.single.$2, SfuReconnectionStrategy.rejoin);
        });
      },
    );

    test(
      'does NOT trigger reconnection when ICE has progressed past "new"',
      () {
        fakeAsync((async) {
          var called = 0;
          final session = _buildTestSession(
            onReconnectionNeeded: (_, __) => called++,
          );
          _wirePublisher(
            session,
            iceState: rtc.RTCIceConnectionState.RTCIceConnectionStateChecking,
          );

          session.startPublisherConnectionCheck();
          async.elapse(const Duration(seconds: 16));

          expect(
            called,
            0,
            reason: 'ICE is no longer in "new" — nothing to recover from',
          );
        });
      },
    );

    test('no-op when publisher is null at deadline', () {
      fakeAsync((async) {
        var called = 0;
        final session = _buildTestSession(
          onReconnectionNeeded: (_, __) => called++,
        );
        final rtcManager = MockRtcManager();
        when(() => rtcManager.publisher).thenReturn(null);
        session.rtcManager = rtcManager;

        session.startPublisherConnectionCheck();
        async.elapse(const Duration(seconds: 16));

        expect(called, 0);
      });
    });

    test('no-op when session was closed before the deadline', () {
      fakeAsync((async) {
        var called = 0;
        final session = _buildTestSession(
          onReconnectionNeeded: (_, __) => called++,
        );
        _wirePublisher(
          session,
          iceState: rtc.RTCIceConnectionState.RTCIceConnectionStateNew,
        );

        session.startPublisherConnectionCheck();

        // close() should cancel the pending timer; even if it didn't, the
        // _isLeavingOrClosed flag set by leave()/close() short-circuits the
        // callback once it fires.
        session.leave(reason: 'test');
        async.elapse(const Duration(seconds: 20));

        expect(called, 0);
      });
    });

    test(
      'calling startPublisherConnectionCheck twice cancels the first timer',
      () {
        fakeAsync((async) {
          var called = 0;
          final session = _buildTestSession(
            onReconnectionNeeded: (_, __) => called++,
          );
          _wirePublisher(
            session,
            iceState: rtc.RTCIceConnectionState.RTCIceConnectionStateNew,
          );

          session.startPublisherConnectionCheck();
          async.elapse(const Duration(seconds: 10));
          // Second call resets the 15s window.
          session.startPublisherConnectionCheck();

          // 10s after the first call but only 5s after the second — the second
          // window hasn't elapsed yet, and the first should have been cancelled.
          async.elapse(const Duration(seconds: 5));
          expect(called, 0, reason: 'first timer should be cancelled');

          // Cross the second deadline.
          async.elapse(const Duration(seconds: 11));
          expect(called, 1, reason: 'second timer should fire exactly once');
        });
      },
    );

    test('close() cancels the pending publisher-check timer', () {
      fakeAsync((async) {
        var called = 0;
        final session = _buildTestSession(
          onReconnectionNeeded: (_, __) => called++,
        );
        _wirePublisher(
          session,
          iceState: rtc.RTCIceConnectionState.RTCIceConnectionStateNew,
        );

        session.startPublisherConnectionCheck();

        // Trigger the timer-cancelling close path. We do not await to keep
        // FakeAsync deterministic; the synchronous side effect we care about
        // (Timer.cancel) runs before any await suspension.
        unawaited(session.close(StreamWebSocketCloseCode.normalClosure));
        async.elapse(const Duration(seconds: 20));

        expect(called, 0);
      });
    });

    test(
      'renegotiates and escalates to rejoin when the publisher is wedged in '
      '"have-local-offer" after the delay',
      () {
        fakeAsync((async) {
          final reconnects =
              <(StreamPeerConnection, SfuReconnectionStrategy)>[];
          final session = _buildTestSession(
            onReconnectionNeeded: (pc, strategy) =>
                reconnects.add((pc, strategy)),
          );
          // ICE progressed past "new", so the ICE-stall branch does NOT fire.
          final wires = _wirePublisher(
            session,
            iceState: rtc.RTCIceConnectionState.RTCIceConnectionStateConnected,
          );
          // ...but the publisher created a local offer and never completed
          // SetPublisher, so it is stuck in have-local-offer.
          when(() => wires.pc.signalingState).thenReturn(
            rtc.RTCSignalingState.RTCSignalingStateHaveLocalOffer,
          );

          session.startPublisherConnectionCheck();
          async
            ..elapse(const Duration(seconds: 16))
            ..flushMicrotasks();

          // The recovery renegotiation cannot complete (no SFU connection in
          // the test), so the watchdog falls back to a full rejoin.
          expect(reconnects, hasLength(1));
          expect(reconnects.single.$1, same(wires.publisher));
          expect(reconnects.single.$2, SfuReconnectionStrategy.rejoin);
        });
      },
    );

    test(
      'does NOT trigger recovery when the publisher signaling state is '
      'stable',
      () {
        fakeAsync((async) {
          var called = 0;
          final session = _buildTestSession(
            onReconnectionNeeded: (_, __) => called++,
          );
          final wires = _wirePublisher(
            session,
            iceState: rtc.RTCIceConnectionState.RTCIceConnectionStateConnected,
          );
          when(() => wires.pc.signalingState).thenReturn(
            rtc.RTCSignalingState.RTCSignalingStateStable,
          );

          session.startPublisherConnectionCheck();
          async
            ..elapse(const Duration(seconds: 16))
            ..flushMicrotasks();

          expect(
            called,
            0,
            reason: 'publisher is connected and stable — nothing to recover',
          );
        });
      },
    );
  });

  group('CallSession.getReconnectDetails', () {
    test(
      'rejoin includes the current sessionId as previousSessionId',
      () async {
        final session = _buildTestSession(onReconnectionNeeded: (_, __) {});

        final details = await session.getReconnectDetails(
          SfuReconnectionStrategy.rejoin,
          reconnectAttempts: 3,
          reason: 'sfu_socket_failed',
        );

        expect(
          details.strategy,
          WebsocketReconnectStrategy.WEBSOCKET_RECONNECT_STRATEGY_REJOIN,
        );
        expect(details.previousSessionId, 'test-session');
        expect(details.reconnectAttempt, 3);
        expect(details.reason, 'sfu_socket_failed');
      },
    );

    test('fast leaves previousSessionId unset', () async {
      final session = _buildTestSession(onReconnectionNeeded: (_, __) {});

      final details = await session.getReconnectDetails(
        SfuReconnectionStrategy.fast,
      );

      expect(
        details.strategy,
        WebsocketReconnectStrategy.WEBSOCKET_RECONNECT_STRATEGY_FAST,
      );
      expect(
        details.previousSessionId,
        isEmpty,
        reason:
            'fast reconnect reuses the same session — no `previous` to send',
      );
    });

    test(
      'migrate carries fromSfuId and leaves previousSessionId unset',
      () async {
        final session = _buildTestSession(onReconnectionNeeded: (_, __) {});

        final details = await session.getReconnectDetails(
          SfuReconnectionStrategy.migrate,
          migratingFromSfuId: 'sfu-eu-west-1',
        );

        expect(
          details.strategy,
          WebsocketReconnectStrategy.WEBSOCKET_RECONNECT_STRATEGY_MIGRATE,
        );
        expect(details.previousSessionId, isEmpty);
        expect(details.fromSfuId, 'sfu-eu-west-1');
      },
    );

    test('omits announcedTracks when rtcManager is null', () async {
      final session = _buildTestSession(onReconnectionNeeded: (_, __) {});

      final details = await session.getReconnectDetails(
        SfuReconnectionStrategy.rejoin,
      );

      // No rtcManager → no announced tracks list; default repeated field
      // remains empty rather than throwing.
      expect(details.announcedTracks, isEmpty);
    });
  });

  group('CallSession.leave', () {
    test(
      'sets the leaving flag so a later publisher-check fire is a no-op',
      () {
        fakeAsync((async) {
          var called = 0;
          final session = _buildTestSession(
            onReconnectionNeeded: (_, __) => called++,
          );
          _wirePublisher(
            session,
            iceState: rtc.RTCIceConnectionState.RTCIceConnectionStateNew,
          );

          session.startPublisherConnectionCheck();
          session.leave(reason: 'user_tapped_leave');
          async.elapse(const Duration(seconds: 20));

          expect(
            called,
            0,
            reason:
                'leave() flips _isLeavingOrClosed; the timer fires but its '
                'callback returns early.',
          );
        });
      },
    );

    test('repeatedly calling leave is safe', () {
      final session = _buildTestSession(onReconnectionNeeded: (_, __) {});
      expect(() => session.leave(reason: 'first'), returnsNormally);
      expect(() => session.leave(reason: 'second'), returnsNormally);
    });
  });

  group('CallSession.close', () {
    test('clears rtcManager so subsequent track lookups return null', () async {
      final session = _buildTestSession(onReconnectionNeeded: (_, __) {});
      _wirePublisher(
        session,
        iceState: rtc.RTCIceConnectionState.RTCIceConnectionStateConnected,
      );

      expect(session.rtcManager, isNotNull);
      await session.close(StreamWebSocketCloseCode.normalClosure);

      expect(session.rtcManager, isNull);
    });
  });
}
