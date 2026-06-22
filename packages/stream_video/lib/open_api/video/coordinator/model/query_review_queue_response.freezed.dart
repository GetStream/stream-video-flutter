// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_review_queue_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QueryReviewQueueResponse {

 Map<String, List<ModerationActionConfigResponse>> get actionConfig; Map<String, List<ModerationActionConfigResponse>>? get defaultActionConfig; String get duration; FilterConfigResponse? get filterConfig; List<ReviewQueueItemResponse> get items; String? get next; String? get prev; Map<String, Object?> get stats;
/// Create a copy of QueryReviewQueueResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueryReviewQueueResponseCopyWith<QueryReviewQueueResponse> get copyWith => _$QueryReviewQueueResponseCopyWithImpl<QueryReviewQueueResponse>(this as QueryReviewQueueResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueryReviewQueueResponse&&const DeepCollectionEquality().equals(other.actionConfig, actionConfig)&&const DeepCollectionEquality().equals(other.defaultActionConfig, defaultActionConfig)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.filterConfig, filterConfig) || other.filterConfig == filterConfig)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.next, next) || other.next == next)&&(identical(other.prev, prev) || other.prev == prev)&&const DeepCollectionEquality().equals(other.stats, stats));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(actionConfig),const DeepCollectionEquality().hash(defaultActionConfig),duration,filterConfig,const DeepCollectionEquality().hash(items),next,prev,const DeepCollectionEquality().hash(stats));

@override
String toString() {
  return 'QueryReviewQueueResponse(actionConfig: $actionConfig, defaultActionConfig: $defaultActionConfig, duration: $duration, filterConfig: $filterConfig, items: $items, next: $next, prev: $prev, stats: $stats)';
}


}

/// @nodoc
abstract mixin class $QueryReviewQueueResponseCopyWith<$Res>  {
  factory $QueryReviewQueueResponseCopyWith(QueryReviewQueueResponse value, $Res Function(QueryReviewQueueResponse) _then) = _$QueryReviewQueueResponseCopyWithImpl;
@useResult
$Res call({
 Map<String, List<ModerationActionConfigResponse>> actionConfig, Map<String, List<ModerationActionConfigResponse>>? defaultActionConfig, String duration, FilterConfigResponse? filterConfig, List<ReviewQueueItemResponse> items, String? next, String? prev, Map<String, Object?> stats
});




}
/// @nodoc
class _$QueryReviewQueueResponseCopyWithImpl<$Res>
    implements $QueryReviewQueueResponseCopyWith<$Res> {
  _$QueryReviewQueueResponseCopyWithImpl(this._self, this._then);

  final QueryReviewQueueResponse _self;
  final $Res Function(QueryReviewQueueResponse) _then;

/// Create a copy of QueryReviewQueueResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? actionConfig = null,Object? defaultActionConfig = freezed,Object? duration = null,Object? filterConfig = freezed,Object? items = null,Object? next = freezed,Object? prev = freezed,Object? stats = null,}) {
  return _then(QueryReviewQueueResponse(
actionConfig: null == actionConfig ? _self.actionConfig : actionConfig // ignore: cast_nullable_to_non_nullable
as Map<String, List<ModerationActionConfigResponse>>,defaultActionConfig: freezed == defaultActionConfig ? _self.defaultActionConfig : defaultActionConfig // ignore: cast_nullable_to_non_nullable
as Map<String, List<ModerationActionConfigResponse>>?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,filterConfig: freezed == filterConfig ? _self.filterConfig : filterConfig // ignore: cast_nullable_to_non_nullable
as FilterConfigResponse?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ReviewQueueItemResponse>,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,prev: freezed == prev ? _self.prev : prev // ignore: cast_nullable_to_non_nullable
as String?,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [QueryReviewQueueResponse].
extension QueryReviewQueueResponsePatterns on QueryReviewQueueResponse {
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
