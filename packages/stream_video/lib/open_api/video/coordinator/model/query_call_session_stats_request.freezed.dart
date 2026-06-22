// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_call_session_stats_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QueryCallSessionStatsRequest {

 Map<String, Object?>? get filterConditions; int? get limit; String? get next; String? get prev; List<SortParamRequest>? get sort;
/// Create a copy of QueryCallSessionStatsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueryCallSessionStatsRequestCopyWith<QueryCallSessionStatsRequest> get copyWith => _$QueryCallSessionStatsRequestCopyWithImpl<QueryCallSessionStatsRequest>(this as QueryCallSessionStatsRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueryCallSessionStatsRequest&&const DeepCollectionEquality().equals(other.filterConditions, filterConditions)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.next, next) || other.next == next)&&(identical(other.prev, prev) || other.prev == prev)&&const DeepCollectionEquality().equals(other.sort, sort));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(filterConditions),limit,next,prev,const DeepCollectionEquality().hash(sort));

@override
String toString() {
  return 'QueryCallSessionStatsRequest(filterConditions: $filterConditions, limit: $limit, next: $next, prev: $prev, sort: $sort)';
}


}

/// @nodoc
abstract mixin class $QueryCallSessionStatsRequestCopyWith<$Res>  {
  factory $QueryCallSessionStatsRequestCopyWith(QueryCallSessionStatsRequest value, $Res Function(QueryCallSessionStatsRequest) _then) = _$QueryCallSessionStatsRequestCopyWithImpl;
@useResult
$Res call({
 Map<String, Object?>? filterConditions, int? limit, String? next, String? prev, List<SortParamRequest>? sort
});




}
/// @nodoc
class _$QueryCallSessionStatsRequestCopyWithImpl<$Res>
    implements $QueryCallSessionStatsRequestCopyWith<$Res> {
  _$QueryCallSessionStatsRequestCopyWithImpl(this._self, this._then);

  final QueryCallSessionStatsRequest _self;
  final $Res Function(QueryCallSessionStatsRequest) _then;

/// Create a copy of QueryCallSessionStatsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filterConditions = freezed,Object? limit = freezed,Object? next = freezed,Object? prev = freezed,Object? sort = freezed,}) {
  return _then(QueryCallSessionStatsRequest(
filterConditions: freezed == filterConditions ? _self.filterConditions : filterConditions // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,prev: freezed == prev ? _self.prev : prev // ignore: cast_nullable_to_non_nullable
as String?,sort: freezed == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as List<SortParamRequest>?,
  ));
}

}


/// Adds pattern-matching-related methods to [QueryCallSessionStatsRequest].
extension QueryCallSessionStatsRequestPatterns on QueryCallSessionStatsRequest {
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
