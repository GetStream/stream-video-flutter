import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/data.dart';

CallMemberState _member(String userId, {DateTime? acceptedAt}) {
  return CallMemberState(
    userId: userId,
    roles: const [],
    name: userId,
    custom: const {},
    callAcceptedAt: acceptedAt,
  );
}

void main() {
  final me = _member('me');
  final alice = _member('alice');
  final bob = _member('bob', acceptedAt: DateTime(2026));

  final state = CallState(
    preferences: DefaultCallPreferences(),
    currentUserId: 'me',
    callCid: SampleCallData.defaultCid,
  ).copyWith(callMembers: [me, alice, bob]);

  test('CallState.ringingMembers lists the other members still ringing', () {
    expect(state.ringingMembers, [alice]);
  });

  test(
    'CallState.ringingMembers is shared by states with the same members',
    () {
      final ringing = state.ringingMembers;

      expect(state.copyWith(isRecording: true).ringingMembers, same(ringing));
    },
  );

  test(
    'CallState.ringingMembers follows a change of members or current user',
    () {
      final accepted = state.copyWith(
        callMembers: [
          me,
          _member('alice', acceptedAt: DateTime(2026)),
          bob,
        ],
      );
      expect(accepted.ringingMembers, isEmpty);
      expect(state.copyWith(currentUserId: 'alice').ringingMembers, [me]);
      expect(state.ringingMembers, [alice]);
    },
  );

  test('CallState.ringingMembers is unmodifiable', () {
    expect(() => state.ringingMembers.add(me), throwsUnsupportedError);
  });

  test(
    'a partial state selecting ringingMembers skips changes that leave the members alone',
    () async {
      final notifier = CallStateNotifier(state);
      final updates = <List<CallMemberState>>[];
      final subscription = notifier
          .partialCallStateStream((state) => state.ringingMembers)
          .listen(updates.add);
      await Future<void>.delayed(Duration.zero);

      notifier.state = notifier.state.copyWith(isRecording: true);
      await Future<void>.delayed(Duration.zero);

      expect(updates, hasLength(1));
      await subscription.cancel();
    },
  );
}
