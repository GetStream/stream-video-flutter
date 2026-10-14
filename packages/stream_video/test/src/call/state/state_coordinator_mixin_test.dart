import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/data.dart';

const _member = CallMember(userId: 'member', roles: ['user'], custom: {});

CallMetadata _metadata({
  StreamCallCid? cid,
  DateTime? endedAt,
  Map<String, CallMember> members = const {},
}) {
  return CallMetadata(
    cid: cid ?? SampleCallData.defaultCid,
    details: CallDetails(
      createdBy: const CallUser(
        id: 'host',
        name: 'host',
        roles: ['host'],
        image: '',
      ),
      team: '',
      ownCapabilities: const [],
      blockedUserIds: const [],
      broadcasting: false,
      recording: false,
      backstage: false,
      transcribing: false,
      captioning: false,
      egress: const CallEgress(),
      custom: const {},
      rtmpIngress: '',
      endedAt: endedAt,
    ),
    settings: const CallSettings(),
    session: const CallSessionData(),
    users: const {},
    members: members,
  );
}

StreamCallEndedEvent _callEnded({
  StreamCallCid? cid,
  DateTime? endedAt,
  DateTime? createdAt,
}) {
  final callCid = cid ?? SampleCallData.defaultCid;
  return StreamCallEndedEvent(
    callCid,
    endedBy: null,
    createdAt: createdAt ?? DateTime.utc(2026, 10, 14, 12),
    metadata: _metadata(cid: callCid, endedAt: endedAt),
    type: 'call.ended',
  );
}

CallParticipantState _participant(String userId) {
  return CallParticipantState(
    userId: userId,
    roles: const [],
    name: userId,
    custom: const {},
    sessionId: '$userId-session',
    trackIdPrefix: '$userId-prefix',
  );
}

CallStateNotifier _notifier(CallStatus status) {
  return CallStateNotifier(
    CallState(
      currentUserId: 'viewer',
      callCid: SampleCallData.defaultCid,
      preferences: DefaultCallPreferences(),
    ).copyWith(
      status: status,
      callParticipants: [_participant('host'), _participant('viewer')],
    ),
  )..callMetadataChanged(_metadata(members: const {'member': _member}));
}

void main() {
  group('coordinatorCallEnded', () {
    final endedAt = DateTime.utc(2026, 10, 14, 11, 59);

    test('a joined call disconnects and takes endedAt from the event', () {
      final notifier = _notifier(CallStatus.joined());

      notifier.coordinatorCallEnded(_callEnded(endedAt: endedAt));

      final state = notifier.state;
      expect(state.status, CallStatus.disconnected(DisconnectReason.ended()));
      expect(state.callParticipants, isEmpty);
      expect(state.endedAt, endedAt);
    });

    test('falls back to the event time when the call has no endedAt', () {
      final notifier = _notifier(CallStatus.joined());
      final createdAt = DateTime.utc(2026, 10, 14, 12, 1);

      notifier.coordinatorCallEnded(_callEnded(createdAt: createdAt));

      expect(notifier.state.endedAt, createdAt);
    });

    test('keeps the members it already has', () {
      final notifier = _notifier(CallStatus.joined());

      notifier.coordinatorCallEnded(_callEnded(endedAt: endedAt));

      expect(
        notifier.state.callMembers.map((m) => m.userId),
        contains('member'),
      );
    });

    test('a watched call that is not joined only takes endedAt', () {
      final notifier = _notifier(CallStatus.idle());

      notifier.coordinatorCallEnded(_callEnded(endedAt: endedAt));

      final state = notifier.state;
      expect(state.status, CallStatus.idle());
      expect(state.callParticipants, hasLength(2));
      expect(state.endedAt, endedAt);
    });

    test('ignores an event for another call', () {
      final notifier = _notifier(CallStatus.joined());
      final before = notifier.state;

      notifier.coordinatorCallEnded(
        _callEnded(
          cid: StreamCallCid.from(type: StreamCallType.defaultType(), id: 'x'),
          endedAt: endedAt,
        ),
      );

      expect(notifier.state, same(before));
    });
  });
}
