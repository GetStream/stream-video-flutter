// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'percentiles.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Percentiles {
  double? get p50;
  double? get p95;

  /// Create a copy of Percentiles
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PercentilesCopyWith<Percentiles> get copyWith =>
      _$PercentilesCopyWithImpl<Percentiles>(this as Percentiles, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Percentiles &&
            (identical(other.p50, p50) || other.p50 == p50) &&
            (identical(other.p95, p95) || other.p95 == p95));
  }

  @override
  int get hashCode => Object.hash(runtimeType, p50, p95);

  @override
  String toString() {
    return 'Percentiles(p50: $p50, p95: $p95)';
  }
}

/// @nodoc
abstract mixin class $PercentilesCopyWith<$Res> {
  factory $PercentilesCopyWith(
    Percentiles value,
    $Res Function(Percentiles) _then,
  ) = _$PercentilesCopyWithImpl;
  @useResult
  $Res call({double? p50, double? p95});
}

/// @nodoc
class _$PercentilesCopyWithImpl<$Res> implements $PercentilesCopyWith<$Res> {
  _$PercentilesCopyWithImpl(this._self, this._then);

  final Percentiles _self;
  final $Res Function(Percentiles) _then;

  /// Create a copy of Percentiles
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? p50 = freezed, Object? p95 = freezed}) {
    return _then(
      Percentiles(
        p50: freezed == p50
            ? _self.p50
            : p50 // ignore: cast_nullable_to_non_nullable
                  as double?,
        p95: freezed == p95
            ? _self.p95
            : p95 // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}
