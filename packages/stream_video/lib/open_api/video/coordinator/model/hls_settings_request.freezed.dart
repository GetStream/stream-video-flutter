// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hls_settings_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HLSSettingsRequest {
  bool? get autoOn;
  bool? get enabled;
  List<HLSSettingsRequestQualityTracks> get qualityTracks;

  /// Create a copy of HLSSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HLSSettingsRequestCopyWith<HLSSettingsRequest> get copyWith =>
      _$HLSSettingsRequestCopyWithImpl<HLSSettingsRequest>(
        this as HLSSettingsRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HLSSettingsRequest &&
            (identical(other.autoOn, autoOn) || other.autoOn == autoOn) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            const DeepCollectionEquality().equals(
              other.qualityTracks,
              qualityTracks,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    autoOn,
    enabled,
    const DeepCollectionEquality().hash(qualityTracks),
  );

  @override
  String toString() {
    return 'HLSSettingsRequest(autoOn: $autoOn, enabled: $enabled, qualityTracks: $qualityTracks)';
  }
}

/// @nodoc
abstract mixin class $HLSSettingsRequestCopyWith<$Res> {
  factory $HLSSettingsRequestCopyWith(
    HLSSettingsRequest value,
    $Res Function(HLSSettingsRequest) _then,
  ) = _$HLSSettingsRequestCopyWithImpl;
  @useResult
  $Res call({
    bool? autoOn,
    bool? enabled,
    List<HLSSettingsRequestQualityTracks> qualityTracks,
  });
}

/// @nodoc
class _$HLSSettingsRequestCopyWithImpl<$Res>
    implements $HLSSettingsRequestCopyWith<$Res> {
  _$HLSSettingsRequestCopyWithImpl(this._self, this._then);

  final HLSSettingsRequest _self;
  final $Res Function(HLSSettingsRequest) _then;

  /// Create a copy of HLSSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? autoOn = freezed,
    Object? enabled = freezed,
    Object? qualityTracks = null,
  }) {
    return _then(
      HLSSettingsRequest(
        autoOn: freezed == autoOn
            ? _self.autoOn
            : autoOn // ignore: cast_nullable_to_non_nullable
                  as bool?,
        enabled: freezed == enabled
            ? _self.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
        qualityTracks: null == qualityTracks
            ? _self.qualityTracks
            : qualityTracks // ignore: cast_nullable_to_non_nullable
                  as List<HLSSettingsRequestQualityTracks>,
      ),
    );
  }
}
