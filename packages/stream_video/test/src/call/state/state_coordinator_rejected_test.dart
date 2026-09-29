import 'package:flutter_test/flutter_test.dart';
import 'package:stream_video/src/call/state/call_state_notifier.dart';
import 'package:stream_video/stream_video.dart';

import '../fixtures/data.dart';

const _currentUserId = 'current-user';
const _creator = CallUser(
  id: 'creator',
  name: 'creator',
  roles: ['user'],
  image: '',
);

CallMemberState _member(String userId) {
  return CallMemberState(
    userId: userId,
    roles: const ['user'],
    name: userId,
    custom: const {},
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

/// A ringing call as seen by [currentUserId].
CallStateNotifier _ringing({
  required String currentUserId,
  required List<String> memberIds,
  List<CallParticipantState> participants = const [],
  CallStatus? status,
}) {
  final isCaller = currentUserId == _creator.id;
  return CallStateNotifier(
    CallState(
      preferences: DefaultCallPreferences(),
      currentUserId: currentUserId,
      callCid: SampleCallData.defaultCid,
    ).copyWith(
      status:
          status ?? (isCaller ? CallStatus.outgoing() : CallStatus.incoming()),
      isRingingFlow: true,
      createdByUser: _creator,
      callMembers: memberIds.map(_member).toList(),
      callParticipants: participants,
    ),
  );
}

StreamCallRejectedEvent _rejected({
  required String byUserId,
  Map<String, DateTime> acceptedBy = const {},
  required Map<String, DateTime> rejectedBy,
  Map<String, DateTime> missedBy = const {},
}) {
  final metadata = SampleCallData.createCallMetadata(
    createdByUser: _creator,
  );
  return StreamCallRejectedEvent(
    SampleCallData.defaultCid,
    rejectedBy: CallUser(
      id: byUserId,
      name: byUserId,
      roles: const [],
      image: '',
    ),
    createdAt: DateTime.utc(2026),
    metadata: CallMetadata(
      cid: metadata.cid,
      details: metadata.details,
      settings: metadata.settings,
      users: metadata.users,
      members: metadata.members,
      session: CallSessionData(
        acceptedBy: acceptedBy,
        rejectedBy: rejectedBy,
        missedBy: missedBy,
      ),
    ),
  );
}

Map<String, DateTime> _at(List<String> userIds) => {
  for (final userId in userIds) userId: DateTime.utc(2026),
};

DisconnectReason? _disconnectReason(CallStateNotifier notifier) {
  final status = notifier.callState.status;
  return status is CallStatusDisconnected ? status.reason : null;
}

void main() {
  group('coordinatorCallRejected, as the caller', () {
    test('disconnects once every callee rejected', () {
      final notifier =
          _ringing(
            currentUserId: _creator.id,
            memberIds: [_creator.id, 'callee-1', 'callee-2'],
          )..coordinatorCallRejected(
            _rejected(
              byUserId: 'callee-2',
              rejectedBy: _at(['callee-1', 'callee-2']),
            ),
          );

      expect(
        _disconnectReason(notifier),
        DisconnectReason.rejected(
          byUserId: 'callee-2',
          reason: CallRejectReason.allOtherParticipantsRejected(),
        ),
      );
    });

    test('keeps ringing while a callee has not answered', () {
      final notifier =
          _ringing(
            currentUserId: _creator.id,
            memberIds: [_creator.id, 'callee-1', 'callee-2'],
          )..coordinatorCallRejected(
            _rejected(byUserId: 'callee-1', rejectedBy: _at(['callee-1'])),
          );

      expect(notifier.callState.status, CallStatus.outgoing());
    });

    test('stays in a call somebody else is already in', () {
      final notifier =
          _ringing(
            currentUserId: _creator.id,
            memberIds: [_creator.id, 'callee-1'],
            participants: [_participant('guest')],
          )..coordinatorCallRejected(
            _rejected(byUserId: 'callee-1', rejectedBy: _at(['callee-1'])),
          );

      expect(notifier.callState.status, CallStatus.outgoing());
    });
  });

  group('coordinatorCallRejected, as a callee', () {
    test('disconnects when the caller cancelled', () {
      final notifier =
          _ringing(
            currentUserId: _currentUserId,
            memberIds: [_creator.id, _currentUserId],
          )..coordinatorCallRejected(
            _rejected(byUserId: _creator.id, rejectedBy: _at([_creator.id])),
          );

      expect(
        _disconnectReason(notifier),
        DisconnectReason.rejected(
          byUserId: _creator.id,
          reason: CallRejectReason.creatorRejected(),
        ),
      );
    });

    test('disconnects when the caller cancelled after another accepted', () {
      final notifier =
          _ringing(
            currentUserId: _currentUserId,
            memberIds: [_creator.id, _currentUserId, 'callee-2'],
          )..coordinatorCallRejected(
            _rejected(
              byUserId: _creator.id,
              acceptedBy: _at(['callee-2']),
              rejectedBy: _at([_creator.id]),
            ),
          );

      expect(
        _disconnectReason(notifier),
        DisconnectReason.rejected(
          byUserId: _creator.id,
          reason: CallRejectReason.creatorRejected(),
        ),
      );
    });

    test('disconnects when the caller cancelled while others are in', () {
      final notifier =
          _ringing(
            currentUserId: _currentUserId,
            memberIds: [_creator.id, _currentUserId, 'callee-2'],
            participants: [_participant('callee-2')],
          )..coordinatorCallRejected(
            _rejected(byUserId: _creator.id, rejectedBy: _at([_creator.id])),
          );

      expect(
        _disconnectReason(notifier),
        DisconnectReason.rejected(
          byUserId: _creator.id,
          reason: CallRejectReason.creatorRejected(),
        ),
      );
    });

    test('stays in the call it accepted when the caller cancelled', () {
      final notifier =
          _ringing(
            currentUserId: _currentUserId,
            memberIds: [_creator.id, _currentUserId],
            status: CallStatus.incoming(acceptedByMe: true),
          )..coordinatorCallRejected(
            _rejected(
              byUserId: _creator.id,
              acceptedBy: _at([_currentUserId]),
              rejectedBy: _at([_creator.id]),
            ),
          );

      expect(
        notifier.callState.status,
        CallStatus.incoming(acceptedByMe: true),
      );
    });

    test('keeps ringing when it missed the ring', () {
      final notifier =
          _ringing(
            currentUserId: _currentUserId,
            memberIds: [_creator.id, _currentUserId, 'callee-2'],
          )..coordinatorCallRejected(
            _rejected(
              byUserId: 'callee-2',
              rejectedBy: _at(['callee-2']),
              missedBy: _at([_currentUserId]),
            ),
          );

      expect(notifier.callState.status, CallStatus.incoming());
    });

    test('disconnects when everyone else rejected', () {
      // The caller is not a member here, so only the everyone-else rule can
      // settle the ring.
      final notifier =
          _ringing(
            currentUserId: _currentUserId,
            memberIds: [_currentUserId, 'callee-2'],
          )..coordinatorCallRejected(
            _rejected(byUserId: 'callee-2', rejectedBy: _at(['callee-2'])),
          );

      expect(
        _disconnectReason(notifier),
        DisconnectReason.rejected(
          byUserId: 'callee-2',
          reason: CallRejectReason.allOtherParticipantsRejected(),
        ),
      );
    });

    test('keeps ringing while another callee has not answered', () {
      final notifier =
          _ringing(
            currentUserId: _currentUserId,
            memberIds: [_creator.id, _currentUserId, 'callee-2'],
          )..coordinatorCallRejected(
            _rejected(byUserId: 'callee-2', rejectedBy: _at(['callee-2'])),
          );

      expect(notifier.callState.status, CallStatus.incoming());
    });
  });
}
