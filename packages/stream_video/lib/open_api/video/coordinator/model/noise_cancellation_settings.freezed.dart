// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'noise_cancellation_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NoiseCancellationSettings {
  NoiseCancellationSettingsMode get mode;

  /// Create a copy of NoiseCancellationSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NoiseCancellationSettingsCopyWith<NoiseCancellationSettings> get copyWith =>
      _$NoiseCancellationSettingsCopyWithImpl<NoiseCancellationSettings>(
        this as NoiseCancellationSettings,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NoiseCancellationSettings &&
            (identical(other.mode, mode) || other.mode == mode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mode);

  @override
  String toString() {
    return 'NoiseCancellationSettings(mode: $mode)';
  }
}

/// @nodoc
abstract mixin class $NoiseCancellationSettingsCopyWith<$Res> {
  factory $NoiseCancellationSettingsCopyWith(
    NoiseCancellationSettings value,
    $Res Function(NoiseCancellationSettings) _then,
  ) = _$NoiseCancellationSettingsCopyWithImpl;
  @useResult
  $Res call({NoiseCancellationSettingsMode mode});
}

/// @nodoc
class _$NoiseCancellationSettingsCopyWithImpl<$Res>
    implements $NoiseCancellationSettingsCopyWith<$Res> {
  _$NoiseCancellationSettingsCopyWithImpl(this._self, this._then);

  final NoiseCancellationSettings _self;
  final $Res Function(NoiseCancellationSettings) _then;

  /// Create a copy of NoiseCancellationSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? mode = null}) {
    return _then(
      NoiseCancellationSettings(
        mode: null == mode
            ? _self.mode
            : mode // ignore: cast_nullable_to_non_nullable
                  as NoiseCancellationSettingsMode,
      ),
    );
  }
}
