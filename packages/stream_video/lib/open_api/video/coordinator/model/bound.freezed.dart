// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bound.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Bound {
  bool get inclusive;
  double get value;

  /// Create a copy of Bound
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BoundCopyWith<Bound> get copyWith =>
      _$BoundCopyWithImpl<Bound>(this as Bound, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Bound &&
            (identical(other.inclusive, inclusive) ||
                other.inclusive == inclusive) &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, inclusive, value);

  @override
  String toString() {
    return 'Bound(inclusive: $inclusive, value: $value)';
  }
}

/// @nodoc
abstract mixin class $BoundCopyWith<$Res> {
  factory $BoundCopyWith(Bound value, $Res Function(Bound) _then) =
      _$BoundCopyWithImpl;
  @useResult
  $Res call({bool inclusive, double value});
}

/// @nodoc
class _$BoundCopyWithImpl<$Res> implements $BoundCopyWith<$Res> {
  _$BoundCopyWithImpl(this._self, this._then);

  final Bound _self;
  final $Res Function(Bound) _then;

  /// Create a copy of Bound
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? inclusive = null, Object? value = null}) {
    return _then(
      Bound(
        inclusive: null == inclusive
            ? _self.inclusive
            : inclusive // ignore: cast_nullable_to_non_nullable
                  as bool,
        value: null == value
            ? _self.value
            : value // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}
