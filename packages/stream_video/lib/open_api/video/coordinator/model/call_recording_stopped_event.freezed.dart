// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_recording_stopped_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallRecordingStoppedEvent {
  String get callCid;
  DateTime get createdAt;
  String get egressId;
  CallRecordingStoppedEventRecordingType get recordingType;
  String get type;

  /// Create a copy of CallRecordingStoppedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallRecordingStoppedEventCopyWith<CallRecordingStoppedEvent> get copyWith =>
      _$CallRecordingStoppedEventCopyWithImpl<CallRecordingStoppedEvent>(
        this as CallRecordingStoppedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallRecordingStoppedEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.egressId, egressId) ||
                other.egressId == egressId) &&
            (identical(other.recordingType, recordingType) ||
                other.recordingType == recordingType) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callCid,
    createdAt,
    egressId,
    recordingType,
    type,
  );

  @override
  String toString() {
    return 'CallRecordingStoppedEvent(callCid: $callCid, createdAt: $createdAt, egressId: $egressId, recordingType: $recordingType, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallRecordingStoppedEventCopyWith<$Res> {
  factory $CallRecordingStoppedEventCopyWith(
    CallRecordingStoppedEvent value,
    $Res Function(CallRecordingStoppedEvent) _then,
  ) = _$CallRecordingStoppedEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    DateTime createdAt,
    String egressId,
    CallRecordingStoppedEventRecordingType recordingType,
    String type,
  });
}

/// @nodoc
class _$CallRecordingStoppedEventCopyWithImpl<$Res>
    implements $CallRecordingStoppedEventCopyWith<$Res> {
  _$CallRecordingStoppedEventCopyWithImpl(this._self, this._then);

  final CallRecordingStoppedEvent _self;
  final $Res Function(CallRecordingStoppedEvent) _then;

  /// Create a copy of CallRecordingStoppedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? createdAt = null,
    Object? egressId = null,
    Object? recordingType = null,
    Object? type = null,
  }) {
    return _then(
      CallRecordingStoppedEvent(
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
        recordingType: null == recordingType
            ? _self.recordingType
            : recordingType // ignore: cast_nullable_to_non_nullable
                  as CallRecordingStoppedEventRecordingType,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
