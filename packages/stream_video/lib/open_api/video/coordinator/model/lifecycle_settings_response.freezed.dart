// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lifecycle_settings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LifecycleSettingsResponse {
  CallLifecycleMode get mode;

  /// Create a copy of LifecycleSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LifecycleSettingsResponseCopyWith<LifecycleSettingsResponse> get copyWith =>
      _$LifecycleSettingsResponseCopyWithImpl<LifecycleSettingsResponse>(
        this as LifecycleSettingsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LifecycleSettingsResponse &&
            (identical(other.mode, mode) || other.mode == mode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mode);

  @override
  String toString() {
    return 'LifecycleSettingsResponse(mode: $mode)';
  }
}

/// @nodoc
abstract mixin class $LifecycleSettingsResponseCopyWith<$Res> {
  factory $LifecycleSettingsResponseCopyWith(
    LifecycleSettingsResponse value,
    $Res Function(LifecycleSettingsResponse) _then,
  ) = _$LifecycleSettingsResponseCopyWithImpl;
  @useResult
  $Res call({CallLifecycleMode mode});
}

/// @nodoc
class _$LifecycleSettingsResponseCopyWithImpl<$Res>
    implements $LifecycleSettingsResponseCopyWith<$Res> {
  _$LifecycleSettingsResponseCopyWithImpl(this._self, this._then);

  final LifecycleSettingsResponse _self;
  final $Res Function(LifecycleSettingsResponse) _then;

  /// Create a copy of LifecycleSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? mode = null}) {
    return _then(
      LifecycleSettingsResponse(
        mode: null == mode
            ? _self.mode
            : mode // ignore: cast_nullable_to_non_nullable
                  as CallLifecycleMode,
      ),
    );
  }
}
