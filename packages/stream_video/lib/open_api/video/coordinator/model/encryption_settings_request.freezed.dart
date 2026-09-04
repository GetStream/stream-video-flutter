// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'encryption_settings_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EncryptionSettingsRequest {
  EncryptionSettingsRequestMode? get mode;

  /// Create a copy of EncryptionSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EncryptionSettingsRequestCopyWith<EncryptionSettingsRequest> get copyWith =>
      _$EncryptionSettingsRequestCopyWithImpl<EncryptionSettingsRequest>(
        this as EncryptionSettingsRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EncryptionSettingsRequest &&
            (identical(other.mode, mode) || other.mode == mode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mode);

  @override
  String toString() {
    return 'EncryptionSettingsRequest(mode: $mode)';
  }
}

/// @nodoc
abstract mixin class $EncryptionSettingsRequestCopyWith<$Res> {
  factory $EncryptionSettingsRequestCopyWith(
    EncryptionSettingsRequest value,
    $Res Function(EncryptionSettingsRequest) _then,
  ) = _$EncryptionSettingsRequestCopyWithImpl;
  @useResult
  $Res call({EncryptionSettingsRequestMode? mode});
}

/// @nodoc
class _$EncryptionSettingsRequestCopyWithImpl<$Res>
    implements $EncryptionSettingsRequestCopyWith<$Res> {
  _$EncryptionSettingsRequestCopyWithImpl(this._self, this._then);

  final EncryptionSettingsRequest _self;
  final $Res Function(EncryptionSettingsRequest) _then;

  /// Create a copy of EncryptionSettingsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? mode = freezed}) {
    return _then(
      EncryptionSettingsRequest(
        mode: freezed == mode
            ? _self.mode
            : mode // ignore: cast_nullable_to_non_nullable
                  as EncryptionSettingsRequestMode?,
      ),
    );
  }
}
