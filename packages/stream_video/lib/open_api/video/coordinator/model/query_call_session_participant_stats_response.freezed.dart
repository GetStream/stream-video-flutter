// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_call_session_participant_stats_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QueryCallSessionParticipantStatsResponse {

 DateTime? get callEndedAt; List<CallLevelEventPayload>? get callEvents; String get callId; String get callSessionId; DateTime? get callStartedAt; String get callType; CallStatsParticipantCounts get counts; String get duration; String? get next; List<CallStatsParticipant> get participants; String? get prev; String? get tmpDataSource;
/// Create a copy of QueryCallSessionParticipantStatsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueryCallSessionParticipantStatsResponseCopyWith<QueryCallSessionParticipantStatsResponse> get copyWith => _$QueryCallSessionParticipantStatsResponseCopyWithImpl<QueryCallSessionParticipantStatsResponse>(this as QueryCallSessionParticipantStatsResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueryCallSessionParticipantStatsResponse&&(identical(other.callEndedAt, callEndedAt) || other.callEndedAt == callEndedAt)&&const DeepCollectionEquality().equals(other.callEvents, callEvents)&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.callSessionId, callSessionId) || other.callSessionId == callSessionId)&&(identical(other.callStartedAt, callStartedAt) || other.callStartedAt == callStartedAt)&&(identical(other.callType, callType) || other.callType == callType)&&(identical(other.counts, counts) || other.counts == counts)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.next, next) || other.next == next)&&const DeepCollectionEquality().equals(other.participants, participants)&&(identical(other.prev, prev) || other.prev == prev)&&(identical(other.tmpDataSource, tmpDataSource) || other.tmpDataSource == tmpDataSource));
}


@override
int get hashCode => Object.hash(runtimeType,callEndedAt,const DeepCollectionEquality().hash(callEvents),callId,callSessionId,callStartedAt,callType,counts,duration,next,const DeepCollectionEquality().hash(participants),prev,tmpDataSource);

@override
String toString() {
  return 'QueryCallSessionParticipantStatsResponse(callEndedAt: $callEndedAt, callEvents: $callEvents, callId: $callId, callSessionId: $callSessionId, callStartedAt: $callStartedAt, callType: $callType, counts: $counts, duration: $duration, next: $next, participants: $participants, prev: $prev, tmpDataSource: $tmpDataSource)';
}


}

/// @nodoc
abstract mixin class $QueryCallSessionParticipantStatsResponseCopyWith<$Res>  {
  factory $QueryCallSessionParticipantStatsResponseCopyWith(QueryCallSessionParticipantStatsResponse value, $Res Function(QueryCallSessionParticipantStatsResponse) _then) = _$QueryCallSessionParticipantStatsResponseCopyWithImpl;
@useResult
$Res call({
 DateTime? callEndedAt, List<CallLevelEventPayload>? callEvents, String callId, String callSessionId, DateTime? callStartedAt, String callType, CallStatsParticipantCounts counts, String duration, String? next, List<CallStatsParticipant> participants, String? prev, String? tmpDataSource
});




}
/// @nodoc
class _$QueryCallSessionParticipantStatsResponseCopyWithImpl<$Res>
    implements $QueryCallSessionParticipantStatsResponseCopyWith<$Res> {
  _$QueryCallSessionParticipantStatsResponseCopyWithImpl(this._self, this._then);

  final QueryCallSessionParticipantStatsResponse _self;
  final $Res Function(QueryCallSessionParticipantStatsResponse) _then;

/// Create a copy of QueryCallSessionParticipantStatsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callEndedAt = freezed,Object? callEvents = freezed,Object? callId = null,Object? callSessionId = null,Object? callStartedAt = freezed,Object? callType = null,Object? counts = null,Object? duration = null,Object? next = freezed,Object? participants = null,Object? prev = freezed,Object? tmpDataSource = freezed,}) {
  return _then(QueryCallSessionParticipantStatsResponse(
callEndedAt: freezed == callEndedAt ? _self.callEndedAt : callEndedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,callEvents: freezed == callEvents ? _self.callEvents : callEvents // ignore: cast_nullable_to_non_nullable
as List<CallLevelEventPayload>?,callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,callSessionId: null == callSessionId ? _self.callSessionId : callSessionId // ignore: cast_nullable_to_non_nullable
as String,callStartedAt: freezed == callStartedAt ? _self.callStartedAt : callStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,callType: null == callType ? _self.callType : callType // ignore: cast_nullable_to_non_nullable
as String,counts: null == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as CallStatsParticipantCounts,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<CallStatsParticipant>,prev: freezed == prev ? _self.prev : prev // ignore: cast_nullable_to_non_nullable
as String?,tmpDataSource: freezed == tmpDataSource ? _self.tmpDataSource : tmpDataSource // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [QueryCallSessionParticipantStatsResponse].
extension QueryCallSessionParticipantStatsResponsePatterns on QueryCallSessionParticipantStatsResponse {
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
