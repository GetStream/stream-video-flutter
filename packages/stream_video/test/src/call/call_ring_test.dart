// ignore_for_file: avoid_redundant_argument_values

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_video/open_api/video/coordinator/api.dart' as open;
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/src/errors/video_error.dart';
import 'package:stream_video/src/shared_emitter.dart';
import 'package:stream_video/stream_video.dart';

import '../../test_helpers.dart';
import 'fixtures/call_test_helpers.dart';
import 'fixtures/data.dart';

void main() {
  setUpAll(() {
    registerMockFallbackValues();
    registerFallbackValue(<String>[]);
    registerFallbackValue(<open.MemberRequest>[]);
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  /// Sets up an ongoing (connected) call started by the current user, with the
  /// current user already a member of the call.
  Future<
    ({
      Call call,
      MutableSharedEmitterImpl<CoordinatorEvent> events,
      MockCoordinatorClient coordinatorClient,
    })
  >
  setupOngoingCall({
    Map<String, CallMember>? members,
  }) async {
    final coordinatorEvents = MutableSharedEmitterImpl<CoordinatorEvent>();

    final currentUser = SampleCallData.defaultCallUser;
    final effectiveMembers =
        members ??
        {
          currentUser.id: SampleCallData.createCallMember(
            userId: currentUser.id,
          ),
        };

    final coordinatorClient = setupMockCoordinatorClient(
      events: coordinatorEvents,
      getOrCreateCallResult: SampleCallData.createCallReceivedOrCreatedData(
        members: effectiveMembers,
        createdByUser: currentUser,
      ),
    );

    final stateManager = CallStateNotifier(
      createActiveCallState(
        currentByUser: currentUser,
        status: CallStatus.connected(),
      ),
    );

    final call = createTestCall(
      coordinatorClient: coordinatorClient,
      stateManager: stateManager,
    );
    await call.getOrCreate();

    return (
      call: call,
      events: coordinatorEvents,
      coordinatorClient: coordinatorClient,
    );
  }

  void stubRingCall(
    MockCoordinatorClient client, {
    Result<List<String>>? result,
  }) {
    when(
      () => client.ringCall(
        callCid: any(named: 'callCid'),
        membersIds: any(named: 'membersIds'),
        video: any(named: 'video'),
      ),
    ).thenAnswer(
      (_) async => result ?? const Result.success(['user1']),
    );
  }

  void stubAddMembers(
    MockCoordinatorClient client, {
    Result<None>? result,
  }) {
    when(
      () => client.addMembers(
        callCid: any(named: 'callCid'),
        members: any(named: 'members'),
      ),
    ).thenAnswer(
      (_) async => result ?? const Result.success(none),
    );
  }

  group('Ongoing call ringing', () {
    test('rings the specified members of an ongoing call', () async {
      final setup = await setupOngoingCall();
      stubRingCall(
        setup.coordinatorClient,
        result: const Result.success(['user1']),
      );

      final result = await setup.call.ring(userIds: ['user1']);

      expect(result.isSuccess, isTrue);
      expect((result as Success<List<String>>).data, equals(['user1']));

      verify(
        () => setup.coordinatorClient.ringCall(
          callCid: setup.call.callCid,
          membersIds: ['user1'],
          video: false,
        ),
      ).called(1);
    });

    test(
      'rings all members not in the call when no ids are provided',
      () async {
        final setup = await setupOngoingCall();
        stubRingCall(
          setup.coordinatorClient,
          result: const Result.success(['user1', 'user2']),
        );

        final result = await setup.call.ring();

        expect(result.isSuccess, isTrue);
        verify(
          () => setup.coordinatorClient.ringCall(
            callCid: setup.call.callCid,
            membersIds: const [],
            video: false,
          ),
        ).called(1);
      },
    );

    test('forwards the video flag when ringing', () async {
      final setup = await setupOngoingCall();
      stubRingCall(setup.coordinatorClient);

      await setup.call.ring(userIds: ['user1'], video: true);

      verify(
        () => setup.coordinatorClient.ringCall(
          callCid: setup.call.callCid,
          membersIds: ['user1'],
          video: true,
        ),
      ).called(1);
    });

    test(
      'propagates failure from the coordinator when ringing fails',
      () async {
        final setup = await setupOngoingCall();
        stubRingCall(
          setup.coordinatorClient,
          result: const Result.failure(VideoError(message: 'ring failed')),
        );

        final result = await setup.call.ring(userIds: ['user1']);

        expect(result.isFailure, isTrue);
        expect((result as Failure).error.message, equals('ring failed'));
      },
    );

    test('adds a member to the ongoing call via the coordinator', () async {
      final setup = await setupOngoingCall();
      stubAddMembers(setup.coordinatorClient);

      final result = await setup.call.addMembers([
        const UserInfo(id: 'user2', role: 'user'),
      ]);

      expect(result.isSuccess, isTrue);

      final captured = verify(
        () => setup.coordinatorClient.addMembers(
          callCid: setup.call.callCid,
          members: captureAny(named: 'members'),
        ),
      ).captured;

      final members = (captured.single as Iterable<open.MemberRequest>)
          .toList();
      expect(members, hasLength(1));
      expect(members.first.userId, equals('user2'));
      expect(members.first.role, equals('user'));
    });

    test(
      'add member then ring: state updates after member added event, '
      'then the new member can be rung',
      () async {
        final currentUser = SampleCallData.defaultCallUser;
        final newUser = SampleCallData.testCallUser2;

        final setup = await setupOngoingCall();
        stubAddMembers(setup.coordinatorClient);
        stubRingCall(
          setup.coordinatorClient,
          result: Result.success([newUser.id]),
        );

        // Initially only the current user is a member.
        expect(
          setup.call.state.value.callMembers.map((m) => m.userId),
          equals([currentUser.id]),
        );

        // Add the new member.
        final addResult = await setup.call.addMembers([
          UserInfo(id: newUser.id),
        ]);
        expect(addResult.isSuccess, isTrue);

        // The coordinator emits a member added event which should update state.
        final newMember = SampleCallData.createCallMember(userId: newUser.id);
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

        // The newly added member is now part of the call members and is not yet
        // a participant (not in the call).
        final addedMember = setup.call.state.value.callMembers.firstWhereOrNull(
          (m) => m.userId == newUser.id,
        );
        expect(addedMember, isNotNull);
        expect(
          setup.call.state.value.callParticipants.any(
            (p) => p.userId == newUser.id,
          ),
          isFalse,
        );

        // Now ring the newly added member.
        final ringResult = await setup.call.ring(userIds: [newUser.id]);
        expect(ringResult.isSuccess, isTrue);

        verify(
          () => setup.coordinatorClient.ringCall(
            callCid: setup.call.callCid,
            membersIds: [newUser.id],
            video: false,
          ),
        ).called(1);
      },
    );
  });
}
