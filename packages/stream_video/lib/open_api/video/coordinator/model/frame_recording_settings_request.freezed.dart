// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'frame_recording_settings_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FrameRecordingSettingsRequest {
  int get captureIntervalInSeconds;
  FrameRecordingSettingsRequestMode get mode;
  FrameRecordingSettingsRequestQuality? get quality;

  /// Create a copy of FrameRecordingSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FrameRecordingSettingsRequestCopyWith<FrameRecordingSettingsRequest>
  get copyWith =>
      _$FrameRecordingSettingsRequestCopyWithImpl<
        FrameRecordingSettingsRequest
      >(this as FrameRecordingSettingsRequest, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FrameRecordingSettingsRequest &&
            (identical(
                  other.captureIntervalInSeconds,
                  captureIntervalInSeconds,
                ) ||
                other.captureIntervalInSeconds == captureIntervalInSeconds) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.quality, quality) || other.quality == quality));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, captureIntervalInSeconds, mode, quality);

  @override
  String toString() {
    return 'FrameRecordingSettingsRequest(captureIntervalInSeconds: $captureIntervalInSeconds, mode: $mode, quality: $quality)';
  }
}

/// @nodoc
abstract mixin class $FrameRecordingSettingsRequestCopyWith<$Res> {
  factory $FrameRecordingSettingsRequestCopyWith(
    FrameRecordingSettingsRequest value,
    $Res Function(FrameRecordingSettingsRequest) _then,
  ) = _$FrameRecordingSettingsRequestCopyWithImpl;
  @useResult
  $Res call({
    int captureIntervalInSeconds,
    FrameRecordingSettingsRequestMode mode,
    FrameRecordingSettingsRequestQuality? quality,
  });
}

/// @nodoc
class _$FrameRecordingSettingsRequestCopyWithImpl<$Res>
    implements $FrameRecordingSettingsRequestCopyWith<$Res> {
  _$FrameRecordingSettingsRequestCopyWithImpl(this._self, this._then);

  final FrameRecordingSettingsRequest _self;
  final $Res Function(FrameRecordingSettingsRequest) _then;

  /// Create a copy of FrameRecordingSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? captureIntervalInSeconds = null,
    Object? mode = null,
    Object? quality = freezed,
  }) {
    return _then(
      FrameRecordingSettingsRequest(
        captureIntervalInSeconds: null == captureIntervalInSeconds
            ? _self.captureIntervalInSeconds
            : captureIntervalInSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        mode: null == mode
            ? _self.mode
            : mode // ignore: cast_nullable_to_non_nullable
                  as FrameRecordingSettingsRequestMode,
        quality: freezed == quality
            ? _self.quality
            : quality // ignore: cast_nullable_to_non_nullable
                  as FrameRecordingSettingsRequestQuality?,
      ),
    );
  }
}
