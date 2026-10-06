import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/data.dart';

CallParticipantState _participant(
  String userId, {
  bool isLocal = false,
  bool isSpeaking = false,
}) {
  return CallParticipantState(
    userId: userId,
    roles: const [],
    name: userId,
    custom: const {},
    sessionId: '$userId-session',
    trackIdPrefix: '$userId-prefix',
    isLocal: isLocal,
    isSpeaking: isSpeaking,
  );
}

CallState _state(List<CallParticipantState> participants) {
  return CallState(
    preferences: DefaultCallPreferences(),
    currentUserId: SampleCallData.defaultUserInfo.id,
    callCid: SampleCallData.defaultCid,
  ).copyWith(callParticipants: participants);
}

void main() {
  group('CallState derived participant views', () {
    final me = _participant('me', isLocal: true);
    final alice = _participant('alice', isSpeaking: true);
    final bob = _participant('bob');

    test('compute the same values as before', () {
      final state = _state([me, alice, bob]);

      expect(state.localParticipant, me);
      expect(state.otherParticipants, [alice, bob]);
      expect(state.activeSpeakers, [alice]);
    });

    test('are computed once per participant list', () {
      final state = _state([me, alice, bob]);

      expect(
        identical(state.otherParticipants, state.otherParticipants),
        isTrue,
      );
      expect(identical(state.activeSpeakers, state.activeSpeakers), isTrue);
    });

    test('are shared by states with the same participant list', () {
      final before = _state([me, alice, bob]);
      final beforeOthers = before.otherParticipants;
      final beforeSpeakers = before.activeSpeakers;

      final after = before.copyWith(isRecording: true);

      expect(identical(after.otherParticipants, beforeOthers), isTrue);
      expect(identical(after.activeSpeakers, beforeSpeakers), isTrue);
      expect(after.localParticipant, me);
    });

    test('reflect a new state, not the one they were first read from', () {
      final before = _state([me, alice]);
      expect(before.otherParticipants, [alice]);

      final after = before.copyWith(callParticipants: [me, alice, bob]);
      expect(after.otherParticipants, [alice, bob]);
      expect(before.otherParticipants, [alice]);
    });

    test('cache a missing local participant', () {
      final state = _state([alice, bob]);

      expect(state.localParticipant, isNull);
      expect(state.localParticipant, isNull);
    });

    test('do not go stale because readers cannot mutate the source list', () {
      final state = _state([me, alice, bob]);
      expect(state.otherParticipants, [alice, bob]);

      expect(
        () => state.callParticipants.sort((a, b) => 0),
        throwsUnsupportedError,
      );
      expect(() => state.callParticipants.add(me), throwsUnsupportedError);

      expect(state.callParticipants, [me, alice, bob]);
      expect(state.otherParticipants, [alice, bob]);
    });

    test('are unmodifiable, so one reader cannot corrupt another', () {
      final state = _state([me, alice, bob]);

      expect(() => state.otherParticipants.add(me), throwsUnsupportedError);
      expect(() => state.activeSpeakers.clear(), throwsUnsupportedError);
    });
  });
}
