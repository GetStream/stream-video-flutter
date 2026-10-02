import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/src/models/call_received_data.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/data.dart';

void main() {
  const member = CallMember(userId: 'member', roles: ['user'], custom: {});

  CallMetadata metadata({
    List<CallPermission> ownCapabilities = const [CallPermission.sendAudio],
  }) {
    return SampleCallData.createCallMetadata(
      members: const {'member': member},
      blockedUserIds: const ['blocked'],
      custom: const {'topic': 'news'},
      ownCapabilities: ownCapabilities,
    );
  }

  late CallStateNotifier notifier;

  setUp(() {
    notifier =
        CallStateNotifier(
          CallState(
            currentUserId: 'user',
            callCid: SampleCallData.defaultCid,
            preferences: DefaultCallPreferences(),
          ),
        )..callMetadataChanged(
          metadata(),
          capabilitiesByRole: {
            'host': ['send-audio'],
          },
        );
  });

  test('received call data keeps the collections it leaves unchanged', () {
    final before = notifier.state;

    notifier.updateFromCallReceivedData(
      CallReceivedData(
        callCid: SampleCallData.defaultCid,
        metadata: metadata(),
      ),
    );

    expect(notifier.state.blockedUserIds, same(before.blockedUserIds));
    expect(notifier.state.custom, same(before.custom));
    expect(notifier.state.ownCapabilities, same(before.ownCapabilities));
    expect(notifier.state.callMembers, same(before.callMembers));
  });

  test(
    'ringing call data keeps unchanged capabilities and takes changed ones',
    () {
      final before = notifier.state;
      CallRingingData ringing(CallMetadata metadata) => CallRingingData(
        callCid: SampleCallData.defaultCid,
        ringing: true,
        metadata: metadata,
      );

      notifier.lifecycleCallRinging(ringing(metadata()));
      expect(notifier.state.ownCapabilities, same(before.ownCapabilities));

      notifier.lifecycleCallRinging(
        ringing(metadata(ownCapabilities: const [])),
      );
      expect(notifier.state.ownCapabilities, isEmpty);
    },
  );

  test(
    'a member update keeps the members and role capabilities it leaves unchanged',
    () {
      final before = notifier.state;

      notifier.coordinatorCallMemberUpdated(
        const [member],
        capabilitiesByRole: {
          'host': ['send-audio'],
        },
      );

      expect(notifier.state.callMembers, same(before.callMembers));
      expect(
        notifier.state.capabilitiesByRole,
        same(before.capabilitiesByRole),
      );
    },
  );

  test('a member update takes changed roles', () {
    notifier.coordinatorCallMemberUpdated(
      [
        const CallMember(userId: 'member', roles: ['host'], custom: {}),
      ],
    );

    expect(notifier.state.callMembers.single.roles, ['host']);
  });
}
