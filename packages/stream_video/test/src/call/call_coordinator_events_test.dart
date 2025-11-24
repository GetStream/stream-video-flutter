import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/src/shared_emitter.dart';
import 'package:stream_video/stream_video.dart';

import 'fixtures/call_test_helpers.dart';
import 'fixtures/data.dart';

void main() {
  setUpAll(() {
    registerMockFallbackValues();
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  Future<({Call call, MutableSharedEmitterImpl<CoordinatorEvent> events})>
  setupCallForEventTesting({
    CallStatus? status,
  }) async {
    final coordinatorEvents = MutableSharedEmitterImpl<CoordinatorEvent>();

    final coordinatorClient = setupMockCoordinatorClient(
      events: coordinatorEvents,
    );

    final initialState = createActiveCallState(
      status: status ?? CallStatus.connected(),
    );
    final stateManager = CallStateNotifier(initialState);

    final call = createTestCall(
      coordinatorClient: coordinatorClient,
      stateManager: stateManager,
    );
    await call.getOrCreate();

    return (call: call, events: coordinatorEvents);
  }

  group('Basic coordinator events', () {
    test(
      'permission request event - onPermissionRequest is called when permission request event is emitted',
      () async {
        final coordinatorEvents = MutableSharedEmitterImpl<CoordinatorEvent>();

        final coordinatorClient = setupMockCoordinatorClient(
          events: coordinatorEvents,
        );

        final call = createTestCall(coordinatorClient: coordinatorClient);
        await call.getOrCreate();

        var permissionRequestCalled = false;
        call.onPermissionRequest = (event) {
          permissionRequestCalled = true;
        };

        coordinatorEvents.emit(
          CoordinatorCallPermissionRequestEvent(
            callCid: call.callCid,
            createdAt: DateTime.now(),
            permissions: const [CallPermission.sendAudio],
            user: const CallUser(
              id: 'id',
              name: 'name',
              roles: [],
              image: 'image',
            ),
          ),
        );

        await Future<void>.delayed(Duration.zero);
        expect(permissionRequestCalled, isTrue);
      },
    );

    test(
      'call ended event - should disconnect with ended reason',
      () async {
        final setup = await setupCallForEventTesting();

        expect(setup.call.state.value.status, isA<CallStatusActive>());

        setup.events.emit(
          CoordinatorCallEndedEvent(
            callCid: setup.call.callCid,
            endedBy: SampleCallData.defaultCallUser,
            type: 'call.ended',
            metadata: SampleCallData.createCallMetadata(),
            createdAt: DateTime.now(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        expect(setup.call.state.value.status, isA<CallStatusDisconnected>());
        final status = setup.call.state.value.status as CallStatusDisconnected;
        expect(status.reason, isA<DisconnectReasonEnded>());
        expect(setup.call.state.value.callParticipants, isEmpty);
      },
    );

    test(
      'call permissions updated event - should update ownCapabilities',
      () async {
        final setup = await setupCallForEventTesting();

        final initialCapabilities = setup.call.state.value.ownCapabilities;
        final newCapabilities = [
          CallPermission.sendAudio,
          CallPermission.sendVideo,
        ];

        setup.events.emit(
          CoordinatorCallPermissionsUpdatedEvent(
            callCid: setup.call.callCid,
            user: SampleCallData.defaultCallUser,
            ownCapabilities: newCapabilities,
            createdAt: DateTime.now(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        expect(
          setup.call.state.value.ownCapabilities,
          isNot(equals(initialCapabilities)),
        );
        expect(setup.call.state.value.ownCapabilities, equals(newCapabilities));
      },
    );

    test(
      'participant count updated event - should update counts when not connected',
      () async {
        final setup = await setupCallForEventTesting(
          status: CallStatus.idle(),
        );

        // Verify initial counts are zero
        expect(setup.call.state.value.participantCount, equals(0));
        expect(setup.call.state.value.anonymousParticipantCount, equals(0));

        // Emit participant count updated event
        setup.events.emit(
          CoordinatorCallSessionParticipantCountUpdatedEvent(
            callCid: setup.call.callCid,
            sessionId: 'test-session-id',
            participantsCountByRole: const {
              'user': 3,
              'admin': 1,
            },
            anonymousParticipantCount: 2,
            createdAt: DateTime.now(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        // Verify counts are updated (sum of all roles + anonymous)
        expect(setup.call.state.value.participantCount, equals(4)); // 3 + 1
        expect(setup.call.state.value.anonymousParticipantCount, equals(2));
      },
    );

    test(
      'participant count updated event - should be ignored when connected',
      () async {
        final setup = await setupCallForEventTesting();

        // Verify call is in connected status
        expect(setup.call.state.value.status, isA<CallStatusConnected>());

        // Get initial counts
        final initialParticipantCount = setup.call.state.value.participantCount;
        final initialAnonymousCount =
            setup.call.state.value.anonymousParticipantCount;

        // Emit participant count updated event
        setup.events.emit(
          CoordinatorCallSessionParticipantCountUpdatedEvent(
            callCid: setup.call.callCid,
            sessionId: 'test-session-id',
            participantsCountByRole: const {
              'user': 10,
              'admin': 2,
            },
            anonymousParticipantCount: 5,
            createdAt: DateTime.now(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        // Verify counts remain unchanged (event should be ignored)
        expect(
          setup.call.state.value.participantCount,
          equals(initialParticipantCount),
        );
        expect(
          setup.call.state.value.anonymousParticipantCount,
          equals(initialAnonymousCount),
        );
      },
    );

    test(
      'user blocked event - should add user to blocked list',
      () async {
        final setup = await setupCallForEventTesting();

        final userToBlock = SampleCallData.testCallUser1;

        expect(setup.call.state.value.blockedUserIds, isEmpty);

        // Emit user blocked event
        setup.events.emit(
          CoordinatorCallUserBlockedEvent(
            callCid: setup.call.callCid,
            user: userToBlock,
            createdAt: DateTime.now(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        // Verify user was added to blocked list
        expect(setup.call.state.value.blockedUserIds, contains(userToBlock.id));
      },
    );

    test(
      'user blocked event - should disconnect if current user is blocked',
      () async {
        final setup = await setupCallForEventTesting();

        final currentUser = SampleCallData.defaultCallUser;

        expect(setup.call.state.value.status, isA<CallStatusActive>());

        // Emit user blocked event for current user
        setup.events.emit(
          CoordinatorCallUserBlockedEvent(
            callCid: setup.call.callCid,
            user: currentUser,
            createdAt: DateTime.now(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        // Verify call was disconnected
        expect(setup.call.state.value.status, isA<CallStatusDisconnected>());
        final status = setup.call.state.value.status as CallStatusDisconnected;
        expect(status.reason, isA<DisconnectReasonBlocked>());
        expect(setup.call.state.value.blockedUserIds, contains(currentUser.id));
      },
    );

    test(
      'user unblocked event - should remove user from blocked list',
      () async {
        final setup = await setupCallForEventTesting();

        final userToUnblock = SampleCallData.testCallUser1;

        // First block the user
        setup.events.emit(
          CoordinatorCallUserBlockedEvent(
            callCid: setup.call.callCid,
            user: userToUnblock,
            createdAt: DateTime.now(),
          ),
        );
        await Future<void>.delayed(Duration.zero);
        expect(
          setup.call.state.value.blockedUserIds,
          contains(userToUnblock.id),
        );

        // Now unblock the user
        setup.events.emit(
          CoordinatorCallUserUnblockedEvent(
            callCid: setup.call.callCid,
            user: userToUnblock,
            createdAt: DateTime.now(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        // Verify user was removed from blocked list
        expect(
          setup.call.state.value.blockedUserIds,
          isNot(contains(userToUnblock.id)),
        );
      },
    );
  });

  group('Member change coordinator events', () {
    test(
      'member added event - should add new members to call',
      () async {
        final setup = await setupCallForEventTesting();

        final initialMemberCount = setup.call.state.value.callMembers.length;

        final newMember = SampleCallData.createCallMember(
          userId: SampleCallData.testCallUser2.id,
        );

        // Emit member added event
        setup.events.emit(
          CoordinatorCallMemberAddedEvent(
            callCid: setup.call.callCid,
            members: [newMember],
            metadata: SampleCallData.createCallMetadata(
              members: {newMember.userId: newMember},
            ),
            createdAt: DateTime.now(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        // Verify member was added
        expect(
          setup.call.state.value.callMembers.length,
          equals(initialMemberCount + 1),
        );
        expect(
          setup.call.state.value.callMembers.any(
            (m) => m.userId == SampleCallData.testCallUser2.id,
          ),
          isTrue,
        );
      },
    );

    test(
      'member removed event - should remove members from call',
      () async {
        final coordinatorEvents = MutableSharedEmitterImpl<CoordinatorEvent>();

        final user1 = SampleCallData.testCallUser1;
        final user2 = SampleCallData.testCallUser2;

        final members = [
          SampleCallData.createCallMember(userId: user1.id),
          SampleCallData.createCallMember(userId: user2.id),
        ];

        final coordinatorClient = setupMockCoordinatorClient(
          events: coordinatorEvents,
          getOrCreateCallResult: SampleCallData.createCallReceivedOrCreatedData(
            members: {
              user1.id: members[0],
              user2.id: members[1],
            },
          ),
        );

        final initialState = createActiveCallState(
          status: CallStatus.connected(),
        );
        final stateManager = CallStateNotifier(initialState);

        final call = createTestCall(
          coordinatorClient: coordinatorClient,
          stateManager: stateManager,
        );
        await call.getOrCreate();

        expect(call.state.value.callMembers.length, equals(2));

        // Emit member removed event
        coordinatorEvents.emit(
          CoordinatorCallMemberRemovedEvent(
            callCid: call.callCid,
            removedMemberIds: [user1.id],
            metadata: SampleCallData.createCallMetadata(),
            createdAt: DateTime.now(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        // Verify member was removed
        expect(call.state.value.callMembers.length, equals(1));
        expect(
          call.state.value.callMembers.any((m) => m.userId == user1.id),
          isFalse,
        );
        expect(
          call.state.value.callMembers.any((m) => m.userId == user2.id),
          isTrue,
        );
      },
    );

    test(
      'member updated event - should update member roles and custom data',
      () async {
        final coordinatorEvents = MutableSharedEmitterImpl<CoordinatorEvent>();

        final user1 = SampleCallData.testCallUser1;

        final members = [
          SampleCallData.createCallMember(userId: user1.id),
        ];

        final coordinatorClient = setupMockCoordinatorClient(
          events: coordinatorEvents,
          getOrCreateCallResult: SampleCallData.createCallReceivedOrCreatedData(
            members: {
              user1.id: members[0],
            },
          ),
        );

        final initialState = createActiveCallState(
          status: CallStatus.connected(),
        );
        final stateManager = CallStateNotifier(initialState);

        final call = createTestCall(
          coordinatorClient: coordinatorClient,
          stateManager: stateManager,
        );
        await call.getOrCreate();

        final initialMember = call.state.value.callMembers.firstWhere(
          (m) => m.userId == user1.id,
        );
        expect(initialMember.roles, equals(['user']));

        // Emit member updated event with new roles
        final updatedMember = CallMember(
          userId: user1.id,
          roles: const ['admin', 'user'],
          custom: const {'updated': true},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        coordinatorEvents.emit(
          CoordinatorCallMemberUpdatedEvent(
            callCid: call.callCid,
            members: [updatedMember],
            metadata: SampleCallData.createCallMetadata(),
            createdAt: DateTime.now(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        // Verify member was updated
        final updatedMemberState = call.state.value.callMembers.firstWhere(
          (m) => m.userId == user1.id,
        );
        expect(updatedMemberState.roles, equals(['admin', 'user']));
        expect(updatedMemberState.custom, equals({'updated': true}));
      },
    );

    test(
      'member updated permission event - should update capabilities by role',
      () async {
        final coordinatorEvents = MutableSharedEmitterImpl<CoordinatorEvent>();

        final user1 = SampleCallData.testCallUser1;

        final members = [
          SampleCallData.createCallMember(userId: user1.id),
        ];

        final coordinatorClient = setupMockCoordinatorClient(
          events: coordinatorEvents,
          getOrCreateCallResult: SampleCallData.createCallReceivedOrCreatedData(
            members: {
              user1.id: members[0],
            },
          ),
        );

        final initialState = createActiveCallState(
          status: CallStatus.connected(),
        );
        final stateManager = CallStateNotifier(initialState);

        final call = createTestCall(
          coordinatorClient: coordinatorClient,
          stateManager: stateManager,
        );
        await call.getOrCreate();

        expect(call.state.value.capabilitiesByRole, isEmpty);

        // Emit member updated permission event
        final capabilitiesByRole = {
          'admin': ['send-audio', 'send-video', 'mute-users'],
          'user': ['send-audio', 'send-video'],
        };

        coordinatorEvents.emit(
          CoordinatorCallMemberUpdatedPermissionEvent(
            callCid: call.callCid,
            capabilitiesByRole: capabilitiesByRole,
            updatedMembers: members,
            metadata: SampleCallData.createCallMetadata(),
            createdAt: DateTime.now(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        // Verify capabilities were updated
        expect(call.state.value.capabilitiesByRole, equals(capabilitiesByRole));
      },
    );
  });

  group('Reaction coordinator events', () {
    test(
      'call reaction event - should set reaction on participant',
      () async {
        final coordinatorEvents = MutableSharedEmitterImpl<CoordinatorEvent>();

        final currentUser = SampleCallData.defaultCallUser;
        final reactingUser = SampleCallData.testCallUser1;

        final participants = {
          'session-1': CallParticipant(
            userId: currentUser.id,
            userSessionId: 'session-1',
            role: 'user',
          ),
          'session-2': CallParticipant(
            userId: reactingUser.id,
            userSessionId: 'session-2',
            role: 'user',
          ),
        };

        final coordinatorClient = setupMockCoordinatorClient(
          events: coordinatorEvents,
          getOrCreateCallResult: SampleCallData.createCallReceivedOrCreatedData(
            participants: participants,
          ),
        );

        // Create initial state with participants
        final initialState = createActiveCallState(
          currentByUser: currentUser,
          status: CallStatus.connected(),
        );
        final stateManager = CallStateNotifier(initialState);

        final call = createTestCall(
          coordinatorClient: coordinatorClient,
          stateManager: stateManager,
        );
        await call.getOrCreate();

        // Verify no reaction initially
        final participantBefore = call.state.value.callParticipants.firstWhere(
          (p) => p.userId == reactingUser.id,
        );
        expect(participantBefore.reaction, isNull);

        // Emit reaction event
        coordinatorEvents.emit(
          CoordinatorCallReactionEvent(
            callCid: call.callCid,
            user: reactingUser,
            reactionType: 'like',
            emojiCode: '👍',
            createdAt: DateTime.now(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        // Verify reaction is set on participant
        final participantAfter = call.state.value.callParticipants.firstWhere(
          (p) => p.userId == reactingUser.id,
        );
        expect(participantAfter.reaction, isNotNull);
        expect(participantAfter.reaction!.type, equals('like'));
        expect(participantAfter.reaction!.emojiCode, equals('👍'));
        expect(participantAfter.reaction!.user.id, equals(reactingUser.id));
      },
    );

    test(
      'call reaction event - should dismiss reaction after timeout',
      () async {
        final coordinatorEvents = MutableSharedEmitterImpl<CoordinatorEvent>();

        final currentUser = SampleCallData.defaultCallUser;
        final reactingUser = SampleCallData.testCallUser1;

        final participants = {
          'session-1': CallParticipant(
            userId: currentUser.id,
            userSessionId: 'session-1',
            role: 'user',
          ),
          'session-2': CallParticipant(
            userId: reactingUser.id,
            userSessionId: 'session-2',
            role: 'user',
          ),
        };

        final coordinatorClient = setupMockCoordinatorClient(
          events: coordinatorEvents,
          getOrCreateCallResult: SampleCallData.createCallReceivedOrCreatedData(
            participants: participants,
          ),
        );

        // Create initial state with custom timeout for faster testing
        final customPreferences = DefaultCallPreferences(
          reactionAutoDismissTime: const Duration(milliseconds: 100),
        );
        final initialState = createActiveCallState(
          currentByUser: currentUser,
          status: CallStatus.connected(),
        ).copyWith(preferences: customPreferences);

        final stateManager = CallStateNotifier(initialState);

        final call = createTestCall(
          coordinatorClient: coordinatorClient,
          stateManager: stateManager,
        );
        await call.getOrCreate();

        // Emit reaction event
        coordinatorEvents.emit(
          CoordinatorCallReactionEvent(
            callCid: call.callCid,
            user: reactingUser,
            reactionType: 'like',
            emojiCode: '👍',
            createdAt: DateTime.now(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        // Verify reaction is set
        var participant = call.state.value.callParticipants.firstWhere(
          (p) => p.userId == reactingUser.id,
        );
        expect(participant.reaction, isNotNull);
        expect(participant.reaction!.type, equals('like'));

        // Wait for reaction to be auto-dismissed
        await Future<void>.delayed(const Duration(milliseconds: 150));

        // Verify reaction is cleared
        participant = call.state.value.callParticipants.firstWhere(
          (p) => p.userId == reactingUser.id,
        );
        expect(participant.reaction, isNull);
      },
    );
  });

  group('State change coordinator events', () {
    test(
      'call recording started event - should set isRecording to true',
      () async {
        final setup = await setupCallForEventTesting();

        expect(setup.call.state.value.isRecording, isFalse);

        setup.events.emit(
          CoordinatorCallRecordingStartedEvent(
            callCid: setup.call.callCid,
            createdAt: DateTime.now(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        expect(setup.call.state.value.isRecording, isTrue);
      },
    );

    test(
      'call recording stopped event - should set isRecording to false',
      () async {
        final setup = await setupCallForEventTesting();

        // First start recording
        setup.events.emit(
          CoordinatorCallRecordingStartedEvent(
            callCid: setup.call.callCid,
            createdAt: DateTime.now(),
          ),
        );
        await Future<void>.delayed(Duration.zero);
        expect(setup.call.state.value.isRecording, isTrue);

        // Then stop recording
        setup.events.emit(
          CoordinatorCallRecordingStoppedEvent(
            callCid: setup.call.callCid,
            createdAt: DateTime.now(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        expect(setup.call.state.value.isRecording, isFalse);
      },
    );

    test(
      'call recording failed event - should set isRecording to false',
      () async {
        final setup = await setupCallForEventTesting();

        // First start recording
        setup.events.emit(
          CoordinatorCallRecordingStartedEvent(
            callCid: setup.call.callCid,
            createdAt: DateTime.now(),
          ),
        );
        await Future<void>.delayed(Duration.zero);
        expect(setup.call.state.value.isRecording, isTrue);

        // Then recording fails
        setup.events.emit(
          CoordinatorCallRecordingFailedEvent(
            callCid: setup.call.callCid,
            createdAt: DateTime.now(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        expect(setup.call.state.value.isRecording, isFalse);
      },
    );

    test(
      'call transcription started event - should set isTranscribing to true',
      () async {
        final setup = await setupCallForEventTesting();

        expect(setup.call.state.value.isTranscribing, isFalse);

        setup.events.emit(
          CoordinatorCallTranscriptionStartedEvent(
            callCid: setup.call.callCid,
            createdAt: DateTime.now(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        expect(setup.call.state.value.isTranscribing, isTrue);
      },
    );

    test(
      'call transcription stopped event - should set isTranscribing to false',
      () async {
        final setup = await setupCallForEventTesting();

        // First start transcription
        setup.events.emit(
          CoordinatorCallTranscriptionStartedEvent(
            callCid: setup.call.callCid,
            createdAt: DateTime.now(),
          ),
        );
        await Future<void>.delayed(Duration.zero);
        expect(setup.call.state.value.isTranscribing, isTrue);

        // Then stop transcription
        setup.events.emit(
          CoordinatorCallTranscriptionStoppedEvent(
            callCid: setup.call.callCid,
            createdAt: DateTime.now(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        expect(setup.call.state.value.isTranscribing, isFalse);
      },
    );

    test(
      'call transcription failed event - should set isTranscribing to false',
      () async {
        final setup = await setupCallForEventTesting();

        // First start transcription
        setup.events.emit(
          CoordinatorCallTranscriptionStartedEvent(
            callCid: setup.call.callCid,
            createdAt: DateTime.now(),
          ),
        );
        await Future<void>.delayed(Duration.zero);
        expect(setup.call.state.value.isTranscribing, isTrue);

        // Then transcription fails
        setup.events.emit(
          CoordinatorCallTranscriptionFailedEvent(
            callCid: setup.call.callCid,
            createdAt: DateTime.now(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        expect(setup.call.state.value.isTranscribing, isFalse);
      },
    );

    test(
      'call closed captions started event - should set isCaptioning to true',
      () async {
        final setup = await setupCallForEventTesting();

        expect(setup.call.state.value.isCaptioning, isFalse);

        setup.events.emit(
          CoordinatorCallClosedCaptionStartedEvent(
            callCid: setup.call.callCid,
            createdAt: DateTime.now(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        expect(setup.call.state.value.isCaptioning, isTrue);
      },
    );

    test(
      'call closed captions stopped event - should set isCaptioning to false',
      () async {
        final setup = await setupCallForEventTesting();

        // First start closed captions
        setup.events.emit(
          CoordinatorCallClosedCaptionStartedEvent(
            callCid: setup.call.callCid,
            createdAt: DateTime.now(),
          ),
        );
        await Future<void>.delayed(Duration.zero);
        expect(setup.call.state.value.isCaptioning, isTrue);

        // Then stop closed captions
        setup.events.emit(
          CoordinatorCallClosedCaptionStoppedEvent(
            callCid: setup.call.callCid,
            createdAt: DateTime.now(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        expect(setup.call.state.value.isCaptioning, isFalse);
      },
    );

    test(
      'call closed captions failed event - should set isCaptioning to false',
      () async {
        final setup = await setupCallForEventTesting();

        // First start closed captions
        setup.events.emit(
          CoordinatorCallClosedCaptionStartedEvent(
            callCid: setup.call.callCid,
            createdAt: DateTime.now(),
          ),
        );
        await Future<void>.delayed(Duration.zero);
        expect(setup.call.state.value.isCaptioning, isTrue);

        // Then closed captions fail
        setup.events.emit(
          CoordinatorCallClosedCaptionFailedEvent(
            callCid: setup.call.callCid,
            createdAt: DateTime.now(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        expect(setup.call.state.value.isCaptioning, isFalse);
      },
    );

    test(
      'call broadcasting started event - should set isBroadcasting to true',
      () async {
        final setup = await setupCallForEventTesting();

        expect(setup.call.state.value.isBroadcasting, isFalse);

        setup.events.emit(
          CoordinatorCallBroadcastingStartedEvent(
            callCid: setup.call.callCid,
            hlsPlaylistUrl: 'https://example.com/hls/playlist.m3u8',
            metadata: SampleCallData.createCallMetadata(),
            createdAt: DateTime.now(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        expect(setup.call.state.value.isBroadcasting, isTrue);
      },
    );

    test(
      'call broadcasting stopped event - should set isBroadcasting to false',
      () async {
        final setup = await setupCallForEventTesting();

        // First start broadcasting
        setup.events.emit(
          CoordinatorCallBroadcastingStartedEvent(
            callCid: setup.call.callCid,
            hlsPlaylistUrl: 'https://example.com/hls/playlist.m3u8',
            metadata: SampleCallData.createCallMetadata(),
            createdAt: DateTime.now(),
          ),
        );
        await Future<void>.delayed(Duration.zero);
        expect(setup.call.state.value.isBroadcasting, isTrue);

        // Then stop broadcasting
        setup.events.emit(
          CoordinatorCallBroadcastingStoppedEvent(
            callCid: setup.call.callCid,
            createdAt: DateTime.now(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        expect(setup.call.state.value.isBroadcasting, isFalse);
      },
    );

    test(
      'call broadcasting failed event - should set isBroadcasting to false',
      () async {
        final setup = await setupCallForEventTesting();

        // First start broadcasting
        setup.events.emit(
          CoordinatorCallBroadcastingStartedEvent(
            callCid: setup.call.callCid,
            hlsPlaylistUrl: 'https://example.com/hls/playlist.m3u8',
            metadata: SampleCallData.createCallMetadata(),
            createdAt: DateTime.now(),
          ),
        );
        await Future<void>.delayed(Duration.zero);
        expect(setup.call.state.value.isBroadcasting, isTrue);

        // Then broadcasting fails
        setup.events.emit(
          CoordinatorCallBroadcastingFailedEvent(
            callCid: setup.call.callCid,
            createdAt: DateTime.now(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        expect(setup.call.state.value.isBroadcasting, isFalse);
      },
    );
  });

  group('Call Metadata Events', () {
    Future<void> testMetadataEvent({
      required String eventName,
      required CoordinatorCallEvent Function(
        StreamCallCid callCid,
        CallMetadata metadata,
        DateTime createdAt,
      )
      createEvent,
      Map<String, List<String>>? capabilitiesByRole,
    }) async {
      final setup = await setupCallForEventTesting();

      // Create metadata with changes
      final metadata = SampleCallData.createCallMetadata(
        recording: true,
        broadcasting: true,
      );

      // Emit the event
      setup.events.emit(
        createEvent(setup.call.callCid, metadata, DateTime.now()),
      );

      await Future<void>.delayed(Duration.zero);

      // Verify metadata was applied
      expect(setup.call.state.value.isRecording, isTrue);
      expect(setup.call.state.value.isBroadcasting, isTrue);

      if (capabilitiesByRole != null) {
        expect(
          setup.call.state.value.capabilitiesByRole,
          equals(capabilitiesByRole),
        );
      }
    }

    test(
      'call updated event - should update metadata and capabilities',
      () async {
        final capabilitiesByRole = {
          'admin': ['send-audio', 'send-video', 'mute-users'],
          'user': ['send-audio', 'send-video'],
        };

        await testMetadataEvent(
          eventName: 'call updated',
          createEvent: (callCid, metadata, createdAt) =>
              CoordinatorCallUpdatedEvent(
                callCid: callCid,
                metadata: metadata,
                capabilitiesByRole: capabilitiesByRole,
                createdAt: createdAt,
              ),
          capabilitiesByRole: capabilitiesByRole,
        );
      },
    );

    test(
      'call live started event - should update metadata',
      () async {
        await testMetadataEvent(
          eventName: 'call live started',
          createEvent: (callCid, metadata, createdAt) =>
              CoordinatorCallLiveStartedEvent(
                callCid: callCid,
                metadata: metadata,
                createdAt: createdAt,
              ),
        );
      },
    );

    test(
      'call ringing event - should update metadata',
      () async {
        await testMetadataEvent(
          eventName: 'call ringing',
          createEvent: (callCid, metadata, createdAt) =>
              CoordinatorCallRingingEvent(
                data: CallRingingData(
                  callCid: callCid,
                  ringing: true,
                  metadata: metadata,
                ),
                video: true,
                sessionId: 'test-session-id',
                createdAt: createdAt,
              ),
        );
      },
    );

    test(
      'call missed event - should update metadata',
      () async {
        await testMetadataEvent(
          eventName: 'call missed',
          createEvent: (callCid, metadata, createdAt) =>
              CoordinatorCallMissedEvent(
                callCid: callCid,
                sessionId: 'test-session-id',
                metadata: metadata,
                callUser: SampleCallData.testCallUser1,
                members: const [],
                createdAt: createdAt,
              ),
        );
      },
    );

    test(
      'call session ended event - should update metadata but not members',
      () async {
        final coordinatorEvents = MutableSharedEmitterImpl<CoordinatorEvent>();

        final user1 = SampleCallData.testCallUser1;
        final user2 = SampleCallData.testCallUser2;

        final members = [
          SampleCallData.createCallMember(userId: user1.id),
          SampleCallData.createCallMember(userId: user2.id),
        ];

        final coordinatorClient = setupMockCoordinatorClient(
          events: coordinatorEvents,
          getOrCreateCallResult: SampleCallData.createCallReceivedOrCreatedData(
            members: {
              user1.id: members[0],
              user2.id: members[1],
            },
          ),
        );

        final initialState = createActiveCallState(
          status: CallStatus.connected(),
        );
        final stateManager = CallStateNotifier(initialState);

        final call = createTestCall(
          coordinatorClient: coordinatorClient,
          stateManager: stateManager,
        );
        await call.getOrCreate();

        // Verify we have 2 members initially
        expect(call.state.value.callMembers.length, equals(2));
        final initialMemberIds = call.state.value.callMembers
            .map((m) => m.userId)
            .toList();

        // Create metadata with empty members (this should NOT update members)
        final metadata = SampleCallData.createCallMetadata(
          recording: true,
        );

        // Emit session ended event
        coordinatorEvents.emit(
          CoordinatorCallSessionEndedEvent(
            callCid: call.callCid,
            sessionId: 'test-session-id',
            metadata: metadata,
            createdAt: DateTime.now(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        // Verify metadata was updated (recording is true)
        expect(call.state.value.isRecording, isTrue);

        // Verify members were NOT updated (still have 2 members)
        expect(call.state.value.callMembers.length, equals(2));
        expect(
          call.state.value.callMembers.map((m) => m.userId).toList(),
          equals(initialMemberIds),
        );
      },
    );

    test(
      'call session started event - should update metadata but not members',
      () async {
        final coordinatorEvents = MutableSharedEmitterImpl<CoordinatorEvent>();

        final user1 = SampleCallData.testCallUser1;
        final user2 = SampleCallData.testCallUser2;

        final members = [
          SampleCallData.createCallMember(userId: user1.id),
          SampleCallData.createCallMember(userId: user2.id),
        ];

        final coordinatorClient = setupMockCoordinatorClient(
          events: coordinatorEvents,
          getOrCreateCallResult: SampleCallData.createCallReceivedOrCreatedData(
            members: {
              user1.id: members[0],
              user2.id: members[1],
            },
          ),
        );

        final initialState = createActiveCallState(
          status: CallStatus.connected(),
        );
        final stateManager = CallStateNotifier(initialState);

        final call = createTestCall(
          coordinatorClient: coordinatorClient,
          stateManager: stateManager,
        );
        await call.getOrCreate();

        // Verify we have 2 members initially
        expect(call.state.value.callMembers.length, equals(2));
        final initialMemberIds = call.state.value.callMembers
            .map((m) => m.userId)
            .toList();

        // Create metadata with empty members (this should NOT update members)
        final metadata = SampleCallData.createCallMetadata(
          broadcasting: true,
        );

        // Emit session started event
        coordinatorEvents.emit(
          CoordinatorCallSessionStartedEvent(
            callCid: call.callCid,
            sessionId: 'test-session-id',
            metadata: metadata,
            createdAt: DateTime.now(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        // Verify metadata was updated (broadcasting is true)
        expect(call.state.value.isBroadcasting, isTrue);

        // Verify members were NOT updated (still have 2 members)
        expect(call.state.value.callMembers.length, equals(2));
        expect(
          call.state.value.callMembers.map((m) => m.userId).toList(),
          equals(initialMemberIds),
        );
      },
    );
  });

  group('Closed Captions Events', () {
    test(
      'closed caption event - should add caption to queue',
      () async {
        final setup = await setupCallForEventTesting();

        // Verify queue is initially empty
        expect(setup.call.closedCaptions, emits(isEmpty));

        // Emit a closed caption event
        setup.events.emit(
          CoordinatorCallClosedCaptionEvent(
            callCid: setup.call.callCid,
            createdAt: DateTime.now(),
            startTime: DateTime.now(),
            endTime: DateTime.now().add(const Duration(seconds: 3)),
            speakerId: 'speaker1',
            text: 'Hello, this is a test caption',
            user: SampleCallData.testCallUser1,
            language: 'en',
            translated: false,
          ),
        );

        await Future<void>.delayed(Duration.zero);

        // Verify caption was added to queue
        final captions = await setup.call.closedCaptions.first;
        expect(captions.length, equals(1));
        expect(captions.first.speakerId, equals('speaker1'));
        expect(captions.first.text, equals('Hello, this is a test caption'));
      },
    );

    test(
      'closed caption event - should ignore duplicate captions',
      () async {
        final setup = await setupCallForEventTesting();

        final startTime = DateTime.now();
        final event = CoordinatorCallClosedCaptionEvent(
          callCid: setup.call.callCid,
          createdAt: DateTime.now(),
          startTime: startTime,
          endTime: startTime.add(const Duration(seconds: 3)),
          speakerId: 'speaker1',
          text: 'Duplicate caption',
          user: SampleCallData.testCallUser1,
          language: 'en',
          translated: false,
        );

        // Emit the first caption
        setup.events.emit(event);
        await Future<void>.delayed(Duration.zero);

        var captions = await setup.call.closedCaptions.first;
        expect(captions.length, equals(1));

        // Emit the same caption again (duplicate)
        setup.events.emit(event);
        await Future<void>.delayed(Duration.zero);

        // Verify caption was not added again
        captions = await setup.call.closedCaptions.first;
        expect(captions.length, equals(1));
      },
    );

    test(
      'closed caption event - should limit queue to visible captions count',
      () async {
        final setup = await setupCallForEventTesting();

        // Default visibleCaptions is 2, so add 3 captions
        for (var i = 0; i < 3; i++) {
          setup.events.emit(
            CoordinatorCallClosedCaptionEvent(
              callCid: setup.call.callCid,
              createdAt: DateTime.now(),
              startTime: DateTime.now().add(Duration(milliseconds: i)),
              endTime: DateTime.now().add(
                Duration(seconds: 3, milliseconds: i),
              ),
              speakerId: 'speaker$i',
              text: 'Caption $i',
              user: SampleCallData.testCallUser1,
              language: 'en',
              translated: false,
            ),
          );
          await Future<void>.delayed(Duration.zero);
        }

        // Verify only the last 2 captions are kept (default visible count is 2)
        final captions = await setup.call.closedCaptions.first;
        expect(captions.length, equals(2));
        expect(captions[0].text, equals('Caption 1'));
        expect(captions[1].text, equals('Caption 2'));
      },
    );

    test(
      'closed caption event - should remove caption after visibility duration',
      () async {
        final setup = await setupCallForEventTesting();

        // Emit a caption
        setup.events.emit(
          CoordinatorCallClosedCaptionEvent(
            callCid: setup.call.callCid,
            createdAt: DateTime.now(),
            startTime: DateTime.now(),
            endTime: DateTime.now().add(const Duration(seconds: 3)),
            speakerId: 'speaker1',
            text: 'Temporary caption',
            user: SampleCallData.testCallUser1,
            language: 'en',
            translated: false,
          ),
        );

        await Future<void>.delayed(Duration.zero);

        // Verify caption was added
        var captions = await setup.call.closedCaptions.first;
        expect(captions.length, equals(1));

        // Wait for the visibility duration (default is 2700ms)
        await Future<void>.delayed(const Duration(milliseconds: 2800));

        // Verify caption was removed
        captions = await setup.call.closedCaptions.first;
        expect(captions, isEmpty);
      },
    );
  });

  group('Ringing Call Events', () {
    test(
      'call rejected event - should update rejected member with callRejectedAt timestamp',
      () async {
        final coordinatorEvents = MutableSharedEmitterImpl<CoordinatorEvent>();

        final members = [
          SampleCallData.createCallMember(
            userId: SampleCallData.defaultUserInfo.id,
          ),
          SampleCallData.createCallMember(
            userId: SampleCallData.testCallUser1.id,
          ),
        ];

        final coordinatorClient = setupMockCoordinatorClient(
          events: coordinatorEvents,
          getOrCreateCallResult: SampleCallData.createCallReceivedOrCreatedData(
            members: {
              SampleCallData.defaultUserInfo.id: members.first,
              SampleCallData.testCallUser1.id: members.last,
            },
          ),
        );

        final initialState = createActiveCallState(
          currentByUser: SampleCallData.defaultCallUser,
        );
        final stateManager = CallStateNotifier(initialState);

        final call = createTestCall(
          coordinatorClient: coordinatorClient,
          stateManager: stateManager,
        );
        await call.getOrCreate(
          memberIds: members.map((m) => m.userId).toList(),
        );

        expect(
          stateManager.callState.callMembers
              .firstWhereOrNull(
                (m) => m.userId == SampleCallData.testCallUser1.id,
              )
              ?.callRejectedAt,
          isNull,
        );

        final rejectedTime = DateTime.now();
        coordinatorEvents.emit(
          CoordinatorCallRejectedEvent(
            callCid: call.callCid,
            user: SampleCallData.defaultCallUser,
            rejectedBy: SampleCallData.testCallUser1,
            createdAt: rejectedTime,
            metadata: SampleCallData.createCallMetadata(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        expect(
          stateManager.callState.callMembers
              .firstWhereOrNull(
                (m) => m.userId == SampleCallData.testCallUser1.id,
              )
              ?.callRejectedAt,
          equals(rejectedTime),
        );
      },
    );

    test(
      'call rejected event - should disconnect when user is creator and all other members rejected',
      () async {
        final coordinatorEvents = MutableSharedEmitterImpl<CoordinatorEvent>();

        final currentUser = SampleCallData.defaultCallUser;
        final user1 = SampleCallData.testCallUser1;
        final user2 = SampleCallData.testCallUser2;

        final members = [
          SampleCallData.createCallMember(userId: currentUser.id),
          SampleCallData.createCallMember(userId: user1.id),
          SampleCallData.createCallMember(userId: user2.id),
        ];

        final coordinatorClient = setupMockCoordinatorClient(
          events: coordinatorEvents,
          getOrCreateCallResult: SampleCallData.createCallReceivedOrCreatedData(
            members: {
              currentUser.id: members[0],
              user1.id: members[1],
              user2.id: members[2],
            },
            createdByUser: currentUser,
          ),
        );

        final initialState = createActiveCallState(
          currentByUser: currentUser,
        );
        final stateManager = CallStateNotifier(initialState);

        final call = createTestCall(
          coordinatorClient: coordinatorClient,
          stateManager: stateManager,
        );
        await call.getOrCreate(
          memberIds: members.map((m) => m.userId).toList(),
        );

        // All other members rejected
        final rejectedTime = DateTime.now();
        coordinatorEvents.emit(
          CoordinatorCallRejectedEvent(
            callCid: call.callCid,
            user: currentUser,
            rejectedBy: user1,
            createdAt: rejectedTime,
            metadata: SampleCallData.createCallMetadata(
              rejectedBy: {
                user1.id: rejectedTime,
                user2.id: rejectedTime,
              },
              createdByUser: currentUser,
            ),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        expect(stateManager.callState.status, isA<CallStatusDisconnected>());
        final status = stateManager.callState.status as CallStatusDisconnected;
        expect(status.reason, isA<DisconnectReasonRejected>());
        expect(stateManager.callState.sessionId, isEmpty);
        expect(stateManager.callState.callParticipants, isEmpty);
      },
    );

    test(
      'call rejected event - should not disconnect when user is creator and some members have not rejected',
      () async {
        final coordinatorEvents = MutableSharedEmitterImpl<CoordinatorEvent>();

        final currentUser = SampleCallData.defaultCallUser;
        final user1 = SampleCallData.testCallUser1;
        final user2 = SampleCallData.testCallUser2;

        final members = [
          SampleCallData.createCallMember(userId: currentUser.id),
          SampleCallData.createCallMember(userId: user1.id),
          SampleCallData.createCallMember(userId: user2.id),
        ];

        final coordinatorClient = setupMockCoordinatorClient(
          events: coordinatorEvents,
          getOrCreateCallResult: SampleCallData.createCallReceivedOrCreatedData(
            members: {
              currentUser.id: members[0],
              user1.id: members[1],
              user2.id: members[2],
            },
            createdByUser: currentUser, // Current user is creator
          ),
        );

        final initialState = createActiveCallState(
          currentByUser: currentUser,
        );
        final stateManager = CallStateNotifier(initialState);

        final call = createTestCall(
          coordinatorClient: coordinatorClient,
          stateManager: stateManager,
        );
        await call.getOrCreate(
          memberIds: members.map((m) => m.userId).toList(),
        );

        // Only one member rejected, another hasn't
        final rejectedTime = DateTime.now();
        coordinatorEvents.emit(
          CoordinatorCallRejectedEvent(
            callCid: call.callCid,
            user: currentUser,
            rejectedBy: user1,
            createdAt: rejectedTime,
            metadata: SampleCallData.createCallMetadata(
              rejectedBy: {
                user1.id: rejectedTime, // Only user1 rejected, user2 hasn't
              },
              createdByUser: currentUser,
            ),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        expect(stateManager.callState.status, isA<CallStatusActive>());
      },
    );

    test(
      'call rejected event - should disconnect when user is not creator and creator rejected',
      () async {
        final coordinatorEvents = MutableSharedEmitterImpl<CoordinatorEvent>();

        final currentUser = SampleCallData.defaultCallUser;
        const creator = CallUser(
          id: 'creator-user-id',
          name: 'Creator',
          roles: ['creator'],
          image: 'creator-image',
        );

        final members = [
          SampleCallData.createCallMember(userId: creator.id),
          SampleCallData.createCallMember(userId: currentUser.id),
        ];

        final coordinatorClient = setupMockCoordinatorClient(
          events: coordinatorEvents,
          getOrCreateCallResult: SampleCallData.createCallReceivedOrCreatedData(
            members: {
              creator.id: members[0],
              currentUser.id: members[1],
            },
            createdByUser: creator, // Creator is different from current user
          ),
        );

        final initialState = createActiveCallState(
          currentByUser: currentUser,
        );
        final stateManager = CallStateNotifier(initialState);

        final call = createTestCall(
          coordinatorClient: coordinatorClient,
          stateManager: stateManager,
        );
        await call.getOrCreate(
          memberIds: members.map((m) => m.userId).toList(),
        );

        // Current user is not the creator, and creator rejected
        final rejectedTime = DateTime.now();
        coordinatorEvents.emit(
          CoordinatorCallRejectedEvent(
            callCid: call.callCid,
            user: currentUser,
            rejectedBy: creator,
            createdAt: rejectedTime,
            metadata: SampleCallData.createCallMetadata(
              rejectedBy: {
                creator.id: rejectedTime,
              },
              createdByUser: creator,
            ),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        expect(stateManager.callState.status, isA<CallStatusDisconnected>());
        final status = stateManager.callState.status as CallStatusDisconnected;
        expect(status.reason, isA<DisconnectReasonRejected>());
        expect(stateManager.callState.sessionId, isEmpty);
        expect(stateManager.callState.callParticipants, isEmpty);
      },
    );

    test(
      'call rejected event - should preserve other members state when updating rejected member',
      () async {
        final coordinatorEvents = MutableSharedEmitterImpl<CoordinatorEvent>();

        final currentUser = SampleCallData.defaultCallUser;
        final user1 = SampleCallData.testCallUser1;
        final user2 = SampleCallData.testCallUser2;

        final members = [
          SampleCallData.createCallMember(userId: currentUser.id),
          SampleCallData.createCallMember(userId: user1.id),
          SampleCallData.createCallMember(userId: user2.id),
        ];

        final coordinatorClient = setupMockCoordinatorClient(
          events: coordinatorEvents,
          getOrCreateCallResult: SampleCallData.createCallReceivedOrCreatedData(
            members: {
              currentUser.id: members[0],
              user1.id: members[1],
              user2.id: members[2],
            },
            createdByUser: currentUser,
          ),
        );

        final initialState = createActiveCallState(
          currentByUser: currentUser,
        );
        final stateManager = CallStateNotifier(initialState);

        final call = createTestCall(
          coordinatorClient: coordinatorClient,
          stateManager: stateManager,
        );
        await call.getOrCreate(
          memberIds: members.map((m) => m.userId).toList(),
        );

        final initialMembersCount = stateManager.callState.callMembers.length;

        final rejectedTime = DateTime.now();
        coordinatorEvents.emit(
          CoordinatorCallRejectedEvent(
            callCid: call.callCid,
            user: currentUser,
            rejectedBy: user1,
            createdAt: rejectedTime,
            metadata: SampleCallData.createCallMetadata(
              rejectedBy: {user1.id: rejectedTime},
              createdByUser: currentUser,
            ),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        // Member count should remain the same
        expect(
          stateManager.callState.callMembers.length,
          equals(initialMembersCount),
        );

        // Only the rejected member should have callRejectedAt
        final rejectedMembers = stateManager.callState.callMembers
            .where((m) => m.callRejectedAt != null)
            .toList();
        expect(rejectedMembers.length, equals(1));
        expect(rejectedMembers.first.userId, equals(user1.id));
      },
    );

    test(
      'call accepted event - should update accepted member with callAcceptedAt timestamp and status',
      () async {
        final coordinatorEvents = MutableSharedEmitterImpl<CoordinatorEvent>();

        final currentUser = SampleCallData.defaultCallUser;
        final acceptingUser = SampleCallData.testCallUser1;

        final members = [
          SampleCallData.createCallMember(userId: currentUser.id),
          SampleCallData.createCallMember(userId: acceptingUser.id),
        ];

        final coordinatorClient = setupMockCoordinatorClient(
          events: coordinatorEvents,
          getOrCreateCallResult: SampleCallData.createCallReceivedOrCreatedData(
            members: {
              currentUser.id: members[0],
              acceptingUser.id: members[1],
            },
            createdByUser: currentUser,
          ),
        );

        final initialState = createActiveCallState(
          currentByUser: currentUser,
          status: CallStatus.outgoing(),
        );
        final stateManager = CallStateNotifier(initialState);

        final call = createTestCall(
          coordinatorClient: coordinatorClient,
          stateManager: stateManager,
        );
        await call.getOrCreate(
          memberIds: members.map((m) => m.userId).toList(),
        );

        expect(
          stateManager.callState.callMembers
              .firstWhereOrNull(
                (m) => m.userId == acceptingUser.id,
              )
              ?.callAcceptedAt,
          isNull,
        );

        final acceptedTime = DateTime.now();
        coordinatorEvents.emit(
          CoordinatorCallAcceptedEvent(
            callCid: call.callCid,
            user: currentUser,
            acceptedBy: acceptingUser,
            createdAt: acceptedTime,
            metadata: SampleCallData.createCallMetadata(),
          ),
        );

        await Future<void>.delayed(Duration.zero);

        // Verify the member's callAcceptedAt is updated
        expect(
          stateManager.callState.callMembers
              .firstWhereOrNull(
                (m) => m.userId == acceptingUser.id,
              )
              ?.callAcceptedAt,
          equals(acceptedTime),
        );

        // Verify status changed to outgoing with acceptedByCallee: true
        expect(stateManager.callState.status, isA<CallStatusOutgoing>());
        final status = stateManager.callState.status as CallStatusOutgoing;
        expect(status.acceptedByCallee, isTrue);
      },
    );
  });
}
