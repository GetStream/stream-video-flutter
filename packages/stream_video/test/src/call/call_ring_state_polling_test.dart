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

// The ring polls on the default settings, so the time advances follow them.
final _startAfter = const RingStatePollingSettings().startAfter;
final _interval = const RingStatePollingSettings().interval;
const _second = Duration(seconds: 1);

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

  late MutableSharedEmitter<StreamVideoEvent> coordinatorEvents;
  late MockCoordinatorClient coordinatorClient;
  late CallStateNotifier stateManager;
  late open.GetCallRingStateResponse polledRingState;
  late int polls;

  /// Starts a ring from the current user to two callees.
  Call startRing({
    RingStatePollingSettings pollingSettings = const RingStatePollingSettings(),
    String sessionId = _sessionId,
    Map<String, CallParticipant> participants = const {},
  }) {
    coordinatorEvents = MutableSharedEmitter<StreamVideoEvent>();
    coordinatorClient = setupMockCoordinatorClient(
      events: coordinatorEvents,
      getOrCreateCallResult: SampleCallData.createCallReceivedOrCreatedData(
        members: {
          for (final user in [_currentUser, _callee1, _callee2])
            user.id: SampleCallData.createCallMember(userId: user.id),
        },
        createdByUser: _currentUser,
        sessionId: sessionId,
        participants: participants,
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

    final streamVideo = setupMockCallHost();
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

  test('polls from 9 s into the ring, every 5 s, by default', () {
    // The tests below advance time by the defaults, so they would not notice
    // a change to them.
    expect(_startAfter, const Duration(seconds: 9));
    expect(_interval, const Duration(seconds: 5));
  });

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
      async.elapse(_startAfter);

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
      async.elapse(_interval * 2);
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
      async.elapse(_startAfter);

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

  test('keeps the ring every callee rejected while a guest is in the call', () {
    fakeAsync((async) {
      startRing(
        participants: const {
          'guest-session': CallParticipant(
            userSessionId: 'guest-session',
            userId: 'guest',
            role: 'user',
          ),
        },
      );
      async.flushMicrotasks();
      expect(stateManager.callState.otherParticipants, isNotEmpty);

      polledRingState = _ringState(
        rejectedBy: {
          _callee1.id: DateTime.utc(2026),
          _callee2.id: DateTime.utc(2026),
        },
      );
      async.elapse(_startAfter);

      // The same outcome as a `call.rejected` event carrying this state.
      expect(stateManager.callState.status, CallStatus.outgoing());
      final callee = stateManager.callState.callMembers.firstWhere(
        (member) => member.userId == _callee1.id,
      );
      expect(callee.callRejectedAt, DateTime.utc(2026));
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
      async.elapse(_startAfter);

      expect(
        stateManager.callState.status,
        CallStatus.disconnected(const DisconnectReason.ended()),
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
      async.elapse(_startAfter + _interval);

      expect(polls, 2);
      expect(stateManager.callState.status, CallStatus.outgoing());
    });
  });

  test('a ring event starts the quiet period over', () {
    fakeAsync((async) {
      final call = startRing();
      async.flushMicrotasks();

      async.elapse(_startAfter - _second);
      final rejectedAt = DateTime.now();
      coordinatorEvents.emit(
        StreamCallRejectedEvent(
          call.callCid,
          rejectedBy: _callee1,
          createdAt: rejectedAt,
          metadata: SampleCallData.createCallMetadata(
            rejectedBy: {_callee1.id: rejectedAt},
            createdByUser: _currentUser,
          ),
        ),
      );
      async.flushMicrotasks();

      async.elapse(_startAfter - _second);
      expect(polls, 0);

      async.elapse(_second);
      expect(polls, 1);
    });
  });

  test('stops polling once the ring is answered over the WebSocket', () {
    fakeAsync((async) {
      final call = startRing();
      async.flushMicrotasks();

      async.elapse(_startAfter - _second);
      coordinatorEvents.emit(
        StreamCallAcceptedEvent(
          call.callCid,
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
