// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_recording_started_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallRecordingStartedEvent {
  String get callCid;
  DateTime get createdAt;
  String get egressId;
  CallRecordingStartedEventRecordingType get recordingType;
  String get type;

  /// Create a copy of CallRecordingStartedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallRecordingStartedEventCopyWith<CallRecordingStartedEvent> get copyWith =>
      _$CallRecordingStartedEventCopyWithImpl<CallRecordingStartedEvent>(
        this as CallRecordingStartedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallRecordingStartedEvent &&
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
    return 'CallRecordingStartedEvent(callCid: $callCid, createdAt: $createdAt, egressId: $egressId, recordingType: $recordingType, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallRecordingStartedEventCopyWith<$Res> {
  factory $CallRecordingStartedEventCopyWith(
    CallRecordingStartedEvent value,
    $Res Function(CallRecordingStartedEvent) _then,
  ) = _$CallRecordingStartedEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    DateTime createdAt,
    String egressId,
    CallRecordingStartedEventRecordingType recordingType,
    String type,
  });
}

/// @nodoc
class _$CallRecordingStartedEventCopyWithImpl<$Res>
    implements $CallRecordingStartedEventCopyWith<$Res> {
  _$CallRecordingStartedEventCopyWithImpl(this._self, this._then);

  final CallRecordingStartedEvent _self;
  final $Res Function(CallRecordingStartedEvent) _then;

  /// Create a copy of CallRecordingStartedEvent
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
      CallRecordingStartedEvent(
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
                  as CallRecordingStartedEventRecordingType,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
