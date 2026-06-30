// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_transcription_ready_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallTranscriptionReadyEvent {
  String get callCid;
  CallTranscription get callTranscription;
  DateTime get createdAt;
  String get egressId;
  String get type;

  /// Create a copy of CallTranscriptionReadyEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallTranscriptionReadyEventCopyWith<CallTranscriptionReadyEvent>
  get copyWith =>
      _$CallTranscriptionReadyEventCopyWithImpl<CallTranscriptionReadyEvent>(
        this as CallTranscriptionReadyEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallTranscriptionReadyEvent &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.callTranscription, callTranscription) ||
                other.callTranscription == callTranscription) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.egressId, egressId) ||
                other.egressId == egressId) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callCid,
    callTranscription,
    createdAt,
    egressId,
    type,
  );

  @override
  String toString() {
    return 'CallTranscriptionReadyEvent(callCid: $callCid, callTranscription: $callTranscription, createdAt: $createdAt, egressId: $egressId, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallTranscriptionReadyEventCopyWith<$Res> {
  factory $CallTranscriptionReadyEventCopyWith(
    CallTranscriptionReadyEvent value,
    $Res Function(CallTranscriptionReadyEvent) _then,
  ) = _$CallTranscriptionReadyEventCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    CallTranscription callTranscription,
    DateTime createdAt,
    String egressId,
    String type,
  });
}

/// @nodoc
class _$CallTranscriptionReadyEventCopyWithImpl<$Res>
    implements $CallTranscriptionReadyEventCopyWith<$Res> {
  _$CallTranscriptionReadyEventCopyWithImpl(this._self, this._then);

  final CallTranscriptionReadyEvent _self;
  final $Res Function(CallTranscriptionReadyEvent) _then;

  /// Create a copy of CallTranscriptionReadyEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? callTranscription = null,
    Object? createdAt = null,
    Object? egressId = null,
    Object? type = null,
  }) {
    return _then(
      CallTranscriptionReadyEvent(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        callTranscription: null == callTranscription
            ? _self.callTranscription
            : callTranscription // ignore: cast_nullable_to_non_nullable
                  as CallTranscription,
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
