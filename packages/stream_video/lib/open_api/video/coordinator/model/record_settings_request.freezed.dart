// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_settings_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecordSettingsRequest {
  bool? get audioOnly;
  RecordSettingsRequestMode get mode;
  RecordSettingsRequestQuality? get quality;

  /// Create a copy of RecordSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecordSettingsRequestCopyWith<RecordSettingsRequest> get copyWith =>
      _$RecordSettingsRequestCopyWithImpl<RecordSettingsRequest>(
        this as RecordSettingsRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecordSettingsRequest &&
            (identical(other.audioOnly, audioOnly) ||
                other.audioOnly == audioOnly) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.quality, quality) || other.quality == quality));
  }

  @override
  int get hashCode => Object.hash(runtimeType, audioOnly, mode, quality);

  @override
  String toString() {
    return 'RecordSettingsRequest(audioOnly: $audioOnly, mode: $mode, quality: $quality)';
  }
}

/// @nodoc
abstract mixin class $RecordSettingsRequestCopyWith<$Res> {
  factory $RecordSettingsRequestCopyWith(
    RecordSettingsRequest value,
    $Res Function(RecordSettingsRequest) _then,
  ) = _$RecordSettingsRequestCopyWithImpl;
  @useResult
  $Res call({
    bool? audioOnly,
    RecordSettingsRequestMode mode,
    RecordSettingsRequestQuality? quality,
  });
}

/// @nodoc
class _$RecordSettingsRequestCopyWithImpl<$Res>
    implements $RecordSettingsRequestCopyWith<$Res> {
  _$RecordSettingsRequestCopyWithImpl(this._self, this._then);

  final RecordSettingsRequest _self;
  final $Res Function(RecordSettingsRequest) _then;

  /// Create a copy of RecordSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? audioOnly = freezed,
    Object? mode = null,
    Object? quality = freezed,
  }) {
    return _then(
      RecordSettingsRequest(
        audioOnly: freezed == audioOnly
            ? _self.audioOnly
            : audioOnly // ignore: cast_nullable_to_non_nullable
                  as bool?,
        mode: null == mode
            ? _self.mode
            : mode // ignore: cast_nullable_to_non_nullable
                  as RecordSettingsRequestMode,
        quality: freezed == quality
            ? _self.quality
            : quality // ignore: cast_nullable_to_non_nullable
                  as RecordSettingsRequestQuality?,
      ),
    );
  }
}
