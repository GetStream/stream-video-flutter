import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/open_api/video/coordinator/api.dart' as open;
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';
import 'fixtures/call_test_helpers.dart';
import 'fixtures/data.dart';

const _sessionId = 'ring-session';

final _currentUser = SampleCallData.defaultCallUser;
final _callee1 = SampleCallData.testCallUser1;
final _callee2 = SampleCallData.testCallUser2;

open.GetCallRingStateResponse _ringState({
  Map<String, DateTime> acceptedBy = const {},
  Map<String, DateTime> rejectedBy = const {},
  DateTime? callEndedAt,
}) {
  return open.GetCallRingStateResponse(
    acceptedBy: acceptedBy,
    callCid: SampleCallData.defaultCid.value,
    callEndedAt: callEndedAt,
    createdByUserId: _currentUser.id,
    duration: '1ms',
    missedBy: const {},
    rejectedBy: rejectedBy,
    sessionId: _sessionId,
  );
}

void main() {
  setUpAll(() {
    registerMockFallbackValues();
    registerFallbackValue(<String>[]);
    registerFallbackValue(<open.MemberRequest>[]);
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  late MutableSharedEmitter<CoordinatorEvent> coordinatorEvents;
  late MockCoordinatorClient coordinatorClient;
  late CallStateNotifier stateManager;
  late open.GetCallRingStateResponse polledRingState;
  late int polls;

  /// Starts a ring from the current user to two callees.
  Call startRing({
    RingStatePollingSettings pollingSettings = const RingStatePollingSettings(),
    String sessionId = _sessionId,
  }) {
    coordinatorEvents = MutableSharedEmitter<CoordinatorEvent>();
    coordinatorClient = setupMockCoordinatorClient(
      events: coordinatorEvents,
      getOrCreateCallResult: SampleCallData.createCallReceivedOrCreatedData(
        members: {
          for (final user in [_currentUser, _callee1, _callee2])
            user.id: SampleCallData.createCallMember(userId: user.id),
        },
        createdByUser: _currentUser,
        sessionId: sessionId,
      ),
    );

    polls = 0;
    polledRingState = _ringState();
    when(
      () => coordinatorClient.getCallRingState(
        callCid: any(named: 'callCid'),
        sessionId: any(named: 'sessionId'),
      ),
    ).thenAnswer((_) async {
      polls++;
      return Result.success(polledRingState);
    });

    final streamVideo = setupMockStreamVideo();
    when(() => streamVideo.options).thenReturn(
      StreamVideoOptions(ringStatePolling: pollingSettings),
    );

    stateManager = CallStateNotifier(
      createActiveCallState(currentByUser: _currentUser),
    );

    final call = createTestCall(
      coordinatorClient: coordinatorClient,
      streamVideo: streamVideo,
      stateManager: stateManager,
    );
    call.getOrCreate(
      ringing: true,
      memberIds: [_callee1.id, _callee2.id],
    );
    return call;
  }

  test('joins the ring a callee accepted without the event', () {
    fakeAsync((async) {
      startRing();
      async.flushMicrotasks();
      expect(
        stateManager.callState.status,
        CallStatus.outgoing(),
      );

      final acceptedAt = DateTime.utc(2026);
      polledRingState = _ringState(acceptedBy: {_callee1.id: acceptedAt});
      async.elapse(const Duration(seconds: 15));

      expect(polls, 1);
      expect(
        stateManager.callState.status,
        CallStatus.outgoing(acceptedByCallee: true),
      );
      final callee = stateManager.callState.callMembers.firstWhere(
        (member) => member.userId == _callee1.id,
      );
      expect(callee.callAcceptedAt, acceptedAt);

      verify(
        () => coordinatorClient.getCallRingState(
          callCid: SampleCallData.defaultCid,
          sessionId: _sessionId,
        ),
      ).called(1);

      // The ring settled, so nothing is polled any more.
      async.elapse(const Duration(seconds: 10));
      expect(polls, 1);
    });
  });

  test('cancels the ring every callee rejected without the event', () {
    fakeAsync((async) {
      startRing();
      async.flushMicrotasks();

      polledRingState = _ringState(
        rejectedBy: {
          _callee1.id: DateTime.utc(2026),
          _callee2.id: DateTime.utc(2026, 1, 2),
        },
      );
      async.elapse(const Duration(seconds: 15));

      final status = stateManager.callState.status;
      expect(status, isA<CallStatusDisconnected>());
      final reason = (status as CallStatusDisconnected).reason;
      expect(
        reason,
        DisconnectReason.rejected(
          byUserId: _callee2.id,
          reason: CallRejectReason.allOtherParticipantsRejected(),
        ),
      );
    });
  });

  test('ends the ring of a call that already ended', () {
    fakeAsync((async) {
      startRing();
      async.flushMicrotasks();

      polledRingState = _ringState(
        callEndedAt: DateTime.utc(2026),
        acceptedBy: {_callee1.id: DateTime.utc(2026)},
      );
      async.elapse(const Duration(seconds: 15));

      expect(
        stateManager.callState.status,
        CallStatus.disconnected(DisconnectReason.ended()),
      );
    });
  });

  test('keeps ringing while the ring is still open', () {
    fakeAsync((async) {
      startRing();
      async.flushMicrotasks();

      polledRingState = _ringState(
        rejectedBy: {_callee1.id: DateTime.utc(2026)},
      );
      async.elapse(const Duration(seconds: 20));

      expect(polls, 2);
      expect(stateManager.callState.status, CallStatus.outgoing());
    });
  });

  test('a ring event starts the quiet period over', () {
    fakeAsync((async) {
      final call = startRing();
      async.flushMicrotasks();

      async.elapse(const Duration(seconds: 10));
      final rejectedAt = DateTime.now();
      coordinatorEvents.emit(
        CoordinatorCallRejectedEvent(
          callCid: call.callCid,
          user: _currentUser,
          rejectedBy: _callee1,
          createdAt: rejectedAt,
          metadata: SampleCallData.createCallMetadata(
            rejectedBy: {_callee1.id: rejectedAt},
            createdByUser: _currentUser,
          ),
        ),
      );
      async.flushMicrotasks();

      async.elapse(const Duration(seconds: 14));
      expect(polls, 0);

      async.elapse(const Duration(seconds: 1));
      expect(polls, 1);
    });
  });

  test('stops polling once the ring is answered over the WebSocket', () {
    fakeAsync((async) {
      final call = startRing();
      async.flushMicrotasks();

      async.elapse(const Duration(seconds: 5));
      coordinatorEvents.emit(
        CoordinatorCallAcceptedEvent(
          callCid: call.callCid,
          user: _callee1,
          acceptedBy: _callee1,
          createdAt: DateTime.now(),
          metadata: SampleCallData.createCallMetadata(
            createdByUser: _currentUser,
          ),
        ),
      );
      async.flushMicrotasks();
      expect(
        stateManager.callState.status,
        CallStatus.outgoing(acceptedByCallee: true),
      );

      async.elapse(const Duration(seconds: 30));
      expect(polls, 0);
    });
  });

  test('does not poll when polling is disabled', () {
    fakeAsync((async) {
      startRing(pollingSettings: const RingStatePollingSettings.disabled());
      async.flushMicrotasks();

      async.elapse(const Duration(seconds: 30));
      expect(polls, 0);
    });
  });

  test('does not poll with an interval that is not positive', () {
    fakeAsync((async) {
      startRing(
        pollingSettings: const RingStatePollingSettings(
          interval: Duration.zero,
        ),
      );
      async.flushMicrotasks();

      async.elapse(const Duration(seconds: 30));
      expect(polls, 0);
    });
  });

  test('does not poll a ring without a session', () {
    fakeAsync((async) {
      startRing(sessionId: '');
      async.flushMicrotasks();

      async.elapse(const Duration(seconds: 30));
      expect(polls, 0);
    });
  });
}
