// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resolution_metrics_time_series.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResolutionMetricsTimeSeries {

 MetricTimeSeries? get height; MetricTimeSeries? get width;
/// Create a copy of ResolutionMetricsTimeSeries
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResolutionMetricsTimeSeriesCopyWith<ResolutionMetricsTimeSeries> get copyWith => _$ResolutionMetricsTimeSeriesCopyWithImpl<ResolutionMetricsTimeSeries>(this as ResolutionMetricsTimeSeries, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResolutionMetricsTimeSeries&&(identical(other.height, height) || other.height == height)&&(identical(other.width, width) || other.width == width));
}


@override
int get hashCode => Object.hash(runtimeType,height,width);

@override
String toString() {
  return 'ResolutionMetricsTimeSeries(height: $height, width: $width)';
}


}

/// @nodoc
abstract mixin class $ResolutionMetricsTimeSeriesCopyWith<$Res>  {
  factory $ResolutionMetricsTimeSeriesCopyWith(ResolutionMetricsTimeSeries value, $Res Function(ResolutionMetricsTimeSeries) _then) = _$ResolutionMetricsTimeSeriesCopyWithImpl;
@useResult
$Res call({
 MetricTimeSeries? height, MetricTimeSeries? width
});




}
/// @nodoc
class _$ResolutionMetricsTimeSeriesCopyWithImpl<$Res>
    implements $ResolutionMetricsTimeSeriesCopyWith<$Res> {
  _$ResolutionMetricsTimeSeriesCopyWithImpl(this._self, this._then);

  final ResolutionMetricsTimeSeries _self;
  final $Res Function(ResolutionMetricsTimeSeries) _then;

/// Create a copy of ResolutionMetricsTimeSeries
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? height = freezed,Object? width = freezed,}) {
  return _then(ResolutionMetricsTimeSeries(
height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as MetricTimeSeries?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as MetricTimeSeries?,
  ));
}

}


/// Adds pattern-matching-related methods to [ResolutionMetricsTimeSeries].
extension ResolutionMetricsTimeSeriesPatterns on ResolutionMetricsTimeSeries {
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
