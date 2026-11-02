import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';

import 'call/fixtures/data.dart';

void main() {
  const member = CallMember(userId: 'member', roles: ['user'], custom: {});

  CallMetadata metadata({
    Map<String, CallMember> members = const {'member': member},
    List<String> blockedUserIds = const ['blocked'],
    Map<String, Object> custom = const {'topic': 'news'},
    List<CallPermission> ownCapabilities = const [CallPermission.sendAudio],
  }) {
    return SampleCallData.createCallMetadata(
      members: members,
      blockedUserIds: blockedUserIds,
      custom: custom,
      ownCapabilities: ownCapabilities,
    );
  }

  final initial =
      CallState(
        currentUserId: 'user',
        callCid: SampleCallData.defaultCid,
        preferences: DefaultCallPreferences(),
      ).copyFromMetadata(
        metadata(),
        capabilitiesByRole: {
          'host': ['send-audio'],
        },
      );

  test(
    'CallState.copyFromMetadata keeps the collections that an update leaves unchanged',
    () {
      final updated = initial.copyFromMetadata(
        metadata(),
        capabilitiesByRole: {
          'host': ['send-audio'],
        },
      );

      expect(updated.blockedUserIds, same(initial.blockedUserIds));
      expect(updated.custom, same(initial.custom));
      expect(updated.ownCapabilities, same(initial.ownCapabilities));
      expect(updated.capabilitiesByRole, same(initial.capabilitiesByRole));
      expect(updated.callMembers, same(initial.callMembers));
    },
  );

  test(
    'CallState.copyFromMetadata takes the collections that an update changes',
    () {
      final updated = initial.copyFromMetadata(
        metadata(
          blockedUserIds: const ['blocked', 'spammer'],
          custom: const {'topic': 'sports'},
          ownCapabilities: const [
            CallPermission.sendAudio,
            CallPermission.sendVideo,
          ],
        ),
        capabilitiesByRole: {
          'host': ['send-audio', 'send-video'],
        },
      );

      expect(updated.blockedUserIds, ['blocked', 'spammer']);
      expect(updated.custom, {'topic': 'sports'});
      expect(updated.ownCapabilities, [
        CallPermission.sendAudio,
        CallPermission.sendVideo,
      ]);
      expect(updated.capabilitiesByRole, {
        'host': ['send-audio', 'send-video'],
      });
    },
  );

  const host = CallMember(userId: 'member', roles: ['host'], custom: {});

  test('CallState.copyFromMetadata takes a changed member list', () {
    final updated = initial.copyFromMetadata(
      metadata(members: const {'member': host}),
    );

    expect(updated.callMembers.single.roles, ['host']);
  });

  test(
    'CallState.copyFromMetadata leaves the members alone without updateMembers',
    () {
      final updated = initial.copyFromMetadata(
        metadata(members: const {'member': host}),
        updateMembers: false,
      );

      expect(updated.callMembers, same(initial.callMembers));
    },
  );

  test(
    'CallState.copyFromMetadata keeps the role capabilities without new ones',
    () {
      final updated = initial.copyFromMetadata(metadata());

      expect(updated.capabilitiesByRole, same(initial.capabilitiesByRole));
    },
  );

  test(
    'CallState.copyFromMetadata takes empty blocked users and custom data',
    () {
      final updated = initial.copyFromMetadata(
        metadata(blockedUserIds: const [], custom: const {}),
      );

      expect(updated.blockedUserIds, isEmpty);
      expect(updated.custom, isEmpty);
    },
  );

  test(
    'CallState.ringingMembers stays the same across an unchanged metadata update',
    () {
      final updated = initial.copyFromMetadata(metadata());

      expect(updated.ringingMembers, isNotEmpty);
      expect(updated.ringingMembers, same(initial.ringingMembers));
    },
  );

  test(
    'CallState.copyFromMetadata takes the session counts before the call is joined',
    () {
      final updated = initial.copyFromMetadata(
        SampleCallData.createCallMetadata(
          participantsCountByRole: const {'host': 1, 'user': 12000},
          anonymousParticipantCount: 300,
        ),
      );

      expect(updated.participantCount, 12001);
      expect(updated.anonymousParticipantCount, 300);
    },
  );

  test(
    'CallState.copyFromMetadata keeps the counts the SFU reports once joined',
    () {
      final joined = initial.copyWith(
        status: CallStatus.connected(),
        participantCount: 12500,
        anonymousParticipantCount: 310,
      );

      final updated = joined.copyFromMetadata(
        SampleCallData.createCallMetadata(
          participantsCountByRole: const {'host': 1, 'user': 12000},
          anonymousParticipantCount: 300,
        ),
      );

      expect(updated.participantCount, 12500);
      expect(updated.anonymousParticipantCount, 310);
    },
  );

  test(
    'CallState.copyFromMetadata counts the session participants when the role counts are lower',
    () {
      final updated = initial.copyFromMetadata(
        SampleCallData.createCallMetadata(
          participants: const {
            'a-session': CallParticipant(
              userSessionId: 'a-session',
              userId: 'a',
              role: 'user',
            ),
            'b-session': CallParticipant(
              userSessionId: 'b-session',
              userId: 'b',
              role: 'user',
            ),
          },
          participantsCountByRole: const {'user': 1},
        ),
      );

      expect(updated.participantCount, 2);
    },
  );

  test(
    'CallState.copyFromMetadata keeps the counts the SFU reports while reconnecting',
    () {
      final reconnecting = initial.copyWith(
        status: CallStatus.reconnecting(1),
        participantCount: 12500,
        anonymousParticipantCount: 310,
      );

      final updated = reconnecting.copyFromMetadata(
        SampleCallData.createCallMetadata(
          participantsCountByRole: const {'host': 1, 'user': 12000},
          anonymousParticipantCount: 300,
        ),
      );

      expect(updated.participantCount, 12500);
      expect(updated.anonymousParticipantCount, 310);
    },
  );
}
