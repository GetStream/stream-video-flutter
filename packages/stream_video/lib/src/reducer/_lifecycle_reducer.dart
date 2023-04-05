import '../action/lifecycle_action.dart';
import '../call_state.dart';
import '../logger/impl/tagged_logger.dart';
import '../models/call_created.dart';
import '../models/call_metadata.dart';
import '../models/call_participant_state.dart';
import '../models/call_status.dart';
import '../models/disconnect_reason.dart';

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
    } else if (action is CallEndedAction) {
      return _reduceCallEnded(state, action);
    } else if (action is CallTimeoutAction) {
      return _reduceCallTimeout(state, action);
    } else if (action is CallConnectingAction) {
      return _reduceCallConnectingAction(state, action);
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
    _logger.d(() => '[reduceUserId] state: $state');
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
    _logger.d(() => '[reduceCallCreated] state: $state');
    return state.copyWith(
      status: action.data.toCallStatus(state: state),
      createdByUserId: action.data.metadata.info.createdByUserId,
      settings: action.data.metadata.details.settings,
      ownCapabilities: action.data.metadata.details.ownCapabilities.toList(),
      callParticipants: action.data.metadata.toCallParticipants(state),
    );
  }

  CallState _reduceCallJoining(
    CallState state,
    CallJoiningAction action,
  ) {
    _logger.d(() => '[reduceCallJoining] state: $state');
    return state.copyWith(
      status: CallStatus.joining(),
    );
  }

  CallState _reduceCallJoined(
    CallState state,
    CallJoinedAction action,
  ) {
    final status = state.status.isJoining ? CallStatus.joined() : state.status;
    _logger.d(() => '[reduceCallJoined] state: $state;\nnewStatus: $status');
    return state.copyWith(
      status: status,
      createdByUserId: action.data.metadata.info.createdByUserId,
      settings: action.data.metadata.details.settings,
      ownCapabilities: action.data.metadata.details.ownCapabilities.toList(),
      callParticipants: action.data.metadata.toCallParticipants(state),
    );
  }

  CallState _reduceCallEnded(
    CallState state,
    CallEndedAction action,
  ) {
    _logger.i(() => '[reduceCallEnded] action: $action, state: $state');
    return state.copyWith(
      status: CallStatus.disconnected(
        DisconnectReason.ended(),
      ),
    );
  }

  CallState _reduceCallDisconnected(
    CallState state,
    CallDisconnectedAction action,
  ) {
    _logger.w(() => '[reduceCallDisconnected] state: $state');
    return state.copyWith(
      status: CallStatus.disconnected(DisconnectReason.manuallyClosed()),
      sessionId: '',
      callParticipants: const [],
    );
  }

  CallState _reduceCallTimeout(
    CallState state,
    CallTimeoutAction action,
  ) {
    _logger.e(() => '[reduceCallTimeout] state: $state');
    return state.copyWith(
      status:
          CallStatus.disconnected(DisconnectReason.timeout(action.timeLimit)),
    );
  }

  CallState _reduceCallConnectingAction(
    CallState state,
    CallConnectingAction action,
  ) {
    _logger.d(() => '[reduceCallConnectingAction] state: $state');
    final CallStatus status;
    if (action.attempt > 0) {
      status = CallStatus.reconnecting(action.attempt);
    } else {
      status = CallStatus.connecting();
    }
    return state.copyWith(
      status: status,
    );
  }

  CallState _reduceCallConnectFailed(
    CallState state,
    CallConnectFailedAction action,
  ) {
    _logger.e(() => '[reduceCallConnectFailed] state: $state');
    return state.copyWith(
      status: CallStatus.disconnected(DisconnectReason.failure(action.error)),
    );
  }

  CallState _reduceCallSessionStart(
    CallState state,
    CallSessionStartAction action,
  ) {
    _logger.d(() => '[reduceCallSessionStart] state: $state');
    return state.copyWith(
      sessionId: action.sessionId,
      //status: CallStatus.connecting(),
    );
  }

  CallState _reduceCallConnected(
    CallState state,
    CallConnectedAction action,
  ) {
    _logger.d(() => '[reduceCallConnected] state: $state');
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
    } else {
      return status;
    }
  }
}

extension on CallMetadata {
  List<CallParticipantState> toCallParticipants(CallState state) {
    final result = <CallParticipantState>[];
    for (final userId in details.members.keys) {
      final member = details.members[userId];
      final user = users[userId];
      final isLocal = state.currentUserId == userId;
      result.add(
        CallParticipantState(
          userId: userId,
          role: member?.role ?? user?.role ?? '',
          name: user?.name ?? '',
          image: user?.image ?? '',
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
