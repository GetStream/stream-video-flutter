import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/debug.dart';
import 'package:stream_video/src/call/stats/tracer.dart';
import 'package:stream_video/src/sfu/ws/sfu_ws.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/src/webrtc/traced_peer_connection.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/call_test_helpers.dart';
import '../fixtures/connection_harness.dart';

/// Pins what each debug hook triggers on a joined call, and that none of them
/// does anything before the call has an SFU session.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  late ConnectionHarness harness;

  tearDown(() => harness.dispose());

  test('dropping the SFU socket closes it as a lost connection', () async {
    harness = ConnectionHarness();
    final socket = _MockSfuWebSocket();
    when(() => harness.session.sfuWS).thenReturn(socket);
    final call = harness.buildCall();
    await call.join();

    call.debugDropSfuSocket();

    verify(socket.simulateConnectionLoss).called(1);
  });

  test(
    'a failed publisher rejoins, though the connection itself is fine',
    () async {
      harness = ConnectionHarness(sessionCount: 2);
      final call = harness.buildCall();
      await call.join();

      final publisher = _MockTracedStreamPeerConnection();
      when(() => publisher.type).thenReturn(StreamPeerType.publisher);
      when(publisher.isConnected).thenReturn(true);
      final rtcManager = _MockRtcManager();
      when(() => rtcManager.publisher).thenReturn(publisher);
      final subscriber = _MockTracedStreamPeerConnection();
      when(() => rtcManager.subscriber).thenReturn(subscriber);
      when(() => harness.session.rtcManager).thenReturn(rtcManager);

      call.debugFailPeerConnection(StreamPeerType.publisher);

      // The rejoin waits out its stability window, then makes a session.
      await waitUntil(() => harness.reconnectionCallbacks.length == 2);
      verifyNever(
        () => harness.session.fastReconnect(
          reconnectDetails: any(named: 'reconnectDetails'),
          capabilities: any(named: 'capabilities'),
          unifiedSessionId: any(named: 'unifiedSessionId'),
        ),
      );
    },
    timeout: const Timeout(Duration(seconds: 20)),
  );

  test(
    'a GoAway migrates and waits for the old SFU to confirm',
    () async {
      harness = ConnectionHarness(sessionCount: 2);
      final [first, _] = harness.sessions;
      when(
        first.waitForMigrationComplete,
      ).thenAnswer((_) => Completer<Result<None>>().future);
      final call = harness.buildCall();
      await call.join();

      call.debugReceiveGoAway();

      await waitUntil(() => call.state.value.status is CallStatusMigrating);
      await waitUntil(() => harness.reconnectionCallbacks.length == 2);
      verify(first.waitForMigrationComplete).called(1);
    },
    timeout: const Timeout(Duration(seconds: 20)),
  );

  test(
    'an SFU error naming rejoin rejoins',
    () async {
      harness = ConnectionHarness(sessionCount: 2);
      final call = harness.buildCall();
      await call.join();

      call.debugReceiveSfuError(SfuReconnectionStrategy.rejoin);

      await waitUntil(() => harness.reconnectionCallbacks.length == 2);
    },
    timeout: const Timeout(Duration(seconds: 20)),
  );

  test('every hook does nothing before the call has a session', () async {
    harness = ConnectionHarness();
    final call = harness.buildCall();

    call
      ..debugDropSfuSocket()
      ..debugFailPeerConnection(StreamPeerType.publisher)
      ..debugFailPeerConnection(StreamPeerType.subscriber)
      ..debugReceiveGoAway()
      ..debugReceiveSfuError(SfuReconnectionStrategy.rejoin);
    await pumpEventQueue();

    expect(call.state.value.status, isA<CallStatusIdle>());
    harness.verifyMakeCallSessionCount(0);
  });
}

class _MockSfuWebSocket extends Mock implements SfuWebSocket {}

class _MockRtcManager extends Mock implements RtcManager {
  @override
  Future<void> dispose() async {}
}

class _MockTracedStreamPeerConnection extends Mock
    implements TracedStreamPeerConnection {
  _MockTracedStreamPeerConnection() {
    when(() => tracer).thenReturn(Tracer('publisher'));
  }

  @override
  Future<void> dispose() async {}
}
