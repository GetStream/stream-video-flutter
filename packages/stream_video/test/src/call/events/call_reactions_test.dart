import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/events/call_reactions.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/call_test_helpers.dart';
import '../fixtures/data.dart';

void main() {
  final reactingUser = SampleCallData.testCallUser1;
  const dismissAfter = Duration(seconds: 3);

  late CallStateNotifier stateManager;
  late CallReactions reactions;

  setUp(() {
    stateManager = CallStateNotifier(
      createActiveCallState().copyWith(
        preferences: DefaultCallPreferences(
          reactionAutoDismissTime: dismissAfter,
        ),
        callParticipants: [
          CallParticipantState(
            userId: reactingUser.id,
            roles: const ['user'],
            name: reactingUser.name,
            custom: const {},
            sessionId: 'session-1',
            trackIdPrefix: 'track-1',
          ),
        ],
      ),
    );
    reactions = CallReactions(stateManager: stateManager);
  });

  StreamCallReactionEvent reaction(String type) {
    return StreamCallReactionEvent(
      SampleCallData.defaultCid,
      createdAt: DateTime.now(),
      reactionType: type,
      user: reactingUser,
    );
  }

  CallReaction? currentReaction() {
    return stateManager.callState.callParticipants
        .firstWhere((p) => p.userId == reactingUser.id)
        .reaction;
  }

  test('a reaction is cleared after the dismiss time', () {
    fakeAsync((async) {
      reactions.onReaction(reaction('like'));
      expect(currentReaction()?.type, 'like');

      async.elapse(dismissAfter);

      expect(currentReaction(), isNull);
    });
  });

  test('a newer reaction from the same user restarts the dismissal', () {
    fakeAsync((async) {
      reactions.onReaction(reaction('like'));
      async.elapse(dismissAfter ~/ 2);

      reactions.onReaction(reaction('wave'));
      async.elapse(dismissAfter ~/ 2 + const Duration(milliseconds: 1));

      expect(currentReaction()?.type, 'wave');

      async.elapse(dismissAfter ~/ 2);

      expect(currentReaction(), isNull);
    });
  });

  test('cancelTimers keeps a reaction from being cleared', () {
    fakeAsync((async) {
      reactions
        ..onReaction(reaction('like'))
        ..cancelTimers();
      async.elapse(dismissAfter * 2);

      expect(currentReaction()?.type, 'like');
    });
  });
}
