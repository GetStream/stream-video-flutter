// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'screensharing_settings_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScreensharingSettingsRequest {
  bool? get accessRequestEnabled;
  bool? get enabled;
  TargetResolution? get targetResolution;

  /// Create a copy of ScreensharingSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScreensharingSettingsRequestCopyWith<ScreensharingSettingsRequest>
  get copyWith =>
      _$ScreensharingSettingsRequestCopyWithImpl<ScreensharingSettingsRequest>(
        this as ScreensharingSettingsRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ScreensharingSettingsRequest &&
            (identical(other.accessRequestEnabled, accessRequestEnabled) ||
                other.accessRequestEnabled == accessRequestEnabled) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.targetResolution, targetResolution) ||
                other.targetResolution == targetResolution));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, accessRequestEnabled, enabled, targetResolution);

  @override
  String toString() {
    return 'ScreensharingSettingsRequest(accessRequestEnabled: $accessRequestEnabled, enabled: $enabled, targetResolution: $targetResolution)';
  }
}

/// @nodoc
abstract mixin class $ScreensharingSettingsRequestCopyWith<$Res> {
  factory $ScreensharingSettingsRequestCopyWith(
    ScreensharingSettingsRequest value,
    $Res Function(ScreensharingSettingsRequest) _then,
  ) = _$ScreensharingSettingsRequestCopyWithImpl;
  @useResult
  $Res call({
    bool? accessRequestEnabled,
    bool? enabled,
    TargetResolution? targetResolution,
  });
}

/// @nodoc
class _$ScreensharingSettingsRequestCopyWithImpl<$Res>
    implements $ScreensharingSettingsRequestCopyWith<$Res> {
  _$ScreensharingSettingsRequestCopyWithImpl(this._self, this._then);

  final ScreensharingSettingsRequest _self;
  final $Res Function(ScreensharingSettingsRequest) _then;

  /// Create a copy of ScreensharingSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessRequestEnabled = freezed,
    Object? enabled = freezed,
    Object? targetResolution = freezed,
  }) {
    return _then(
      ScreensharingSettingsRequest(
        accessRequestEnabled: freezed == accessRequestEnabled
            ? _self.accessRequestEnabled
            : accessRequestEnabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
        enabled: freezed == enabled
            ? _self.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
        targetResolution: freezed == targetResolution
            ? _self.targetResolution
            : targetResolution // ignore: cast_nullable_to_non_nullable
                  as TargetResolution?,
      ),
    );
  }
}
