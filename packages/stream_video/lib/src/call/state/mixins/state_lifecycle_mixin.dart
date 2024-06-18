import 'package:collection/collection.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../../../stream_video.dart';
import '../../../errors/video_error.dart';
import '../../../models/call_received_data.dart';

final _logger = taggedLogger(tag: 'SV:CoordNotifier');

mixin StateLifecycleMixin on StateNotifier<CallState> {
  void lifecycleUpdateUserId(
    String userId,
  ) {
    _logger.d(
      () => '[lifecycleUpdateUserId] userId: $userId, state: $state',
    );
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

  void lifecycleCallRejected() {
    final status = state.status;
    if (status is! CallStatusIncoming || status.acceptedByMe) {
      _logger.w(
        () => '[lifecycleCallRejected] rejected (invalid status): $status',
      );
      return;
    }
    _logger.i(() => '[lifecycleCallRejected] state: $state');
    state = state.copyWith(
      status: CallStatus.disconnected(
        DisconnectReason.rejected(
          byUserId: state.currentUserId,
        ),
      ),
    );
  }

  void lifecycleCallEnded() {
    _logger.i(() => '[lifecycleCallEnded] state: $state');
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
    CallReceivedData data, {
    bool ringing = false,
    bool notify = false,
  }) {
    _logger.d(
      () => '[lifecycleCallReceived] ringing: $ringing'
          ', notify: $notify, state: $state',
    );
    final status = data.toCallStatus(state: state, ringing: ringing);
    state = state.copyWith(
      status: status,
      createdByUserId: data.metadata.details.createdBy.id,
      settings: data.metadata.settings,
      egress: data.metadata.details.egress,
      ownCapabilities: data.metadata.details.ownCapabilities.toList(),
      callParticipants: data.metadata.toCallParticipants(
        state,
        fromMembers: !status.isConnected,
      ),
      createdAt: data.metadata.details.createdAt,
      startsAt: data.metadata.details.startsAt,
      endedAt: data.metadata.details.endedAt,
      liveStartedAt: data.metadata.session.liveStartedAt,
      liveEndedAt: data.metadata.session.liveEndedAt,
      isBackstage: data.metadata.details.backstage,
      isBroadcasting: data.metadata.details.broadcasting,
      isRecording: data.metadata.details.recording,
      isTranscribing: data.metadata.details.transcribing,
    );
  }

  void lifecycleCallCreated(
    CallCreatedData data, {
    required CallConnectOptions callConnectOptions,
    bool ringing = false,
  }) {
    _logger.d(() => '[lifecycleCallCreated] ringing: $ringing, state: $state');
    state = state.copyWith(
      status: data.toCallStatus(state: state, ringing: ringing),
      createdByUserId: data.metadata.details.createdBy.id,
      settings: data.metadata.settings,
      egress: data.metadata.details.egress,
      ownCapabilities: data.metadata.details.ownCapabilities.toList(),
      callParticipants: data.metadata.toCallParticipants(
        state,
        fromMembers: true,
      ),
      createdAt: data.metadata.details.createdAt,
      startsAt: data.metadata.details.startsAt,
      endedAt: data.metadata.details.endedAt,
      liveStartedAt: data.metadata.session.liveStartedAt,
      liveEndedAt: data.metadata.session.liveEndedAt,
      isBackstage: data.metadata.details.backstage,
      isBroadcasting: data.metadata.details.broadcasting,
      isRecording: data.metadata.details.recording,
      isTranscribing: data.metadata.details.transcribing,
      audioOutputDevice: callConnectOptions.audioOutputDevice,
      audioInputDevice: callConnectOptions.audioInputDevice,
    );
  }

  void lifecycleCallRinging(
    CallRingingData data,
  ) {
    _logger.d(() => '[lifecycleCallRinging] state: $state');
    state = state.copyWith(
      status: data.toCallStatus(state: state),
      createdByUserId: data.metadata.details.createdBy.id,
      isRingingFlow: data.ringing,
      settings: data.metadata.settings,
      egress: data.metadata.details.egress,
      ownCapabilities: data.metadata.details.ownCapabilities.toList(),
      callParticipants: data.metadata.toCallParticipants(
        state,
        fromMembers: true,
      ),
      createdAt: data.metadata.details.createdAt,
      startsAt: data.metadata.details.startsAt,
      endedAt: data.metadata.details.endedAt,
      liveStartedAt: data.metadata.session.liveStartedAt,
      liveEndedAt: data.metadata.session.liveEndedAt,
      isBackstage: data.metadata.details.backstage,
      isBroadcasting: data.metadata.details.broadcasting,
      isRecording: data.metadata.details.recording,
      isTranscribing: data.metadata.details.transcribing,
    );
  }

  void lifecycleCallJoining() {
    _logger.d(() => '[lifecycleCallJoining] state: $state');
    state = state.copyWith(
      status: CallStatus.joining(),
    );
  }

  void lifecycleCallJoined(
    CallJoinedData data,
  ) {
    final status = state.status.isJoining ? CallStatus.joined() : state.status;
    _logger.d(() => '[lifecycleCallJoined] state: $state;\nnewStatus: $status');
    state = state.copyWith(
      status: status,
      createdByUserId: data.metadata.details.createdBy.id,
      settings: data.metadata.settings,
      egress: data.metadata.details.egress,
      ownCapabilities: data.metadata.details.ownCapabilities.toList(),
      callParticipants: data.metadata.toCallParticipants(
        state,
        fromMembers: true,
      ),
      createdAt: data.metadata.details.createdAt,
      startsAt: data.metadata.details.startsAt,
      endedAt: data.metadata.details.endedAt,
      liveStartedAt: data.metadata.session.liveStartedAt,
      liveEndedAt: data.metadata.session.liveEndedAt,
      isBackstage: data.metadata.details.backstage,
      isBroadcasting: data.metadata.details.broadcasting,
      isRecording: data.metadata.details.recording,
      isTranscribing: data.metadata.details.transcribing,
    );
  }

  void lifecycleCallDisconnected() {
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

  void lifecycleCallTimeout() {
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

  void lifecycleCallConnecting({
    required int attempt,
    bool isFastReconnectAttempt = false,
  }) {
    _logger.d(() => '[lifecycleCallConnectingAction] state: $state');
    final CallStatus status;
    if (attempt > 0) {
      status = CallStatus.reconnecting(
        attempt,
        isFastReconnectAttempt: isFastReconnectAttempt,
      );
    } else {
      status = CallStatus.connecting();
    }
    state = state.copyWith(
      status: status,
    );
  }

  void lifecycleCallConnectFailed({
    required VideoError error,
  }) {
    _logger.e(() => '[lifecycleCallConnectFailed] state: $state');
    state = state.copyWith(
      status: CallStatus.disconnected(
        DisconnectReason.failure(error),
      ),
      localStats: LocalStats.empty(),
      publisherStats: PeerConnectionStats.empty(),
      subscriberStats: PeerConnectionStats.empty(),
    );
  }

  void lifecycleCallSessionStart({
    required String sessionId,
    LocalStats? localStats,
  }) {
    _logger.d(() => '[lifecycleCallSessionStart] state: $state');
    state = state.copyWith(
      sessionId: sessionId,
      localStats: localStats,
      //status: CallStatus.connecting(),
    );
  }

  void lifecycleCallConnected() {
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
              roles: member?.roles ?? user?.roles ?? [],
              name: user?.name ?? '',
              custom: user?.custom ?? {},
              image: user?.image ?? '',
              sessionId: participant.userSessionId,
              isLocal: isLocal,
              isOnline: !isLocal,
            ) ??
            CallParticipantState(
              userId: userId,
              roles: member?.roles ?? user?.roles ?? [],
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
