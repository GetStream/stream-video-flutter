// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_settings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoSettingsResponse {
  bool get accessRequestEnabled;
  bool get cameraDefaultOn;
  VideoSettingsResponseCameraFacing get cameraFacing;
  bool get enabled;
  TargetResolution get targetResolution;

  /// Create a copy of VideoSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VideoSettingsResponseCopyWith<VideoSettingsResponse> get copyWith =>
      _$VideoSettingsResponseCopyWithImpl<VideoSettingsResponse>(
        this as VideoSettingsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VideoSettingsResponse &&
            (identical(other.accessRequestEnabled, accessRequestEnabled) ||
                other.accessRequestEnabled == accessRequestEnabled) &&
            (identical(other.cameraDefaultOn, cameraDefaultOn) ||
                other.cameraDefaultOn == cameraDefaultOn) &&
            (identical(other.cameraFacing, cameraFacing) ||
                other.cameraFacing == cameraFacing) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.targetResolution, targetResolution) ||
                other.targetResolution == targetResolution));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    accessRequestEnabled,
    cameraDefaultOn,
    cameraFacing,
    enabled,
    targetResolution,
  );

  @override
  String toString() {
    return 'VideoSettingsResponse(accessRequestEnabled: $accessRequestEnabled, cameraDefaultOn: $cameraDefaultOn, cameraFacing: $cameraFacing, enabled: $enabled, targetResolution: $targetResolution)';
  }
}

/// @nodoc
abstract mixin class $VideoSettingsResponseCopyWith<$Res> {
  factory $VideoSettingsResponseCopyWith(
    VideoSettingsResponse value,
    $Res Function(VideoSettingsResponse) _then,
  ) = _$VideoSettingsResponseCopyWithImpl;
  @useResult
  $Res call({
    bool accessRequestEnabled,
    bool cameraDefaultOn,
    VideoSettingsResponseCameraFacing cameraFacing,
    bool enabled,
    TargetResolution targetResolution,
  });
}

/// @nodoc
class _$VideoSettingsResponseCopyWithImpl<$Res>
    implements $VideoSettingsResponseCopyWith<$Res> {
  _$VideoSettingsResponseCopyWithImpl(this._self, this._then);

  final VideoSettingsResponse _self;
  final $Res Function(VideoSettingsResponse) _then;

  /// Create a copy of VideoSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessRequestEnabled = null,
    Object? cameraDefaultOn = null,
    Object? cameraFacing = null,
    Object? enabled = null,
    Object? targetResolution = null,
  }) {
    return _then(
      VideoSettingsResponse(
        accessRequestEnabled: null == accessRequestEnabled
            ? _self.accessRequestEnabled
            : accessRequestEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        cameraDefaultOn: null == cameraDefaultOn
            ? _self.cameraDefaultOn
            : cameraDefaultOn // ignore: cast_nullable_to_non_nullable
                  as bool,
        cameraFacing: null == cameraFacing
            ? _self.cameraFacing
            : cameraFacing // ignore: cast_nullable_to_non_nullable
                  as VideoSettingsResponseCameraFacing,
        enabled: null == enabled
            ? _self.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        targetResolution: null == targetResolution
            ? _self.targetResolution
            : targetResolution // ignore: cast_nullable_to_non_nullable
                  as TargetResolution,
      ),
    );
  }
}
