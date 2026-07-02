// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_settings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecordSettingsResponse {
  bool get audioOnly;
  String get mode;
  String get quality;

  /// Create a copy of RecordSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecordSettingsResponseCopyWith<RecordSettingsResponse> get copyWith =>
      _$RecordSettingsResponseCopyWithImpl<RecordSettingsResponse>(
        this as RecordSettingsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecordSettingsResponse &&
            (identical(other.audioOnly, audioOnly) ||
                other.audioOnly == audioOnly) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.quality, quality) || other.quality == quality));
  }

  @override
  int get hashCode => Object.hash(runtimeType, audioOnly, mode, quality);

  @override
  String toString() {
    return 'RecordSettingsResponse(audioOnly: $audioOnly, mode: $mode, quality: $quality)';
  }
}

/// @nodoc
abstract mixin class $RecordSettingsResponseCopyWith<$Res> {
  factory $RecordSettingsResponseCopyWith(
    RecordSettingsResponse value,
    $Res Function(RecordSettingsResponse) _then,
  ) = _$RecordSettingsResponseCopyWithImpl;
  @useResult
  $Res call({bool audioOnly, String mode, String quality});
}

/// @nodoc
class _$RecordSettingsResponseCopyWithImpl<$Res>
    implements $RecordSettingsResponseCopyWith<$Res> {
  _$RecordSettingsResponseCopyWithImpl(this._self, this._then);

  final RecordSettingsResponse _self;
  final $Res Function(RecordSettingsResponse) _then;

  /// Create a copy of RecordSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? audioOnly = null,
    Object? mode = null,
    Object? quality = null,
  }) {
    return _then(
      RecordSettingsResponse(
        audioOnly: null == audioOnly
            ? _self.audioOnly
            : audioOnly // ignore: cast_nullable_to_non_nullable
                  as bool,
        mode: null == mode
            ? _self.mode
            : mode // ignore: cast_nullable_to_non_nullable
                  as String,
        quality: null == quality
            ? _self.quality
            : quality // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
