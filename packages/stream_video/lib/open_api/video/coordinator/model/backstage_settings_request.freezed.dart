// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backstage_settings_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BackstageSettingsRequest {
  bool? get enabled;
  int? get joinAheadTimeSeconds;

  /// Create a copy of BackstageSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BackstageSettingsRequestCopyWith<BackstageSettingsRequest> get copyWith =>
      _$BackstageSettingsRequestCopyWithImpl<BackstageSettingsRequest>(
        this as BackstageSettingsRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BackstageSettingsRequest &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.joinAheadTimeSeconds, joinAheadTimeSeconds) ||
                other.joinAheadTimeSeconds == joinAheadTimeSeconds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, enabled, joinAheadTimeSeconds);

  @override
  String toString() {
    return 'BackstageSettingsRequest(enabled: $enabled, joinAheadTimeSeconds: $joinAheadTimeSeconds)';
  }
}

/// @nodoc
abstract mixin class $BackstageSettingsRequestCopyWith<$Res> {
  factory $BackstageSettingsRequestCopyWith(
    BackstageSettingsRequest value,
    $Res Function(BackstageSettingsRequest) _then,
  ) = _$BackstageSettingsRequestCopyWithImpl;
  @useResult
  $Res call({bool? enabled, int? joinAheadTimeSeconds});
}

/// @nodoc
class _$BackstageSettingsRequestCopyWithImpl<$Res>
    implements $BackstageSettingsRequestCopyWith<$Res> {
  _$BackstageSettingsRequestCopyWithImpl(this._self, this._then);

  final BackstageSettingsRequest _self;
  final $Res Function(BackstageSettingsRequest) _then;

  /// Create a copy of BackstageSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = freezed,
    Object? joinAheadTimeSeconds = freezed,
  }) {
    return _then(
      BackstageSettingsRequest(
        enabled: freezed == enabled
            ? _self.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
        joinAheadTimeSeconds: freezed == joinAheadTimeSeconds
            ? _self.joinAheadTimeSeconds
            : joinAheadTimeSeconds // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}
