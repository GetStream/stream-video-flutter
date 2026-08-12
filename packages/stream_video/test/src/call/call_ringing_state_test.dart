import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/call_reject_reason.dart';
import 'package:stream_video/src/call/call_ringing_state.dart';
import 'package:stream_video/src/call/call_type.dart';
import 'package:stream_video/src/models/models.dart';

const _currentUserId = 'current-user';
const _creatorId = 'creator';

CallMetadata _metadata({
  DateTime? endedAt,
  DateTime? sessionEndedAt,
  Map<String, DateTime> acceptedBy = const {},
  Map<String, DateTime> rejectedBy = const {},
  Map<String, DateTime> missedBy = const {},
  List<String> memberIds = const [_creatorId, _currentUserId],
  String creatorId = _creatorId,
}) {
  return CallMetadata(
    cid: StreamCallCid.from(
      type: StreamCallType.defaultType(),
      id: 'test-cid',
    ),
    session: CallSessionData(
      acceptedBy: acceptedBy,
      rejectedBy: rejectedBy,
      missedBy: missedBy,
      endedAt: sessionEndedAt,
    ),
    users: const {},
    members: {
      for (final userId in memberIds)
        userId: CallMember(
          userId: userId,
          roles: const ['user'],
          custom: const {},
        ),
    },
    details: CallDetails(
      createdBy: CallUser(
        id: creatorId,
        name: creatorId,
        roles: const ['user'],
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
  );
}

Map<String, DateTime> _at(List<String> userIds) => {
  for (final userId in userIds) userId: DateTime.utc(2026),
};

void main() {
  group('ringingStateFor', () {
    test('is ringing while nothing resolved the flow', () {
      final state = _metadata(
        memberIds: const [_creatorId, _currentUserId, 'other-1', 'other-2'],
      ).ringingStateFor(_currentUserId);

      expect(state, CallRingingState.ringing);
    });

    test('is ended when the call ended', () {
      final state = _metadata(
        endedAt: DateTime.utc(2026),
      ).ringingStateFor(_currentUserId);

      expect(state, CallRingingState.ended);
    });

    test('is ended when the session ended', () {
      final state = _metadata(
        sessionEndedAt: DateTime.utc(2026),
      ).ringingStateFor(_currentUserId);

      expect(state, CallRingingState.ended);
    });

    test('is accepted when accepted by the current user elsewhere', () {
      final state = _metadata(
        acceptedBy: _at([_currentUserId]),
      ).ringingStateFor(_currentUserId);

      expect(state, CallRingingState.accepted);
    });

    test('is rejected when rejected by the current user elsewhere', () {
      final state = _metadata(
        rejectedBy: _at([_currentUserId]),
      ).ringingStateFor(_currentUserId);

      expect(state, CallRingingState.rejected);
    });

    test('is rejected when missed by the current user', () {
      final state = _metadata(
        missedBy: _at([_currentUserId]),
      ).ringingStateFor(_currentUserId);

      expect(state, CallRingingState.rejected);
    });

    test('is rejected when the caller cancelled the ring', () {
      final state = _metadata(
        rejectedBy: _at([_creatorId]),
        memberIds: const [_creatorId, _currentUserId, 'other-1'],
      ).ringingStateFor(_currentUserId);

      expect(state, CallRingingState.rejected);
    });

    test('keeps ringing when the caller cancelled but someone accepted', () {
      final state = _metadata(
        rejectedBy: _at([_creatorId]),
        acceptedBy: _at(['other-1']),
        memberIds: const [_creatorId, _currentUserId, 'other-1'],
      ).ringingStateFor(_currentUserId);

      expect(state, CallRingingState.ringing);
    });

    test('keeps ringing when only one other invitee rejected', () {
      final state = _metadata(
        rejectedBy: _at(['other-1']),
        memberIds: const [_creatorId, _currentUserId, 'other-1', 'other-2'],
      ).ringingStateFor(_currentUserId);

      expect(state, CallRingingState.ringing);
    });

    test('keeps ringing when every invitee but the caller rejected', () {
      final state = _metadata(
        rejectedBy: _at(['other-1', 'other-2']),
        memberIds: const [_creatorId, _currentUserId, 'other-1', 'other-2'],
      ).ringingStateFor(_currentUserId);

      expect(state, CallRingingState.ringing);
    });

    test('is rejected when everyone else, caller included, rejected', () {
      final state = _metadata(
        rejectedBy: _at([_creatorId, 'other-1', 'other-2']),
        memberIds: const [_creatorId, _currentUserId, 'other-1', 'other-2'],
      ).ringingStateFor(_currentUserId);

      expect(state, CallRingingState.rejected);
    });

    test('is rejected when everyone else rejected without the caller', () {
      // The caller isn't part of the member list here, so the everyone-rejected
      // fallback is the only rule that can resolve the flow.
      final state = _metadata(
        rejectedBy: _at(['other-1', 'other-2']),
        memberIds: const [_currentUserId, 'other-1', 'other-2'],
      ).ringingStateFor(_currentUserId);

      expect(state, CallRingingState.rejected);
    });

    test('keeps ringing when the current user is the only member', () {
      final state = _metadata(
        memberIds: const [_currentUserId],
      ).ringingStateFor(_currentUserId);

      expect(state, CallRingingState.ringing);
    });
  });

  group('CallRingingState', () {
    test('isRinging is only set for the ringing state', () {
      expect(CallRingingState.ringing.isRinging, isTrue);
      expect(CallRingingState.ended.isRinging, isFalse);
      expect(CallRingingState.accepted.isRinging, isFalse);
      expect(CallRingingState.rejected.isRinging, isFalse);
    });

    test('toReason maps every state to a reject reason', () {
      expect(CallRingingState.ringing.toReason(), isNull);
      expect(
        CallRingingState.ended.toReason(),
        CallRejectReason.callEnded(),
      );
      expect(
        CallRingingState.accepted.toReason(),
        CallRejectReason.userRespondedElsewhere(),
      );
      expect(
        CallRingingState.rejected.toReason(),
        CallRejectReason.userRespondedElsewhere(),
      );
    });
  });
}
