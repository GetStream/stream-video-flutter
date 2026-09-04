// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'concurrency_minute.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConcurrencyMinute {
  int get joins;
  int get leaves;
  int get max;
  int get min;
  String get minute;

  /// Create a copy of ConcurrencyMinute
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConcurrencyMinuteCopyWith<ConcurrencyMinute> get copyWith =>
      _$ConcurrencyMinuteCopyWithImpl<ConcurrencyMinute>(
        this as ConcurrencyMinute,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConcurrencyMinute &&
            (identical(other.joins, joins) || other.joins == joins) &&
            (identical(other.leaves, leaves) || other.leaves == leaves) &&
            (identical(other.max, max) || other.max == max) &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.minute, minute) || other.minute == minute));
  }

  @override
  int get hashCode => Object.hash(runtimeType, joins, leaves, max, min, minute);

  @override
  String toString() {
    return 'ConcurrencyMinute(joins: $joins, leaves: $leaves, max: $max, min: $min, minute: $minute)';
  }
}

/// @nodoc
abstract mixin class $ConcurrencyMinuteCopyWith<$Res> {
  factory $ConcurrencyMinuteCopyWith(
    ConcurrencyMinute value,
    $Res Function(ConcurrencyMinute) _then,
  ) = _$ConcurrencyMinuteCopyWithImpl;
  @useResult
  $Res call({int joins, int leaves, int max, int min, String minute});
}

/// @nodoc
class _$ConcurrencyMinuteCopyWithImpl<$Res>
    implements $ConcurrencyMinuteCopyWith<$Res> {
  _$ConcurrencyMinuteCopyWithImpl(this._self, this._then);

  final ConcurrencyMinute _self;
  final $Res Function(ConcurrencyMinute) _then;

  /// Create a copy of ConcurrencyMinute
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? joins = null,
    Object? leaves = null,
    Object? max = null,
    Object? min = null,
    Object? minute = null,
  }) {
    return _then(
      ConcurrencyMinute(
        joins: null == joins
            ? _self.joins
            : joins // ignore: cast_nullable_to_non_nullable
                  as int,
        leaves: null == leaves
            ? _self.leaves
            : leaves // ignore: cast_nullable_to_non_nullable
                  as int,
        max: null == max
            ? _self.max
            : max // ignore: cast_nullable_to_non_nullable
                  as int,
        min: null == min
            ? _self.min
            : min // ignore: cast_nullable_to_non_nullable
                  as int,
        minute: null == minute
            ? _self.minute
            : minute // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
