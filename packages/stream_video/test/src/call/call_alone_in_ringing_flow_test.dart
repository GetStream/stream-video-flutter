import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/src/call/ringing/call_drop_if_alone.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/sfu/data/models/sfu_participant.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';
import '../logger/impl/test_logger.dart';
import 'fixtures/call_test_helpers.dart';
import 'fixtures/data.dart';

// A ringing call ends itself when the last other participant leaves and
// `CallPreferences.dropIfAloneInRingingFlow` is on. The check runs on the
// participant list the call holds when the SFU's left event arrives, and again
// once `CallDropIfAlone.gracePeriod` has passed, so a participant who rejoins
// with a new session does not end the call.

final _me = SampleCallData.defaultUserInfo.id;

CallParticipantState _participant(String userId, {String? sessionId}) {
  return CallParticipantState(
    userId: userId,
    roles: const [],
    name: userId,
    custom: const {},
    sessionId: sessionId ?? '$userId-session',
    trackIdPrefix: '$userId-prefix',
    isLocal: userId == _me,
  );
}

SfuParticipant _sfuParticipant(String userId, {String? sessionId}) {
  return SfuParticipant(
    userId: userId,
    userName: userId,
    userImage: '',
    sessionId: sessionId ?? '$userId-session',
    custom: const {},
    customData: const {},
    publishedTracks: const [],
    joinedAt: DateTime.utc(2026),
    trackLookupPrefix: '$userId-prefix',
    connectionQuality: SfuConnectionQuality.unspecified,
    isSpeaking: false,
    isDominantSpeaker: false,
    audioLevel: 0,
    roles: const [],
    participantSource: SfuParticipantSource.webrtc,
  );
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerMockFallbackValues();
  });

  // The call runs in fake time, so the grace period passes without waiting.
  // The test itself runs in real time: some futures the call awaits complete
  // in the root zone, so [elapse] yields to the event loop between steps.
  late FakeAsync fake;
  late BehaviorSubject<InternetStatus> internetStatus;
  late MockCallSession callSession;
  late MockPermissionsManager permissionsManager;
  late CallStateNotifier stateManager;
  late Call call;

  const grace = CallDropIfAlone.gracePeriod;

  Future<void> elapse(Duration duration) async {
    const step = Duration(milliseconds: 100);
    var left = duration;
    do {
      final next = left < step ? left : step;
      fake.elapse(next);
      left -= next;
      for (var i = 0; i < 5; i++) {
        await Future<void>.delayed(Duration.zero);
      }
    } while (left > Duration.zero);
  }

  /// Joins a call that holds [participants], ringing or not.
  Future<void> joinWith({
    required List<CallParticipantState> participants,
    bool ringing = true,
    bool dropIfAlone = true,
  }) async {
    Result<None>? joinResult;
    fake.run((_) {
      stateManager = CallStateNotifier(
        CallState(
          preferences: DefaultCallPreferences(
            dropIfAloneInRingingFlow: dropIfAlone,
          ),
          currentUserId: _me,
          callCid: SampleCallData.defaultCid,
        ),
      );

      call = createTestCall(
        networkMonitor: setupMockInternetConnection(
          statusStream: internetStatus,
        ),
        sessionFactory: setupMockSessionFactory(callSession: callSession),
        streamVideo: setupMockCallHost(),
        permissionManager: permissionsManager,
        stateManager: stateManager,
      );

      unawaited(call.join().then((result) => joinResult = result));
    });
    for (var i = 0; i < 20 && joinResult == null; i++) {
      await elapse(const Duration(milliseconds: 100));
    }
    expect(joinResult?.isSuccess, isTrue);

    stateManager.state = stateManager.state.copyWith(
      isRingingFlow: ringing,
      callParticipants: participants,
    );
  }

  /// Has the SFU send a left event for [participant], then drops its session
  /// from the participant list, as the session's event router does after the
  /// call has seen the event.
  Future<void> emitLeft(
    SfuParticipant participant, {
    String? callCid,
  }) async {
    fake.run(
      (_) => (callSession.events as MutableSharedEmitter<SfuEvent>).emit(
        SfuParticipantLeftEvent(
          callCid: callCid ?? SampleCallData.defaultCid.value,
          participant: participant,
        ),
      ),
    );
    await elapse(Duration.zero);
    if (callCid != null) return;

    stateManager.state = stateManager.state.copyWith(
      callParticipants: [
        for (final it in stateManager.state.callParticipants)
          if (it.userId != participant.userId ||
              it.sessionId != participant.sessionId)
            it,
      ],
    );
  }

  /// Lets what the call started, such as an end or a leave, finish.
  Future<void> settle() => elapse(const Duration(seconds: 1));

  /// Lets the grace period run out, and the end flow run.
  Future<void> elapseGrace() async {
    await elapse(grace);
    await settle();
  }

  /// Sets the participant list as the SFU's left and joined events, or a join
  /// response, would.
  void setParticipants(List<CallParticipantState> participants) {
    stateManager.state = stateManager.state.copyWith(
      callParticipants: participants,
    );
  }

  setUp(() {
    fake = FakeAsync();
    fake.run((_) {
      internetStatus = BehaviorSubject<InternetStatus>.seeded(
        InternetStatus.connected,
      );
      callSession = setupMockCallSession();
    });
    permissionsManager = MockPermissionsManager();
    when(permissionsManager.endCall).thenAnswer(
      (_) async => const Result.success(none),
    );
  });

  tearDown(() async {
    await internetStatus.close();
  });

  group('alone in a ringing flow', () {
    test('ends the call when the last other participant leaves', () async {
      await joinWith(participants: [_participant(_me), _participant('bob')]);

      await emitLeft(_sfuParticipant('bob'));
      await elapseGrace();

      verify(permissionsManager.endCall).called(1);
      expect(call.state.value.status.isDisconnected, isTrue);
    });

    test('reports the end as made by the app', () async {
      await joinWith(participants: [_participant(_me), _participant('bob')]);

      await emitLeft(_sfuParticipant('bob'));
      await elapseGrace();

      expect(
        (call.state.value.status as CallStatusDisconnected).reason,
        const DisconnectReason.ended(
          initiator: LeaveInitiator.app,
          message: 'last participant left the call (ringing flow)',
        ),
      );
    });

    test(
      'reports a leave made by the app when the end is not delivered',
      () async {
        when(permissionsManager.endCall).thenAnswer(
          (_) async => const Result.failure(
            StreamVideoExceptionWithCause(
              message: 'end failed',
              cause: StreamApiException(message: 'HTTP 503', statusCode: 503),
            ),
          ),
        );
        await joinWith(participants: [_participant(_me), _participant('bob')]);

        await emitLeft(_sfuParticipant('bob'));
        await elapseGrace();

        expect(
          (call.state.value.status as CallStatusDisconnected).reason,
          const DisconnectReason.left(
            initiator: LeaveInitiator.app,
            message: 'end not delivered',
          ),
        );
      },
    );

    test('keeps the call when someone else is still there', () async {
      await joinWith(
        participants: [
          _participant(_me),
          _participant('bob'),
          _participant('carol'),
        ],
      );

      await emitLeft(_sfuParticipant('bob'));
      await elapseGrace();

      verifyNever(permissionsManager.endCall);
      expect(call.state.value.status.isDisconnected, isFalse);
    });

    test('keeps the call when the local user is on two devices', () async {
      await joinWith(
        participants: [
          _participant(_me),
          _participant(_me, sessionId: '$_me-tablet'),
          _participant('bob'),
        ],
      );

      await emitLeft(_sfuParticipant('bob'));
      await elapseGrace();

      verifyNever(permissionsManager.endCall);
      expect(call.state.value.status.isDisconnected, isFalse);
    });

    test(
      'keeps the call when a remote user leaves on one of two devices',
      () async {
        await joinWith(
          participants: [
            _participant(_me),
            _participant('bob'),
            _participant('bob', sessionId: 'bob-tablet'),
          ],
        );

        await emitLeft(_sfuParticipant('bob', sessionId: 'bob-tablet'));
        await elapseGrace();

        verifyNever(permissionsManager.endCall);
        expect(call.state.value.status.isDisconnected, isFalse);
      },
    );

    test(
      'ends the call once the last device of a remote user leaves',
      () async {
        await joinWith(
          participants: [
            _participant(_me),
            _participant('bob', sessionId: 'bob-tablet'),
          ],
        );

        await emitLeft(_sfuParticipant('bob', sessionId: 'bob-tablet'));
        await elapseGrace();

        verify(permissionsManager.endCall).called(1);
        expect(call.state.value.status.isDisconnected, isTrue);
      },
    );

    test('keeps the call when the one who left is the local user', () async {
      await joinWith(participants: [_participant(_me), _participant('bob')]);

      await emitLeft(_sfuParticipant(_me));
      await elapseGrace();

      verifyNever(permissionsManager.endCall);
    });

    test('keeps the call when nobody is left at all', () async {
      await joinWith(participants: [_participant('bob')]);

      await emitLeft(_sfuParticipant('bob'));
      await elapseGrace();

      verifyNever(permissionsManager.endCall);
    });

    test('ignores a left for a session the call does not hold', () async {
      await joinWith(participants: [_participant(_me), _participant('bob')]);

      await emitLeft(_sfuParticipant('ghost'));
      await elapseGrace();

      verifyNever(permissionsManager.endCall);
    });

    test('does nothing outside a ringing flow', () async {
      await joinWith(
        participants: [_participant(_me), _participant('bob')],
        ringing: false,
      );

      await emitLeft(_sfuParticipant('bob'));
      await elapseGrace();

      verifyNever(permissionsManager.endCall);
      expect(call.state.value.status.isDisconnected, isFalse);
    });

    test('does nothing when the preference is off', () async {
      await joinWith(
        participants: [_participant(_me), _participant('bob')],
        dropIfAlone: false,
      );

      await emitLeft(_sfuParticipant('bob'));
      await elapseGrace();

      verifyNever(permissionsManager.endCall);
      expect(call.state.value.status.isDisconnected, isFalse);
    });

    test('ignores a left for another call', () async {
      await joinWith(participants: [_participant(_me), _participant('bob')]);

      await emitLeft(_sfuParticipant('bob'), callCid: 'default:another-call');
      await elapseGrace();

      verifyNever(permissionsManager.endCall);
    });

    test('an error thrown while ending is logged', () async {
      final logger = installRecordingLogger();
      when(permissionsManager.endCall).thenThrow(StateError('boom'));

      final uncaught = <Object>[];
      await runZonedGuarded(
        () async {
          await joinWith(
            participants: [_participant(_me), _participant('bob')],
          );
          await emitLeft(_sfuParticipant('bob'));
          await elapseGrace();
        },
        (error, _) => uncaught.add(error),
      );

      expect(uncaught, isEmpty);
      expect(
        logger.errors,
        contains(allOf(contains('[dropIfAlone]'), contains('boom'))),
      );
    });
  });

  group('grace period', () {
    test('waits the whole grace period before ending', () async {
      await joinWith(participants: [_participant(_me), _participant('bob')]);

      await emitLeft(_sfuParticipant('bob'));

      await elapse(grace - const Duration(milliseconds: 1));
      verifyNever(permissionsManager.endCall);
      expect(call.state.value.status.isDisconnected, isFalse);

      await elapse(const Duration(milliseconds: 1));
      verify(permissionsManager.endCall).called(1);
      await settle();
      expect(call.state.value.status.isDisconnected, isTrue);
    });

    test(
      'keeps the call when the participant rejoins with a new session',
      () async {
        await joinWith(participants: [_participant(_me), _participant('bob')]);

        // A rejoin: the old session leaves before the new one joins.
        await emitLeft(_sfuParticipant('bob'));
        await elapse(grace ~/ 2);
        setParticipants([
          _participant(_me),
          _participant('bob', sessionId: 'bob-rejoined'),
        ]);

        await elapse(grace * 2);

        verifyNever(permissionsManager.endCall);
        expect(call.state.value.status.isDisconnected, isFalse);
      },
    );

    test('counts the grace period from the last left', () async {
      await joinWith(participants: [_participant(_me), _participant('bob')]);

      await emitLeft(_sfuParticipant('bob'));
      await elapse(grace ~/ 2);

      // Back with a new session, and gone again.
      setParticipants([
        _participant(_me),
        _participant('bob', sessionId: 'bob-rejoined'),
      ]);
      await emitLeft(_sfuParticipant('bob', sessionId: 'bob-rejoined'));

      await elapse(grace - const Duration(milliseconds: 1));
      verifyNever(permissionsManager.endCall);

      await elapse(const Duration(milliseconds: 1));
      verify(permissionsManager.endCall).called(1);
    });

    test('does not end a call left during the grace period', () async {
      await joinWith(participants: [_participant(_me), _participant('bob')]);

      await emitLeft(_sfuParticipant('bob'));
      await elapse(grace ~/ 2);

      fake.run((_) => unawaited(call.leave()));
      await settle();
      expect(call.state.value.status.isDisconnected, isTrue);
      expect(
        fake.pendingTimers.where((timer) => timer.duration == grace),
        isEmpty,
        reason: 'the leave cancels the pending check',
      );

      await elapse(grace * 2);

      verifyNever(permissionsManager.endCall);
      expect(
        (call.state.value.status as CallStatusDisconnected).reason,
        isA<DisconnectReasonLeft>(),
      );
    });

    for (final (label, status) in [
      ('reconnecting', const CallStatusReconnecting(attempt: 1)),
      ('migrating', CallStatus.migrating()),
      ('joining', CallStatus.joining()),
    ]) {
      test('waits while $label before checking again', () async {
        await joinWith(participants: [_participant(_me), _participant('bob')]);

        await emitLeft(_sfuParticipant('bob'));

        stateManager.state = stateManager.state.copyWith(status: status);
        await elapseGrace();
        verifyNever(permissionsManager.endCall);

        // Connected again, and still alone.
        stateManager.state = stateManager.state.copyWith(
          status: CallStatus.connected(),
        );
        await elapseGrace();
        verify(permissionsManager.endCall).called(1);
      });
    }

    test('keeps the call when the same session comes back', () async {
      await joinWith(participants: [_participant(_me), _participant('bob')]);

      await emitLeft(_sfuParticipant('bob'));
      await elapse(grace ~/ 2);
      setParticipants([_participant(_me), _participant('bob')]);

      await elapse(grace * 2);

      verifyNever(permissionsManager.endCall);
      expect(call.state.value.status.isDisconnected, isFalse);
    });

    test(
      'ends the call when the list dropped the session before its left event',
      () async {
        await joinWith(participants: [_participant(_me)]);

        await emitLeft(_sfuParticipant('bob'));
        await elapseGrace();

        verify(permissionsManager.endCall).called(1);
      },
    );
  });
}
