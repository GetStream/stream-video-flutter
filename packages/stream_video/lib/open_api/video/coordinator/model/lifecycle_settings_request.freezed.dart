// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lifecycle_settings_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LifecycleSettingsRequest {
  CallLifecycleMode? get mode;

  /// Create a copy of LifecycleSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LifecycleSettingsRequestCopyWith<LifecycleSettingsRequest> get copyWith =>
      _$LifecycleSettingsRequestCopyWithImpl<LifecycleSettingsRequest>(
        this as LifecycleSettingsRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LifecycleSettingsRequest &&
            (identical(other.mode, mode) || other.mode == mode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mode);

  @override
  String toString() {
    return 'LifecycleSettingsRequest(mode: $mode)';
  }
}

/// @nodoc
abstract mixin class $LifecycleSettingsRequestCopyWith<$Res> {
  factory $LifecycleSettingsRequestCopyWith(
    LifecycleSettingsRequest value,
    $Res Function(LifecycleSettingsRequest) _then,
  ) = _$LifecycleSettingsRequestCopyWithImpl;
  @useResult
  $Res call({CallLifecycleMode? mode});
}

/// @nodoc
class _$LifecycleSettingsRequestCopyWithImpl<$Res>
    implements $LifecycleSettingsRequestCopyWith<$Res> {
  _$LifecycleSettingsRequestCopyWithImpl(this._self, this._then);

  final LifecycleSettingsRequest _self;
  final $Res Function(LifecycleSettingsRequest) _then;

  /// Create a copy of LifecycleSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? mode = freezed}) {
    return _then(
      LifecycleSettingsRequest(
        mode: freezed == mode
            ? _self.mode
            : mode // ignore: cast_nullable_to_non_nullable
                  as CallLifecycleMode?,
      ),
    );
  }
}
