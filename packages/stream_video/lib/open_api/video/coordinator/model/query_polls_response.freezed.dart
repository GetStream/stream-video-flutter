// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_polls_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QueryPollsResponse {

 String get duration; String? get next; List<PollResponseData> get polls; String? get prev;
/// Create a copy of QueryPollsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueryPollsResponseCopyWith<QueryPollsResponse> get copyWith => _$QueryPollsResponseCopyWithImpl<QueryPollsResponse>(this as QueryPollsResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueryPollsResponse&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.next, next) || other.next == next)&&const DeepCollectionEquality().equals(other.polls, polls)&&(identical(other.prev, prev) || other.prev == prev));
}


@override
int get hashCode => Object.hash(runtimeType,duration,next,const DeepCollectionEquality().hash(polls),prev);

@override
String toString() {
  return 'QueryPollsResponse(duration: $duration, next: $next, polls: $polls, prev: $prev)';
}


}

/// @nodoc
abstract mixin class $QueryPollsResponseCopyWith<$Res>  {
  factory $QueryPollsResponseCopyWith(QueryPollsResponse value, $Res Function(QueryPollsResponse) _then) = _$QueryPollsResponseCopyWithImpl;
@useResult
$Res call({
 String duration, String? next, List<PollResponseData> polls, String? prev
});




}
/// @nodoc
class _$QueryPollsResponseCopyWithImpl<$Res>
    implements $QueryPollsResponseCopyWith<$Res> {
  _$QueryPollsResponseCopyWithImpl(this._self, this._then);

  final QueryPollsResponse _self;
  final $Res Function(QueryPollsResponse) _then;

/// Create a copy of QueryPollsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? duration = null,Object? next = freezed,Object? polls = null,Object? prev = freezed,}) {
  return _then(QueryPollsResponse(
duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,polls: null == polls ? _self.polls : polls // ignore: cast_nullable_to_non_nullable
as List<PollResponseData>,prev: freezed == prev ? _self.prev : prev // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [QueryPollsResponse].
extension QueryPollsResponsePatterns on QueryPollsResponse {
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
