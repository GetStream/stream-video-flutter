import 'package:collection/collection.dart';

import '../action/coordinator_call_action.dart';
import '../call_state.dart';
import '../coordinator/models/coordinator_events.dart';
import '../logger/impl/tagged_logger.dart';
import '../models/call_participant_state.dart';
import '../models/call_status.dart';
import '../models/disconnect_reason.dart';

final _logger = taggedLogger(tag: 'SV:CoordReducer');

class CoordinatorCallReducer {
  const CoordinatorCallReducer();

  CallState reduce(
    CallState state,
    CoordinatorCallAction action,
  ) {
    if (action is CoordinatorCallUsersAction) {
      return _reduceCallCoordinatorUsers(state, action);
    } else if (action is CoordinatorCallEventAction) {
      return _reduceCoordinatorCallEvent(state, action.event);
    }
    return state;
  }

  CallState _reduceCallCoordinatorUsers(
    CallState state,
    CoordinatorCallUsersAction action,
  ) {
    return state.copyWith(
      callParticipants: state.callParticipants.map(
        (participant) {
          final user = action.users[participant.userId];
          if (user == null) return participant;
          return participant.copyWith(
            role: user.role,
            name: user.name,
            image: user.image,
          );
        },
      ).toList(),
    );
  }

  CallState _reduceCoordinatorCallEvent(
    CallState state,
    CoordinatorCallEvent event,
  ) {
    if (event is CoordinatorCallRejectedEvent) {
      return _reduceCallRejected(state, event);
    } else if (event is CoordinatorCallAcceptedEvent) {
      return _reduceCallAccepted(state, event);
    } else if (event is CoordinatorCallEndedEvent) {
      return _reduceCallEnded(state, event);
    } else if (event is CoordinatorCallPermissionsUpdatedEvent) {
      return _reduceCallPermissionsUpdated(state, event);
    } else if (event is CoordinatorCallRecordingStartedEvent) {
      return _reduceCallRecordingStarted(state, event);
    } else if (event is CoordinatorCallRecordingStoppedEvent) {
      return _reduceCallRecordingStopped(state, event);
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
        status: CallStatus.disconnected(
          DisconnectReason.rejected(
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

  CallState _reduceCallEnded(
    CallState state,
    CoordinatorCallEndedEvent event,
  ) {
    _logger.i(() => '[reduceCallCancelled] state: $state');
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(() => '[reduceCallEnded] rejected (status is not Active)');
      return state;
    }
    final participantIndex = state.callParticipants.indexWhere((participant) {
      return participant.userId == event.sentByUserId;
    });
    if (participantIndex == -1) {
      _logger.w(
        () => '[reduceCallEnded] rejected '
            '(by unknown user): ${event.sentByUserId}',
      );
      return state;
    }
    final callParticipants = [...state.callParticipants];
    final removed = callParticipants.removeAt(participantIndex);
    if (removed.userId == state.currentUserId ||
        callParticipants.hasSingle(state.currentUserId)) {
      return state.copyWith(
        status: CallStatus.disconnected(
          DisconnectReason.cancelled(
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

  CallState _reduceCallPermissionsUpdated(
    CallState state,
    CoordinatorCallPermissionsUpdatedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () => '[reduceCallPermissionsUpdated] rejected (status is not Active)',
      );
      return state;
    }

    return state.copyWith(
      ownCapabilities: List.unmodifiable(
        event.ownCapabilities,
      ),
    );
  }

  CallState _reduceCallRecordingStarted(
    CallState state,
    CoordinatorCallRecordingStartedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () => '[reduceCallRecordingStarted] rejected (status is not Active)',
      );
      return state;
    }

    return state.copyWith(
      isRecording: true,
    );
  }

  CallState _reduceCallRecordingStopped(
    CallState state,
    CoordinatorCallRecordingStoppedEvent event,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () => '[reduceCallRecordingStopped] rejected (status is not Active)',
      );
      return state;
    }

    return state.copyWith(
      isRecording: false,
    );
  }
}

extension on List<CallParticipantState> {
  bool hasSingle(String userId) {
    return length == 1 && firstOrNull?.userId == userId;
  }
}
