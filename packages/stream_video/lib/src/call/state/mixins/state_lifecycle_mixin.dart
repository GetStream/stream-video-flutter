import 'package:collection/collection.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../../call_state.dart';
import '../../../logger/impl/tagged_logger.dart';
import '../../../logger/stream_logger.dart';
import '../../../models/call_member_state.dart';
import '../../../models/call_received_data.dart';
import '../../../models/models.dart';
import '../../../sfu/data/models/sfu_error.dart';
import '../../../utils/none.dart';
import '../../../utils/result.dart';
import '../../call_connect_options.dart';

final _logger = taggedLogger(tag: 'SV:CoordNotifier');

mixin StateLifecycleMixin on StateNotifier<CallState> {
  void _logWithState(String methodName, [String? params]) {
    _logger.logConditional((priority) {
      switch (priority) {
        case Priority.verbose:
          final stateInfo = ', state: $state';
          return params != null
              ? '[$methodName] $params$stateInfo'
              : '[$methodName]$stateInfo';
        case Priority.debug:
          return params != null ? '[$methodName] $params' : '[$methodName]';
        default:
          return null;
      }
    });
  }

  void lifecycleUpdateUserId(
    String userId,
  ) {
    _logWithState('lifecycleUpdateUserId', 'userId: $userId');
    state = state.copyWith(
      currentUserId: userId,
      status: CallStatus.idle(),
      sessionId: '',
      callParticipants: const [],
    );
  }

  void lifecycleCallAccepted() {
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

  void lifecycleCallEnded() {
    _logWithState('lifecycleCallEnded');
    state = state.copyWith(
      status: CallStatus.disconnected(
        DisconnectReason.ended(),
      ),
      sessionId: '',
    );
  }

  void updateFromCallReceivedData(
    CallReceivedData data, {
    bool ringing = false,
    bool notify = false,
  }) {
    _logWithState(
      'lifecycleCallReceived',
      'ringing: $ringing, notify: $notify',
    );

    state = state.copyWith(
      status: data.toCallStatus(state: state, ringing: ringing),
      isBackstage: data.metadata.details.backstage,
      isRecording: data.metadata.details.recording,
      isTranscribing: data.metadata.details.transcribing,
      isCaptioning: data.metadata.details.captioning,
      isBroadcasting: data.metadata.details.broadcasting,
      blockedUserIds: data.metadata.details.blockedUserIds.toList(),
      createdAt: data.metadata.details.createdAt,
      updatedAt: data.metadata.details.updatedAt,
      startsAt: data.metadata.details.startsAt,
      endedAt: data.metadata.details.endedAt,
      startedAt:
          data.metadata.session.startedAt ??
          data.metadata.session.liveStartedAt,
      createdByUser: data.metadata.details.createdBy,
      custom: data.metadata.details.custom,
      egress: data.metadata.details.egress,
      rtmpIngress: data.metadata.details.rtmpIngress,
      settings: data.metadata.settings,
      ownCapabilities: data.metadata.details.ownCapabilities.toList(),
      callParticipants: data.metadata.toCallParticipants(state),
      liveStartedAt: data.metadata.session.liveStartedAt,
      liveEndedAt: data.metadata.session.liveEndedAt,
      callMembers: data.metadata.toCallMembers(),
    );
  }

  void updateFromCallCreatedData(
    CallCreatedData data, {
    required CallConnectOptions callConnectOptions,
    bool ringing = false,
  }) {
    _logWithState('lifecycleCallCreated', 'ringing: $ringing');

    final newState = state.copyFromMetadata(data.metadata);

    state = newState.copyWith(
      status: data.toCallStatus(state: newState, ringing: ringing),
      callParticipants: data.metadata.toCallParticipants(newState),
      isRingingFlow: ringing,
      audioOutputDevice: callConnectOptions.audioOutputDevice,
      audioInputDevice: callConnectOptions.audioInputDevice,
      videoInputDevice: callConnectOptions.videoInputDevice,
    );
  }

  void lifecycleCallRinging(
    CallRingingData data,
  ) {
    _logWithState('lifecycleCallRinging');

    final newState = state.copyFromMetadata(data.metadata);

    state = newState.copyWith(
      status: data.toCallStatus(state: newState),
      isRingingFlow: data.ringing,
      ownCapabilities: data.metadata.details.ownCapabilities.toList(),
      callParticipants: data.metadata.toCallParticipants(newState),
    );
  }

  void lifecycleCallJoining() {
    _logWithState('lifecycleCallJoining');

    state = state.copyWith(
      status: CallStatus.joining(),
    );
  }

  void lifecycleCallJoined(
    CallJoinedData data, {
    CallConnectOptions? callConnectOptions,
  }) {
    final status = state.status.isJoining ? CallStatus.joined() : state.status;
    _logWithState('lifecycleCallJoined', 'newStatus: $status');

    final newState = state.copyFromMetadata(data.metadata);

    state = newState.copyWith(
      status: status,
      ownCapabilities: data.metadata.details.ownCapabilities.toList(),
      callParticipants: data.metadata.toCallParticipants(newState),
      audioOutputDevice: callConnectOptions?.audioOutputDevice,
      audioInputDevice: callConnectOptions?.audioInputDevice,
      videoInputDevice: callConnectOptions?.videoInputDevice,
    );
  }

  void lifecycleCallReconnectingFailed() {
    _logWithState('lifecycleCallReconnectingFailed');

    state = state.copyWith(
      status: CallStatus.reconnectingFailed(),
    );
  }

  void lifecycleCallDisconnected({DisconnectReason? reason}) {
    if (state.status.isDisconnected) {
      _logger.i(
        () => '[lifecycleCallDisconnected] already disconnected',
      );

      return;
    }

    _logWithState('lifecycleCallDisconnected', 'reason: $reason');

    state = state.copyWith(
      status: CallStatus.disconnected(
        reason ??
            DisconnectReason.cancelled(
              byUserId: state.currentUserId,
            ),
      ),
      sessionId: '',
      callParticipants: const [],
    );
  }

  void lifecycleCallConnecting({
    required int attempt,
    SfuReconnectionStrategy? strategy,
  }) {
    _logWithState('lifecycleCallConnectingAction');
    final CallStatus status;

    if (strategy == SfuReconnectionStrategy.migrate) {
      status = CallStatus.migrating();
    } else if (strategy != SfuReconnectionStrategy.unspecified) {
      status = CallStatus.reconnecting(
        attempt,
        isFastReconnectAttempt: strategy == SfuReconnectionStrategy.fast,
      );
    } else {
      status = CallStatus.connecting();
    }
    state = state.copyWith(
      status: status,
    );
  }

  void lifecycleCallSessionStart({
    required String sessionId,
  }) {
    _logWithState('lifecycleCallSessionStart');
    state = state.copyWith(
      sessionId: sessionId,
    );
  }

  void lifecycleCallConnected() {
    _logWithState('lifecycleCallConnected');
    state = state.copyWith(
      status: CallStatus.connected(),
    );
  }

  Future<Result<None>> validateUserId(String currentUserId) async {
    final stateUserId = state.currentUserId;
    if (currentUserId.isEmpty) {
      return Result.error('no userId');
    }

    if (stateUserId.isEmpty || stateUserId != currentUserId) {
      lifecycleUpdateUserId(currentUserId);
    }

    return const Result.success(none);
  }
}

extension on CallMetadata {
  List<CallParticipantState> toCallParticipants(CallState state) {
    final result = <CallParticipantState>[];

    for (final participant in session.participants.values) {
      final userId = participant.userId;
      final sessionId = participant.userSessionId;
      final user = users[userId];
      final currentState = state.callParticipants.firstWhereOrNull(
        (it) => it.userId == userId && it.sessionId == sessionId,
      );

      final isLocal =
          state.currentUserId == userId && state.sessionId == sessionId;

      result.add(
        currentState?.copyWith(
              roles: user?.roles ?? [participant.role],
              name: user?.name ?? '',
              custom: user?.custom ?? {},
              image: user?.image ?? '',
              sessionId: sessionId,
              isLocal: isLocal,
              isOnline: !isLocal,
            ) ??
            CallParticipantState(
              userId: userId,
              roles: user?.roles ?? [participant.role],
              name: user?.name ?? '',
              custom: user?.custom ?? {},
              image: user?.image ?? '',
              sessionId: participant.userSessionId,
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
