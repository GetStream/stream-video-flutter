// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hls_settings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HLSSettingsResponse {
  bool get autoOn;
  bool get enabled;
  List<String> get qualityTracks;

  /// Create a copy of HLSSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HLSSettingsResponseCopyWith<HLSSettingsResponse> get copyWith =>
      _$HLSSettingsResponseCopyWithImpl<HLSSettingsResponse>(
        this as HLSSettingsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HLSSettingsResponse &&
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
    return 'HLSSettingsResponse(autoOn: $autoOn, enabled: $enabled, qualityTracks: $qualityTracks)';
  }
}

/// @nodoc
abstract mixin class $HLSSettingsResponseCopyWith<$Res> {
  factory $HLSSettingsResponseCopyWith(
    HLSSettingsResponse value,
    $Res Function(HLSSettingsResponse) _then,
  ) = _$HLSSettingsResponseCopyWithImpl;
  @useResult
  $Res call({bool autoOn, bool enabled, List<String> qualityTracks});
}

/// @nodoc
class _$HLSSettingsResponseCopyWithImpl<$Res>
    implements $HLSSettingsResponseCopyWith<$Res> {
  _$HLSSettingsResponseCopyWithImpl(this._self, this._then);

  final HLSSettingsResponse _self;
  final $Res Function(HLSSettingsResponse) _then;

  /// Create a copy of HLSSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? autoOn = null,
    Object? enabled = null,
    Object? qualityTracks = null,
  }) {
    return _then(
      HLSSettingsResponse(
        autoOn: null == autoOn
            ? _self.autoOn
            : autoOn // ignore: cast_nullable_to_non_nullable
                  as bool,
        enabled: null == enabled
            ? _self.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        qualityTracks: null == qualityTracks
            ? _self.qualityTracks
            : qualityTracks // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}
