import 'package:collection/collection.dart';

import '../../logger/impl/tagged_logger.dart';
import '../action/coordinator_action.dart';
import '../call_participant_state.dart';
import '../call_state.dart';
import '../coordinator/ws/coordinator_events.dart';
import '../model/call_status.dart';
import '../model/drop_reason.dart';

final _logger = taggedLogger(tag: 'SV:CoordReducer');

class CoordinatorReducer {
  const CoordinatorReducer();

  CallState reduce(
    CallState state,
    CoordinatorAction action,
  ) {
    if (action is CoordinatorUsersAction) {
      return _reduceCoordinatorUsers(state, action);
    } else if (action is CoordinatorEventAction) {
      return _reduceCoordinatorEvent(state, action.event);
    }
    return state;
  }

  CallState _reduceCoordinatorUsers(
    CallState state,
    CoordinatorUsersAction action,
  ) {
    return state.copyWith(
      callParticipants: state.callParticipants.map(
        (participant) {
          final user = action.users[participant.userId];
          if (user == null) return participant;
          return participant.copyWith(
            role: user.role,
            name: user.name,
            profileImageURL: user.imageUrl,
          );
        },
      ).toList(),
    );
  }

  CallState _reduceCoordinatorEvent(
    CallState state,
    CoordinatorEvent event,
  ) {
    if (event is CoordinatorCallRejectedEvent) {
      return _reduceCallRejected(state, event);
    } else if (event is CoordinatorCallAcceptedEvent) {
      return _reduceCallAccepted(state, event);
    } else if (event is CoordinatorCallCancelledEvent) {
      return _reduceCallCancelled(state, event);
    }
    return state;
  }

  CallState _reduceCallAccepted(
    CallState state,
    CoordinatorCallAcceptedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusOutgoing) {
      _logger.w(() => '[reduceCallAccepted] rejected (status is not Outgoing)');
      return state;
    }
    final participant = state.callParticipants.firstWhereOrNull((participant) {
      return participant.userId == event.sentByUserId;
    });
    if (participant == null) {
      _logger.w(() => '[reduceCallAccepted] rejected (accepted by non-Member)');
      return state;
    }
    return state.copyWith(
      status: CallStatus.outgoing(acceptedByCallee: true),
    );
  }

  CallState _reduceCallRejected(
    CallState state,
    CoordinatorCallRejectedEvent event,
  ) {
    final status = state.status;
    _logger.d(() => '[reduceCallRejected] state: $state');
    if (status is! CallStatusActive) {
      _logger.w(
        () => '[reduceCallRejected] rejected (status is not Active): $status',
      );
      return state;
    }
    final participantIndex = state.callParticipants.indexWhere((participant) {
      return participant.userId == event.sentByUserId;
    });
    if (participantIndex == -1) {
      _logger.w(
        () => '[reduceCallRejected] rejected '
            '(by unknown user): ${event.sentByUserId}',
      );
      return state;
    }
    final callParticipants = [...state.callParticipants];
    final removed = callParticipants.removeAt(participantIndex);
    if (removed.userId == state.currentUserId ||
        callParticipants.hasSingle(state.currentUserId)) {
      return state.copyWith(
        status: CallStatus.drop(
          DropReason.rejected(
            byUserId: removed.userId,
          ),
        ),
        callParticipants: callParticipants,
      );
    }
    return state.copyWith(
      callParticipants: callParticipants,
    );
  }

  CallState _reduceCallCancelled(
    CallState state,
    CoordinatorCallCancelledEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(() => '[reduceCallCancelled] rejected (status is not Active)');
      return state;
    }
    final participantIndex = state.callParticipants.indexWhere((participant) {
      return participant.userId == event.sentByUserId;
    });
    if (participantIndex == -1) {
      _logger.w(
        () => '[reduceCallCancelled] rejected '
            '(by unknown user): ${event.sentByUserId}',
      );
      return state;
    }
    final callParticipants = [...state.callParticipants];
    final removed = callParticipants.removeAt(participantIndex);
    if (removed.userId == state.currentUserId ||
        callParticipants.hasSingle(state.currentUserId)) {
      return state.copyWith(
        status: CallStatus.drop(
          DropReason.cancelled(
            byUserId: removed.userId,
          ),
        ),
        callParticipants: callParticipants,
      );
    }
    return state.copyWith(
      callParticipants: callParticipants,
    );
  }
}

extension on List<CallParticipantState> {
  bool hasSingle(String userId) {
    return length == 1 && firstOrNull?.userId == userId;
  }
}
