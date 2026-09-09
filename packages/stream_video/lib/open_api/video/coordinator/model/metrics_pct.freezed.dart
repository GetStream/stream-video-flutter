// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'metrics_pct.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MetricsPct {
  double? get freezes;
  double? get geo;
  double? get jitter;
  double? get latency;
  double? get qualityScore;

  /// Create a copy of MetricsPct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MetricsPctCopyWith<MetricsPct> get copyWith =>
      _$MetricsPctCopyWithImpl<MetricsPct>(this as MetricsPct, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MetricsPct &&
            (identical(other.freezes, freezes) || other.freezes == freezes) &&
            (identical(other.geo, geo) || other.geo == geo) &&
            (identical(other.jitter, jitter) || other.jitter == jitter) &&
            (identical(other.latency, latency) || other.latency == latency) &&
            (identical(other.qualityScore, qualityScore) ||
                other.qualityScore == qualityScore));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, freezes, geo, jitter, latency, qualityScore);

  @override
  String toString() {
    return 'MetricsPct(freezes: $freezes, geo: $geo, jitter: $jitter, latency: $latency, qualityScore: $qualityScore)';
  }
}

/// @nodoc
abstract mixin class $MetricsPctCopyWith<$Res> {
  factory $MetricsPctCopyWith(
    MetricsPct value,
    $Res Function(MetricsPct) _then,
  ) = _$MetricsPctCopyWithImpl;
  @useResult
  $Res call({
    double? freezes,
    double? geo,
    double? jitter,
    double? latency,
    double? qualityScore,
  });
}

/// @nodoc
class _$MetricsPctCopyWithImpl<$Res> implements $MetricsPctCopyWith<$Res> {
  _$MetricsPctCopyWithImpl(this._self, this._then);

  final MetricsPct _self;
  final $Res Function(MetricsPct) _then;

  /// Create a copy of MetricsPct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? freezes = freezed,
    Object? geo = freezed,
    Object? jitter = freezed,
    Object? latency = freezed,
    Object? qualityScore = freezed,
  }) {
    return _then(
      MetricsPct(
        freezes: freezed == freezes
            ? _self.freezes
            : freezes // ignore: cast_nullable_to_non_nullable
                  as double?,
        geo: freezed == geo
            ? _self.geo
            : geo // ignore: cast_nullable_to_non_nullable
                  as double?,
        jitter: freezed == jitter
            ? _self.jitter
            : jitter // ignore: cast_nullable_to_non_nullable
                  as double?,
        latency: freezed == latency
            ? _self.latency
            : latency // ignore: cast_nullable_to_non_nullable
                  as double?,
        qualityScore: freezed == qualityScore
            ? _self.qualityScore
            : qualityScore // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}
