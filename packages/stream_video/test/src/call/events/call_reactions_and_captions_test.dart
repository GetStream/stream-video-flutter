import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/events/call_reactions_and_captions.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/call_test_helpers.dart';
import '../fixtures/data.dart';

void main() {
  final reactingUser = SampleCallData.testCallUser1;
  const dismissAfter = Duration(seconds: 3);

  late CallStateNotifier stateManager;
  late CallReactionsAndCaptions reactionsAndCaptions;

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
    reactionsAndCaptions = CallReactionsAndCaptions(
      stateManager: stateManager,
      logger: taggedLogger(tag: 'test'),
    );
  });

  StreamCallReactionEvent reaction(String type) {
    return StreamCallReactionEvent(
      SampleCallData.defaultCid,
      createdAt: DateTime.now(),
      reactionType: type,
      user: reactingUser,
    );
  }

  StreamCallClosedCaptionsEvent caption() {
    return StreamCallClosedCaptionsEvent(
      SampleCallData.defaultCid,
      createdAt: DateTime.now(),
      startTime: DateTime(2026),
      endTime: DateTime(2026).add(const Duration(seconds: 3)),
      speakerId: 'speaker1',
      text: 'Hello',
      user: reactingUser,
      language: 'en',
      translated: false,
    );
  }

  CallReaction? reactionOf(String userId) {
    return stateManager.callState.callParticipants
        .firstWhere((p) => p.userId == userId)
        .reaction;
  }

  test('a newer reaction from the same user restarts the dismissal', () {
    fakeAsync((async) {
      reactionsAndCaptions.onReaction(reaction('like'));
      async.elapse(dismissAfter ~/ 2);

      reactionsAndCaptions.onReaction(reaction('wave'));
      async.elapse(dismissAfter ~/ 2 + const Duration(milliseconds: 1));

      expect(reactionOf(reactingUser.id)?.type, 'wave');

      async.elapse(dismissAfter ~/ 2);

      expect(reactionOf(reactingUser.id), isNull);
    });
  });

  test('cancelTimers keeps reactions and captions from being cleared', () {
    fakeAsync((async) {
      reactionsAndCaptions
        ..onReaction(reaction('like'))
        ..onClosedCaption(caption());
      async.flushMicrotasks();
      expect(reactionsAndCaptions.closedCaptions.value, hasLength(1));

      reactionsAndCaptions.cancelTimers();
      async.elapse(dismissAfter * 2);

      expect(reactionOf(reactingUser.id)?.type, 'like');
      expect(reactionsAndCaptions.closedCaptions.value, hasLength(1));
    });
  });
}
