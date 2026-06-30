// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_frame_recording_frame_ready_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallFrameRecordingFrameReadyEvent {
  String get callCid;
  DateTime get capturedAt;
  DateTime get createdAt;
  String get egressId;
  String get sessionId;
  String get trackType;
  String get type;
  String get url;
  Map<String, UserResponse> get users;

  /// Create a copy of CallFrameRecordingFrameReadyEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallFrameRecordingFrameReadyEventCopyWith<CallFrameRecordingFrameReadyEvent>
  get copyWith =>
      _$CallFrameRecordingFrameReadyEventCopyWithImpl<
        CallFrameRecordingFrameReadyEvent
      >(this as CallFrameRecordingFrameReadyEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallFrameRecordingFrameReadyEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.capturedAt, capturedAt) ||
                other.capturedAt == capturedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.egressId, egressId) ||
                other.egressId == egressId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.trackType, trackType) ||
                other.trackType == trackType) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.url, url) || other.url == url) &&
            const DeepCollectionEquality().equals(other.users, users));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callCid,
    capturedAt,
    createdAt,
    egressId,
    sessionId,
    trackType,
    type,
    url,
    const DeepCollectionEquality().hash(users),
  );

  @override
  String toString() {
    return 'CallFrameRecordingFrameReadyEvent(callCid: $callCid, capturedAt: $capturedAt, createdAt: $createdAt, egressId: $egressId, sessionId: $sessionId, trackType: $trackType, type: $type, url: $url, users: $users)';
  }
}

/// @nodoc
abstract mixin class $CallFrameRecordingFrameReadyEventCopyWith<$Res> {
  factory $CallFrameRecordingFrameReadyEventCopyWith(
    CallFrameRecordingFrameReadyEvent value,
    $Res Function(CallFrameRecordingFrameReadyEvent) _then,
  ) = _$CallFrameRecordingFrameReadyEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    DateTime capturedAt,
    DateTime createdAt,
    String egressId,
    String sessionId,
    String trackType,
    String type,
    String url,
    Map<String, UserResponse> users,
  });
}

/// @nodoc
class _$CallFrameRecordingFrameReadyEventCopyWithImpl<$Res>
    implements $CallFrameRecordingFrameReadyEventCopyWith<$Res> {
  _$CallFrameRecordingFrameReadyEventCopyWithImpl(this._self, this._then);

  final CallFrameRecordingFrameReadyEvent _self;
  final $Res Function(CallFrameRecordingFrameReadyEvent) _then;

  /// Create a copy of CallFrameRecordingFrameReadyEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? capturedAt = null,
    Object? createdAt = null,
    Object? egressId = null,
    Object? sessionId = null,
    Object? trackType = null,
    Object? type = null,
    Object? url = null,
    Object? users = null,
  }) {
    return _then(
      CallFrameRecordingFrameReadyEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        capturedAt: null == capturedAt
            ? _self.capturedAt
            : capturedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        egressId: null == egressId
            ? _self.egressId
            : egressId // ignore: cast_nullable_to_non_nullable
                  as String,
        sessionId: null == sessionId
            ? _self.sessionId
            : sessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        trackType: null == trackType
            ? _self.trackType
            : trackType // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        url: null == url
            ? _self.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        users: null == users
            ? _self.users
            : users // ignore: cast_nullable_to_non_nullable
                  as Map<String, UserResponse>,
      ),
    );
  }
}
