// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'thumbnails_settings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ThumbnailsSettingsResponse {
  bool get enabled;

  /// Create a copy of ThumbnailsSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ThumbnailsSettingsResponseCopyWith<ThumbnailsSettingsResponse>
  get copyWith =>
      _$ThumbnailsSettingsResponseCopyWithImpl<ThumbnailsSettingsResponse>(
        this as ThumbnailsSettingsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ThumbnailsSettingsResponse &&
            (identical(other.enabled, enabled) || other.enabled == enabled));
  }

  @override
  int get hashCode => Object.hash(runtimeType, enabled);

  @override
  String toString() {
    return 'ThumbnailsSettingsResponse(enabled: $enabled)';
  }
}

/// @nodoc
abstract mixin class $ThumbnailsSettingsResponseCopyWith<$Res> {
  factory $ThumbnailsSettingsResponseCopyWith(
    ThumbnailsSettingsResponse value,
    $Res Function(ThumbnailsSettingsResponse) _then,
  ) = _$ThumbnailsSettingsResponseCopyWithImpl;
  @useResult
  $Res call({bool enabled});
}

/// @nodoc
class _$ThumbnailsSettingsResponseCopyWithImpl<$Res>
    implements $ThumbnailsSettingsResponseCopyWith<$Res> {
  _$ThumbnailsSettingsResponseCopyWithImpl(this._self, this._then);

  final ThumbnailsSettingsResponse _self;
  final $Res Function(ThumbnailsSettingsResponse) _then;

  /// Create a copy of ThumbnailsSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? enabled = null}) {
    return _then(
      ThumbnailsSettingsResponse(
        enabled: null == enabled
            ? _self.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
