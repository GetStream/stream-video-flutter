// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'whip_ingress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WHIPIngress {
  String get address;

  /// Create a copy of WHIPIngress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WHIPIngressCopyWith<WHIPIngress> get copyWith =>
      _$WHIPIngressCopyWithImpl<WHIPIngress>(this as WHIPIngress, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WHIPIngress &&
            (identical(other.address, address) || other.address == address));
  }

  @override
  int get hashCode => Object.hash(runtimeType, address);

  @override
  String toString() {
    return 'WHIPIngress(address: $address)';
  }
}

/// @nodoc
abstract mixin class $WHIPIngressCopyWith<$Res> {
  factory $WHIPIngressCopyWith(
    WHIPIngress value,
    $Res Function(WHIPIngress) _then,
  ) = _$WHIPIngressCopyWithImpl;
  @useResult
  $Res call({String address});
}

/// @nodoc
class _$WHIPIngressCopyWithImpl<$Res> implements $WHIPIngressCopyWith<$Res> {
  _$WHIPIngressCopyWithImpl(this._self, this._then);

  final WHIPIngress _self;
  final $Res Function(WHIPIngress) _then;

  /// Create a copy of WHIPIngress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? address = null}) {
    return _then(
      WHIPIngress(
        address: null == address
            ? _self.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
