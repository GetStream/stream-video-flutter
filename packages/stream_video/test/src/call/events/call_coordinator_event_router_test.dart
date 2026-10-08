import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/events/call_closed_captions.dart';
import 'package:stream_video/src/call/events/call_coordinator_event_router.dart';
import 'package:stream_video/src/call/events/call_reactions.dart';
import 'package:stream_video/src/call/events/call_video_moderation.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/call_test_helpers.dart';
import '../fixtures/data.dart';

void main() {
  final cid = SampleCallData.defaultCid;
  final user = SampleCallData.testCallUser1;

  late CallStateNotifier stateManager;
  late CallCoordinatorEventRouter router;
  late List<String> calls;

  void setUpRouter(CallStatus status) {
    calls = [];
    stateManager = CallStateNotifier(createActiveCallState(status: status));
    router = CallCoordinatorEventRouter(
      stateManager: stateManager,
      reactions: CallReactions(stateManager: stateManager),
      closedCaptions: CallClosedCaptions(
        stateManager: stateManager,
        logger: taggedLogger(tag: 'test'),
      ),
      moderation: CallVideoModeration(
        stateManager: stateManager,
        currentUserId: () => user.id,
        setMicrophoneEnabled: ({required enabled}) async =>
            const Result.success(none),
        setCameraEnabled: ({required enabled}) async =>
            const Result.success(none),
      ),
      onPermissionRequest: (_) => calls.add('permissionRequest'),
      onAccepted: (_) async => calls.add('accepted'),
      onRejected: (_) async => calls.add('rejected'),
      onRingActivity: () => calls.add('ringActivity'),
    );
  }

  setUp(() => setUpRouter(CallStatus.connected()));

  test('a permission request goes to its hook', () async {
    await router.route(
      StreamCallPermissionRequestEvent(
        cid,
        createdAt: DateTime.now(),
        permissions: const [CallPermission.sendAudio],
        user: user,
      ),
    );

    expect(calls, ['permissionRequest']);
  });

  test(
    'accepted and rejected mark ring activity, then reach their hook',
    () async {
      final metadata = SampleCallData.defaultCallMetadata;

      await router.route(
        StreamCallAcceptedEvent(
          cid,
          acceptedBy: user,
          createdAt: DateTime.now(),
          metadata: metadata,
        ),
      );
      await router.route(
        StreamCallRejectedEvent(
          cid,
          rejectedBy: user,
          createdAt: DateTime.now(),
          metadata: metadata,
        ),
      );

      expect(calls, ['ringActivity', 'accepted', 'ringActivity', 'rejected']);
    },
  );

  test('a missed call marks ring activity', () async {
    await router.route(
      StreamCallMissedEvent(
        cid,
        sessionId: 'session',
        metadata: SampleCallData.defaultCallMetadata,
        createdAt: DateTime.now(),
        callUser: user,
        members: const [],
      ),
    );

    expect(calls, ['ringActivity']);
  });

  StreamCallSessionParticipantCountUpdatedEvent countEvent() {
    return StreamCallSessionParticipantCountUpdatedEvent(
      cid,
      createdAt: DateTime.now(),
      sessionId: 'session',
      participantsCountByRole: const {'user': 3, 'host': 1},
      anonymousParticipantCount: 2,
    );
  }

  test('the participant count applies before the call is joined', () async {
    setUpRouter(CallStatus.idle());

    await router.route(countEvent());

    expect(stateManager.callState.participantCount, 4);
    expect(stateManager.callState.anonymousParticipantCount, 2);
  });

  test('the participant count is ignored once connected', () async {
    final before = stateManager.callState.participantCount;

    await router.route(countEvent());

    expect(stateManager.callState.participantCount, before);
  });

  test('an event it does not route leaves the state alone', () async {
    final before = stateManager.callState;

    await router.route(
      StreamCallCreatedEvent(
        cid,
        metadata: SampleCallData.defaultCallMetadata,
        createdAt: DateTime.now(),
      ),
    );

    expect(stateManager.callState, same(before));
    expect(calls, isEmpty);
  });
}
