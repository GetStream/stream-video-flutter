import '../../logger/stream_logger.dart';
import '../action/lifecycle_action.dart';
import '../call_participant_state.dart';
import '../call_state.dart';
import '../coordinator/models/coordinator_models.dart';
import '../model/call_status.dart';
import '../model/drop_reason.dart';

class LifecycleReducer {
  LifecycleReducer();

  late final _logger = taggedLogger(tag: 'SV:Reducer-Lifecycle');

  CallStateV2 reduce(
    CallStateV2 state,
    LifecycleAction action,
  ) {
    if (action is CallUserIdAction) {
      return _reduceUserId(state, action);
    } else if (action is CallCreatedAction) {
      return _reduceCallCreated(state, action);
    } else if (action is CallDestroyedAction) {
      return _reduceCallDestroyed(state, action);
    } else if (action is CallAcceptedAction) {
      return _reduceCallAccepted(state, action);
    } else if (action is CallRejectedAction) {
      return _reduceCallRejected(state, action);
    } else if (action is CallCancelledAction) {
      return _reduceCallCancelled(state, action);
    } else if (action is CallTimeoutAction) {
      return _reduceCallTimeout(state, action);
    } else if (action is CallConnectFailedAction) {
      return _reduceCallConnectFailed(state, action);
    } else if (action is CallConnectAction) {
      return _reduceCallConnect(state, action);
    } else if (action is CallJoinedAction) {
      return _reduceCallJoined(state, action);
    } else if (action is CallSessionStartAction) {
      return _reduceCallSessionStart(state, action);
    } else if (action is CallConnectedAction) {
      return _reduceCallConnected(state, action);
    }
    return state;
  }

  CallStateV2 _reduceUserId(
    CallStateV2 state,
    CallUserIdAction action,
  ) {
    return state.copyWith(
      currentUserId: action.userId,
      status: CallStatus.idle(),
      sessionId: '',
      callParticipants: const {},
    );
  }

  CallStateV2 _reduceCallCreated(
    CallStateV2 state,
    CallCreatedAction action,
  ) {
    return state.copyWith(
      status: action.data.metadata.toCallStatus(
        currentUserId: state.currentUserId,
        ringing: action.data.ringing,
      ),
      callParticipants: action.data.metadata.toCallParticipants(
        state.currentUserId,
      ),
    );
  }

  CallStateV2 _reduceCallDestroyed(
    CallStateV2 state,
    CallDestroyedAction action,
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
      callParticipants: const {},
    );
  }

  CallStateV2 _reduceCallAccepted(
    CallStateV2 state,
    CallAcceptedAction action,
  ) {
    final status = state.status;
    if (status is! CallStatusIncoming || status.acceptedByMe) {
      _logger.w(
        () => '[reduceCallAccepted] rejected (invalid status): $status',
      );
      return state;
    }
    return state.copyWith(
      status: CallStatus.incoming(acceptedByMe: true),
    );
  }

  CallStateV2 _reduceCallRejected(
    CallStateV2 state,
    CallRejectedAction action,
  ) {
    final status = state.status;
    if (status is! CallStatusIncoming || status.acceptedByMe) {
      _logger.w(
        () => '[reduceCallRejected] rejected (invalid status): $status',
      );
      return state;
    }
    return state.copyWith(
      status: CallStatus.drop(
        DropReason.rejected(
          byUserId: state.currentUserId,
        ),
      ),
    );
  }

  CallStateV2 _reduceCallCancelled(
    CallStateV2 state,
    CallCancelledAction action,
  ) {
    final status = state.status;
    if (status is! CallStatusActive) {
      _logger.w(
        () => '[reduceCallRejected] rejected (invalid status): $status',
      );
      return state;
    }
    return state.copyWith(
      status: CallStatus.drop(
        DropReason.cancelled(
          byUserId: state.currentUserId,
        ),
      ),
    );
  }

  CallStateV2 _reduceCallTimeout(
    CallStateV2 state,
    CallTimeoutAction action,
  ) {
    final status = state.status;
    if (!status.isJoinable) {
      _logger.w(
        () => '[reduceCallTimeout] rejected (not Joinable): $status',
      );
      return state;
    }
    return state.copyWith(
      status: CallStatus.drop(DropReason.timeout(action.timeLimit)),
    );
  }

  CallStateV2 _reduceCallConnectFailed(
    CallStateV2 state,
    CallConnectFailedAction action,
  ) {
    final status = state.status;
    if (!status.isConnecting) {
      _logger.w(
        () => '[reduceCallConnectFailed] rejected (not Connecting): $status',
      );
      return state;
    }
    return state.copyWith(
      status: CallStatus.drop(DropReason.failure(action.error)),
    );
  }

  CallStateV2 _reduceCallConnect(
    CallStateV2 state,
    CallConnectAction action,
  ) {
    final status = state.status;
    if (!status.isJoinable) {
      _logger.w(() => '[reduceCallConnect] rejected (not Joinable): $status');
      return state;
    }
    return state.copyWith(
      status: CallStatus.connecting(),
    );
  }

  CallStateV2 _reduceCallJoined(
    CallStateV2 state,
    CallJoinedAction action,
  ) {
    return state.copyWith(
      callParticipants: action.data.metadata.toCallParticipants(
        state.currentUserId,
      ),
    );
  }

  CallStateV2 _reduceCallSessionStart(
    CallStateV2 state,
    CallSessionStartAction action,
  ) {
    return state.copyWith(sessionId: action.sessionId);
  }

  CallStateV2 _reduceCallConnected(
    CallStateV2 state,
    CallConnectedAction action,
  ) {
    final status = state.status;
    if (!status.isConnecting) {
      _logger.w(() => '[reduceCallConnected] rejected (not Joinable): $status');
      return state;
    }
    return state.copyWith(
      status: CallStatus.connected(),
    );
  }
}

extension on CallMetadata {
  CallStatus toCallStatus({
    required String currentUserId,
    required bool ringing,
  }) {
    final createdByMe = currentUserId == info.createdByUserId;
    if (createdByMe && ringing) {
      return CallStatus.outgoing();
    } else if (!createdByMe && ringing) {
      return CallStatus.incoming();
    } else {
      return CallStatus.initialized();
    }
  }

  Map<String, CallParticipantStateV2> toCallParticipants(String currentUserId) {
    final result = <String, CallParticipantStateV2>{};
    for (final userId in details.memberUserIds) {
      final member = details.members[userId];
      final isLocal = currentUserId == userId;
      result[userId] = CallParticipantStateV2(
        userId: userId,
        role: member?.role ?? '',
        name: '',
        profileImageURL: '',
        sessionId: '',
        trackIdPrefix: '',
        isLocal: isLocal,
        isOnline: !isLocal,
      );
    }
    return result;
  }
}
