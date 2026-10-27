import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/src/core/client_state.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/call_test_helpers.dart';
import '../../logger/impl/test_logger.dart';
import '../fixtures/connection_harness.dart';
import '../fixtures/data.dart';

/// Pins the wait for a ring to be answered: it ends with the call, not with
/// its own timer. And pins how a ring answered elsewhere ends here: by
/// leaving, never by rejecting.
void main() {
  const timeout = Duration(milliseconds: 100);

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  late ConnectionHarness harness;

  setUp(() {
    harness = ConnectionHarness();
    // An unanswered ring is rejected on the way out.
    when(
      () => harness.coordinatorClient.rejectCall(
        cid: any(named: 'cid'),
        reason: any(named: 'reason'),
      ),
    ).thenAnswer((_) async => const Result.success(none));
  });
  tearDown(() => harness.dispose());

  Call ringingCall(CallStatus status) {
    final call = harness.buildCall(status: status, isRingingFlow: true);
    harness.stateManager.state = harness.stateManager.callState.copyWith(
      settings: const CallSettings(
        ring: StreamRingSettings(
          autoRejectTimeout: timeout,
          autoCancelTimeout: timeout,
        ),
      ),
    );
    return call;
  }

  for (final (name, status) in [
    ('an incoming', CallStatus.incoming()),
    ('an outgoing', CallStatus.outgoing()),
  ]) {
    test('the wait for $name ring stops when the call is left', () async {
      final logger = installRecordingLogger();
      final async = FakeAsync();
      Result<None>? joined;
      Result<None>? left;

      async.run((_) {
        final call = ringingCall(status);
        call.join().then((result) => joined = result);
        async.flushMicrotasks();
        async.elapse(timeout ~/ 2);
        expect(joined, isNull, reason: 'the join waits for the ring');

        call.leave().then((result) => left = result);
        async.flushMicrotasks();
        expect(joined?.isFailure, isTrue);
      });

      // Part of the leave completes on the real event loop: rxdart cancels
      // its subscriptions through a root-zone future.
      for (var turn = 0; left == null && turn < 100; turn++) {
        await Future<void>.delayed(Duration.zero);
        async.flushMicrotasks();
      }
      expect(left?.isSuccess, isTrue);

      async.elapse(timeout * 3);
      expect(
        logger.errors.where((message) => message.contains('ToBeAccepted')),
        isEmpty,
      );
    });

    test('the wait for $name ring fails the join when unanswered', () async {
      final logger = installRecordingLogger();
      final call = ringingCall(status);

      final result = await call.join();

      expect(result.isFailure, isTrue);
      expect(
        logger.errors.where((message) => message.contains('ToBeAccepted')),
        hasLength(1),
      );
      harness.verifyJoinCallCount(0);
    });
  }

  test('an incoming ring accepted during the wait joins', () async {
    final call = ringingCall(CallStatus.incoming());

    final joining = call.join();
    await pumpEventQueue();
    harness.stateManager.lifecycleCallAccepted();

    expect((await joining).isSuccess, isTrue);
  });

  group('a ring answered elsewhere by the current user', () {
    final currentUser = SampleCallData.defaultCallUser;

    void verifyNoReject() => verifyNever(
      () => harness.coordinatorClient.rejectCall(
        cid: any(named: 'cid'),
        reason: any(named: 'reason'),
      ),
    );

    StreamCallAcceptedEvent accepted(Call call) => StreamCallAcceptedEvent(
      call.callCid,
      acceptedBy: currentUser,
      createdAt: DateTime.now(),
      metadata: SampleCallData.createCallMetadata(),
    );

    StreamCallRejectedEvent rejected(Call call) => StreamCallRejectedEvent(
      call.callCid,
      rejectedBy: currentUser,
      createdAt: DateTime.now(),
      metadata: SampleCallData.createCallMetadata(),
    );

    for (final (name, event) in [
      ('accepted', accepted),
      ('rejected', rejected),
    ]) {
      test('$name: leaves the ring without sending a reject', () async {
        final call = ringingCall(CallStatus.incoming());

        harness.coordinatorEvents.emit(event(call));
        await pumpEventQueue();

        final status = harness.stateManager.callState.status;
        expect(status, isA<CallStatusDisconnected>());
        final reason = (status as CallStatusDisconnected).reason;
        expect(reason, isA<DisconnectReasonRejected>());
        expect(
          (reason as DisconnectReasonRejected).reason,
          CallRejectReason.userRespondedElsewhere(),
        );
        verifyNoReject();
      });
    }

    test('the echo of its own reject keeps the reason it was given', () async {
      final call = ringingCall(CallStatus.incoming());
      // The server's event for the reject arrives before its response.
      when(
        () => harness.coordinatorClient.rejectCall(
          cid: any(named: 'cid'),
          reason: any(named: 'reason'),
        ),
      ).thenAnswer((_) async {
        harness.coordinatorEvents.emit(rejected(call));
        await pumpEventQueue();
        return const Result.success(none);
      });

      await call.reject(reason: CallRejectReason.decline());

      final status = harness.stateManager.callState.status;
      final reason = (status as CallStatusDisconnected).reason;
      expect(
        (reason as DisconnectReasonRejected).reason,
        CallRejectReason.decline(),
      );
      verify(
        () => harness.coordinatorClient.rejectCall(
          cid: any(named: 'cid'),
          reason: any(named: 'reason'),
        ),
      ).called(1);
    });

    test('an accept the server applied stays, though its response '
        'failed', () async {
      final call = ringingCall(CallStatus.incoming());
      // The server's event for the accept arrives, then the request times
      // out.
      when(
        () => harness.coordinatorClient.acceptCall(cid: any(named: 'cid')),
      ).thenAnswer((_) async {
        harness.coordinatorEvents.emit(accepted(call));
        await pumpEventQueue();
        return failureWithError('timed out');
      });

      final result = await call.accept();
      harness.coordinatorEvents.emit(accepted(call));
      await pumpEventQueue();

      expect(result.isSuccess, isTrue);
      expect(
        harness.stateManager.callState.status,
        CallStatus.incoming(acceptedByMe: true),
      );
      verifyNoReject();
    });

    test('an accept the server never applied is reverted', () async {
      final call = ringingCall(CallStatus.incoming());
      when(
        () => harness.coordinatorClient.acceptCall(cid: any(named: 'cid')),
      ).thenAnswer((_) async => failureWithError('rejected'));

      final result = await call.accept();

      expect(result.isFailure, isTrue);
      expect(
        harness.stateManager.callState.status,
        CallStatus.incoming(),
      );
    });

    test('another user accepting does not end the ring', () async {
      final call = ringingCall(CallStatus.incoming());

      harness.coordinatorEvents.emit(
        StreamCallAcceptedEvent(
          call.callCid,
          acceptedBy: SampleCallData.testCallUser1,
          createdAt: DateTime.now(),
          metadata: SampleCallData.createCallMetadata(),
        ),
      );
      await pumpEventQueue();

      expect(
        harness.stateManager.callState.status,
        isA<CallStatusIncoming>(),
      );
      verifyNoReject();
    });

    test('a second instance leaving keeps the joining one', () async {
      final clientState = MutableClientState(
        User(id: currentUser.id),
        allowMultipleActiveCalls: false,
        multiCallAudioPolicy: MultiCallAudioPolicy.manual,
      );
      when(() => harness.streamVideo.state).thenReturn(clientState);

      final stale = ringingCall(CallStatus.incoming());
      final staleState = harness.stateManager;
      final joining = ringingCall(CallStatus.incoming(acceptedByMe: true));
      final joiningState = harness.stateManager;
      // The stale instance was watched first, as a ring is before an accept.
      clientState.setWatchedCall(stale);
      await clientState.setActiveCall(joining);
      await clientState.setOutgoingCall(joining);

      harness.coordinatorEvents.emit(accepted(joining));
      await pumpEventQueue();

      expect(staleState.callState.status, isA<CallStatusDisconnected>());
      expect(joiningState.callState.status, isA<CallStatusIncoming>());
      expect(clientState.activeCalls.value, [joining]);
      expect(clientState.activeCall.value, joining);
      expect(clientState.watchedCalls.value, [joining]);
      expect(clientState.outgoingCall.value, joining);
      verifyNoReject();
    });

    test('accepted here: the echo of its own accept is not a leave', () async {
      final call = ringingCall(CallStatus.incoming(acceptedByMe: true));

      harness.coordinatorEvents.emit(accepted(call));
      await pumpEventQueue();

      expect(
        harness.stateManager.callState.status,
        isNot(isA<CallStatusDisconnected>()),
      );
      verifyNoReject();
    });
  });
}
