import '../action/lifecycle_action.dart';
import '../call_participant_state.dart';
import '../call_state.dart';
import '../coordinator/models/coordinator_models.dart';
import '../logger/impl/tagged_logger.dart';
import '../models/call_created.dart';
import '../models/call_status.dart';
import '../models/drop_reason.dart';

final _logger = taggedLogger(tag: 'SV:Reducer-Lifecycle');

class LifecycleReducer {
  const LifecycleReducer();

  CallState reduce(
    CallState state,
    LifecycleAction action,
  ) {
    if (action is CallUserIdAction) {
      return _reduceUserId(state, action);
    } else if (action is CallCreatedAction) {
      return _reduceCallCreated(state, action);
    } else if (action is CallJoiningAction) {
      return _reduceCallJoining(state, action);
    } else if (action is CallJoinedAction) {
      return _reduceCallJoined(state, action);
    } else if (action is CallDisconnectedAction) {
      return _reduceCallDisconnected(state, action);
    } else if (action is CallTimeoutAction) {
      return _reduceCallTimeout(state, action);
    } else if (action is CallConnectFailedAction) {
      return _reduceCallConnectFailed(state, action);
    } else if (action is CallSessionStartAction) {
      return _reduceCallSessionStart(state, action);
    } else if (action is CallConnectedAction) {
      return _reduceCallConnected(state, action);
    }
    return state;
  }

  CallState _reduceUserId(
    CallState state,
    CallUserIdAction action,
  ) {
    return state.copyWith(
      currentUserId: action.userId,
      status: CallStatus.idle(),
      sessionId: '',
      callParticipants: const [],
    );
  }

  CallState _reduceCallCreated(
    CallState state,
    CallCreatedAction action,
  ) {
    return state.copyWith(
      status: action.data.toCallStatus(state: state),
      createdByUserId: action.data.metadata.info.createdByUserId,
      callParticipants: action.data.metadata.toCallParticipants(state),
    );
  }

  CallState _reduceCallJoining(
    CallState state,
    CallJoiningAction action,
  ) {
    return state.copyWith(
      status: CallStatus.joining(),
    );
  }

  CallState _reduceCallJoined(
    CallState state,
    CallJoinedAction action,
  ) {
    return state.copyWith(
      status: CallStatus.joined(action.data.credentials),
      createdByUserId: action.data.metadata.info.createdByUserId,
      callParticipants: action.data.metadata.toCallParticipants(state),
    );
  }

  CallState _reduceCallDisconnected(
    CallState state,
    CallDisconnectedAction action,
  ) {
    final status = state.status;
    if (status is! CallStatusDrop) {
      _logger.w(
        () => '[reduceCallDestroyed] rejected (invalid status): $status',
      );
      return state;
    }
    return state.copyWith(
      status: CallStatus.idle(),
      sessionId: '',
      callParticipants: const [],
    );
  }

  CallState _reduceCallTimeout(
    CallState state,
    CallTimeoutAction action,
  ) {
    return state.copyWith(
      status: CallStatus.drop(DropReason.timeout(action.timeLimit)),
    );
  }

  CallState _reduceCallConnectFailed(
    CallState state,
    CallConnectFailedAction action,
  ) {
    return state.copyWith(
      status: CallStatus.drop(DropReason.failure(action.error)),
    );
  }

  CallState _reduceCallSessionStart(
    CallState state,
    CallSessionStartAction action,
  ) {
    return state.copyWith(sessionId: action.sessionId);
  }

  CallState _reduceCallConnected(
    CallState state,
    CallConnectedAction action,
  ) {
    return state.copyWith(
      status: CallStatus.connected(),
    );
  }
}

extension on CallCreated {
  CallStatus toCallStatus({
    required CallState state,
  }) {
    final status = state.status;
    final createdByMe = state.currentUserId == metadata.info.createdByUserId;
    if (ringing && !status.isOutgoing && createdByMe) {
      return CallStatus.outgoing();
    } else if (ringing && !status.isIncoming && !createdByMe) {
      return CallStatus.incoming();
    } else if (status.isIdle) {
      return CallStatus.created();
    } else {
      return status;
    }
  }
}

extension on CallMetadata {
  List<CallParticipantState> toCallParticipants(CallState state) {
    final result = <CallParticipantState>[];
    for (final userId in users.keys) {
      final member = details.members[userId];
      final user = users[userId];
      final isLocal = state.currentUserId == userId;
      result.add(
        CallParticipantState(
          userId: userId,
          role: member?.role ?? user?.role ?? '',
          name: user?.name ?? '',
          profileImageURL: user?.imageUrl ?? '',
          sessionId: '',
          trackIdPrefix: '',
          isLocal: isLocal,
          isOnline: !isLocal,
        ),
      );
    }
    return result;
  }
}
