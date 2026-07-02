// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rtmp_settings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RTMPSettingsResponse {
  bool get enabled;
  String get quality;

  /// Create a copy of RTMPSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RTMPSettingsResponseCopyWith<RTMPSettingsResponse> get copyWith =>
      _$RTMPSettingsResponseCopyWithImpl<RTMPSettingsResponse>(
        this as RTMPSettingsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RTMPSettingsResponse &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.quality, quality) || other.quality == quality));
  }

  @override
  int get hashCode => Object.hash(runtimeType, enabled, quality);

  @override
  String toString() {
    return 'RTMPSettingsResponse(enabled: $enabled, quality: $quality)';
  }
}

/// @nodoc
abstract mixin class $RTMPSettingsResponseCopyWith<$Res> {
  factory $RTMPSettingsResponseCopyWith(
    RTMPSettingsResponse value,
    $Res Function(RTMPSettingsResponse) _then,
  ) = _$RTMPSettingsResponseCopyWithImpl;
  @useResult
  $Res call({bool enabled, String quality});
}

/// @nodoc
class _$RTMPSettingsResponseCopyWithImpl<$Res>
    implements $RTMPSettingsResponseCopyWith<$Res> {
  _$RTMPSettingsResponseCopyWithImpl(this._self, this._then);

  final RTMPSettingsResponse _self;
  final $Res Function(RTMPSettingsResponse) _then;

  /// Create a copy of RTMPSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? enabled = null, Object? quality = null}) {
    return _then(
      RTMPSettingsResponse(
        enabled: null == enabled
            ? _self.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        quality: null == quality
            ? _self.quality
            : quality // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
