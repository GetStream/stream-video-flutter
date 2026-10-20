import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/stats/trace_tag.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/call_test_helpers.dart';
import '../fixtures/connection_harness.dart';

/// How a call gives up on a reconnect that keeps rejoining or keeps failing.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  // The call runs in fake time, so the stability windows, backoffs and the
  // rejoin window pass without waiting. The test itself runs in real time:
  // some futures the call awaits complete in the root zone, so [elapse]
  // yields to the event loop between steps.
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
    fake.run((_) => harness = ConnectionHarness());
  });
  tearDown(() async {
    // Steps time until the harness is disposed, rather than awaiting a
    // future that completes in fake time.
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

  const forcedRejoin = SfuErrorEvent(
    error: SfuError(
      message: 'participant media transport failure',
      code: SfuErrorCode.participantMediaTransportFailure,
      shouldRetry: true,
      reconnectStrategy: SfuReconnectionStrategy.rejoin,
    ),
  );

  Future<Call> joinedCall() async {
    final call = fake.run((_) {
      final call = harness.buildCall();
      call.join();
      return call;
    });
    await elapse(const Duration(seconds: 1));
    expect(call.state.value.status, isA<CallStatusConnected>());
    return call;
  }

  /// Has the SFU force a rejoin, and lets it complete.
  Future<void> forceRejoin() async {
    fake.run((_) => unawaited(harness.emitSfu(harness.session, forcedRejoin)));
    await elapse(const Duration(seconds: 10));
  }

  /// Drops the SFU socket, which reconnects fast, and lets it complete.
  Future<void> dropSocket() async {
    fake.run(
      (_) => unawaited(harness.emitSfu(harness.session, sfuSocketDropped)),
    );
    await elapse(const Duration(seconds: 1));
  }

  void verifyGaveUp(String reason, {String strategy = 'rejoin'}) {
    verify(
      () => harness.session.trace(TraceTag.callReconnectFailed, {
        'strategy': strategy,
        'error': reason,
      }),
    ).called(1);
  }

  test('a call forced to rejoin again and again leaves after the 10th rejoin '
      'within 120 seconds', () async {
    final call = await joinedCall();
    final statuses = recordStatuses(call);

    for (var i = 0; i < 10; i++) {
      await forceRejoin();
      expect(call.state.value.status, isA<CallStatusConnected>());
    }

    await forceRejoin();

    expect(statuses, contains(isA<CallStatusReconnectionFailed>()));
    final status = call.state.value.status as CallStatusDisconnected;
    expect(status.reason, isA<DisconnectReasonReconnectionFailed>());
    verifyGaveUp('rejoin_attempt_limit_exceeded');
    expect(harness.reporter.aborts, hasLength(1));
  });

  test('rejoins older than 120 seconds no longer count', () async {
    final call = await joinedCall();

    for (var i = 0; i < 10; i++) {
      await forceRejoin();
    }
    await elapse(const Duration(seconds: 120));
    await forceRejoin();

    expect(call.state.value.status, isA<CallStatusConnected>());
  });

  test('fast reconnects do not count towards the rejoin limit', () async {
    final call = await joinedCall();

    for (var i = 0; i < 9; i++) {
      await forceRejoin();
    }
    for (var i = 0; i < 20; i++) {
      await dropSocket();
      expect(call.state.value.status, isA<CallStatusConnected>());
    }
    await forceRejoin();

    expect(call.state.value.status, isA<CallStatusConnected>());
    verify(
      () => harness.session.fastReconnect(
        reconnectDetails: any(named: 'reconnectDetails'),
        capabilities: any(named: 'capabilities'),
        unifiedSessionId: any(named: 'unifiedSessionId'),
      ),
    ).called(20);
  });

  test('a reconnect whose attempts fail too slowly for the rejoin limit '
      'fails after 10 attempts', () async {
    final call = await joinedCall();
    final statuses = recordStatuses(call);

    // Every SFU join from here on waits out a join response that never
    // comes, so each attempt takes longer than the rejoin window allows
    // for 10 of them.
    harness.stubSessionStart(harness.session, () async {
      await Future<void>.delayed(const Duration(seconds: 5));
      return const Result.failure(
        StreamVideoException(message: 'join response timed out'),
      );
    });
    final reconnectStart = fake.elapsed;
    Duration? failedAfter;
    call.state.listen((state) {
      if (state.status is CallStatusReconnectionFailed) {
        failedAfter ??= fake.elapsed - reconnectStart;
      }
    });

    fake.run((_) => unawaited(harness.emitSfu(harness.session, forcedRejoin)));
    await elapse(const Duration(minutes: 10));

    final attempts = statuses
        .whereType<CallStatusReconnecting>()
        .map((s) => s.attempt)
        .toSet();
    expect(attempts, {for (var i = 1; i <= 10; i++) i});
    expect(failedAfter, greaterThan(const Duration(seconds: 120)));
    expect(call.state.value.status, isA<CallStatusDisconnected>());
    verifyGaveUp('reconnect_attempt_limit_exceeded');
    verifyNever(
      () => harness.session.trace(TraceTag.callReconnectFailed, {
        'strategy': 'rejoin',
        'error': 'rejoin_attempt_limit_exceeded',
      }),
    );
  });
}
