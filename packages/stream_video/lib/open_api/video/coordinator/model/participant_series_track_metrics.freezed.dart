// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_series_track_metrics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ParticipantSeriesTrackMetrics {

 String? get codec; String? get label; Map<String, List<List<double>>>? get metrics; Map<String, MetricDescriptor>? get metricsMeta; List<String>? get metricsOrder; String? get rid; Map<String, List<MetricThreshold>>? get thresholds; String get trackId; String? get trackType;
/// Create a copy of ParticipantSeriesTrackMetrics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantSeriesTrackMetricsCopyWith<ParticipantSeriesTrackMetrics> get copyWith => _$ParticipantSeriesTrackMetricsCopyWithImpl<ParticipantSeriesTrackMetrics>(this as ParticipantSeriesTrackMetrics, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantSeriesTrackMetrics&&(identical(other.codec, codec) || other.codec == codec)&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other.metrics, metrics)&&const DeepCollectionEquality().equals(other.metricsMeta, metricsMeta)&&const DeepCollectionEquality().equals(other.metricsOrder, metricsOrder)&&(identical(other.rid, rid) || other.rid == rid)&&const DeepCollectionEquality().equals(other.thresholds, thresholds)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.trackType, trackType) || other.trackType == trackType));
}


@override
int get hashCode => Object.hash(runtimeType,codec,label,const DeepCollectionEquality().hash(metrics),const DeepCollectionEquality().hash(metricsMeta),const DeepCollectionEquality().hash(metricsOrder),rid,const DeepCollectionEquality().hash(thresholds),trackId,trackType);

@override
String toString() {
  return 'ParticipantSeriesTrackMetrics(codec: $codec, label: $label, metrics: $metrics, metricsMeta: $metricsMeta, metricsOrder: $metricsOrder, rid: $rid, thresholds: $thresholds, trackId: $trackId, trackType: $trackType)';
}


}

/// @nodoc
abstract mixin class $ParticipantSeriesTrackMetricsCopyWith<$Res>  {
  factory $ParticipantSeriesTrackMetricsCopyWith(ParticipantSeriesTrackMetrics value, $Res Function(ParticipantSeriesTrackMetrics) _then) = _$ParticipantSeriesTrackMetricsCopyWithImpl;
@useResult
$Res call({
 String? codec, String? label, Map<String, List<List<double>>>? metrics, Map<String, MetricDescriptor>? metricsMeta, List<String>? metricsOrder, String? rid, Map<String, List<MetricThreshold>>? thresholds, String trackId, String? trackType
});




}
/// @nodoc
class _$ParticipantSeriesTrackMetricsCopyWithImpl<$Res>
    implements $ParticipantSeriesTrackMetricsCopyWith<$Res> {
  _$ParticipantSeriesTrackMetricsCopyWithImpl(this._self, this._then);

  final ParticipantSeriesTrackMetrics _self;
  final $Res Function(ParticipantSeriesTrackMetrics) _then;

/// Create a copy of ParticipantSeriesTrackMetrics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? codec = freezed,Object? label = freezed,Object? metrics = freezed,Object? metricsMeta = freezed,Object? metricsOrder = freezed,Object? rid = freezed,Object? thresholds = freezed,Object? trackId = null,Object? trackType = freezed,}) {
  return _then(ParticipantSeriesTrackMetrics(
codec: freezed == codec ? _self.codec : codec // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,metrics: freezed == metrics ? _self.metrics : metrics // ignore: cast_nullable_to_non_nullable
as Map<String, List<List<double>>>?,metricsMeta: freezed == metricsMeta ? _self.metricsMeta : metricsMeta // ignore: cast_nullable_to_non_nullable
as Map<String, MetricDescriptor>?,metricsOrder: freezed == metricsOrder ? _self.metricsOrder : metricsOrder // ignore: cast_nullable_to_non_nullable
as List<String>?,rid: freezed == rid ? _self.rid : rid // ignore: cast_nullable_to_non_nullable
as String?,thresholds: freezed == thresholds ? _self.thresholds : thresholds // ignore: cast_nullable_to_non_nullable
as Map<String, List<MetricThreshold>>?,trackId: null == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String,trackType: freezed == trackType ? _self.trackType : trackType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ParticipantSeriesTrackMetrics].
extension ParticipantSeriesTrackMetricsPatterns on ParticipantSeriesTrackMetrics {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

// dart format on
