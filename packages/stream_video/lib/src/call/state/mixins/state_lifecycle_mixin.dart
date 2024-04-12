import 'package:collection/collection.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../../../stream_video.dart';
import '../../../action/internal/lifecycle_action.dart';
import '../../../models/call_received_data.dart';

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
      localStats: LocalStats.empty(),
      publisherStats: PeerConnectionStats.empty(),
      subscriberStats: PeerConnectionStats.empty(),
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
    final status = stage.data.toCallStatus(state: state, ringing: ringing);
    state = state.copyWith(
      status: status,
      createdByUserId: stage.data.metadata.details.createdBy.id,
      settings: stage.data.metadata.settings,
      egress: stage.data.metadata.details.egress,
      ownCapabilities: stage.data.metadata.details.ownCapabilities.toList(),
      callParticipants: stage.data.metadata.toCallParticipants(
        state,
        fromMembers: !status.isConnected,
      ),
      createdAt: stage.data.metadata.details.createdAt,
      startsAt: stage.data.metadata.details.startsAt,
      endedAt: stage.data.metadata.details.endedAt,
      liveStartedAt: stage.data.metadata.session.liveStartedAt,
      liveEndedAt: stage.data.metadata.session.liveEndedAt,
      isBackstage: stage.data.metadata.details.backstage,
      isBroadcasting: stage.data.metadata.details.broadcasting,
      isRecording: stage.data.metadata.details.recording,
    );
  }

  void lifecycleCallCreated(
    CallCreated stage, {
    bool ringing = false,
    List<RtcMediaDevice>? audioOutputs,
    List<RtcMediaDevice>? audioInputs,
  }) {
    var defaultAudioOutput = audioOutputs?.firstWhereOrNull((device) {
      if (stage.data.metadata.settings.audio.defaultDevice ==
          AudioSettingsRequestDefaultDeviceEnum.speaker) {
        return device.id.equalsIgnoreCase(
          AudioSettingsRequestDefaultDeviceEnum.speaker.value,
        );
      }

      return !device.id.equalsIgnoreCase(
        AudioSettingsRequestDefaultDeviceEnum.speaker.value,
      );
    });

    if (defaultAudioOutput == null &&
        audioOutputs != null &&
        audioOutputs.isNotEmpty) {
      defaultAudioOutput = audioOutputs.first;
    }

    final defaultAudioInput = audioInputs
            ?.firstWhereOrNull((d) => d.label == defaultAudioOutput?.label) ??
        audioInputs?.firstOrNull;

    _logger.d(() => '[lifecycleCallCreated] ringing: $ringing, state: $state');
    state = state.copyWith(
      status: stage.data.toCallStatus(state: state, ringing: ringing),
      createdByUserId: stage.data.metadata.details.createdBy.id,
      settings: stage.data.metadata.settings,
      egress: stage.data.metadata.details.egress,
      ownCapabilities: stage.data.metadata.details.ownCapabilities.toList(),
      callParticipants: stage.data.metadata.toCallParticipants(
        state,
        fromMembers: true,
      ),
      createdAt: stage.data.metadata.details.createdAt,
      startsAt: stage.data.metadata.details.startsAt,
      endedAt: stage.data.metadata.details.endedAt,
      liveStartedAt: stage.data.metadata.session.liveStartedAt,
      liveEndedAt: stage.data.metadata.session.liveEndedAt,
      isBackstage: stage.data.metadata.details.backstage,
      isBroadcasting: stage.data.metadata.details.broadcasting,
      isRecording: stage.data.metadata.details.recording,
      audioOutputDevice: defaultAudioOutput,
      audioInputDevice: defaultAudioInput,
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
      callParticipants: stage.data.metadata.toCallParticipants(
        state,
        fromMembers: true,
      ),
      createdAt: stage.data.metadata.details.createdAt,
      startsAt: stage.data.metadata.details.startsAt,
      endedAt: stage.data.metadata.details.endedAt,
      liveStartedAt: stage.data.metadata.session.liveStartedAt,
      liveEndedAt: stage.data.metadata.session.liveEndedAt,
      isBackstage: stage.data.metadata.details.backstage,
      isBroadcasting: stage.data.metadata.details.broadcasting,
      isRecording: stage.data.metadata.details.recording,
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
      callParticipants: stage.data.metadata.toCallParticipants(
        state,
        fromMembers: true,
      ),
      createdAt: stage.data.metadata.details.createdAt,
      startsAt: stage.data.metadata.details.startsAt,
      endedAt: stage.data.metadata.details.endedAt,
      liveStartedAt: stage.data.metadata.session.liveStartedAt,
      liveEndedAt: stage.data.metadata.session.liveEndedAt,
      isBackstage: stage.data.metadata.details.backstage,
      isBroadcasting: stage.data.metadata.details.broadcasting,
      isRecording: stage.data.metadata.details.recording,
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
      localStats: LocalStats.empty(),
      publisherStats: PeerConnectionStats.empty(),
      subscriberStats: PeerConnectionStats.empty(),
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
      localStats: LocalStats.empty(),
      publisherStats: PeerConnectionStats.empty(),
      subscriberStats: PeerConnectionStats.empty(),
    );
  }

  void lifecycleCallConnectingAction(
    CallConnecting stage,
  ) {
    _logger.d(() => '[lifecycleCallConnectingAction] state: $state');
    final CallStatus status;
    if (stage.attempt > 0) {
      status = CallStatus.reconnecting(
        stage.attempt,
        isFastReconnectAttempt: stage.isFastReconnectAttempt,
      );
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
      localStats: LocalStats.empty(),
      publisherStats: PeerConnectionStats.empty(),
      subscriberStats: PeerConnectionStats.empty(),
    );
  }

  void lifecycleCallSessionStart(
    CallSessionStart action, {
    LocalStats? localStats,
  }) {
    _logger.d(() => '[lifecycleCallSessionStart] state: $state');
    state = state.copyWith(
      sessionId: action.sessionId,
      localStats: localStats,
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

  void lifecycleCallMigrating() {
    _logger.d(() => '[lifecycleCallMigrating] state: $state');
    state = state.copyWith(
      status: const CallStatusMigrating(),
      callParticipants: const [],
    );
  }

  void lifecycleCallStats({
    required List<int> latencyHistory,
    PeerConnectionStats? publisherStats,
    PeerConnectionStats? subscriberStats,
  }) {
    _logger.d(
      () =>
          '[lifecycleCallStats] publisherStats: $publisherStats, subscriberStats: $subscriberStats, state: $state',
    );
    state = state.copyWith(
      publisherStats: publisherStats,
      subscriberStats: subscriberStats,
      latencyHistory: latencyHistory,
    );
  }
}

extension on CallMetadata {
  List<CallParticipantState> toCallParticipants(
    CallState state, {
    bool fromMembers = false,
  }) {
    final result = <CallParticipantState>[];

    final participantsData = fromMembers
        ? members.values
            .map((e) => (userId: e.userId, userSessionId: null))
            .toList()
        : session.participants.values
            .map((e) => (userId: e.userId, userSessionId: e.userSessionId))
            .toList();

    for (final participant in participantsData) {
      final userId = participant.userId;
      final member = members[userId];
      final user = users[userId];
      final currentState =
          state.callParticipants.firstWhereOrNull((it) => it.userId == userId);
      final isLocal = state.currentUserId == userId;

      result.add(
        currentState?.copyWith(
              role: member?.role ?? user?.role ?? '',
              name: user?.name ?? '',
              custom: user?.custom ?? {},
              image: user?.image ?? '',
              sessionId: participant.userSessionId,
              isLocal: isLocal,
              isOnline: !isLocal,
            ) ??
            CallParticipantState(
              userId: userId,
              role: member?.role ?? user?.role ?? '',
              name: user?.name ?? '',
              custom: user?.custom ?? {},
              image: user?.image ?? '',
              sessionId: participant.userSessionId ?? '',
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

extension on String {
  bool equalsIgnoreCase(String other) => toUpperCase() == other.toUpperCase();
}
