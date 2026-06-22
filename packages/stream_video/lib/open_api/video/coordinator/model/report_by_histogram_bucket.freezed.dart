// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_by_histogram_bucket.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReportByHistogramBucket {

 String get category; int get count; Bound? get lowerBound; double get sum; Bound? get upperBound;
/// Create a copy of ReportByHistogramBucket
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportByHistogramBucketCopyWith<ReportByHistogramBucket> get copyWith => _$ReportByHistogramBucketCopyWithImpl<ReportByHistogramBucket>(this as ReportByHistogramBucket, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportByHistogramBucket&&(identical(other.category, category) || other.category == category)&&(identical(other.count, count) || other.count == count)&&(identical(other.lowerBound, lowerBound) || other.lowerBound == lowerBound)&&(identical(other.sum, sum) || other.sum == sum)&&(identical(other.upperBound, upperBound) || other.upperBound == upperBound));
}


@override
int get hashCode => Object.hash(runtimeType,category,count,lowerBound,sum,upperBound);

@override
String toString() {
  return 'ReportByHistogramBucket(category: $category, count: $count, lowerBound: $lowerBound, sum: $sum, upperBound: $upperBound)';
}


}

/// @nodoc
abstract mixin class $ReportByHistogramBucketCopyWith<$Res>  {
  factory $ReportByHistogramBucketCopyWith(ReportByHistogramBucket value, $Res Function(ReportByHistogramBucket) _then) = _$ReportByHistogramBucketCopyWithImpl;
@useResult
$Res call({
 String category, int count, Bound? lowerBound, double sum, Bound? upperBound
});




}
/// @nodoc
class _$ReportByHistogramBucketCopyWithImpl<$Res>
    implements $ReportByHistogramBucketCopyWith<$Res> {
  _$ReportByHistogramBucketCopyWithImpl(this._self, this._then);

  final ReportByHistogramBucket _self;
  final $Res Function(ReportByHistogramBucket) _then;

/// Create a copy of ReportByHistogramBucket
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? count = null,Object? lowerBound = freezed,Object? sum = null,Object? upperBound = freezed,}) {
  return _then(ReportByHistogramBucket(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,lowerBound: freezed == lowerBound ? _self.lowerBound : lowerBound // ignore: cast_nullable_to_non_nullable
as Bound?,sum: null == sum ? _self.sum : sum // ignore: cast_nullable_to_non_nullable
as double,upperBound: freezed == upperBound ? _self.upperBound : upperBound // ignore: cast_nullable_to_non_nullable
as Bound?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportByHistogramBucket].
extension ReportByHistogramBucketPatterns on ReportByHistogramBucket {
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
