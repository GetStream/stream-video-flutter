// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_series_subscriber_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ParticipantSeriesSubscriberStats {

 Map<String, List<List<double>>>? get global; Map<String, MetricDescriptor>? get globalMeta; List<String>? get globalMetricsOrder; Map<String, List<MetricThreshold>>? get globalThresholds; List<ParticipantSeriesSubscriptionTrackMetrics>? get subscriptions;
/// Create a copy of ParticipantSeriesSubscriberStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantSeriesSubscriberStatsCopyWith<ParticipantSeriesSubscriberStats> get copyWith => _$ParticipantSeriesSubscriberStatsCopyWithImpl<ParticipantSeriesSubscriberStats>(this as ParticipantSeriesSubscriberStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantSeriesSubscriberStats&&const DeepCollectionEquality().equals(other.global, global)&&const DeepCollectionEquality().equals(other.globalMeta, globalMeta)&&const DeepCollectionEquality().equals(other.globalMetricsOrder, globalMetricsOrder)&&const DeepCollectionEquality().equals(other.globalThresholds, globalThresholds)&&const DeepCollectionEquality().equals(other.subscriptions, subscriptions));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(global),const DeepCollectionEquality().hash(globalMeta),const DeepCollectionEquality().hash(globalMetricsOrder),const DeepCollectionEquality().hash(globalThresholds),const DeepCollectionEquality().hash(subscriptions));

@override
String toString() {
  return 'ParticipantSeriesSubscriberStats(global: $global, globalMeta: $globalMeta, globalMetricsOrder: $globalMetricsOrder, globalThresholds: $globalThresholds, subscriptions: $subscriptions)';
}


}

/// @nodoc
abstract mixin class $ParticipantSeriesSubscriberStatsCopyWith<$Res>  {
  factory $ParticipantSeriesSubscriberStatsCopyWith(ParticipantSeriesSubscriberStats value, $Res Function(ParticipantSeriesSubscriberStats) _then) = _$ParticipantSeriesSubscriberStatsCopyWithImpl;
@useResult
$Res call({
 Map<String, List<List<double>>>? global, Map<String, MetricDescriptor>? globalMeta, List<String>? globalMetricsOrder, Map<String, List<MetricThreshold>>? globalThresholds, List<ParticipantSeriesSubscriptionTrackMetrics>? subscriptions
});




}
/// @nodoc
class _$ParticipantSeriesSubscriberStatsCopyWithImpl<$Res>
    implements $ParticipantSeriesSubscriberStatsCopyWith<$Res> {
  _$ParticipantSeriesSubscriberStatsCopyWithImpl(this._self, this._then);

  final ParticipantSeriesSubscriberStats _self;
  final $Res Function(ParticipantSeriesSubscriberStats) _then;

/// Create a copy of ParticipantSeriesSubscriberStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? global = freezed,Object? globalMeta = freezed,Object? globalMetricsOrder = freezed,Object? globalThresholds = freezed,Object? subscriptions = freezed,}) {
  return _then(ParticipantSeriesSubscriberStats(
global: freezed == global ? _self.global : global // ignore: cast_nullable_to_non_nullable
as Map<String, List<List<double>>>?,globalMeta: freezed == globalMeta ? _self.globalMeta : globalMeta // ignore: cast_nullable_to_non_nullable
as Map<String, MetricDescriptor>?,globalMetricsOrder: freezed == globalMetricsOrder ? _self.globalMetricsOrder : globalMetricsOrder // ignore: cast_nullable_to_non_nullable
as List<String>?,globalThresholds: freezed == globalThresholds ? _self.globalThresholds : globalThresholds // ignore: cast_nullable_to_non_nullable
as Map<String, List<MetricThreshold>>?,subscriptions: freezed == subscriptions ? _self.subscriptions : subscriptions // ignore: cast_nullable_to_non_nullable
as List<ParticipantSeriesSubscriptionTrackMetrics>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ParticipantSeriesSubscriberStats].
extension ParticipantSeriesSubscriberStatsPatterns on ParticipantSeriesSubscriberStats {
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
