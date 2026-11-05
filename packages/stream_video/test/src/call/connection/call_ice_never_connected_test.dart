import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/stats/trace_tag.dart';
import 'package:stream_video/src/call/stats/tracer.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/webrtc/peer_connection.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/src/webrtc/traced_peer_connection.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/call_test_helpers.dart';
import '../fixtures/connection_harness.dart';

/// How a call gives up on a network where ICE never connects.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  // The call runs in fake time, so the stability windows and backoffs pass
  // without waiting. The test itself runs in real time: some futures the
  // call awaits complete in the root zone, so [elapse] yields to the event
  // loop between steps.
  late FakeAsync fake;
  late ConnectionHarness harness;

  Future<void> elapse(Duration duration) async {
    const step = Duration(milliseconds: 100);
    var left = duration;
    while (left > Duration.zero) {
      final next = left < step ? left : step;
      fake.elapse(next);
      left -= next;
      await Future<void>.delayed(Duration.zero);
    }
  }

  setUp(() {
    fake = FakeAsync();
    fake.run((_) => harness = ConnectionHarness(sessionCount: 4));
  });
  tearDown(() async {
    var disposed = false;
    fake.run(
      (_) => unawaited(
        harness.dispose().whenComplete(() => disposed = true),
      ),
    );
    for (var i = 0; i < 100 && !disposed; i++) {
      await elapse(const Duration(seconds: 1));
    }
  });

  /// Whether ICE of a peer connection of `sessions[i]` has connected, as the
  /// stubs [stubIce] installs read it.
  late List<bool> iceConnected;

  /// Gives every session peer connections whose ICE has [connected] or not,
  /// and whose last gathering found [noLocalCandidates] or not.
  void stubIce({bool connected = false, bool noLocalCandidates = false}) {
    iceConnected = List.filled(harness.sessions.length, connected);
    for (final (i, session) in harness.sessions.indexed) {
      final publisher = _MockTracedStreamPeerConnection(
        StreamPeerType.publisher,
      );
      final subscriber = _MockTracedStreamPeerConnection(
        StreamPeerType.subscriber,
      );
      final rtcManager = _MockRtcManager();
      when(() => rtcManager.publisher).thenReturn(publisher);
      when(() => rtcManager.subscriber).thenReturn(subscriber);
      when(
        () => rtcManager.hasIceEverConnected,
      ).thenAnswer((_) => iceConnected[i]);
      when(
        () => rtcManager.hasNoLocalCandidates,
      ).thenReturn(noLocalCandidates);
      when(() => session.rtcManager).thenReturn(rtcManager);
    }
  }

  Future<Call> joinedCall({CallPreferences? preferences}) async {
    final call = fake.run((_) {
      final call = harness.buildCall(preferences: preferences);
      call.join();
      return call;
    });
    await elapse(const Duration(seconds: 1));
    expect(call.state.value.status, isA<CallStatusConnected>());
    return call;
  }

  const mediaTransportFailure = SfuErrorEvent(
    error: SfuError(
      message: 'participant media transport failure',
      code: SfuErrorCode.participantMediaTransportFailure,
      shouldRetry: true,
      reconnectStrategy: SfuReconnectionStrategy.rejoin,
    ),
  );

  /// Has the SFU of `sessions[index]` report a media transport failure, and
  /// lets the rejoin it asks for complete.
  Future<void> failMediaTransport(int index) async {
    fake.run(
      (_) => unawaited(
        harness.emitSfu(harness.sessions[index], mediaTransportFailure),
      ),
    );
    await elapse(const Duration(seconds: 10));
  }

  /// Has the publisher of `sessions[index]` ask for a rejoin for [reason],
  /// and lets it complete.
  Future<void> requestRejoin(
    int index,
    ReconnectionNeededReason reason,
  ) async {
    fake.run(
      (_) => harness.requestReconnect(
        index,
        SfuReconnectionStrategy.rejoin,
        reason: reason,
      ),
    );
    await elapse(const Duration(seconds: 10));
  }

  void verifyUnsupportedNetwork(Call call, {required int lastSession}) {
    final status = call.state.value.status as CallStatusDisconnected;
    expect(status.reason, isA<DisconnectReasonUnsupportedNetwork>());
    verify(
      () => harness.sessions[lastSession].trace(
        TraceTag.callReconnectFailed,
        {'strategy': 'rejoin', 'error': 'webrtc_unsupported_network'},
      ),
    ).called(1);
    harness.verifyMakeCallSessionCount(lastSession + 1);
  }

  test('a media transport failure on a session that never connected rejoins '
      'once, then leaves as an unsupported network', () async {
    stubIce();
    final call = await joinedCall();

    await failMediaTransport(0);
    expect(call.state.value.status, isA<CallStatusConnected>());

    await failMediaTransport(1);

    verifyUnsupportedNetwork(call, lastSession: 1);
  });

  test('a media transport failure on a session that connected rejoins as '
      'usual', () async {
    stubIce(connected: true);
    final call = await joinedCall();

    for (var i = 0; i < 3; i++) {
      await failMediaTransport(i);
      expect(call.state.value.status, isA<CallStatusConnected>());
    }
    harness.verifyMakeCallSessionCount(4);
  });

  test('ICE connecting refills the budget', () async {
    stubIce();
    final call = await joinedCall();

    await failMediaTransport(0);
    final pc = _MockTracedStreamPeerConnection(StreamPeerType.subscriber);
    fake.run((_) => harness.iceConnectedCallbacks[1](pc));
    await failMediaTransport(1);

    expect(call.state.value.status, isA<CallStatusConnected>());
    harness.verifyMakeCallSessionCount(3);
  });

  test('a peer connection that fails before ICE connected rejoins once, '
      'then leaves as an unsupported network', () async {
    stubIce();
    final call = await joinedCall();

    await requestRejoin(0, ReconnectionNeededReason.iceNeverConnected);
    expect(call.state.value.status, isA<CallStatusConnected>());

    await requestRejoin(1, ReconnectionNeededReason.iceNeverConnected);

    verifyUnsupportedNetwork(call, lastSession: 1);
  });

  test('a peer connection that fails before ICE connected, while the other '
      'one connected, rejoins as usual', () async {
    stubIce(connected: true);
    final call = await joinedCall();

    for (var i = 0; i < 3; i++) {
      await requestRejoin(i, ReconnectionNeededReason.iceNeverConnected);
      expect(call.state.value.status, isA<CallStatusConnected>());
    }
  });

  test('gathering no local candidates rejoins once, then leaves as an '
      'unsupported network', () async {
    stubIce(noLocalCandidates: true);
    final call = await joinedCall();

    await requestRejoin(0, ReconnectionNeededReason.noLocalCandidates);
    expect(call.state.value.status, isA<CallStatusConnected>());

    await requestRejoin(1, ReconnectionNeededReason.noLocalCandidates);

    verifyUnsupportedNetwork(call, lastSession: 1);
  });

  test(
    'gathering no local candidates while offline asks for nothing',
    () async {
      stubIce(noLocalCandidates: true);
      final call = await joinedCall();
      when(
        () => harness.networkMonitor.lastTryResults,
      ).thenReturn(InternetStatus.disconnected);

      await requestRejoin(0, ReconnectionNeededReason.noLocalCandidates);

      expect(call.state.value.status, isA<CallStatusConnected>());
      harness.verifyMakeCallSessionCount(1);
    },
  );

  test('a rejoin that finds the device offline does not count towards the '
      'budget', () async {
    stubIce();
    final call = await joinedCall();
    // Every network check finds the device offline before it comes back.
    when(
      () => harness.networkMonitor.internetStatus,
    ).thenAnswer((_) async => InternetStatus.disconnected);

    for (var i = 0; i < 3; i++) {
      await failMediaTransport(i);
      expect(call.state.value.status, isA<CallStatusConnected>());
    }
    harness.verifyMakeCallSessionCount(4);
  });

  test('one peer connection reporting its failure twice counts once', () async {
    stubIce();
    final call = await joinedCall();

    // ICE fails, then the connection itself.
    fake.run((_) {
      harness
        ..requestReconnect(
          0,
          SfuReconnectionStrategy.rejoin,
          reason: ReconnectionNeededReason.iceNeverConnected,
        )
        ..requestReconnect(
          0,
          SfuReconnectionStrategy.rejoin,
          reason: ReconnectionNeededReason.iceNeverConnected,
        );
    });
    await elapse(const Duration(seconds: 10));
    expect(call.state.value.status, isA<CallStatusConnected>());

    await requestRejoin(1, ReconnectionNeededReason.iceNeverConnected);

    verifyUnsupportedNetwork(call, lastSession: 1);
  });

  group('a never-connected failure held while the session connects', () {
    const forcedRejoin = SfuErrorEvent(
      error: SfuError(
        message: 'participant signal lost',
        code: SfuErrorCode.participantSignalLost,
        shouldRetry: true,
        reconnectStrategy: SfuReconnectionStrategy.rejoin,
      ),
    );

    /// Starts a rejoin to `sessions[1]` whose SFU join takes 5 seconds, and
    /// waits until it is joining, so a reconnect asked for meanwhile is
    /// held.
    Future<void> startSlowRejoin() async {
      harness.stubSessionStart(harness.sessions[1], () async {
        await Future<void>.delayed(const Duration(seconds: 5));
        return sessionStartSuccess();
      });
      fake.run(
        (_) => unawaited(harness.emitSfu(harness.session, forcedRejoin)),
      );
      await elapse(const Duration(seconds: 4));
      expect(harness.reconnectionCallbacks, hasLength(2));
    }

    test('still rejoins for the peer connection that failed, without '
        'counting', () async {
      stubIce();
      final call = await joinedCall();
      await startSlowRejoin();

      // The publisher fails; then the subscriber connects.
      fake.run(
        (_) => harness.requestReconnect(
          1,
          SfuReconnectionStrategy.rejoin,
          reason: ReconnectionNeededReason.iceNeverConnected,
        ),
      );
      iceConnected[1] = true;
      await elapse(const Duration(seconds: 15));

      expect(call.state.value.status, isA<CallStatusConnected>());
      harness.verifyMakeCallSessionCount(3);

      // Uncounted: one more never-connected session still rejoins.
      await failMediaTransport(2);
      expect(call.state.value.status, isA<CallStatusConnected>());
    });

    test(
      'is dropped when the cause was gathering no local candidates',
      () async {
        stubIce(noLocalCandidates: true);
        final call = await joinedCall();
        await startSlowRejoin();

        fake.run(
          (_) => harness.requestReconnect(
            1,
            SfuReconnectionStrategy.rejoin,
            reason: ReconnectionNeededReason.noLocalCandidates,
          ),
        );
        iceConnected[1] = true;
        await elapse(const Duration(seconds: 15));

        expect(call.state.value.status, isA<CallStatusConnected>());
        harness.verifyMakeCallSessionCount(2);
      },
    );
  });

  test(
    'maxIceFailuresWithoutConnect sets how many reconnects it takes',
    () async {
      stubIce();
      final call = await joinedCall(
        preferences: DefaultCallPreferences(maxIceFailuresWithoutConnect: 3),
      );

      await failMediaTransport(0);
      await failMediaTransport(1);
      expect(call.state.value.status, isA<CallStatusConnected>());

      await failMediaTransport(2);

      verifyUnsupportedNetwork(call, lastSession: 2);
    },
  );
}

class _MockRtcManager extends Mock implements RtcManager {
  @override
  Future<void> dispose() async {}
}

class _MockTracedStreamPeerConnection extends Mock
    implements TracedStreamPeerConnection {
  _MockTracedStreamPeerConnection(StreamPeerType type) {
    when(() => this.type).thenReturn(type);
    when(() => tracer).thenReturn(Tracer(type.name));
    when(isHealthy).thenReturn(true);
    when(isConnected).thenReturn(false);
  }

  @override
  Future<void> dispose() async {}
}
