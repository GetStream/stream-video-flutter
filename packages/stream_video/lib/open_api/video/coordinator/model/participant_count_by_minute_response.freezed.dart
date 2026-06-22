// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_count_by_minute_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ParticipantCountByMinuteResponse {

 int get first; int get last; int get max; int get min; DateTime get startTs;
/// Create a copy of ParticipantCountByMinuteResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantCountByMinuteResponseCopyWith<ParticipantCountByMinuteResponse> get copyWith => _$ParticipantCountByMinuteResponseCopyWithImpl<ParticipantCountByMinuteResponse>(this as ParticipantCountByMinuteResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantCountByMinuteResponse&&(identical(other.first, first) || other.first == first)&&(identical(other.last, last) || other.last == last)&&(identical(other.max, max) || other.max == max)&&(identical(other.min, min) || other.min == min)&&(identical(other.startTs, startTs) || other.startTs == startTs));
}


@override
int get hashCode => Object.hash(runtimeType,first,last,max,min,startTs);

@override
String toString() {
  return 'ParticipantCountByMinuteResponse(first: $first, last: $last, max: $max, min: $min, startTs: $startTs)';
}


}

/// @nodoc
abstract mixin class $ParticipantCountByMinuteResponseCopyWith<$Res>  {
  factory $ParticipantCountByMinuteResponseCopyWith(ParticipantCountByMinuteResponse value, $Res Function(ParticipantCountByMinuteResponse) _then) = _$ParticipantCountByMinuteResponseCopyWithImpl;
@useResult
$Res call({
 int first, int last, int max, int min, DateTime startTs
});




}
/// @nodoc
class _$ParticipantCountByMinuteResponseCopyWithImpl<$Res>
    implements $ParticipantCountByMinuteResponseCopyWith<$Res> {
  _$ParticipantCountByMinuteResponseCopyWithImpl(this._self, this._then);

  final ParticipantCountByMinuteResponse _self;
  final $Res Function(ParticipantCountByMinuteResponse) _then;

/// Create a copy of ParticipantCountByMinuteResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? first = null,Object? last = null,Object? max = null,Object? min = null,Object? startTs = null,}) {
  return _then(ParticipantCountByMinuteResponse(
first: null == first ? _self.first : first // ignore: cast_nullable_to_non_nullable
as int,last: null == last ? _self.last : last // ignore: cast_nullable_to_non_nullable
as int,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int,min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as int,startTs: null == startTs ? _self.startTs : startTs // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ParticipantCountByMinuteResponse].
extension ParticipantCountByMinuteResponsePatterns on ParticipantCountByMinuteResponse {
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
