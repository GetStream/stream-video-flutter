import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/data.dart';

void main() {
  final sessionStart = DateTime.utc(2026, 11, 20, 10);
  final firstLive = DateTime.utc(2026, 11, 20, 10, 5);
  final firstEnd = DateTime.utc(2026, 11, 20, 10, 15);
  final secondLive = DateTime.utc(2026, 11, 20, 10, 20);

  CallMetadata withSession(CallSessionData session) {
    final base = SampleCallData.createCallMetadata();
    return CallMetadata(
      cid: base.cid,
      details: base.details,
      settings: base.settings,
      session: session,
      users: base.users,
      members: base.members,
    );
  }

  late CallStateNotifier notifier;

  setUp(() {
    notifier = CallStateNotifier(
      CallState(
        currentUserId: 'user',
        callCid: SampleCallData.defaultCid,
        preferences: DefaultCallPreferences(),
      ),
    );
    addTearDown(notifier.dispose);
  });

  test('received call data clears liveEndedAt on going live again', () {
    notifier.updateFromCallReceivedData(
      CallReceivedData(
        callCid: SampleCallData.defaultCid,
        metadata: withSession(
          CallSessionData(
            startedAt: sessionStart,
            liveStartedAt: firstLive,
            liveEndedAt: firstEnd,
          ),
        ),
      ),
    );
    expect(notifier.state.liveEndedAt, firstEnd);

    notifier.updateFromCallReceivedData(
      CallReceivedData(
        callCid: SampleCallData.defaultCid,
        metadata: withSession(
          CallSessionData(startedAt: sessionStart, liveStartedAt: secondLive),
        ),
      ),
    );

    expect(notifier.state.startedAt, sessionStart);
    expect(notifier.state.liveStartedAt, secondLive);
    expect(notifier.state.liveEndedAt, isNull);
  });

  test('received call data keeps startedAt apart from liveStartedAt', () {
    notifier.updateFromCallReceivedData(
      CallReceivedData(
        callCid: SampleCallData.defaultCid,
        metadata: withSession(CallSessionData(liveStartedAt: firstLive)),
      ),
    );

    expect(notifier.state.startedAt, isNull);
    expect(notifier.state.liveStartedAt, firstLive);
  });
}
