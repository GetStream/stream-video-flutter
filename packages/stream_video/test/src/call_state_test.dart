import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/stream_video.dart';

void main() {
  CallMetadata metadata({
    List<String> blockedUserIds = const ['blocked'],
    Map<String, Object> custom = const {'topic': 'news'},
    List<CallPermission> ownCapabilities = const [CallPermission.sendAudio],
  }) {
    return CallMetadata(
      cid: StreamCallCid(cid: 'default:test'),
      details: CallDetails(
        createdBy: const CallUser(
          id: 'creator',
          name: 'creator',
          roles: ['host'],
          image: '',
        ),
        team: '',
        // Copied, as a parsed response holds new lists and maps every time.
        ownCapabilities: [...ownCapabilities],
        blockedUserIds: [...blockedUserIds],
        broadcasting: false,
        recording: false,
        backstage: false,
        transcribing: false,
        captioning: false,
        custom: {...custom},
        egress: const CallEgress(),
        rtmpIngress: '',
      ),
      settings: const CallSettings(),
      session: const CallSessionData(),
      users: const {},
      members: const {
        'member': CallMember(userId: 'member', roles: ['user'], custom: {}),
      },
    );
  }

  final initial =
      CallState(
        currentUserId: 'user',
        callCid: StreamCallCid(cid: 'default:test'),
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
