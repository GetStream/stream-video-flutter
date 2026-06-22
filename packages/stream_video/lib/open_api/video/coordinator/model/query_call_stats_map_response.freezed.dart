// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_call_stats_map_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QueryCallStatsMapResponse {

 DateTime? get callEndedAt; String get callId; String get callSessionId; DateTime? get callStartedAt; String get callType; CallStatsParticipantCounts get counts; String? get dataSource; String get duration; DateTime? get endTime; DateTime? get generatedAt; CallStatsMapPublishers? get publishers; CallStatsMapSFUs? get sfus; DateTime? get startTime; CallStatsMapSubscribers? get subscribers;
/// Create a copy of QueryCallStatsMapResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueryCallStatsMapResponseCopyWith<QueryCallStatsMapResponse> get copyWith => _$QueryCallStatsMapResponseCopyWithImpl<QueryCallStatsMapResponse>(this as QueryCallStatsMapResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueryCallStatsMapResponse&&(identical(other.callEndedAt, callEndedAt) || other.callEndedAt == callEndedAt)&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.callSessionId, callSessionId) || other.callSessionId == callSessionId)&&(identical(other.callStartedAt, callStartedAt) || other.callStartedAt == callStartedAt)&&(identical(other.callType, callType) || other.callType == callType)&&(identical(other.counts, counts) || other.counts == counts)&&(identical(other.dataSource, dataSource) || other.dataSource == dataSource)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&(identical(other.publishers, publishers) || other.publishers == publishers)&&(identical(other.sfus, sfus) || other.sfus == sfus)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.subscribers, subscribers) || other.subscribers == subscribers));
}


@override
int get hashCode => Object.hash(runtimeType,callEndedAt,callId,callSessionId,callStartedAt,callType,counts,dataSource,duration,endTime,generatedAt,publishers,sfus,startTime,subscribers);

@override
String toString() {
  return 'QueryCallStatsMapResponse(callEndedAt: $callEndedAt, callId: $callId, callSessionId: $callSessionId, callStartedAt: $callStartedAt, callType: $callType, counts: $counts, dataSource: $dataSource, duration: $duration, endTime: $endTime, generatedAt: $generatedAt, publishers: $publishers, sfus: $sfus, startTime: $startTime, subscribers: $subscribers)';
}


}

/// @nodoc
abstract mixin class $QueryCallStatsMapResponseCopyWith<$Res>  {
  factory $QueryCallStatsMapResponseCopyWith(QueryCallStatsMapResponse value, $Res Function(QueryCallStatsMapResponse) _then) = _$QueryCallStatsMapResponseCopyWithImpl;
@useResult
$Res call({
 DateTime? callEndedAt, String callId, String callSessionId, DateTime? callStartedAt, String callType, CallStatsParticipantCounts counts, String? dataSource, String duration, DateTime? endTime, DateTime? generatedAt, CallStatsMapPublishers? publishers, CallStatsMapSFUs? sfus, DateTime? startTime, CallStatsMapSubscribers? subscribers
});




}
/// @nodoc
class _$QueryCallStatsMapResponseCopyWithImpl<$Res>
    implements $QueryCallStatsMapResponseCopyWith<$Res> {
  _$QueryCallStatsMapResponseCopyWithImpl(this._self, this._then);

  final QueryCallStatsMapResponse _self;
  final $Res Function(QueryCallStatsMapResponse) _then;

/// Create a copy of QueryCallStatsMapResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callEndedAt = freezed,Object? callId = null,Object? callSessionId = null,Object? callStartedAt = freezed,Object? callType = null,Object? counts = null,Object? dataSource = freezed,Object? duration = null,Object? endTime = freezed,Object? generatedAt = freezed,Object? publishers = freezed,Object? sfus = freezed,Object? startTime = freezed,Object? subscribers = freezed,}) {
  return _then(QueryCallStatsMapResponse(
callEndedAt: freezed == callEndedAt ? _self.callEndedAt : callEndedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,callSessionId: null == callSessionId ? _self.callSessionId : callSessionId // ignore: cast_nullable_to_non_nullable
as String,callStartedAt: freezed == callStartedAt ? _self.callStartedAt : callStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,callType: null == callType ? _self.callType : callType // ignore: cast_nullable_to_non_nullable
as String,counts: null == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as CallStatsParticipantCounts,dataSource: freezed == dataSource ? _self.dataSource : dataSource // ignore: cast_nullable_to_non_nullable
as String?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,generatedAt: freezed == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,publishers: freezed == publishers ? _self.publishers : publishers // ignore: cast_nullable_to_non_nullable
as CallStatsMapPublishers?,sfus: freezed == sfus ? _self.sfus : sfus // ignore: cast_nullable_to_non_nullable
as CallStatsMapSFUs?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,subscribers: freezed == subscribers ? _self.subscribers : subscribers // ignore: cast_nullable_to_non_nullable
as CallStatsMapSubscribers?,
  ));
}

}


/// Adds pattern-matching-related methods to [QueryCallStatsMapResponse].
extension QueryCallStatsMapResponsePatterns on QueryCallStatsMapResponse {
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
