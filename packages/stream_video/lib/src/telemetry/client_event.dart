import 'client_event_types.dart';

/// Call/connection identity fields carried by a telemetry event.
class ClientEventIdentity {
  const ClientEventIdentity({
    this.callType,
    this.callId,
    this.joinAttemptId,
    this.joinReason,
    this.callSessionId,
    this.coordinatorConnectId,
  });

  final String? callType;
  final String? callId;
  final String? joinAttemptId;
  final JoinReason? joinReason;
  final String? callSessionId;
  final String? coordinatorConnectId;

  ClientEventIdentity copyWith({
    String? callType,
    String? callId,
    String? joinAttemptId,
    JoinReason? joinReason,
    String? callSessionId,
    String? coordinatorConnectId,
  }) {
    return ClientEventIdentity(
      callType: callType ?? this.callType,
      callId: callId ?? this.callId,
      joinAttemptId: joinAttemptId ?? this.joinAttemptId,
      joinReason: joinReason ?? this.joinReason,
      callSessionId: callSessionId ?? this.callSessionId,
      coordinatorConnectId: coordinatorConnectId ?? this.coordinatorConnectId,
    );
  }

  Map<String, Object?> toJson() {
    final sessionId = callSessionId;
    return {
      if (callType != null) 'type': callType,
      if (callId != null) 'id': callId,
      if (joinAttemptId != null) 'join_attempt_id': joinAttemptId,
      if (joinReason != null) 'join_reason': joinReason!.wireValue,
      if (sessionId != null && sessionId.isNotEmpty)
        'call_session_id': sessionId,
      if (coordinatorConnectId != null)
        'coordinator_connect_id': coordinatorConnectId,
    };
  }
}

/// Stage-specific fields.
class ClientEventDetails {
  const ClientEventDetails({
    this.sfuId,
    this.peerConnectionRole,
    this.wasPreviouslyConnected,
    this.previouslyConnectedAt,
    this.iceState,
    this.trackId,
  });

  final String? sfuId;
  final ClientEventPeerConnectionRole? peerConnectionRole;
  final bool? wasPreviouslyConnected;
  final DateTime? previouslyConnectedAt;
  final ClientEventIceState? iceState;
  final String? trackId;

  Map<String, Object?> toJson() {
    final connectedAt = previouslyConnectedAt;
    return {
      if (sfuId != null) 'sfu_id': sfuId,
      if (peerConnectionRole != null)
        'peer_connection': peerConnectionRole!.wireValue,
      if (wasPreviouslyConnected != null)
        'was_previously_connected': wasPreviouslyConnected,
      if (connectedAt != null)
        'previously_connected_timestamp': connectedAt.toUtc().toIso8601String(),
      if (iceState != null) 'ice_state': iceState!.wireValue,
      if (trackId != null) 'track_id': trackId,
    };
  }
}

class ClientEvent {
  const ClientEvent({
    required this.stage,
    required this.type,
    required this.userId,
    required this.userAgent,
    required this.sdkVersion,
    required this.timestamp,
    this.identity = const ClientEventIdentity(),
    this.stageId,
    this.outcome,
    this.retryCount,
    this.elapsedTime,
    this.failure,
    this.details = const ClientEventDetails(),
  });

  final ClientEventStage stage;
  final ClientEventType type;
  final String userId;
  final String userAgent;
  final String sdkVersion;
  final DateTime timestamp;
  final ClientEventIdentity identity;
  final String? stageId;

  final ClientEventOutcome? outcome;
  final int? retryCount;
  final int? elapsedTime;
  final ClientEventFailure? failure;

  final ClientEventDetails details;

  Map<String, Object?> toJson() {
    final failure = this.failure;
    return {
      'user_id': userId,
      ...identity.toJson(),
      'stage': stage.wireValue,
      if (stageId != null) 'stage_id': stageId,
      'event_type': type.wireValue,
      'timestamp': timestamp.toUtc().toIso8601String(),
      'user_agent': userAgent,
      'sdk_version': sdkVersion,
      if (outcome != null) 'outcome': outcome!.wireValue,
      if (retryCount != null) 'retry_count_attempt': retryCount,
      if (elapsedTime != null) 'elapsed_time': elapsedTime,
      if (failure != null) ...{
        'retry_failure_code': failure.code.wireValue,
        'retry_failure_reason': failure.reason,
      },
      ...details.toJson(),
    };
  }
}
