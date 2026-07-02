// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'raw_recording_settings_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RawRecordingSettingsRequest {
  bool? get audioOnly;
  RawRecordingSettingsRequestMode get mode;

  /// Create a copy of RawRecordingSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RawRecordingSettingsRequestCopyWith<RawRecordingSettingsRequest>
  get copyWith =>
      _$RawRecordingSettingsRequestCopyWithImpl<RawRecordingSettingsRequest>(
        this as RawRecordingSettingsRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RawRecordingSettingsRequest &&
            (identical(other.audioOnly, audioOnly) ||
                other.audioOnly == audioOnly) &&
            (identical(other.mode, mode) || other.mode == mode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, audioOnly, mode);

  @override
  String toString() {
    return 'RawRecordingSettingsRequest(audioOnly: $audioOnly, mode: $mode)';
  }
}

/// @nodoc
abstract mixin class $RawRecordingSettingsRequestCopyWith<$Res> {
  factory $RawRecordingSettingsRequestCopyWith(
    RawRecordingSettingsRequest value,
    $Res Function(RawRecordingSettingsRequest) _then,
  ) = _$RawRecordingSettingsRequestCopyWithImpl;
  @useResult
  $Res call({bool? audioOnly, RawRecordingSettingsRequestMode mode});
}

/// @nodoc
class _$RawRecordingSettingsRequestCopyWithImpl<$Res>
    implements $RawRecordingSettingsRequestCopyWith<$Res> {
  _$RawRecordingSettingsRequestCopyWithImpl(this._self, this._then);

  final RawRecordingSettingsRequest _self;
  final $Res Function(RawRecordingSettingsRequest) _then;

  /// Create a copy of RawRecordingSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? audioOnly = freezed, Object? mode = null}) {
    return _then(
      RawRecordingSettingsRequest(
        audioOnly: freezed == audioOnly
            ? _self.audioOnly
            : audioOnly // ignore: cast_nullable_to_non_nullable
                  as bool?,
        mode: null == mode
            ? _self.mode
            : mode // ignore: cast_nullable_to_non_nullable
                  as RawRecordingSettingsRequestMode,
      ),
    );
  }
}
