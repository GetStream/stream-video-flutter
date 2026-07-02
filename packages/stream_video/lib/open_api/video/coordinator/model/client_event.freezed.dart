// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClientEvent {
  String? get callSessionId;
  String? get cameraPermissionStatus;
  String? get coordinatorConnectId;
  int? get elapsedTime;
  String? get eventType;
  String? get iceState;
  String? get id;
  String? get joinAttemptId;
  String? get microphonePermissionStatus;
  String? get outcome;
  String? get peerConnection;
  DateTime? get previouslyConnectedTimestamp;
  int? get retryCountAttempt;
  String? get retryFailureCode;
  String? get retryFailureReason;
  String? get screenShareStatus;
  String? get sdkVersion;
  String? get sfuId;
  String? get stage;
  String? get stageId;
  DateTime? get timestamp;
  String? get trackId;
  String? get type;
  String? get userAgent;
  String? get userId;
  bool? get wasPreviouslyConnected;

  /// Create a copy of ClientEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ClientEventCopyWith<ClientEvent> get copyWith =>
      _$ClientEventCopyWithImpl<ClientEvent>(this as ClientEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ClientEvent &&
            (identical(other.callSessionId, callSessionId) ||
                other.callSessionId == callSessionId) &&
            (identical(other.cameraPermissionStatus, cameraPermissionStatus) ||
                other.cameraPermissionStatus == cameraPermissionStatus) &&
            (identical(other.coordinatorConnectId, coordinatorConnectId) ||
                other.coordinatorConnectId == coordinatorConnectId) &&
            (identical(other.elapsedTime, elapsedTime) ||
                other.elapsedTime == elapsedTime) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            (identical(other.iceState, iceState) ||
                other.iceState == iceState) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.joinAttemptId, joinAttemptId) ||
                other.joinAttemptId == joinAttemptId) &&
            (identical(
                  other.microphonePermissionStatus,
                  microphonePermissionStatus,
                ) ||
                other.microphonePermissionStatus ==
                    microphonePermissionStatus) &&
            (identical(other.outcome, outcome) || other.outcome == outcome) &&
            (identical(other.peerConnection, peerConnection) ||
                other.peerConnection == peerConnection) &&
            (identical(
                  other.previouslyConnectedTimestamp,
                  previouslyConnectedTimestamp,
                ) ||
                other.previouslyConnectedTimestamp ==
                    previouslyConnectedTimestamp) &&
            (identical(other.retryCountAttempt, retryCountAttempt) ||
                other.retryCountAttempt == retryCountAttempt) &&
            (identical(other.retryFailureCode, retryFailureCode) ||
                other.retryFailureCode == retryFailureCode) &&
            (identical(other.retryFailureReason, retryFailureReason) ||
                other.retryFailureReason == retryFailureReason) &&
            (identical(other.screenShareStatus, screenShareStatus) ||
                other.screenShareStatus == screenShareStatus) &&
            (identical(other.sdkVersion, sdkVersion) ||
                other.sdkVersion == sdkVersion) &&
            (identical(other.sfuId, sfuId) || other.sfuId == sfuId) &&
            (identical(other.stage, stage) || other.stage == stage) &&
            (identical(other.stageId, stageId) || other.stageId == stageId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.trackId, trackId) || other.trackId == trackId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.userAgent, userAgent) ||
                other.userAgent == userAgent) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.wasPreviouslyConnected, wasPreviouslyConnected) ||
                other.wasPreviouslyConnected == wasPreviouslyConnected));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    callSessionId,
    cameraPermissionStatus,
    coordinatorConnectId,
    elapsedTime,
    eventType,
    iceState,
    id,
    joinAttemptId,
    microphonePermissionStatus,
    outcome,
    peerConnection,
    previouslyConnectedTimestamp,
    retryCountAttempt,
    retryFailureCode,
    retryFailureReason,
    screenShareStatus,
    sdkVersion,
    sfuId,
    stage,
    stageId,
    timestamp,
    trackId,
    type,
    userAgent,
    userId,
    wasPreviouslyConnected,
  ]);

  @override
  String toString() {
    return 'ClientEvent(callSessionId: $callSessionId, cameraPermissionStatus: $cameraPermissionStatus, coordinatorConnectId: $coordinatorConnectId, elapsedTime: $elapsedTime, eventType: $eventType, iceState: $iceState, id: $id, joinAttemptId: $joinAttemptId, microphonePermissionStatus: $microphonePermissionStatus, outcome: $outcome, peerConnection: $peerConnection, previouslyConnectedTimestamp: $previouslyConnectedTimestamp, retryCountAttempt: $retryCountAttempt, retryFailureCode: $retryFailureCode, retryFailureReason: $retryFailureReason, screenShareStatus: $screenShareStatus, sdkVersion: $sdkVersion, sfuId: $sfuId, stage: $stage, stageId: $stageId, timestamp: $timestamp, trackId: $trackId, type: $type, userAgent: $userAgent, userId: $userId, wasPreviouslyConnected: $wasPreviouslyConnected)';
  }
}

/// @nodoc
abstract mixin class $ClientEventCopyWith<$Res> {
  factory $ClientEventCopyWith(
    ClientEvent value,
    $Res Function(ClientEvent) _then,
  ) = _$ClientEventCopyWithImpl;
  @useResult
  $Res call({
    String? callSessionId,
    String? cameraPermissionStatus,
    String? coordinatorConnectId,
    int? elapsedTime,
    String? eventType,
    String? iceState,
    String? id,
    String? joinAttemptId,
    String? microphonePermissionStatus,
    String? outcome,
    String? peerConnection,
    DateTime? previouslyConnectedTimestamp,
    int? retryCountAttempt,
    String? retryFailureCode,
    String? retryFailureReason,
    String? screenShareStatus,
    String? sdkVersion,
    String? sfuId,
    String? stage,
    String? stageId,
    DateTime? timestamp,
    String? trackId,
    String? type,
    String? userAgent,
    String? userId,
    bool? wasPreviouslyConnected,
  });
}

/// @nodoc
class _$ClientEventCopyWithImpl<$Res> implements $ClientEventCopyWith<$Res> {
  _$ClientEventCopyWithImpl(this._self, this._then);

  final ClientEvent _self;
  final $Res Function(ClientEvent) _then;

  /// Create a copy of ClientEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callSessionId = freezed,
    Object? cameraPermissionStatus = freezed,
    Object? coordinatorConnectId = freezed,
    Object? elapsedTime = freezed,
    Object? eventType = freezed,
    Object? iceState = freezed,
    Object? id = freezed,
    Object? joinAttemptId = freezed,
    Object? microphonePermissionStatus = freezed,
    Object? outcome = freezed,
    Object? peerConnection = freezed,
    Object? previouslyConnectedTimestamp = freezed,
    Object? retryCountAttempt = freezed,
    Object? retryFailureCode = freezed,
    Object? retryFailureReason = freezed,
    Object? screenShareStatus = freezed,
    Object? sdkVersion = freezed,
    Object? sfuId = freezed,
    Object? stage = freezed,
    Object? stageId = freezed,
    Object? timestamp = freezed,
    Object? trackId = freezed,
    Object? type = freezed,
    Object? userAgent = freezed,
    Object? userId = freezed,
    Object? wasPreviouslyConnected = freezed,
  }) {
    return _then(
      ClientEvent(
        callSessionId: freezed == callSessionId
            ? _self.callSessionId
            : callSessionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        cameraPermissionStatus: freezed == cameraPermissionStatus
            ? _self.cameraPermissionStatus
            : cameraPermissionStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        coordinatorConnectId: freezed == coordinatorConnectId
            ? _self.coordinatorConnectId
            : coordinatorConnectId // ignore: cast_nullable_to_non_nullable
                  as String?,
        elapsedTime: freezed == elapsedTime
            ? _self.elapsedTime
            : elapsedTime // ignore: cast_nullable_to_non_nullable
                  as int?,
        eventType: freezed == eventType
            ? _self.eventType
            : eventType // ignore: cast_nullable_to_non_nullable
                  as String?,
        iceState: freezed == iceState
            ? _self.iceState
            : iceState // ignore: cast_nullable_to_non_nullable
                  as String?,
        id: freezed == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        joinAttemptId: freezed == joinAttemptId
            ? _self.joinAttemptId
            : joinAttemptId // ignore: cast_nullable_to_non_nullable
                  as String?,
        microphonePermissionStatus: freezed == microphonePermissionStatus
            ? _self.microphonePermissionStatus
            : microphonePermissionStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        outcome: freezed == outcome
            ? _self.outcome
            : outcome // ignore: cast_nullable_to_non_nullable
                  as String?,
        peerConnection: freezed == peerConnection
            ? _self.peerConnection
            : peerConnection // ignore: cast_nullable_to_non_nullable
                  as String?,
        previouslyConnectedTimestamp: freezed == previouslyConnectedTimestamp
            ? _self.previouslyConnectedTimestamp
            : previouslyConnectedTimestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        retryCountAttempt: freezed == retryCountAttempt
            ? _self.retryCountAttempt
            : retryCountAttempt // ignore: cast_nullable_to_non_nullable
                  as int?,
        retryFailureCode: freezed == retryFailureCode
            ? _self.retryFailureCode
            : retryFailureCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        retryFailureReason: freezed == retryFailureReason
            ? _self.retryFailureReason
            : retryFailureReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        screenShareStatus: freezed == screenShareStatus
            ? _self.screenShareStatus
            : screenShareStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        sdkVersion: freezed == sdkVersion
            ? _self.sdkVersion
            : sdkVersion // ignore: cast_nullable_to_non_nullable
                  as String?,
        sfuId: freezed == sfuId
            ? _self.sfuId
            : sfuId // ignore: cast_nullable_to_non_nullable
                  as String?,
        stage: freezed == stage
            ? _self.stage
            : stage // ignore: cast_nullable_to_non_nullable
                  as String?,
        stageId: freezed == stageId
            ? _self.stageId
            : stageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        timestamp: freezed == timestamp
            ? _self.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        trackId: freezed == trackId
            ? _self.trackId
            : trackId // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: freezed == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
        userAgent: freezed == userAgent
            ? _self.userAgent
            : userAgent // ignore: cast_nullable_to_non_nullable
                  as String?,
        userId: freezed == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
        wasPreviouslyConnected: freezed == wasPreviouslyConnected
            ? _self.wasPreviouslyConnected
            : wasPreviouslyConnected // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}
