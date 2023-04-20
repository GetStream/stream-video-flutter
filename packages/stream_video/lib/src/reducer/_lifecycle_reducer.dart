import '../action/internal/lifecycle_action.dart';
import '../call_state.dart';
import '../logger/impl/tagged_logger.dart';
import '../models/call_created_data.dart';
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
    if (action is SetUserId) {
      return _reduceUserId(state, action);
    } else if (action is SetLifecycleStage) {
      return _reduceStage(state, action.stage);
    }
    return state;
  }

  CallState _reduceUserId(
    CallState state,
    SetUserId action,
  ) {
    _logger.d(() => '[reduceUserId] state: $state');
    return state.copyWith(
      currentUserId: action.userId,
      status: CallStatus.idle(),
      sessionId: '',
      callParticipants: const [],
    );
  }

  CallState _reduceStage(
    CallState state,
    LifecycleStage stage,
  ) {
    if (stage is CallAccepted) {
      return _reduceCallAccepted(state, stage);
    } else if (stage is CallRejected) {
      return _reduceCallRejected(state, stage);
    } else if (stage is CallEnded) {
      return _reduceCallEnded(state, stage);
    } else if (stage is CallCreated) {
      return _reduceCallCreated(state, stage);
    } else if (stage is CallJoining) {
      return _reduceCallJoining(state, stage);
    } else if (stage is CallJoined) {
      return _reduceCallJoined(state, stage);
    } else if (stage is CallDisconnected) {
      return _reduceCallDisconnected(state, stage);
    } else if (stage is CallTimeout) {
      return _reduceCallTimeout(state, stage);
    } else if (stage is CallConnecting) {
      return _reduceCallConnectingAction(state, stage);
    } else if (stage is ConnectFailed) {
      return _reduceCallConnectFailed(state, stage);
    } else if (stage is CallSessionStart) {
      return _reduceCallSessionStart(state, stage);
    } else if (stage is CallConnected) {
      return _reduceCallConnected(state, stage);
    }
    return state;
  }

  CallState _reduceCallAccepted(
    CallState state,
    CallAccepted action,
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

  CallState _reduceCallRejected(
    CallState state,
    CallRejected stage,
  ) {
    final status = state.status;
    if (status is! CallStatusIncoming || status.acceptedByMe) {
      _logger.w(
        () => '[reduceCallRejected] rejected (invalid status): $status',
      );
      return state;
    }
    _logger.i(() => '[reduceCallRejected] stage: $stage, state: $state');
    return state.copyWith(
      status: CallStatus.disconnected(
        DisconnectReason.rejected(
          byUserId: state.currentUserId,
        ),
      ),
    );
  }

  CallState _reduceCallEnded(
    CallState state,
    CallEnded stage,
  ) {
    _logger.i(() => '[reduceCallEnded] stage: $stage, state: $state');
    return state.copyWith(
      status: CallStatus.disconnected(
        DisconnectReason.ended(),
      ),
      sessionId: '',
    );
  }

  CallState _reduceCallCreated(
    CallState state,
    CallCreated stage,
  ) {
    _logger.d(() => '[reduceCallCreated] state: $state');
    return state.copyWith(
      status: stage.data.toCallStatus(state: state),
      createdByUserId: stage.data.metadata.info.createdByUserId,
      settings: stage.data.metadata.details.settings,
      ownCapabilities: stage.data.metadata.details.ownCapabilities.toList(),
      callParticipants: stage.data.metadata.toCallParticipants(state),
    );
  }

  CallState _reduceCallJoining(
    CallState state,
    CallJoining stage,
  ) {
    _logger.d(() => '[reduceCallJoining] state: $state');
    return state.copyWith(
      status: CallStatus.joining(),
    );
  }

  CallState _reduceCallJoined(
    CallState state,
    CallJoined stage,
  ) {
    final status = state.status.isJoining ? CallStatus.joined() : state.status;
    _logger.d(() => '[reduceCallJoined] state: $state;\nnewStatus: $status');
    return state.copyWith(
      status: status,
      createdByUserId: stage.data.metadata.info.createdByUserId,
      settings: stage.data.metadata.details.settings,
      ownCapabilities: stage.data.metadata.details.ownCapabilities.toList(),
      callParticipants: stage.data.metadata.toCallParticipants(state),
    );
  }

  CallState _reduceCallDisconnected(
    CallState state,
    CallDisconnected stage,
  ) {
    _logger.w(() => '[reduceCallDisconnected] state: $state');
    return state.copyWith(
      status: CallStatus.disconnected(
        DisconnectReason.cancelled(
          byUserId: state.currentUserId,
        ),
      ),
      sessionId: '',
      callParticipants: const [],
    );
  }

  CallState _reduceCallTimeout(
    CallState state,
    CallTimeout stage,
  ) {
    _logger.e(() => '[reduceCallTimeout] state: $state');
    return state.copyWith(
      status: CallStatus.disconnected(
        DisconnectReason.timeout(stage.timeLimit),
      ),
      sessionId: '',
    );
  }

  CallState _reduceCallConnectingAction(
    CallState state,
    CallConnecting stage,
  ) {
    _logger.d(() => '[reduceCallConnectingAction] state: $state');
    final CallStatus status;
    if (stage.attempt > 0) {
      status = CallStatus.reconnecting(stage.attempt);
    } else {
      status = CallStatus.connecting();
    }
    return state.copyWith(
      status: status,
    );
  }

  CallState _reduceCallConnectFailed(
    CallState state,
    ConnectFailed stage,
  ) {
    _logger.e(() => '[reduceCallConnectFailed] state: $state');
    return state.copyWith(
      status: CallStatus.disconnected(
        DisconnectReason.failure(stage.error),
      ),
    );
  }

  CallState _reduceCallSessionStart(
    CallState state,
    CallSessionStart action,
  ) {
    _logger.d(() => '[reduceCallSessionStart] state: $state');
    return state.copyWith(
      sessionId: action.sessionId,
      //status: CallStatus.connecting(),
    );
  }

  CallState _reduceCallConnected(
    CallState state,
    CallConnected stage,
  ) {
    _logger.d(() => '[reduceCallConnected] state: $state');
    return state.copyWith(
      status: CallStatus.connected(),
    );
  }
}

extension on CallCreatedData {
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
