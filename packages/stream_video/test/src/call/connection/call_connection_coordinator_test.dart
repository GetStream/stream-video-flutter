import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/call/stats/trace_tag.dart';
import 'package:stream_video/src/call/stats/tracer.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/telemetry/client_event_types.dart';
import 'package:stream_video/src/webrtc/peer_connection.dart';
import 'package:stream_video/src/webrtc/rtc_manager.dart';
import 'package:stream_video/src/webrtc/traced_peer_connection.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/call_test_helpers.dart';
import '../fixtures/connection_harness.dart';
import '../fixtures/data.dart';

/// Pins what the connection coordinator owns: leaving is terminal, waits end
/// on leave, a failed join leaves once, a remote end leaves like a local
/// leave, a join refused before it starts leaves the call idle, each
/// reconnect counts its attempts afresh, and a reconnect asked for during
/// other connection work is held for it rather than dropped.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  late ConnectionHarness harness;

  setUp(() => harness = ConnectionHarness());
  tearDown(() => harness.dispose());

  test(
    'a leave whose teardown throws still settles disconnected, and a later '
    'leave does not tear down again',
    () async {
      final call = harness.buildCall();
      await call.join();
      when(
        () => harness.streamVideo.state.removeActiveCall(any()),
      ).thenThrow(StateError('teardown failed'));

      await expectLater(call.leave(), throwsStateError);

      expect(call.state.value.status, isA<CallStatusDisconnected>());

      await call.leave();

      verify(
        () => harness.session.leave(reason: any(named: 'reason')),
      ).called(1);
      final rejoin = await call.join();
      expect(rejoin.getErrorOrNull()?.message, 'call was left');
    },
  );

  test(
    'a teardown that throws early still removes the call from the active '
    'calls',
    () async {
      final call = harness.buildCall();
      await call.join();
      when(
        harness.streamVideo.isAudioProcessorConfigured,
      ).thenThrow(StateError('teardown failed'));
      clearInteractions(harness.streamVideo.state);

      await expectLater(call.leave(), throwsStateError);

      verify(
        () => harness.streamVideo.state.removeActiveCall(call),
      ).called(greaterThan(0));
    },
  );

  test(
    'an end whose teardown throws still ends the call on the server and '
    'settles disconnected as ended',
    () async {
      when(
        () => harness.permissionsManager.endCall(),
      ).thenAnswer((_) async => const Result.success(none));
      final call = harness.buildCall();
      await call.join();
      when(
        () => harness.streamVideo.state.removeActiveCall(any()),
      ).thenThrow(StateError('teardown failed'));

      await expectLater(call.end(), throwsStateError);

      verify(() => harness.permissionsManager.endCall()).called(1);
      final status = call.state.value.status as CallStatusDisconnected;
      expect(status.reason, isA<DisconnectReasonEnded>());
    },
  );

  test('a leave during a fast reconnect that then succeeds stays '
      'disconnected', () async {
    final call = harness.buildCall();
    await call.join();
    final reconnectGate = Completer<void>();
    harness.stubFastReconnect(harness.session, () async {
      await reconnectGate.future;
      return sessionStartSuccess();
    });
    await harness.emitSfu(harness.session, sfuSocketDropped);
    expect(call.state.value.status, isA<CallStatusReconnecting>());

    await call.leave();
    reconnectGate.complete();
    await pumpEventQueue();

    expect(call.state.value.status, isA<CallStatusDisconnected>());
  });

  test('a join refused before it starts can be retried', () async {
    final call = harness.buildCall();
    final activeCalls =
        harness.streamVideo.state.activeCalls
            as MutableStateEmitter<List<Call>>;
    activeCalls.value = [harness.buildCall()];

    final refused = await call.join();
    expect(
      refused.getErrorOrNull()?.message,
      'a call with the same cid is in progress',
    );

    activeCalls.value = [];
    final retried = await call.join();

    expect(retried.isSuccess, isTrue);
    expect(call.state.value.status, isA<CallStatusConnected>());
  });

  test('each reconnect counts its attempts from 1', () async {
    final call = harness.buildCall();
    await call.join();
    harness.stubFastReconnect(
      harness.session,
      () async => sessionStartSuccess(),
    );
    final statuses = recordStatuses(call);

    Future<void> dropAndReconnect() async {
      await harness.emitSfu(harness.session, sfuSocketDropped);
      await waitUntil(() => call.state.value.status.isConnected);
    }

    await dropAndReconnect();
    await dropAndReconnect();

    final attempts = statuses
        .whereType<CallStatusReconnecting>()
        .map((status) => status.attempt)
        .toSet();
    expect(attempts, {1});
    // The status recorded on listening, then one per reconnect.
    expect(statuses.whereType<CallStatusConnected>(), hasLength(3));
  });

  test(
    'a leave during the backoff between join attempts ends the join without '
    'another coordinator join',
    () async {
      harness.stubJoinCall(() async => recoverableJoinFailure());
      final call = harness.buildCall(
        retryPolicy: RetryPolicy(
          backoff: (_, _) => const Duration(seconds: 1),
        ),
      );

      final join = call.join();
      await waitUntil(() => call.state.value.status is CallStatusConnecting);
      await pumpEventQueue();
      await call.leave();

      expect((await join).isFailure, isTrue);
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      harness.verifyJoinCallCount(1);
    },
  );

  test('a ring that is not answered in time rejects once and reports one '
      'abort', () async {
    when(
      () => harness.coordinatorClient.rejectCall(
        cid: any(named: 'cid'),
        reason: any(named: 'reason'),
      ),
    ).thenAnswer((_) async => const Result.success(none));
    final call = harness.buildCall(status: CallStatus.outgoing());
    harness.stateManager.state = harness.stateManager.callState.copyWith(
      settings: harness.stateManager.callState.settings.copyWith(
        ring: const StreamRingSettings(
          autoCancelTimeout: Duration(milliseconds: 50),
        ),
      ),
    );

    final result = await call.join();

    expect(result.isFailure, isTrue);
    verify(
      () => harness.coordinatorClient.rejectCall(
        cid: any(named: 'cid'),
        reason: CallRejectReason.timeout().value,
      ),
    ).called(1);
    await harness.settleAborts(1);
    expect(harness.reporter.aborts, [ClientEventStandardCode.clientAborted]);
    final status = call.state.value.status as CallStatusDisconnected;
    expect(status.reason, isA<DisconnectReasonRejected>());
  });

  void stubRejectCall() {
    when(
      () => harness.coordinatorClient.rejectCall(
        cid: any(named: 'cid'),
        reason: any(named: 'reason'),
      ),
    ).thenAnswer((_) async => const Result.success(none));
  }

  test(
    'a leave while the call is being marked active leaves it neither active '
    'nor registered',
    () async {
      final gate = Completer<void>();
      final clientState = harness.streamVideo.state;
      when(() => clientState.setActiveCall(any())).thenAnswer(
        (_) => gate.future,
      );
      final call = harness.buildCall();

      final join = call.join();
      await pumpEventQueue();
      await call.leave();
      clearInteractions(clientState);
      gate.complete();

      expect((await join).getErrorOrNull()?.message, 'call was left');
      verify(() => clientState.removeActiveCall(call)).called(1);
      expect(harness.reporter.registered, isEmpty);
      harness.verifyJoinCallCount(0);
    },
  );

  test(
    'a leave during the outgoing ring wait cancels the join without '
    'rejecting the call',
    () async {
      stubRejectCall();
      final call = harness.buildCall(status: CallStatus.outgoing());

      final join = call.join();
      await pumpEventQueue();
      await call.leave();

      expect((await join).getErrorOrNull()?.message, 'connect cancelled');
      verifyNever(
        () => harness.coordinatorClient.rejectCall(
          cid: any(named: 'cid'),
          reason: any(named: 'reason'),
        ),
      );
      await harness.settleAborts(1);
      expect(harness.reporter.aborts, [ClientEventStandardCode.clientAborted]);
    },
  );

  test(
    'a callee rejecting during the ring wait ends the join with the '
    'rejection, without rejecting back',
    () async {
      stubRejectCall();
      final call = harness.buildCall(status: CallStatus.outgoing());

      final join = call.join();
      await pumpEventQueue();
      harness.stateManager.state = harness.stateManager.callState.copyWith(
        status: CallStatus.disconnected(
          const DisconnectReason.rejected(byUserId: 'callee'),
        ),
      );

      final error = (await join).getErrorOrNull();
      expect(error?.message, 'connect cancelled');
      expect(
        (error! as StreamVideoExceptionWithCause).cause,
        isA<DisconnectReasonRejected>(),
      );
      verifyNever(
        () => harness.coordinatorClient.rejectCall(
          cid: any(named: 'cid'),
          reason: any(named: 'reason'),
        ),
      );
      final status = call.state.value.status as CallStatusDisconnected;
      expect(status.reason, isA<DisconnectReasonRejected>());
      await harness.settleAborts(1);
      expect(harness.reporter.aborts, hasLength(1));
    },
  );

  test(
    'a remote end during the coordinator join cancels the join before any '
    'SFU session',
    () async {
      final gate = Completer<void>();
      harness.stubJoinCall(() async {
        await gate.future;
        return Result.success(SampleCallData.coordinatorJoinedSuccess);
      });
      final call = harness.buildCall();

      final join = call.join();
      await pumpEventQueue();
      harness.stateManager.state = harness.stateManager.callState.copyWith(
        status: CallStatus.disconnected(DisconnectReason.ended()),
      );
      gate.complete();

      final error = (await join).getErrorOrNull();
      expect(
        (error! as StreamVideoExceptionWithCause).cause,
        isA<DisconnectReasonEnded>(),
      );
      await pumpEventQueue();
      harness.verifyMakeCallSessionCount(0);
      final status = call.state.value.status as CallStatusDisconnected;
      expect(status.reason, isA<DisconnectReasonEnded>());
    },
  );

  test(
    'a leave during the reconnect backoff stops the reconnect',
    () async {
      final call = harness.buildCall(
        retryPolicy: RetryPolicy(
          backoff: (_, _) => const Duration(seconds: 1),
        ),
      );
      await call.join();
      harness.stubFastReconnect(
        harness.session,
        () async => const Result.failure(
          StreamVideoException(message: 'sfu unreachable'),
        ),
      );

      await harness.emitSfu(harness.session, sfuSocketDropped);
      await waitUntil(() {
        final status = call.state.value.status;
        return status is CallStatusReconnecting &&
            status.phase == CallReconnectPhase.waiting &&
            status.attempt == 1;
      });
      await pumpEventQueue();
      await call.leave();
      await Future<void>.delayed(const Duration(milliseconds: 1500));

      verify(
        () => harness.session.fastReconnect(
          reconnectDetails: any(named: 'reconnectDetails'),
          capabilities: any(named: 'capabilities'),
          unifiedSessionId: any(named: 'unifiedSessionId'),
        ),
      ).called(1);
      harness.verifyMakeCallSessionCount(1);
      expect(call.state.value.status, isA<CallStatusDisconnected>());
    },
  );

  test(
    'a session that throws while being made is retried, then the join leaves '
    'once',
    () async {
      harness.stubMakeCallSession(() async => throw StateError('no session'));
      final call = harness.buildCall();

      final result = await call.join();

      expect(result.isFailure, isTrue);
      harness.verifyMakeCallSessionCount(3);
      await harness.settleAborts(1);
      expect(harness.reporter.aborts, [ClientEventStandardCode.clientAborted]);
    },
  );

  test(
    'a leave during the migration wait settles disconnected without a '
    'failed reconnect',
    () async {
      harness = ConnectionHarness(sessionCount: 2);
      final [first, second] = harness.sessions;
      when(
        second.waitForMigrationComplete,
      ).thenAnswer((_) => Completer<Result<None>>().future);
      var firstClosed = false;
      when(
        () => first.close(any(), closeReason: any(named: 'closeReason')),
      ).thenAnswer((_) async => firstClosed = true);
      final call = harness.buildCall();
      await call.join();
      final statuses = recordStatuses(call);

      await harness.emitSfu(
        first,
        const SfuGoAwayEvent(goAwayReason: SfuGoAwayReason.rebalance),
      );
      await waitUntil(() => firstClosed);
      await call.leave();
      await pumpEventQueue();

      expect(call.state.value.status, isA<CallStatusDisconnected>());
      expect(statuses, isNot(contains(isA<CallStatusReconnectionFailed>())));
      harness.verifyMakeCallSessionCount(2);
      expect(harness.reporter.aborts, [ClientEventStandardCode.clientAborted]);
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );

  group('a reconnect asked for while other connection work runs', () {
    test(
      'from a failed join attempt is taken by the next attempt, with no '
      'reconnect after it',
      () async {
        harness = ConnectionHarness(sessionCount: 2);
        final [first, second] = harness.sessions;
        harness.stubSessionStart(
          first,
          () async => const Result.failure(
            StreamVideoException(message: 'sfu unreachable'),
          ),
        );
        var fastReconnects = 0;
        for (final session in harness.sessions) {
          harness.stubFastReconnect(session, () async {
            fastReconnects++;
            return sessionStartSuccess();
          });
        }
        final call = harness.buildCall(
          retryPolicy: RetryPolicy(
            backoff: (_, _) => const Duration(milliseconds: 300),
          ),
        );

        final join = call.join();
        await waitUntil(() => harness.reconnectionCallbacks.length == 1);
        await pumpEventQueue();
        // The first attempt has failed and the join is backing off.
        await harness.emitSfu(first, sfuSocketDropped);

        expect((await join).isSuccess, isTrue);
        await Future<void>.delayed(const Duration(milliseconds: 100));

        harness.verifyMakeCallSessionCount(2);
        expect(fastReconnects, 0);
        expect(call.state.value.status, isA<CallStatusConnected>());
        verifyNever(() => second.leave(reason: any(named: 'reason')));
      },
    );

    test(
      'on the session a join is starting runs once the join returns',
      () async {
        final sessionStartGate = Completer<void>();
        harness.stubSessionStart(harness.session, () async {
          await sessionStartGate.future;
          return sessionStartSuccess();
        });
        var fastReconnects = 0;
        harness.stubFastReconnect(harness.session, () async {
          fastReconnects++;
          return sessionStartSuccess();
        });
        final call = harness.buildCall();

        final join = call.join();
        await waitUntil(() => harness.reconnectionCallbacks.length == 1);
        await pumpEventQueue();
        await harness.emitSfu(harness.session, sfuSocketDropped);
        expect(fastReconnects, 0);

        sessionStartGate.complete();
        expect((await join).isSuccess, isTrue);

        await waitUntil(() => fastReconnects == 1);
        await waitUntil(() => call.state.value.status is CallStatusConnected);
      },
    );

    test(
      'during a reconnect attempt that succeeds runs another reconnect',
      () async {
        final call = harness.buildCall();
        await call.join();
        final attemptGate = Completer<void>();
        var fastReconnects = 0;
        harness.stubFastReconnect(harness.session, () async {
          if (++fastReconnects == 1) await attemptGate.future;
          return sessionStartSuccess();
        });

        await harness.emitSfu(harness.session, sfuSocketDropped);
        await waitUntil(() => fastReconnects == 1);
        harness.requestReconnect(0, SfuReconnectionStrategy.fast);
        attemptGate.complete();

        await waitUntil(() => fastReconnects == 2);
        await waitUntil(() => call.state.value.status is CallStatusConnected);
      },
    );

    test(
      'before the reconnect attempt starts is taken into it, so a burst of '
      'triggers reconnects once',
      () async {
        final call = harness.buildCall();
        await call.join();
        var fastReconnects = 0;
        harness.stubFastReconnect(harness.session, () async {
          fastReconnects++;
          return sessionStartSuccess();
        });

        harness.internetStatus.add(InternetStatus.disconnected);
        await waitUntil(
          () => call.state.value.status is CallStatusReconnecting,
        );
        await harness.emitSfu(harness.session, sfuSocketDropped);
        harness
          ..requestReconnect(0, SfuReconnectionStrategy.fast)
          ..requestReconnect(0, SfuReconnectionStrategy.fast);
        harness.internetStatus.add(InternetStatus.connected);

        await waitUntil(() => call.state.value.status is CallStatusConnected);
        await Future<void>.delayed(const Duration(milliseconds: 200));

        expect(fastReconnects, 1);
        expect(call.state.value.status, isA<CallStatusConnected>());
      },
    );

    test(
      'by a session a rejoin has replaced is dropped',
      () async {
        harness = ConnectionHarness(sessionCount: 2);
        final [first, second] = harness.sessions;
        final makeSessionGate = Completer<void>();
        var made = 0;
        harness.stubMakeCallSession(() async {
          if (made++ == 1) await makeSessionGate.future;
        });
        var fastReconnects = 0;
        for (final session in harness.sessions) {
          harness.stubFastReconnect(session, () async {
            fastReconnects++;
            return sessionStartSuccess();
          });
        }
        final call = harness.buildCall();
        await call.join();

        harness.requestReconnect(0, SfuReconnectionStrategy.rejoin);
        // The rejoin waits out its stability window, then makes a session.
        await waitUntil(() => made == 2);
        await harness.emitSfu(first, sfuSocketDropped);
        harness.requestReconnect(0, SfuReconnectionStrategy.fast);
        makeSessionGate.complete();

        await waitUntil(() => call.state.value.status is CallStatusConnected);
        await Future<void>.delayed(const Duration(milliseconds: 200));

        expect(fastReconnects, 0);
        harness.verifyMakeCallSessionCount(2);
        verifyNever(() => second.leave(reason: any(named: 'reason')));
      },
      timeout: const Timeout(Duration(seconds: 20)),
    );

    test(
      'during the first join is not lost: a rejoin asked for then runs once '
      'the join returns',
      () async {
        harness = ConnectionHarness(sessionCount: 2);
        final sessionStartGate = Completer<void>();
        harness.stubSessionStart(harness.session, () async {
          await sessionStartGate.future;
          return sessionStartSuccess();
        });
        final call = harness.buildCall();

        final join = call.join();
        await waitUntil(() => harness.reconnectionCallbacks.length == 1);
        harness.requestReconnect(0, SfuReconnectionStrategy.rejoin);
        sessionStartGate.complete();
        expect((await join).isSuccess, isTrue);

        await waitUntil(() => harness.reconnectionCallbacks.length == 2);
        await waitUntil(() => call.state.value.status is CallStatusConnected);
        harness.verifyMakeCallSessionCount(2);
      },
      timeout: const Timeout(Duration(seconds: 20)),
    );

    test(
      'and still held when a join waiting behind the reconnect finishes runs '
      'then',
      () async {
        final call = harness.buildCall();
        await call.join();
        final attemptGate = Completer<void>();
        var fastReconnects = 0;
        harness.stubFastReconnect(harness.session, () async {
          if (++fastReconnects == 1) await attemptGate.future;
          return sessionStartSuccess();
        });

        await harness.emitSfu(harness.session, sfuSocketDropped);
        await waitUntil(() => fastReconnects == 1);
        final join = call.join();
        await pumpEventQueue();
        harness.requestReconnect(0, SfuReconnectionStrategy.fast);
        attemptGate.complete();

        expect((await join).isSuccess, isTrue);
        await waitUntil(() => fastReconnects == 2);
        await waitUntil(() => call.state.value.status is CallStatusConnected);
      },
    );

    test(
      'is not displaced by a later one from a session already replaced',
      () async {
        harness = ConnectionHarness(sessionCount: 3);
        final [_, second, _] = harness.sessions;
        final call = harness.buildCall();
        await call.join();
        harness.requestReconnect(0, SfuReconnectionStrategy.rejoin);
        await waitUntil(() => harness.reconnectionCallbacks.length == 2);
        await waitUntil(() => call.state.value.status is CallStatusConnected);

        final attemptGate = Completer<void>();
        var fastReconnects = 0;
        harness.stubFastReconnect(second, () async {
          if (++fastReconnects == 1) await attemptGate.future;
          return sessionStartSuccess();
        });
        await harness.emitSfu(second, sfuSocketDropped);
        await waitUntil(() => fastReconnects == 1);
        harness
          ..requestReconnect(1, SfuReconnectionStrategy.rejoin)
          // The first session's publisher, long replaced, fires late.
          ..requestReconnect(0, SfuReconnectionStrategy.fast);
        attemptGate.complete();

        // The held rejoin runs: a third session after its stability window.
        await waitUntil(() => harness.reconnectionCallbacks.length == 3);
        await waitUntil(() => call.state.value.status is CallStatusConnected);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );

    test(
      'with a stronger strategy upgrades the attempt that takes it',
      () async {
        harness = ConnectionHarness(sessionCount: 2);
        final call = harness.buildCall();
        await call.join();
        var fastReconnects = 0;
        for (final session in harness.sessions) {
          harness.stubFastReconnect(session, () async {
            fastReconnects++;
            return sessionStartSuccess();
          });
        }

        harness.internetStatus.add(InternetStatus.disconnected);
        await waitUntil(
          () => call.state.value.status is CallStatusReconnecting,
        );
        harness.requestReconnect(0, SfuReconnectionStrategy.rejoin);
        harness.internetStatus.add(InternetStatus.connected);

        await waitUntil(() => harness.reconnectionCallbacks.length == 2);
        await waitUntil(() => call.state.value.status is CallStatusConnected);
        expect(fastReconnects, 0);
      },
    );

    test('is dropped when the call leaves before the work finishes', () async {
      final sessionStartGate = Completer<void>();
      harness.stubSessionStart(harness.session, () async {
        await sessionStartGate.future;
        return sessionStartSuccess();
      });
      var fastReconnects = 0;
      harness.stubFastReconnect(harness.session, () async {
        fastReconnects++;
        return sessionStartSuccess();
      });
      final call = harness.buildCall();

      final join = call.join();
      await waitUntil(() => harness.reconnectionCallbacks.length == 1);
      harness.requestReconnect(0, SfuReconnectionStrategy.fast);
      await call.leave();
      sessionStartGate.complete();

      expect((await join).isFailure, isTrue);
      await Future<void>.delayed(const Duration(milliseconds: 200));
      expect(fastReconnects, 0);
      expect(call.state.value.status, isA<CallStatusDisconnected>());
    });

    test(
      'from a peer connection that is connected again by then is dropped',
      () async {
        final call = harness.buildCall();
        await call.join();
        final attemptGate = Completer<void>();
        var fastReconnects = 0;
        harness.stubFastReconnect(harness.session, () async {
          if (++fastReconnects == 1) await attemptGate.future;
          return sessionStartSuccess();
        });

        await harness.emitSfu(harness.session, sfuSocketDropped);
        await waitUntil(() => fastReconnects == 1);
        final publisher = harness.requestReconnect(
          0,
          SfuReconnectionStrategy.fast,
        );
        // The attempt's ICE restart brings the peer connection back.
        when(publisher.isConnected).thenReturn(true);
        attemptGate.complete();

        await waitUntil(() => call.state.value.status is CallStatusConnected);
        await Future<void>.delayed(const Duration(milliseconds: 200));
        expect(fastReconnects, 1);
      },
    );

    test(
      'from a stuck peer connection still runs, even when it looks connected',
      () async {
        final call = harness.buildCall();
        await call.join();
        final attemptGate = Completer<void>();
        var fastReconnects = 0;
        harness.stubFastReconnect(harness.session, () async {
          if (++fastReconnects == 1) await attemptGate.future;
          return sessionStartSuccess();
        });

        await harness.emitSfu(harness.session, sfuSocketDropped);
        await waitUntil(() => fastReconnects == 1);
        final publisher = harness.requestReconnect(
          0,
          SfuReconnectionStrategy.fast,
          reason: ReconnectionNeededReason.stuck,
        );
        when(publisher.isConnected).thenReturn(true);
        attemptGate.complete();

        await waitUntil(() => fastReconnects == 2);
        await waitUntil(() => call.state.value.status is CallStatusConnected);
      },
    );

    test(
      'for a socket that is connected again by then is dropped',
      () async {
        final sessionStartGate = Completer<void>();
        harness.stubSessionStart(harness.session, () async {
          await sessionStartGate.future;
          return sessionStartSuccess();
        });
        var fastReconnects = 0;
        harness.stubFastReconnect(harness.session, () async {
          fastReconnects++;
          return sessionStartSuccess();
        });
        final call = harness.buildCall();

        final join = call.join();
        await waitUntil(() => harness.reconnectionCallbacks.length == 1);
        await pumpEventQueue();
        await harness.emitSfu(harness.session, sfuSocketDropped);
        when(() => harness.session.isSfuConnected).thenReturn(true);
        sessionStartGate.complete();

        expect((await join).isSuccess, isTrue);
        await Future<void>.delayed(const Duration(milliseconds: 200));
        expect(fastReconnects, 0);
        expect(call.state.value.status, isA<CallStatusConnected>());
      },
    );

    test(
      'from a network drop still runs once the network is back',
      () async {
        final call = harness.buildCall();
        await call.join();
        final attemptGate = Completer<void>();
        var fastReconnects = 0;
        harness.stubFastReconnect(harness.session, () async {
          if (++fastReconnects == 1) await attemptGate.future;
          return sessionStartSuccess();
        });

        await harness.emitSfu(harness.session, sfuSocketDropped);
        await waitUntil(() => fastReconnects == 1);
        // The network drops and comes back while the attempt runs; the
        // connections it set up may be stale.
        harness.internetStatus.add(InternetStatus.disconnected);
        await pumpEventQueue();
        harness.internetStatus.add(InternetStatus.connected);
        await pumpEventQueue();
        attemptGate.complete();

        await waitUntil(() => fastReconnects == 2);
        await waitUntil(() => call.state.value.status is CallStatusConnected);
      },
    );

    test(
      'that is stronger but cleared does not hide a weaker one still needed',
      () async {
        final call = harness.buildCall();
        await call.join();
        final attemptGate = Completer<void>();
        var fastReconnects = 0;
        harness.stubFastReconnect(harness.session, () async {
          if (++fastReconnects == 1) await attemptGate.future;
          return sessionStartSuccess();
        });

        await harness.emitSfu(harness.session, sfuSocketDropped);
        await waitUntil(() => fastReconnects == 1);
        final publisher = harness.requestReconnect(
          0,
          SfuReconnectionStrategy.rejoin,
        );
        when(publisher.isConnected).thenReturn(true);
        // The socket drops again and stays down.
        await harness.emitSfu(harness.session, sfuSocketDropped);
        attemptGate.complete();

        await waitUntil(() => fastReconnects == 2);
        await waitUntil(() => call.state.value.status is CallStatusConnected);
        // A fast reconnect, not the cleared rejoin: no new session.
        expect(harness.reconnectionCallbacks, hasLength(1));
      },
    );

    test(
      'that cleared does not escalate a failed attempt to a rejoin',
      () async {
        // A long deadline, so only a held rejoin could force the escalation.
        harness.stubSessionStart(
          harness.session,
          () async => Result.success((
            callState: createTestSfuCallState(),
            fastReconnectDeadline: const Duration(minutes: 5),
          )),
        );
        final call = harness.buildCall();
        await call.join();
        final attemptGate = Completer<void>();
        var fastReconnects = 0;
        harness.stubFastReconnect(harness.session, () async {
          if (++fastReconnects == 1) {
            await attemptGate.future;
            return failureWithError('fast reconnect failed');
          }
          return sessionStartSuccess();
        });

        await harness.emitSfu(harness.session, sfuSocketDropped);
        await waitUntil(() => fastReconnects == 1);
        final publisher = harness.requestReconnect(
          0,
          SfuReconnectionStrategy.rejoin,
        );
        when(publisher.isConnected).thenReturn(true);
        attemptGate.complete();

        await waitUntil(() => fastReconnects == 2);
        await waitUntil(() => call.state.value.status is CallStatusConnected);
        // The retry stayed fast: no new session was made.
        expect(harness.reconnectionCallbacks, hasLength(1));
      },
    );

    test(
      'that is a migration makes the attempt after a failed one a migration',
      () async {
        harness = ConnectionHarness(sessionCount: 2);
        final [first, _] = harness.sessions;
        // A long deadline, so only the held migration decides the next attempt.
        harness.stubSessionStart(
          first,
          () async => Result.success((
            callState: createTestSfuCallState(),
            fastReconnectDeadline: const Duration(minutes: 5),
          )),
        );
        final call = harness.buildCall();
        await call.join();
        final attemptGate = Completer<void>();
        var fastReconnects = 0;
        harness.stubFastReconnect(first, () async {
          if (++fastReconnects == 1) {
            await attemptGate.future;
            return failureWithError('fast reconnect failed');
          }
          return sessionStartSuccess();
        });

        await harness.emitSfu(first, sfuSocketDropped);
        await waitUntil(() => fastReconnects == 1);
        await harness.emitSfu(
          first,
          const SfuGoAwayEvent(goAwayReason: SfuGoAwayReason.rebalance),
        );
        attemptGate.complete();

        await waitUntil(() => harness.reconnectionCallbacks.length == 2);
        // A migration keeps the session id; a rejoin would start a new one.
        expect(harness.captureMakeCallSessionIds().last.sessionId, 'session-0');
        expect(fastReconnects, 1);
      },
      timeout: const Timeout(Duration(seconds: 20)),
    );
  });

  test(
    'a reconnect asked for by a replaced session after its rejoin has '
    'finished is dropped',
    () async {
      harness = ConnectionHarness(sessionCount: 2);
      var fastReconnects = 0;
      for (final session in harness.sessions) {
        harness.stubFastReconnect(session, () async {
          fastReconnects++;
          return sessionStartSuccess();
        });
      }
      final call = harness.buildCall();
      await call.join();
      harness.requestReconnect(0, SfuReconnectionStrategy.rejoin);
      await waitUntil(() => harness.reconnectionCallbacks.length == 2);
      await waitUntil(() => call.state.value.status is CallStatusConnected);

      // The first session's publisher, long replaced, fires with no work
      // running.
      harness.requestReconnect(0, SfuReconnectionStrategy.fast);
      await Future<void>.delayed(const Duration(milliseconds: 200));

      expect(fastReconnects, 0);
      expect(harness.reconnectionCallbacks, hasLength(2));
      expect(call.state.value.status, isA<CallStatusConnected>());
    },
    timeout: const Timeout(Duration(seconds: 20)),
  );

  test(
    'a reconnect that throws outside an attempt fails and leaves instead of '
    'staying reconnecting',
    () async {
      final call = harness.buildCall();
      await call.join();
      when(
        () => harness.session.trace(TraceTag.callReconnect, any<Object?>()),
      ).thenThrow(StateError('trace failed'));

      await harness.emitSfu(harness.session, sfuSocketDropped);
      await waitUntil(() => call.state.value.status is CallStatusDisconnected);

      final status = call.state.value.status as CallStatusDisconnected;
      expect(status.reason, isA<DisconnectReasonReconnectionFailed>());
    },
  );

  group('after the device was offline', () {
    /// Takes the device offline for [offline], with the SFU giving a
    /// fast-reconnect deadline of [deadline], and returns a getter for the
    /// number of fast reconnects made.
    Future<int Function()> goOffline({
      required Duration offline,
      required Duration deadline,
    }) async {
      harness.stubSessionStart(
        harness.session,
        () async => Result.success((
          callState: createTestSfuCallState(),
          fastReconnectDeadline: deadline,
        )),
      );
      final call = harness.buildCall();
      await call.join();
      var fastReconnects = 0;
      for (final session in harness.sessions) {
        harness.stubFastReconnect(session, () async {
          fastReconnects++;
          return sessionStartSuccess();
        });
      }

      harness.internetStatus.add(InternetStatus.disconnected);
      await waitUntil(() => call.state.value.status is CallStatusReconnecting);
      await Future<void>.delayed(offline);
      harness.internetStatus.add(InternetStatus.connected);
      return () => fastReconnects;
    }

    test(
      'longer than the fast-reconnect deadline rejoins without trying fast',
      () async {
        harness = ConnectionHarness(sessionCount: 2);
        final fastReconnects = await goOffline(
          offline: const Duration(milliseconds: 400),
          deadline: const Duration(milliseconds: 100),
        );

        // The rejoin first waits for the network to stay up for a while.
        await Future<void>.delayed(const Duration(seconds: 1));
        expect(harness.reconnectionCallbacks, hasLength(1));
        await waitUntil(() => harness.reconnectionCallbacks.length == 2);
        expect(fastReconnects(), 0);
      },
    );

    test(
      'reconnects fast when the SFU gave no fast-reconnect deadline',
      () async {
        harness = ConnectionHarness(sessionCount: 2);
        final fastReconnects = await goOffline(
          offline: const Duration(milliseconds: 200),
          deadline: Duration.zero,
        );

        await waitUntil(() => fastReconnects() == 1);
        expect(harness.reconnectionCallbacks, hasLength(1));
      },
    );

    test(
      'past the fast-reconnect deadline keeps a migration a migration',
      () async {
        harness = ConnectionHarness(sessionCount: 2);
        final [first, _] = harness.sessions;
        harness.stubSessionStart(
          first,
          () async => Result.success((
            callState: createTestSfuCallState(),
            fastReconnectDeadline: const Duration(milliseconds: 100),
          )),
        );
        final call = harness.buildCall();
        await call.join();

        await harness.emitSfu(
          first,
          const SfuGoAwayEvent(goAwayReason: SfuGoAwayReason.rebalance),
        );
        harness.internetStatus.add(InternetStatus.disconnected);
        await pumpEventQueue();
        await Future<void>.delayed(const Duration(milliseconds: 400));
        harness.internetStatus.add(InternetStatus.connected);

        await waitUntil(() => harness.reconnectionCallbacks.length == 2);
        // A migration keeps the session id; a rejoin would start a new one.
        expect(harness.captureMakeCallSessionIds().last.sessionId, 'session-0');
      },
      timeout: const Timeout(Duration(seconds: 20)),
    );

    test('shorter than the fast-reconnect deadline reconnects fast', () async {
      harness = ConnectionHarness(sessionCount: 2);
      final fastReconnects = await goOffline(
        offline: const Duration(milliseconds: 100),
        deadline: const Duration(seconds: 5),
      );

      await waitUntil(() => fastReconnects() == 1);
      expect(harness.reconnectionCallbacks, hasLength(1));
    });
  });

  group('a failed fast reconnect attempt', () {
    /// Fails the first fast reconnect on [harness]'s first session, with the
    /// peer connections reporting [publisherHealthy] and [subscriberHealthy]
    /// by then; a null [publisherHealthy] means the call does not publish.
    /// Returns a getter for the number of fast reconnects made.
    Future<int Function()> failFirstFastAttempt({
      required bool? publisherHealthy,
      bool subscriberHealthy = true,
    }) async {
      // A long deadline, so only the peer connections decide the escalation.
      harness.stubSessionStart(
        harness.session,
        () async => Result.success((
          callState: createTestSfuCallState(),
          fastReconnectDeadline: const Duration(minutes: 5),
        )),
      );
      final call = harness.buildCall();
      await call.join();

      final subscriber = _MockTracedStreamPeerConnection();
      when(subscriber.isHealthy).thenReturn(subscriberHealthy);
      when(() => subscriber.tracer).thenReturn(Tracer('subscriber'));
      _MockTracedStreamPeerConnection? publisher;
      if (publisherHealthy != null) {
        publisher = _MockTracedStreamPeerConnection();
        when(publisher.isHealthy).thenReturn(publisherHealthy);
        when(() => publisher!.tracer).thenReturn(Tracer('publisher'));
      }
      final rtcManager = _MockRtcManager();
      when(() => rtcManager.publisher).thenReturn(publisher);
      when(() => rtcManager.subscriber).thenReturn(subscriber);
      when(() => harness.session.rtcManager).thenReturn(rtcManager);

      var fastReconnects = 0;
      harness.stubFastReconnect(harness.session, () async {
        if (++fastReconnects == 1) {
          return failureWithError('fast reconnect failed');
        }
        return sessionStartSuccess();
      });

      await harness.emitSfu(harness.session, sfuSocketDropped);
      return () => fastReconnects;
    }

    test(
      'rejoins when the publisher has failed',
      () async {
        harness = ConnectionHarness(sessionCount: 2);
        final fastReconnects = await failFirstFastAttempt(
          publisherHealthy: false,
        );

        // The rejoin waits out its stability window, then makes a session.
        await waitUntil(() => harness.reconnectionCallbacks.length == 2);
        expect(fastReconnects(), 1);
      },
      timeout: const Timeout(Duration(seconds: 20)),
    );

    test(
      'rejoins when the subscriber has failed',
      () async {
        harness = ConnectionHarness(sessionCount: 2);
        final fastReconnects = await failFirstFastAttempt(
          publisherHealthy: true,
          subscriberHealthy: false,
        );

        await waitUntil(() => harness.reconnectionCallbacks.length == 2);
        expect(fastReconnects(), 1);
      },
      timeout: const Timeout(Duration(seconds: 20)),
    );

    test(
      'retries fast for a call that does not publish and a healthy subscriber',
      () async {
        harness = ConnectionHarness(sessionCount: 2);
        final fastReconnects = await failFirstFastAttempt(
          publisherHealthy: null,
        );

        await waitUntil(() => fastReconnects() == 2);
        expect(harness.reconnectionCallbacks, hasLength(1));
      },
    );

    test(
      'retries fast while the peer connections are healthy',
      () async {
        harness = ConnectionHarness(sessionCount: 2);
        final fastReconnects = await failFirstFastAttempt(
          publisherHealthy: true,
        );

        await waitUntil(() => fastReconnects() == 2);
        expect(harness.reconnectionCallbacks, hasLength(1));
      },
    );
  });
}

class _MockRtcManager extends Mock implements RtcManager {
  @override
  Future<void> dispose() async {}
}

class _MockTracedStreamPeerConnection extends Mock
    implements TracedStreamPeerConnection {
  @override
  Future<void> dispose() async {}
}
