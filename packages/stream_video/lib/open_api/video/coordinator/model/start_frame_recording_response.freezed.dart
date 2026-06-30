// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'start_frame_recording_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StartFrameRecordingResponse {
  String get duration;

  /// Create a copy of StartFrameRecordingResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StartFrameRecordingResponseCopyWith<StartFrameRecordingResponse>
  get copyWith =>
      _$StartFrameRecordingResponseCopyWithImpl<StartFrameRecordingResponse>(
        this as StartFrameRecordingResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StartFrameRecordingResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration);

  @override
  String toString() {
    return 'StartFrameRecordingResponse(duration: $duration)';
  }
}

/// @nodoc
abstract mixin class $StartFrameRecordingResponseCopyWith<$Res> {
  factory $StartFrameRecordingResponseCopyWith(
    StartFrameRecordingResponse value,
    $Res Function(StartFrameRecordingResponse) _then,
  ) = _$StartFrameRecordingResponseCopyWithImpl;
  @useResult
  $Res call({String duration});
}

/// @nodoc
class _$StartFrameRecordingResponseCopyWithImpl<$Res>
    implements $StartFrameRecordingResponseCopyWith<$Res> {
  _$StartFrameRecordingResponseCopyWithImpl(this._self, this._then);

  final StartFrameRecordingResponse _self;
  final $Res Function(StartFrameRecordingResponse) _then;

  /// Create a copy of StartFrameRecordingResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null}) {
    return _then(
      StartFrameRecordingResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
