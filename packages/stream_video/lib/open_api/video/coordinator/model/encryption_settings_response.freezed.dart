// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'encryption_settings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EncryptionSettingsResponse {
  EncryptionSettingsResponseMode get mode;

  /// Create a copy of EncryptionSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EncryptionSettingsResponseCopyWith<EncryptionSettingsResponse>
  get copyWith =>
      _$EncryptionSettingsResponseCopyWithImpl<EncryptionSettingsResponse>(
        this as EncryptionSettingsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EncryptionSettingsResponse &&
            (identical(other.mode, mode) || other.mode == mode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mode);

  @override
  String toString() {
    return 'EncryptionSettingsResponse(mode: $mode)';
  }
}

/// @nodoc
abstract mixin class $EncryptionSettingsResponseCopyWith<$Res> {
  factory $EncryptionSettingsResponseCopyWith(
    EncryptionSettingsResponse value,
    $Res Function(EncryptionSettingsResponse) _then,
  ) = _$EncryptionSettingsResponseCopyWithImpl;
  @useResult
  $Res call({EncryptionSettingsResponseMode mode});
}

/// @nodoc
class _$EncryptionSettingsResponseCopyWithImpl<$Res>
    implements $EncryptionSettingsResponseCopyWith<$Res> {
  _$EncryptionSettingsResponseCopyWithImpl(this._self, this._then);

  final EncryptionSettingsResponse _self;
  final $Res Function(EncryptionSettingsResponse) _then;

  /// Create a copy of EncryptionSettingsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? mode = null}) {
    return _then(
      EncryptionSettingsResponse(
        mode: null == mode
            ? _self.mode
            : mode // ignore: cast_nullable_to_non_nullable
                  as EncryptionSettingsResponseMode,
      ),
    );
  }
}
