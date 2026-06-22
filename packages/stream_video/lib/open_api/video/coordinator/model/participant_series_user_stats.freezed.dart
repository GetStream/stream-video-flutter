// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_series_user_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ParticipantSeriesUserStats {

 Map<String, List<List<double>>>? get metrics; Map<String, MetricDescriptor>? get metricsMeta; List<String>? get metricsOrder; Map<String, List<MetricThreshold>>? get thresholds;
/// Create a copy of ParticipantSeriesUserStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantSeriesUserStatsCopyWith<ParticipantSeriesUserStats> get copyWith => _$ParticipantSeriesUserStatsCopyWithImpl<ParticipantSeriesUserStats>(this as ParticipantSeriesUserStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantSeriesUserStats&&const DeepCollectionEquality().equals(other.metrics, metrics)&&const DeepCollectionEquality().equals(other.metricsMeta, metricsMeta)&&const DeepCollectionEquality().equals(other.metricsOrder, metricsOrder)&&const DeepCollectionEquality().equals(other.thresholds, thresholds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(metrics),const DeepCollectionEquality().hash(metricsMeta),const DeepCollectionEquality().hash(metricsOrder),const DeepCollectionEquality().hash(thresholds));

@override
String toString() {
  return 'ParticipantSeriesUserStats(metrics: $metrics, metricsMeta: $metricsMeta, metricsOrder: $metricsOrder, thresholds: $thresholds)';
}


}

/// @nodoc
abstract mixin class $ParticipantSeriesUserStatsCopyWith<$Res>  {
  factory $ParticipantSeriesUserStatsCopyWith(ParticipantSeriesUserStats value, $Res Function(ParticipantSeriesUserStats) _then) = _$ParticipantSeriesUserStatsCopyWithImpl;
@useResult
$Res call({
 Map<String, List<List<double>>>? metrics, Map<String, MetricDescriptor>? metricsMeta, List<String>? metricsOrder, Map<String, List<MetricThreshold>>? thresholds
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
@pragma('vm:prefer-inline') @override $Res call({Object? metrics = freezed,Object? metricsMeta = freezed,Object? metricsOrder = freezed,Object? thresholds = freezed,}) {
  return _then(ParticipantSeriesUserStats(
metrics: freezed == metrics ? _self.metrics : metrics // ignore: cast_nullable_to_non_nullable
as Map<String, List<List<double>>>?,metricsMeta: freezed == metricsMeta ? _self.metricsMeta : metricsMeta // ignore: cast_nullable_to_non_nullable
as Map<String, MetricDescriptor>?,metricsOrder: freezed == metricsOrder ? _self.metricsOrder : metricsOrder // ignore: cast_nullable_to_non_nullable
as List<String>?,thresholds: freezed == thresholds ? _self.thresholds : thresholds // ignore: cast_nullable_to_non_nullable
as Map<String, List<MetricThreshold>>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ParticipantSeriesUserStats].
extension ParticipantSeriesUserStatsPatterns on ParticipantSeriesUserStats {
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
