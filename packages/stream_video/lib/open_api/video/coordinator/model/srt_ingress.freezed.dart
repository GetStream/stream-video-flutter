// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'srt_ingress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SRTIngress {
  String get address;

  /// Create a copy of SRTIngress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SRTIngressCopyWith<SRTIngress> get copyWith =>
      _$SRTIngressCopyWithImpl<SRTIngress>(this as SRTIngress, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SRTIngress &&
            (identical(other.address, address) || other.address == address));
  }

  @override
  int get hashCode => Object.hash(runtimeType, address);

  @override
  String toString() {
    return 'SRTIngress(address: $address)';
  }
}

/// @nodoc
abstract mixin class $SRTIngressCopyWith<$Res> {
  factory $SRTIngressCopyWith(
    SRTIngress value,
    $Res Function(SRTIngress) _then,
  ) = _$SRTIngressCopyWithImpl;
  @useResult
  $Res call({String address});
}

/// @nodoc
class _$SRTIngressCopyWithImpl<$Res> implements $SRTIngressCopyWith<$Res> {
  _$SRTIngressCopyWithImpl(this._self, this._then);

  final SRTIngress _self;
  final $Res Function(SRTIngress) _then;

  /// Create a copy of SRTIngress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? address = null}) {
    return _then(
      SRTIngress(
        address: null == address
            ? _self.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
