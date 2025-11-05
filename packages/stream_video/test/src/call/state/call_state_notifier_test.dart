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
}
