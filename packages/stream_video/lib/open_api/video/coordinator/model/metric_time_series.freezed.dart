// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'metric_time_series.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MetricTimeSeries {
  List<List<double>>? get dataPoints;

  /// Create a copy of MetricTimeSeries
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MetricTimeSeriesCopyWith<MetricTimeSeries> get copyWith =>
      _$MetricTimeSeriesCopyWithImpl<MetricTimeSeries>(
        this as MetricTimeSeries,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MetricTimeSeries &&
            const DeepCollectionEquality().equals(
              other.dataPoints,
              dataPoints,
            ));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(dataPoints));

  @override
  String toString() {
    return 'MetricTimeSeries(dataPoints: $dataPoints)';
  }
}

/// @nodoc
abstract mixin class $MetricTimeSeriesCopyWith<$Res> {
  factory $MetricTimeSeriesCopyWith(
    MetricTimeSeries value,
    $Res Function(MetricTimeSeries) _then,
  ) = _$MetricTimeSeriesCopyWithImpl;
  @useResult
  $Res call({List<List<double>>? dataPoints});
}

/// @nodoc
class _$MetricTimeSeriesCopyWithImpl<$Res>
    implements $MetricTimeSeriesCopyWith<$Res> {
  _$MetricTimeSeriesCopyWithImpl(this._self, this._then);

  final MetricTimeSeries _self;
  final $Res Function(MetricTimeSeries) _then;

  /// Create a copy of MetricTimeSeries
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? dataPoints = freezed}) {
    return _then(
      MetricTimeSeries(
        dataPoints: freezed == dataPoints
            ? _self.dataPoints
            : dataPoints // ignore: cast_nullable_to_non_nullable
                  as List<List<double>>?,
      ),
    );
  }
}
