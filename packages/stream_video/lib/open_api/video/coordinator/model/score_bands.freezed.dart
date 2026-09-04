// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'score_bands.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScoreBands {
  double? get good;
  double? get ok;
  double? get poor;

  /// Create a copy of ScoreBands
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScoreBandsCopyWith<ScoreBands> get copyWith =>
      _$ScoreBandsCopyWithImpl<ScoreBands>(this as ScoreBands, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ScoreBands &&
            (identical(other.good, good) || other.good == good) &&
            (identical(other.ok, ok) || other.ok == ok) &&
            (identical(other.poor, poor) || other.poor == poor));
  }

  @override
  int get hashCode => Object.hash(runtimeType, good, ok, poor);

  @override
  String toString() {
    return 'ScoreBands(good: $good, ok: $ok, poor: $poor)';
  }
}

/// @nodoc
abstract mixin class $ScoreBandsCopyWith<$Res> {
  factory $ScoreBandsCopyWith(
    ScoreBands value,
    $Res Function(ScoreBands) _then,
  ) = _$ScoreBandsCopyWithImpl;
  @useResult
  $Res call({double? good, double? ok, double? poor});
}

/// @nodoc
class _$ScoreBandsCopyWithImpl<$Res> implements $ScoreBandsCopyWith<$Res> {
  _$ScoreBandsCopyWithImpl(this._self, this._then);

  final ScoreBands _self;
  final $Res Function(ScoreBands) _then;

  /// Create a copy of ScoreBands
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? good = freezed,
    Object? ok = freezed,
    Object? poor = freezed,
  }) {
    return _then(
      ScoreBands(
        good: freezed == good
            ? _self.good
            : good // ignore: cast_nullable_to_non_nullable
                  as double?,
        ok: freezed == ok
            ? _self.ok
            : ok // ignore: cast_nullable_to_non_nullable
                  as double?,
        poor: freezed == poor
            ? _self.poor
            : poor // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}
