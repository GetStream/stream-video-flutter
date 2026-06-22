// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'metric_threshold.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MetricThreshold {

 String get level; String get operator; double get value; String? get valueUnit; int? get windowSeconds;
/// Create a copy of MetricThreshold
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MetricThresholdCopyWith<MetricThreshold> get copyWith => _$MetricThresholdCopyWithImpl<MetricThreshold>(this as MetricThreshold, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MetricThreshold&&(identical(other.level, level) || other.level == level)&&(identical(other.operator, operator) || other.operator == operator)&&(identical(other.value, value) || other.value == value)&&(identical(other.valueUnit, valueUnit) || other.valueUnit == valueUnit)&&(identical(other.windowSeconds, windowSeconds) || other.windowSeconds == windowSeconds));
}


@override
int get hashCode => Object.hash(runtimeType,level,operator,value,valueUnit,windowSeconds);

@override
String toString() {
  return 'MetricThreshold(level: $level, operator: $operator, value: $value, valueUnit: $valueUnit, windowSeconds: $windowSeconds)';
}


}

/// @nodoc
abstract mixin class $MetricThresholdCopyWith<$Res>  {
  factory $MetricThresholdCopyWith(MetricThreshold value, $Res Function(MetricThreshold) _then) = _$MetricThresholdCopyWithImpl;
@useResult
$Res call({
 String level, String operator, double value, String? valueUnit, int? windowSeconds
});




}
/// @nodoc
class _$MetricThresholdCopyWithImpl<$Res>
    implements $MetricThresholdCopyWith<$Res> {
  _$MetricThresholdCopyWithImpl(this._self, this._then);

  final MetricThreshold _self;
  final $Res Function(MetricThreshold) _then;

/// Create a copy of MetricThreshold
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? operator = null,Object? value = null,Object? valueUnit = freezed,Object? windowSeconds = freezed,}) {
  return _then(MetricThreshold(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,operator: null == operator ? _self.operator : operator // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,valueUnit: freezed == valueUnit ? _self.valueUnit : valueUnit // ignore: cast_nullable_to_non_nullable
as String?,windowSeconds: freezed == windowSeconds ? _self.windowSeconds : windowSeconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MetricThreshold].
extension MetricThresholdPatterns on MetricThreshold {
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
