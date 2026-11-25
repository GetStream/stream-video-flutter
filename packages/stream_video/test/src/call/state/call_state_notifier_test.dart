import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/stream_video.dart';

void main() {
  test('partialCallStateStream distinct filter', () async {
    var callState = CallState(
      callCid: StreamCallCid.from(
        type: StreamCallType.defaultType(),
        id: 'id',
      ),
      currentUserId: 'userId',
      preferences: DefaultCallPreferences(),
    );

    final notifier = CallStateNotifier(callState);
    var updates = 0;

    // We only listen to status updates
    final subscription = notifier
        .partialCallStateStream((state) => state.status)
        .listen((status) {
          updates++;
        });

    // Initial state should be received from the partialCallStateStream
    await Future<void>.delayed(Duration.zero);
    expect(updates, 1);

    // Updating status should triger partialCallStateStream
    callState = callState.copyWith(status: CallStatus.incoming());
    notifier.state = callState;
    await Future<void>.delayed(Duration.zero);
    expect(updates, 2);

    // anything else should not trigger partialCallStateStream
    callState = callState.copyWith(isRecording: true);
    notifier.state = callState;
    await Future<void>.delayed(Duration.zero);
    expect(updates, 2);

    await subscription.cancel();
  });

  test('partialCallStateStream mapped list', () async {
    var callState =
        CallState(
          callCid: StreamCallCid.from(
            type: StreamCallType.defaultType(),
            id: 'id',
          ),
          currentUserId: 'userId',
          preferences: DefaultCallPreferences(),
        ).copyWith(
          callParticipants: [
            CallParticipantState(
              userId: 'userId',
              roles: const ['participant'],
              name: 'name',
              custom: const {},
              sessionId: 'sessionId',
              trackIdPrefix: 'trackIdPrefix',
            ),
            CallParticipantState(
              userId: 'userId2',
              roles: const ['participant'],
              name: 'name2',
              custom: const {},
              sessionId: 'sessionId2',
              trackIdPrefix: 'trackIdPrefix2',
            ),
          ],
        );

    final notifier = CallStateNotifier(callState);
    var updates = 0;

    // We only listen to status updates
    final subscription = notifier
        .partialCallStateStream(
          (state) => state.callParticipants.map((e) => e.userId).toList(),
        )
        .listen((status) {
          updates++;
        });

    // Initial state should be received from the partialCallStateStream
    await Future<void>.delayed(Duration.zero);
    expect(updates, 1);

    // Updating participant id should triger partialCallStateStream
    callState = callState.copyWith(
      callParticipants: [
        callState.callParticipants[0],
        callState.callParticipants[1].copyWith(userId: 'userId3'),
      ],
    );
    notifier.state = callState;
    await Future<void>.delayed(Duration.zero);
    expect(updates, 2);

    // anything else should not trigger partialCallStateStream
    callState = callState.copyWith(
      callParticipants: [
        callState.callParticipants[0],
        callState.callParticipants[1].copyWith(name: 'other name'),
      ],
    );
    notifier.state = callState;
    await Future<void>.delayed(Duration.zero);
    expect(updates, 2);

    await subscription.cancel();
  });

  test(
    'partialCallStateStream stops running its selector once cancelled',
    () async {
      var callState = CallState(
        callCid: StreamCallCid.from(
          type: StreamCallType.defaultType(),
          id: 'id',
        ),
        currentUserId: 'userId',
        preferences: DefaultCallPreferences(),
      );
      final notifier = CallStateNotifier(callState);
      var selectorRuns = 0;

      final subscription = notifier
          .partialCallStateStream((state) {
            selectorRuns++;
            return state.status;
          })
          .listen((_) {});
      await Future<void>.delayed(Duration.zero);
      expect(selectorRuns, isPositive);
      await subscription.cancel();
      selectorRuns = 0;

      callState = callState.copyWith(status: CallStatus.incoming());
      notifier.state = callState;
      await Future<void>.delayed(Duration.zero);

      expect(selectorRuns, 0);
    },
  );

  test(
    'partialCallStateStream skips a map that is a new instance with the same entries',
    () async {
      var callState =
          CallState(
            callCid: StreamCallCid.from(
              type: StreamCallType.defaultType(),
              id: 'id',
            ),
            currentUserId: 'userId',
            preferences: DefaultCallPreferences(),
          ).copyWith(
            capabilitiesByRole: {
              'host': ['send-audio'],
            },
          );
      final notifier = CallStateNotifier(callState);
      final updates = <Map<String, List<String>>>[];

      final subscription = notifier
          .partialCallStateStream((state) => state.capabilitiesByRole)
          .listen(updates.add);
      await Future<void>.delayed(Duration.zero);

      callState = callState.copyWith(
        capabilitiesByRole: {
          'host': ['send-audio'],
        },
      );
      notifier.state = callState;
      await Future<void>.delayed(Duration.zero);
      expect(updates, hasLength(1));

      callState = callState.copyWith(
        capabilitiesByRole: {
          'host': ['send-audio', 'send-video'],
        },
      );
      notifier.state = callState;
      await Future<void>.delayed(Duration.zero);
      expect(updates, hasLength(2));

      await subscription.cancel();
    },
  );

  test(
    'a partialCallStateStream can be listened to more than once',
    () async {
      var callState = CallState(
        callCid: StreamCallCid.from(
          type: StreamCallType.defaultType(),
          id: 'id',
        ),
        currentUserId: 'userId',
        preferences: DefaultCallPreferences(),
      );
      final initialStatus = callState.status;
      final notifier = CallStateNotifier(callState);
      var selectorRuns = 0;
      final stream = notifier.partialCallStateStream((state) {
        selectorRuns++;
        return state.status;
      });

      final first = <CallStatus>[];
      final second = <CallStatus>[];
      final firstSubscription = stream.listen(first.add);
      final secondSubscription = stream.listen(second.add);
      await Future<void>.delayed(Duration.zero);

      expect(first, [initialStatus]);
      expect(second, [initialStatus]);
      expect(selectorRuns, 2);

      await firstSubscription.cancel();
      callState = callState.copyWith(status: CallStatus.incoming());
      notifier.state = callState;
      await Future<void>.delayed(Duration.zero);

      expect(first, hasLength(1));
      expect(second, [initialStatus, callState.status]);
      expect(selectorRuns, 3);

      await secondSubscription.cancel();
    },
  );

  group('liveDurationStream', () {
    CallState state({DateTime? liveStartedAt, DateTime? liveEndedAt}) {
      return CallState(
        callCid: StreamCallCid.from(
          type: StreamCallType.liveStream(),
          id: 'id',
        ),
        currentUserId: 'userId',
        preferences: DefaultCallPreferences(),
      ).copyWithSessionTimes(
        CallSessionData(
          startedAt: liveStartedAt,
          liveStartedAt: liveStartedAt,
          liveEndedAt: liveEndedAt,
        ),
      );
    }

    test('emits nothing before the call goes live', () async {
      final notifier = CallStateNotifier(state());
      addTearDown(notifier.dispose);

      final durations = <Duration>[];
      final subscription = notifier.liveDurationStream.listen(durations.add);
      addTearDown(subscription.cancel);
      await Future<void>.delayed(Duration.zero);

      expect(durations, isEmpty);
    });

    test(
      'freezes when the live ends and restarts on going live again',
      () async {
        final now = DateTime.now();
        final notifier = CallStateNotifier(
          state(liveStartedAt: now.subtract(const Duration(minutes: 10))),
        );
        addTearDown(notifier.dispose);

        final durations = <Duration>[];
        final subscription = notifier.liveDurationStream.listen(durations.add);
        addTearDown(subscription.cancel);
        await Future<void>.delayed(Duration.zero);
        expect(durations.single.inMinutes, 10);

        notifier.state = state(
          liveStartedAt: now.subtract(const Duration(minutes: 10)),
          liveEndedAt: now.subtract(const Duration(minutes: 3)),
        );
        await Future<void>.delayed(Duration.zero);
        expect(durations.last, const Duration(minutes: 7));

        notifier.state = state(liveStartedAt: now);
        await Future<void>.delayed(const Duration(milliseconds: 1100));
        expect(durations.last.inSeconds, inInclusiveRange(0, 2));
      },
    );

    test(
      'starts with the frozen length when listened to after the live',
      () async {
        final now = DateTime.now();
        final notifier = CallStateNotifier(
          state(
            liveStartedAt: now.subtract(const Duration(minutes: 5)),
            liveEndedAt: now,
          ),
        );
        addTearDown(notifier.dispose);

        final first = await notifier.liveDurationStream.first;

        expect(first, const Duration(minutes: 5));
      },
    );
  });
}
