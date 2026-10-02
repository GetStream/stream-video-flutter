import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';

import 'call/fixtures/data.dart';

void main() {
  const member = CallMember(userId: 'member', roles: ['user'], custom: {});

  CallMetadata metadata({
    List<String> blockedUserIds = const ['blocked'],
    Map<String, Object> custom = const {'topic': 'news'},
    List<CallPermission> ownCapabilities = const [CallPermission.sendAudio],
  }) {
    return SampleCallData.createCallMetadata(
      members: const {'member': member},
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
}
