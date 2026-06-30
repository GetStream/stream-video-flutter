// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_series_user_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParticipantSeriesUserStats {
  Map<String, List<List<double>>>? get metrics;
  Map<String, MetricDescriptor>? get metricsMeta;
  List<String>? get metricsOrder;
  Map<String, List<MetricThreshold>>? get thresholds;

  /// Create a copy of ParticipantSeriesUserStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ParticipantSeriesUserStatsCopyWith<ParticipantSeriesUserStats>
  get copyWith =>
      _$ParticipantSeriesUserStatsCopyWithImpl<ParticipantSeriesUserStats>(
        this as ParticipantSeriesUserStats,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ParticipantSeriesUserStats &&
            const DeepCollectionEquality().equals(other.metrics, metrics) &&
            const DeepCollectionEquality().equals(
              other.metricsMeta,
              metricsMeta,
            ) &&
            const DeepCollectionEquality().equals(
              other.metricsOrder,
              metricsOrder,
            ) &&
            const DeepCollectionEquality().equals(
              other.thresholds,
              thresholds,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(metrics),
    const DeepCollectionEquality().hash(metricsMeta),
    const DeepCollectionEquality().hash(metricsOrder),
    const DeepCollectionEquality().hash(thresholds),
  );

  @override
  String toString() {
    return 'ParticipantSeriesUserStats(metrics: $metrics, metricsMeta: $metricsMeta, metricsOrder: $metricsOrder, thresholds: $thresholds)';
  }
}

/// @nodoc
abstract mixin class $ParticipantSeriesUserStatsCopyWith<$Res> {
  factory $ParticipantSeriesUserStatsCopyWith(
    ParticipantSeriesUserStats value,
    $Res Function(ParticipantSeriesUserStats) _then,
  ) = _$ParticipantSeriesUserStatsCopyWithImpl;
  @useResult
  $Res call({
    Map<String, List<List<double>>>? metrics,
    Map<String, MetricDescriptor>? metricsMeta,
    List<String>? metricsOrder,
    Map<String, List<MetricThreshold>>? thresholds,
  });
}

/// @nodoc
class _$ParticipantSeriesUserStatsCopyWithImpl<$Res>
    implements $ParticipantSeriesUserStatsCopyWith<$Res> {
  _$ParticipantSeriesUserStatsCopyWithImpl(this._self, this._then);

  final ParticipantSeriesUserStats _self;
  final $Res Function(ParticipantSeriesUserStats) _then;

  /// Create a copy of ParticipantSeriesUserStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? metrics = freezed,
    Object? metricsMeta = freezed,
    Object? metricsOrder = freezed,
    Object? thresholds = freezed,
  }) {
    return _then(
      ParticipantSeriesUserStats(
        metrics: freezed == metrics
            ? _self.metrics
            : metrics // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<List<double>>>?,
        metricsMeta: freezed == metricsMeta
            ? _self.metricsMeta
            : metricsMeta // ignore: cast_nullable_to_non_nullable
                  as Map<String, MetricDescriptor>?,
        metricsOrder: freezed == metricsOrder
            ? _self.metricsOrder
            : metricsOrder // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        thresholds: freezed == thresholds
            ? _self.thresholds
            : thresholds // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<MetricThreshold>>?,
      ),
    );
  }
}
