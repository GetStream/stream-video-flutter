// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_frame_recording_started_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallFrameRecordingStartedEvent {
  CallResponse get call;
  String get callCid;
  DateTime get createdAt;
  String get egressId;
  String get type;

  /// Create a copy of CallFrameRecordingStartedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallFrameRecordingStartedEventCopyWith<CallFrameRecordingStartedEvent>
  get copyWith =>
      _$CallFrameRecordingStartedEventCopyWithImpl<
        CallFrameRecordingStartedEvent
      >(this as CallFrameRecordingStartedEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallFrameRecordingStartedEvent &&
            (identical(other.call, call) || other.call == call) &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.egressId, egressId) ||
                other.egressId == egressId) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, call, callCid, createdAt, egressId, type);

  @override
  String toString() {
    return 'CallFrameRecordingStartedEvent(call: $call, callCid: $callCid, createdAt: $createdAt, egressId: $egressId, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallFrameRecordingStartedEventCopyWith<$Res> {
  factory $CallFrameRecordingStartedEventCopyWith(
    CallFrameRecordingStartedEvent value,
    $Res Function(CallFrameRecordingStartedEvent) _then,
  ) = _$CallFrameRecordingStartedEventCopyWithImpl;
  @useResult
  $Res call({
    CallResponse call,
    String callCid,
    DateTime createdAt,
    String egressId,
    String type,
  });
}

/// @nodoc
class _$CallFrameRecordingStartedEventCopyWithImpl<$Res>
    implements $CallFrameRecordingStartedEventCopyWith<$Res> {
  _$CallFrameRecordingStartedEventCopyWithImpl(this._self, this._then);

  final CallFrameRecordingStartedEvent _self;
  final $Res Function(CallFrameRecordingStartedEvent) _then;

  /// Create a copy of CallFrameRecordingStartedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? call = null,
    Object? callCid = null,
    Object? createdAt = null,
    Object? egressId = null,
    Object? type = null,
  }) {
    return _then(
      CallFrameRecordingStartedEvent(
        call: null == call
            ? _self.call
            : call // ignore: cast_nullable_to_non_nullable
                  as CallResponse,
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        egressId: null == egressId
            ? _self.egressId
            : egressId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
