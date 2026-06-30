// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_participant_timeline.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallParticipantTimeline {
  Map<String, Object?> get data;
  String get severity;
  DateTime get timestamp;
  String get type;

  /// Create a copy of CallParticipantTimeline
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallParticipantTimelineCopyWith<CallParticipantTimeline> get copyWith =>
      _$CallParticipantTimelineCopyWithImpl<CallParticipantTimeline>(
        this as CallParticipantTimeline,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallParticipantTimeline &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(data),
    severity,
    timestamp,
    type,
  );

  @override
  String toString() {
    return 'CallParticipantTimeline(data: $data, severity: $severity, timestamp: $timestamp, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CallParticipantTimelineCopyWith<$Res> {
  factory $CallParticipantTimelineCopyWith(
    CallParticipantTimeline value,
    $Res Function(CallParticipantTimeline) _then,
  ) = _$CallParticipantTimelineCopyWithImpl;
  @useResult
  $Res call({
    Map<String, Object?> data,
    String severity,
    DateTime timestamp,
    String type,
  });
}

/// @nodoc
class _$CallParticipantTimelineCopyWithImpl<$Res>
    implements $CallParticipantTimelineCopyWith<$Res> {
  _$CallParticipantTimelineCopyWithImpl(this._self, this._then);

  final CallParticipantTimeline _self;
  final $Res Function(CallParticipantTimeline) _then;

  /// Create a copy of CallParticipantTimeline
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? severity = null,
    Object? timestamp = null,
    Object? type = null,
  }) {
    return _then(
      CallParticipantTimeline(
        data: null == data
            ? _self.data
            : data // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        severity: null == severity
            ? _self.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _self.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
