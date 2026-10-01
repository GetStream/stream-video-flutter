import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/src/sfu/data/events/sfu_events.dart';
import 'package:stream_video/src/sfu/data/models/sfu_participant.dart';
import 'package:stream_video/src/shared_emitter.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';
import 'fixtures/call_test_helpers.dart';
import 'fixtures/data.dart';

// A ringing call ends itself when the last other participant leaves and
// `CallPreferences.dropIfAloneInRingingFlow` is on. The check runs on the
// participant list the call holds when the SFU's left event arrives.

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

  late BehaviorSubject<InternetStatus> internetStatus;
  late MockCallSession callSession;
  late MockPermissionsManager permissionsManager;
  late CallStateNotifier stateManager;
  late Call call;

  /// Joins a call that holds [participants], ringing or not.
  Future<void> joinWith({
    required List<CallParticipantState> participants,
    bool ringing = true,
    bool dropIfAlone = true,
  }) async {
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
      networkMonitor: setupMockInternetConnection(statusStream: internetStatus),
      sessionFactory: setupMockSessionFactory(callSession: callSession),
      streamVideo: setupMockStreamVideo(),
      permissionManager: permissionsManager,
      stateManager: stateManager,
    );

    final joinResult = await call.join();
    expect(joinResult.isSuccess, isTrue);

    stateManager.state = stateManager.state.copyWith(
      isRingingFlow: ringing,
      callParticipants: participants,
    );
  }

  Future<void> emitLeft(SfuParticipant participant) async {
    (callSession.events as MutableSharedEmitterImpl<SfuEvent>).emit(
      SfuParticipantLeftEvent(
        callCid: SampleCallData.defaultCid.value,
        participant: participant,
      ),
    );

    // Let the async handler and the end flow run.
    for (var i = 0; i < 10; i++) {
      await Future<void>.delayed(Duration.zero);
    }
  }

  setUp(() {
    internetStatus = BehaviorSubject<InternetStatus>.seeded(
      InternetStatus.connected,
    );
    callSession = setupMockCallSession();
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

      verify(permissionsManager.endCall).called(1);
      expect(call.state.value.status.isDisconnected, isTrue);
    });

    test('keeps the call when someone else is still there', () async {
      await joinWith(
        participants: [
          _participant(_me),
          _participant('bob'),
          _participant('carol'),
        ],
      );

      await emitLeft(_sfuParticipant('bob'));

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

        verify(permissionsManager.endCall).called(1);
        expect(call.state.value.status.isDisconnected, isTrue);
      },
    );

    test('keeps the call when the one who left is the local user', () async {
      await joinWith(participants: [_participant(_me), _participant('bob')]);

      await emitLeft(_sfuParticipant(_me));

      verifyNever(permissionsManager.endCall);
    });

    test('keeps the call when nobody is left at all', () async {
      await joinWith(participants: [_participant('bob')]);

      await emitLeft(_sfuParticipant('bob'));

      verifyNever(permissionsManager.endCall);
    });

    test('ignores a left for a session the call does not hold', () async {
      await joinWith(participants: [_participant(_me), _participant('bob')]);

      await emitLeft(_sfuParticipant('ghost'));

      verifyNever(permissionsManager.endCall);
    });

    test('does nothing outside a ringing flow', () async {
      await joinWith(
        participants: [_participant(_me), _participant('bob')],
        ringing: false,
      );

      await emitLeft(_sfuParticipant('bob'));

      verifyNever(permissionsManager.endCall);
      expect(call.state.value.status.isDisconnected, isFalse);
    });

    test('does nothing when the preference is off', () async {
      await joinWith(
        participants: [_participant(_me), _participant('bob')],
        dropIfAlone: false,
      );

      await emitLeft(_sfuParticipant('bob'));

      verifyNever(permissionsManager.endCall);
      expect(call.state.value.status.isDisconnected, isFalse);
    });

    test('ignores a left for another call', () async {
      await joinWith(participants: [_participant(_me), _participant('bob')]);

      (callSession.events as MutableSharedEmitterImpl<SfuEvent>).emit(
        SfuParticipantLeftEvent(
          callCid: 'default:another-call',
          participant: _sfuParticipant('bob'),
        ),
      );
      for (var i = 0; i < 10; i++) {
        await Future<void>.delayed(Duration.zero);
      }

      verifyNever(permissionsManager.endCall);
    });
  });
}
