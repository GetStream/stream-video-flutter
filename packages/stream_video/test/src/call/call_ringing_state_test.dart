import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/open_api/video/coordinator/api.dart' as open;
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

    test('is rejected when the caller cancelled after someone accepted', () {
      final state = _metadata(
        rejectedBy: _at([_creatorId]),
        acceptedBy: _at(['other-1']),
        memberIds: const [_creatorId, _currentUserId, 'other-1'],
      ).ringingStateFor(_currentUserId);

      expect(state, CallRingingState.rejected);
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

  group('ringingStateFor the caller', () {
    const members = [_creatorId, 'other-1', 'other-2'];

    CallRingingState resolve({
      DateTime? endedAt,
      Map<String, DateTime> acceptedBy = const {},
      Map<String, DateTime> rejectedBy = const {},
      Map<String, DateTime> missedBy = const {},
    }) {
      return _metadata(
        endedAt: endedAt,
        acceptedBy: acceptedBy,
        rejectedBy: rejectedBy,
        missedBy: missedBy,
        memberIds: members,
      ).ringingStateFor(_creatorId);
    }

    test('is ringing while nobody answered', () {
      expect(resolve(), CallRingingState.ringing);
    });

    test('is accepted when a callee accepted', () {
      expect(
        resolve(acceptedBy: _at(['other-1'])),
        CallRingingState.accepted,
      );
    });

    test('is not accepted by its own acceptance', () {
      expect(
        resolve(acceptedBy: _at([_creatorId])),
        CallRingingState.ringing,
      );
    });

    test('is accepted when one callee accepted and the rest rejected', () {
      expect(
        resolve(
          acceptedBy: _at(['other-1']),
          rejectedBy: _at(['other-2']),
        ),
        CallRingingState.accepted,
      );
    });

    test('keeps ringing when only one callee rejected', () {
      expect(
        resolve(rejectedBy: _at(['other-1'])),
        CallRingingState.ringing,
      );
    });

    test('is rejected when every callee rejected', () {
      expect(
        resolve(rejectedBy: _at(['other-1', 'other-2'])),
        CallRingingState.rejected,
      );
    });

    test('keeps ringing when every callee missed the ring', () {
      // Nobody answering is left to the caller's own ring timeout.
      expect(
        resolve(missedBy: _at(['other-1', 'other-2'])),
        CallRingingState.ringing,
      );
    });

    test('is ended before anything else when the call ended', () {
      expect(
        resolve(
          endedAt: DateTime.utc(2026),
          acceptedBy: _at(['other-1']),
        ),
        CallRingingState.ended,
      );
    });
  });

  group('RingingSnapshot', () {
    test('copies its collections from the source', () {
      final acceptedBy = <String, DateTime>{};
      final memberIds = <String>{_creatorId};
      final snapshot = RingingSnapshot(
        creatorId: _creatorId,
        memberIds: memberIds,
        acceptedBy: acceptedBy,
      );

      acceptedBy['other-1'] = DateTime.utc(2026);
      memberIds.add('other-1');

      expect(snapshot.acceptedBy, isEmpty);
      expect(snapshot.memberIds, {_creatorId});
    });

    test('cannot be changed through its collections', () {
      final snapshot = _metadata(
        acceptedBy: _at(['other-1']),
      ).ringingSnapshot;

      expect(
        () => snapshot.acceptedBy['other-2'] = DateTime.utc(2026),
        throwsUnsupportedError,
      );
      expect(snapshot.rejectedBy.clear, throwsUnsupportedError);
      expect(snapshot.missedBy.clear, throwsUnsupportedError);
      expect(() => snapshot.memberIds.add('other-2'), throwsUnsupportedError);
    });
  });

  group('toRingingSnapshot', () {
    open.GetCallRingStateResponse ringState({
      DateTime? callEndedAt,
      DateTime? sessionEndedAt,
    }) {
      return open.GetCallRingStateResponse(
        acceptedBy: _at(['other-1']),
        callCid: 'default:test-cid',
        callEndedAt: callEndedAt,
        createdByUserId: _creatorId,
        duration: '1ms',
        missedBy: _at(['other-2']),
        rejectedBy: _at(['other-3']),
        sessionEndedAt: sessionEndedAt,
        sessionId: 'session-id',
      );
    }

    test('carries the ring maps, the creator and the given members', () {
      final snapshot = ringState().toRingingSnapshot(
        memberIds: const [_creatorId, 'other-1'],
      );

      expect(snapshot.creatorId, _creatorId);
      expect(snapshot.memberIds, {_creatorId, 'other-1'});
      expect(snapshot.acceptedBy.keys, ['other-1']);
      expect(snapshot.missedBy.keys, ['other-2']);
      expect(snapshot.rejectedBy.keys, ['other-3']);
      expect(snapshot.ended, isFalse);
    });

    test('is ended when the call or the session ended', () {
      expect(
        ringState(
          callEndedAt: DateTime.utc(2026),
        ).toRingingSnapshot(memberIds: const []).ended,
        isTrue,
      );
      expect(
        ringState(
          sessionEndedAt: DateTime.utc(2026),
        ).toRingingSnapshot(memberIds: const []).ended,
        isTrue,
      );
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
