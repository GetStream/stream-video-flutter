import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/call_test_helpers.dart';
import 'fixtures/connection_harness.dart';
import 'fixtures/data.dart';

/// Pins that a `Call` is joined once, and what `Call.dispose` releases.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  late ConnectionHarness harness;

  setUp(() => harness = ConnectionHarness());
  tearDown(() => harness.dispose());

  CallParticipantState participant(String userId) => CallParticipantState(
    userId: userId,
    roles: const [],
    name: userId,
    custom: const {},
    sessionId: '$userId-session',
    trackIdPrefix: '$userId-prefix',
  );

  void stubGetCall() {
    when(
      () => harness.coordinatorClient.getCall(
        callCid: any(named: 'callCid'),
        membersLimit: any(named: 'membersLimit'),
        ringing: any(named: 'ringing'),
        notify: any(named: 'notify'),
        video: any(named: 'video'),
      ),
    ).thenAnswer(
      (_) async => const Result.failure(StreamVideoException(message: 'n/a')),
    );
  }

  /// A coordinator event for the call, which it forwards to its events.
  CoordinatorCallEvent caption() => CoordinatorCallClosedCaptionEvent(
    callCid: SampleCallData.defaultCid,
    createdAt: DateTime.now(),
    startTime: DateTime.now(),
    endTime: DateTime.now().add(const Duration(seconds: 3)),
    speakerId: 'speaker1',
    text: 'Hello',
    user: SampleCallData.testCallUser1,
    language: 'en',
    translated: false,
  );

  /// Completes once every stream of [call] is done.
  Future<void> streamsDone(Call call) {
    const limit = Duration(seconds: 5);
    return Future.wait(
      [
        call.state.drain<void>(),
        call.partialState((state) => state.status).drain<void>(),
        call.participantsStream.drain<void>(),
        call.callEvents.drain<void>(),
        call.stats.drain<void>(),
        call.closedCaptions.drain<void>(),
        call.callDurationStream.drain<void>(),
      ].map((done) => done.timeout(limit)),
    );
  }

  test('a join after leave fails with CallLeftException', () async {
    final call = harness.buildCall();
    await call.join();
    await call.leave();

    final result = await call.join();

    expect(result.getErrorOrNull(), isA<CallLeftException>());
  });

  test('dispose leaves a joined call and completes its streams', () async {
    final call = harness.buildCall();
    await call.join();
    final done = streamsDone(call);

    await call.dispose();

    await done;
    expect(call.state.value.status, isA<CallStatusDisconnected>());
    verify(
      () => harness.session.leave(reason: any(named: 'reason')),
    ).called(1);
    verify(harness.session.dispose).called(1);
  });

  test('dispose after leave does not leave again', () async {
    final call = harness.buildCall();
    await call.join();
    await call.leave();

    await call.dispose();

    verify(
      () => harness.session.leave(reason: any(named: 'reason')),
    ).called(1);
    verify(harness.session.dispose).called(1);
  });

  test('dispose during a leave waits for the leave to finish', () async {
    final call = harness.buildCall();
    await call.join();
    final gate = Completer<void>();
    when(harness.session.dispose).thenAnswer((_) => gate.future);

    final left = call.leave();
    await pumpEventQueue();
    var disposed = false;
    final disposing = call.dispose().then((_) => disposed = true);
    await pumpEventQueue();

    expect(disposed, isFalse);

    gate.complete();
    await left;
    await disposing;
    expect(call.state.value.status, isA<CallStatusDisconnected>());
    verify(harness.session.dispose).called(1);
  });

  test('a state change after dispose is dropped', () async {
    final call = harness.buildCall();
    await call.join();
    await call.dispose();
    final last = call.state.value;

    call.updateCallPreferences(
      DefaultCallPreferences(connectTimeout: const Duration(seconds: 1)),
    );

    expect(call.state.value, same(last));
  });

  test('a second dispose does nothing', () async {
    final call = harness.buildCall();
    await call.join();

    await call.dispose();
    await call.dispose();

    verify(
      () => harness.session.leave(reason: any(named: 'reason')),
    ).called(1);
    verify(harness.session.dispose).called(1);
  });

  test('a join after dispose fails with CallLeftException', () async {
    final call = harness.buildCall();
    await call.dispose();

    final result = await call.join();

    expect(result.getErrorOrNull(), isA<CallLeftException>());
  });

  test('dispose on a call never joined completes its streams', () async {
    final call = harness.buildCall();
    final done = streamsDone(call);

    await call.dispose();

    await done;
    harness.verifyMakeCallSessionCount(0);
  });

  test(
    'dispose after leave, while the participants are still throttled, does '
    'not throw',
    () async {
      final call = harness.buildCall();
      await call.join();
      harness.stateManager.state = harness.stateManager.callState.copyWith(
        callParticipants: [participant('a'), participant('b')],
      );
      final listening = call.participantsStream.listen((_) {});
      await pumpEventQueue();

      await call.leave();
      await call.dispose();
      await pumpEventQueue();
      await Future<void>.delayed(const Duration(milliseconds: 1100));

      await listening.cancel();
    },
  );

  test(
    'a watched call ended remotely and then disposed drops later events',
    () async {
      stubGetCall();
      final call = harness.buildCall();
      await call.get();
      harness.stateManager.state = harness.stateManager.callState.copyWith(
        status: CallStatus.disconnected(DisconnectReason.ended()),
      );

      await call.dispose();
      harness.coordinatorEvents.emit(caption());
      await pumpEventQueue();
    },
  );

  test('a get after dispose does not watch the call again', () async {
    stubGetCall();
    final call = harness.buildCall();
    await call.dispose();

    await call.get();
    harness.coordinatorEvents.emit(caption());
    await pumpEventQueue();

    final clientState = harness.streamVideo.state;
    verifyNever(() => clientState.setWatchedCall(call));
  });

  test('dispose while a join is in flight cancels the join', () async {
    final gate = Completer<void>();
    final clientState = harness.streamVideo.state;
    when(() => clientState.setActiveCall(any())).thenAnswer(
      (_) => gate.future,
    );
    final call = harness.buildCall();

    final join = call.join();
    await pumpEventQueue();
    final disposing = call.dispose();
    await pumpEventQueue();
    gate.complete();

    expect((await join).getErrorOrNull(), isA<CallLeftException>());
    await disposing;
    harness.verifyJoinCallCount(0);
  });

  group('dispose after an end whose server call throws completes', () {
    Future<Call> joinWithEndCallThrowing() async {
      final call = harness.buildCall();
      await call.join();
      when(
        harness.permissionsManager.endCall,
      ).thenThrow(StateError('end call failed'));
      return call;
    }

    test('after a teardown that succeeded', () async {
      final call = await joinWithEndCallThrowing();

      await expectLater(call.end(), throwsStateError);
      await call.dispose().timeout(const Duration(seconds: 5));

      expect(call.state.value.status, isA<CallStatusDisconnected>());
    });

    test('after a teardown that threw', () async {
      final call = await joinWithEndCallThrowing();
      when(
        () => harness.streamVideo.state.removeActiveCall(any()),
      ).thenThrow(StateError('teardown failed'));

      await expectLater(call.end(), throwsStateError);
      await call.dispose().timeout(const Duration(seconds: 5));

      expect(call.state.value.status, isA<CallStatusDisconnected>());
    });
  });

  group('a ringing call', () {
    /// Puts [call] in [status], created by the current user or by [createdBy].
    void ringing(CallStatus status, {String? createdBy}) {
      final state = harness.stateManager.callState;
      harness.stateManager.state = state.copyWith(
        status: status,
        createdByUser: CallUser(
          id: createdBy ?? state.currentUserId,
          name: '',
          roles: const [],
          image: '',
        ),
      );
    }

    void stubRejectCall() {
      when(
        () => harness.coordinatorClient.rejectCall(
          cid: any(named: 'cid'),
          reason: any(named: 'reason'),
        ),
      ).thenAnswer((_) async => const Result.success(none));
    }

    void verifyRejectCall(String reason, {int times = 1}) {
      verify(
        () => harness.coordinatorClient.rejectCall(
          cid: any(named: 'cid'),
          reason: reason,
        ),
      ).called(times);
    }

    void verifyNoRejectCall() {
      verifyNever(
        () => harness.coordinatorClient.rejectCall(
          cid: any(named: 'cid'),
          reason: any(named: 'reason'),
        ),
      );
    }

    setUp(stubRejectCall);

    test('that is outgoing and unanswered is cancelled by dispose', () async {
      final call = harness.buildCall();
      ringing(CallStatus.outgoing());

      await call.dispose();

      verifyRejectCall('cancel');
    });

    test('that is outgoing and unanswered is cancelled by leave', () async {
      final call = harness.buildCall();
      ringing(CallStatus.outgoing());

      await call.leave();

      verifyRejectCall('cancel');
    });

    test('that the caller rejects is rejected once', () async {
      final call = harness.buildCall();
      ringing(CallStatus.outgoing());

      await call.reject(reason: CallRejectReason.timeout());

      verifyRejectCall('timeout');
      verifyNever(
        () => harness.coordinatorClient.rejectCall(
          cid: any(named: 'cid'),
          reason: 'cancel',
        ),
      );
    });

    test('that the callee accepted is not cancelled', () async {
      final call = harness.buildCall();
      ringing(CallStatus.outgoing(acceptedByCallee: true));

      await call.dispose();

      verifyNoRejectCall();
    });

    test('that another user created is not cancelled', () async {
      final call = harness.buildCall();
      ringing(CallStatus.outgoing(), createdBy: 'someone-else');

      await call.dispose();

      verifyNoRejectCall();
    });

    test('that is incoming is not rejected by dispose', () async {
      final call = harness.buildCall();
      ringing(CallStatus.incoming(), createdBy: 'caller');

      await call.dispose();

      verifyNoRejectCall();
      expect(call.state.value.status, isA<CallStatusDisconnected>());
    });
  });

  test('dispose still closes the streams when the leave throws', () async {
    final call = harness.buildCall();
    await call.join();
    when(
      () => harness.streamVideo.state.removeActiveCall(any()),
    ).thenThrow(StateError('teardown failed'));
    final done = streamsDone(call);

    await call.dispose();

    await done;
  });

  test(
    'dispose on a call that never joined leaves the client state of another '
    'call with the same cid alone',
    () async {
      final live = harness.buildCall();
      await live.join();
      final other = harness.buildCall();
      final clientState = harness.streamVideo.state;
      clearInteractions(clientState);

      await other.dispose();

      verifyNever(() => clientState.removeActiveCall(any()));
      expect(harness.reporter.aborts, isEmpty);
    },
  );
}
