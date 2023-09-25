import 'package:state_notifier/state_notifier.dart';

import '../../../action/internal/lifecycle_action.dart';
import '../../../call_state.dart';
import '../../../logger/impl/tagged_logger.dart';
import '../../../models/call_created_data.dart';
import '../../../models/call_metadata.dart';
import '../../../models/call_participant_state.dart';
import '../../../models/call_received_data.dart';
import '../../../models/call_ringing_data.dart';
import '../../../models/call_status.dart';
import '../../../models/disconnect_reason.dart';

final _logger = taggedLogger(tag: 'SV:CoordNotifier');

mixin StateLifecycleMixin on StateNotifier<CallState> {
  void lifecycleUpdateUserId(
    SetUserId action,
  ) {
    _logger.d(
      () => '[lifecycleUpdateUserId] userId: ${action.userId}, state: $state',
    );
    state = state.copyWith(
      currentUserId: action.userId,
      status: CallStatus.idle(),
      sessionId: '',
      callParticipants: const [],
    );
  }

  void lifecycleCallAccepted(
    CallAccepted action,
  ) {
    final status = state.status;
    if (status is! CallStatusIncoming || status.acceptedByMe) {
      _logger.w(
        () => '[lifecycleCallAccepted] rejected (invalid status): $status',
      );
      return;
    }
    state = state.copyWith(
      status: CallStatus.incoming(acceptedByMe: true),
    );
  }

  void lifecycleCallRejected(
    CallRejected stage,
  ) {
    final status = state.status;
    if (status is! CallStatusIncoming || status.acceptedByMe) {
      _logger.w(
        () => '[lifecycleCallRejected] rejected (invalid status): $status',
      );
      return;
    }
    _logger.i(() => '[lifecycleCallRejected] stage: $stage, state: $state');
    state = state.copyWith(
      status: CallStatus.disconnected(
        DisconnectReason.rejected(
          byUserId: state.currentUserId,
        ),
      ),
    );
  }

  void lifecycleCallEnded(
    CallEnded stage,
  ) {
    _logger.i(() => '[lifecycleCallEnded] stage: $stage, state: $state');
    state = state.copyWith(
      status: CallStatus.disconnected(
        DisconnectReason.ended(),
      ),
      sessionId: '',
    );
  }

  void lifecycleCallReceived(
    CallReceived stage, {
    bool ringing = false,
    bool notify = false,
  }) {
    _logger.d(
      () => '[lifecycleCallReceived] ringing: $ringing'
          ', notify: $notify, state: $state',
    );
    state = state.copyWith(
      status: stage.data.toCallStatus(state: state, ringing: ringing),
      createdByUserId: stage.data.metadata.details.createdBy.id,
      settings: stage.data.metadata.settings,
      egress: stage.data.metadata.details.egress,
      ownCapabilities: stage.data.metadata.details.ownCapabilities.toList(),
      callParticipants: stage.data.metadata.toCallParticipants(state),
    );
  }

  void lifecycleCallCreated(
    CallCreated stage, {
    bool ringing = false,
  }) {
    _logger.d(() => '[lifecycleCallCreated] ringing: $ringing, state: $state');
    state = state.copyWith(
      status: stage.data.toCallStatus(state: state, ringing: ringing),
      createdByUserId: stage.data.metadata.details.createdBy.id,
      settings: stage.data.metadata.settings,
      egress: stage.data.metadata.details.egress,
      ownCapabilities: stage.data.metadata.details.ownCapabilities.toList(),
      callParticipants: stage.data.metadata.toCallParticipants(state),
    );
  }

  void lifecycleCallRinging(
    CallRinging stage,
  ) {
    _logger.d(() => '[lifecycleCallRinging] state: $state');
    state = state.copyWith(
      status: stage.data.toCallStatus(state: state),
      createdByUserId: stage.data.metadata.details.createdBy.id,
      isRingingFlow: stage.data.ringing,
      settings: stage.data.metadata.settings,
      egress: stage.data.metadata.details.egress,
      ownCapabilities: stage.data.metadata.details.ownCapabilities.toList(),
      callParticipants: stage.data.metadata.toCallParticipants(state),
    );
  }

  void lifecycleCallJoining(
    CallJoining stage,
  ) {
    _logger.d(() => '[lifecycleCallJoining] state: $state');
    state = state.copyWith(
      status: CallStatus.joining(),
    );
  }

  void lifecycleCallJoined(
    CallJoined stage,
  ) {
    final status = state.status.isJoining ? CallStatus.joined() : state.status;
    _logger.d(() => '[lifecycleCallJoined] state: $state;\nnewStatus: $status');
    state = state.copyWith(
      status: status,
      createdByUserId: stage.data.metadata.details.createdBy.id,
      settings: stage.data.metadata.settings,
      egress: stage.data.metadata.details.egress,
      ownCapabilities: stage.data.metadata.details.ownCapabilities.toList(),
      callParticipants: stage.data.metadata.toCallParticipants(state),
    );
  }

  void lifecycleCallDisconnected(
    CallDisconnected stage,
  ) {
    _logger.w(() => '[lifecycleCallDisconnected] state: $state');
    state = state.copyWith(
      status: CallStatus.disconnected(
        DisconnectReason.cancelled(
          byUserId: state.currentUserId,
        ),
      ),
      sessionId: '',
      callParticipants: const [],
    );
  }

  void lifecycleCallTimeout(
    CallTimeout stage,
  ) {
    _logger.e(() => '[lifecycleCallTimeout] state: $state');
    state = state.copyWith(
      status: CallStatus.disconnected(
        const DisconnectReason.timeout(),
      ),
      sessionId: '',
    );
  }

  void lifecycleCallConnectingAction(
    CallConnecting stage,
  ) {
    _logger.d(() => '[lifecycleCallConnectingAction] state: $state');
    final CallStatus status;
    if (stage.attempt > 0) {
      status = CallStatus.reconnecting(stage.attempt);
    } else {
      status = CallStatus.connecting();
    }
    state = state.copyWith(
      status: status,
    );
  }

  void lifecycleCallConnectFailed(
    ConnectFailed stage,
  ) {
    _logger.e(() => '[lifecycleCallConnectFailed] state: $state');
    state = state.copyWith(
      status: CallStatus.disconnected(
        DisconnectReason.failure(stage.error),
      ),
    );
  }

  void lifecycleCallSessionStart(
    CallSessionStart action,
  ) {
    _logger.d(() => '[lifecycleCallSessionStart] state: $state');
    state = state.copyWith(
      sessionId: action.sessionId,
      //status: CallStatus.connecting(),
    );
  }

  void lifecycleCallConnected(
    CallConnected stage,
  ) {
    _logger.d(() => '[lifecycleCallConnected] state: $state');
    state = state.copyWith(
      status: CallStatus.connected(),
    );
  }
}

extension on CallMetadata {
  List<CallParticipantState> toCallParticipants(CallState state) {
    final result = <CallParticipantState>[];
    for (final userId in members.keys) {
      final member = members[userId];
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

extension on CallCreatedData {
  CallStatus toCallStatus({
    required CallState state,
    required bool ringing,
  }) {
    final status = state.status;
    final createdByMe = state.currentUserId == metadata.details.createdBy.id;
    if (ringing && !status.isOutgoing && createdByMe) {
      return CallStatus.outgoing();
    } else if (ringing && !status.isIncoming && !createdByMe) {
      return CallStatus.incoming();
    } else {
      return status;
    }
  }
}

extension on CallReceivedData {
  CallStatus toCallStatus({
    required CallState state,
    required bool ringing,
  }) {
    final status = state.status;
    final createdByMe = state.currentUserId == metadata.details.createdBy.id;
    if (ringing && !status.isOutgoing && createdByMe) {
      return CallStatus.outgoing();
    } else if (ringing && !status.isIncoming && !createdByMe) {
      return CallStatus.incoming();
    } else {
      return status;
    }
  }
}

extension on CallRingingData {
  CallStatus toCallStatus({
    required CallState state,
  }) {
    final status = state.status;
    final createdByMe = state.currentUserId == metadata.details.createdBy.id;
    if (ringing && !status.isOutgoing && createdByMe) {
      return CallStatus.outgoing();
    } else if (ringing && !status.isIncoming && !createdByMe) {
      return CallStatus.incoming();
    } else {
      return status;
    }
  }
}
