// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rtmp_settings_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RTMPSettingsRequest {
  bool? get enabled;
  RTMPSettingsRequestQuality? get quality;

  /// Create a copy of RTMPSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RTMPSettingsRequestCopyWith<RTMPSettingsRequest> get copyWith =>
      _$RTMPSettingsRequestCopyWithImpl<RTMPSettingsRequest>(
        this as RTMPSettingsRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RTMPSettingsRequest &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.quality, quality) || other.quality == quality));
  }

  @override
  int get hashCode => Object.hash(runtimeType, enabled, quality);

  @override
  String toString() {
    return 'RTMPSettingsRequest(enabled: $enabled, quality: $quality)';
  }
}

/// @nodoc
abstract mixin class $RTMPSettingsRequestCopyWith<$Res> {
  factory $RTMPSettingsRequestCopyWith(
    RTMPSettingsRequest value,
    $Res Function(RTMPSettingsRequest) _then,
  ) = _$RTMPSettingsRequestCopyWithImpl;
  @useResult
  $Res call({bool? enabled, RTMPSettingsRequestQuality? quality});
}

/// @nodoc
class _$RTMPSettingsRequestCopyWithImpl<$Res>
    implements $RTMPSettingsRequestCopyWith<$Res> {
  _$RTMPSettingsRequestCopyWithImpl(this._self, this._then);

  final RTMPSettingsRequest _self;
  final $Res Function(RTMPSettingsRequest) _then;

  /// Create a copy of RTMPSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? enabled = freezed, Object? quality = freezed}) {
    return _then(
      RTMPSettingsRequest(
        enabled: freezed == enabled
            ? _self.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
        quality: freezed == quality
            ? _self.quality
            : quality // ignore: cast_nullable_to_non_nullable
                  as RTMPSettingsRequestQuality?,
      ),
    );
  }
}
