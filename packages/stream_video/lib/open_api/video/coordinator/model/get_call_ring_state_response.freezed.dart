// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_call_ring_state_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetCallRingStateResponse {
  Map<String, DateTime> get acceptedBy;
  String get callCid;
  DateTime? get callEndedAt;
  String get createdByUserId;
  String get duration;
  Map<String, DateTime> get missedBy;
  Map<String, DateTime> get rejectedBy;
  DateTime? get sessionEndedAt;
  String get sessionId;
  DateTime? get sessionStartedAt;

  /// Create a copy of GetCallRingStateResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GetCallRingStateResponseCopyWith<GetCallRingStateResponse> get copyWith =>
      _$GetCallRingStateResponseCopyWithImpl<GetCallRingStateResponse>(
        this as GetCallRingStateResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GetCallRingStateResponse &&
            const DeepCollectionEquality().equals(
              other.acceptedBy,
              acceptedBy,
            ) &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.callEndedAt, callEndedAt) ||
                other.callEndedAt == callEndedAt) &&
            (identical(other.createdByUserId, createdByUserId) ||
                other.createdByUserId == createdByUserId) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            const DeepCollectionEquality().equals(other.missedBy, missedBy) &&
            const DeepCollectionEquality().equals(
              other.rejectedBy,
              rejectedBy,
            ) &&
            (identical(other.sessionEndedAt, sessionEndedAt) ||
                other.sessionEndedAt == sessionEndedAt) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.sessionStartedAt, sessionStartedAt) ||
                other.sessionStartedAt == sessionStartedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(acceptedBy),
    callCid,
    callEndedAt,
    createdByUserId,
    duration,
    const DeepCollectionEquality().hash(missedBy),
    const DeepCollectionEquality().hash(rejectedBy),
    sessionEndedAt,
    sessionId,
    sessionStartedAt,
  );

  @override
  String toString() {
    return 'GetCallRingStateResponse(acceptedBy: $acceptedBy, callCid: $callCid, callEndedAt: $callEndedAt, createdByUserId: $createdByUserId, duration: $duration, missedBy: $missedBy, rejectedBy: $rejectedBy, sessionEndedAt: $sessionEndedAt, sessionId: $sessionId, sessionStartedAt: $sessionStartedAt)';
  }
}

/// @nodoc
abstract mixin class $GetCallRingStateResponseCopyWith<$Res> {
  factory $GetCallRingStateResponseCopyWith(
    GetCallRingStateResponse value,
    $Res Function(GetCallRingStateResponse) _then,
  ) = _$GetCallRingStateResponseCopyWithImpl;
  @useResult
  $Res call({
    Map<String, DateTime> acceptedBy,
    String callCid,
    DateTime? callEndedAt,
    String createdByUserId,
    String duration,
    Map<String, DateTime> missedBy,
    Map<String, DateTime> rejectedBy,
    DateTime? sessionEndedAt,
    String sessionId,
    DateTime? sessionStartedAt,
  });
}

/// @nodoc
class _$GetCallRingStateResponseCopyWithImpl<$Res>
    implements $GetCallRingStateResponseCopyWith<$Res> {
  _$GetCallRingStateResponseCopyWithImpl(this._self, this._then);

  final GetCallRingStateResponse _self;
  final $Res Function(GetCallRingStateResponse) _then;

  /// Create a copy of GetCallRingStateResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? acceptedBy = null,
    Object? callCid = null,
    Object? callEndedAt = freezed,
    Object? createdByUserId = null,
    Object? duration = null,
    Object? missedBy = null,
    Object? rejectedBy = null,
    Object? sessionEndedAt = freezed,
    Object? sessionId = null,
    Object? sessionStartedAt = freezed,
  }) {
    return _then(
      GetCallRingStateResponse(
        acceptedBy: null == acceptedBy
            ? _self.acceptedBy
            : acceptedBy // ignore: cast_nullable_to_non_nullable
                  as Map<String, DateTime>,
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        callEndedAt: freezed == callEndedAt
            ? _self.callEndedAt
            : callEndedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdByUserId: null == createdByUserId
            ? _self.createdByUserId
            : createdByUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        missedBy: null == missedBy
            ? _self.missedBy
            : missedBy // ignore: cast_nullable_to_non_nullable
                  as Map<String, DateTime>,
        rejectedBy: null == rejectedBy
            ? _self.rejectedBy
            : rejectedBy // ignore: cast_nullable_to_non_nullable
                  as Map<String, DateTime>,
        sessionEndedAt: freezed == sessionEndedAt
            ? _self.sessionEndedAt
            : sessionEndedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        sessionId: null == sessionId
            ? _self.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        sessionStartedAt: freezed == sessionStartedAt
            ? _self.sessionStartedAt
            : sessionStartedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}
