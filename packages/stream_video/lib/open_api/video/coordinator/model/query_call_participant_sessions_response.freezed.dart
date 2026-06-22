// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_call_participant_sessions_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QueryCallParticipantSessionsResponse {

 String get callId; String get callSessionId; String get callType; int get duration; String? get next; List<ParticipantSessionDetails> get participantsSessions; String? get prev; CallSessionResponse? get session; int get totalParticipantDuration; int get totalParticipantSessions;
/// Create a copy of QueryCallParticipantSessionsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueryCallParticipantSessionsResponseCopyWith<QueryCallParticipantSessionsResponse> get copyWith => _$QueryCallParticipantSessionsResponseCopyWithImpl<QueryCallParticipantSessionsResponse>(this as QueryCallParticipantSessionsResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueryCallParticipantSessionsResponse&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.callSessionId, callSessionId) || other.callSessionId == callSessionId)&&(identical(other.callType, callType) || other.callType == callType)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.next, next) || other.next == next)&&const DeepCollectionEquality().equals(other.participantsSessions, participantsSessions)&&(identical(other.prev, prev) || other.prev == prev)&&(identical(other.session, session) || other.session == session)&&(identical(other.totalParticipantDuration, totalParticipantDuration) || other.totalParticipantDuration == totalParticipantDuration)&&(identical(other.totalParticipantSessions, totalParticipantSessions) || other.totalParticipantSessions == totalParticipantSessions));
}


@override
int get hashCode => Object.hash(runtimeType,callId,callSessionId,callType,duration,next,const DeepCollectionEquality().hash(participantsSessions),prev,session,totalParticipantDuration,totalParticipantSessions);

@override
String toString() {
  return 'QueryCallParticipantSessionsResponse(callId: $callId, callSessionId: $callSessionId, callType: $callType, duration: $duration, next: $next, participantsSessions: $participantsSessions, prev: $prev, session: $session, totalParticipantDuration: $totalParticipantDuration, totalParticipantSessions: $totalParticipantSessions)';
}


}

/// @nodoc
abstract mixin class $QueryCallParticipantSessionsResponseCopyWith<$Res>  {
  factory $QueryCallParticipantSessionsResponseCopyWith(QueryCallParticipantSessionsResponse value, $Res Function(QueryCallParticipantSessionsResponse) _then) = _$QueryCallParticipantSessionsResponseCopyWithImpl;
@useResult
$Res call({
 String callId, String callSessionId, String callType, int duration, String? next, List<ParticipantSessionDetails> participantsSessions, String? prev, CallSessionResponse? session, int totalParticipantDuration, int totalParticipantSessions
});




}
/// @nodoc
class _$QueryCallParticipantSessionsResponseCopyWithImpl<$Res>
    implements $QueryCallParticipantSessionsResponseCopyWith<$Res> {
  _$QueryCallParticipantSessionsResponseCopyWithImpl(this._self, this._then);

  final QueryCallParticipantSessionsResponse _self;
  final $Res Function(QueryCallParticipantSessionsResponse) _then;

/// Create a copy of QueryCallParticipantSessionsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callId = null,Object? callSessionId = null,Object? callType = null,Object? duration = null,Object? next = freezed,Object? participantsSessions = null,Object? prev = freezed,Object? session = freezed,Object? totalParticipantDuration = null,Object? totalParticipantSessions = null,}) {
  return _then(QueryCallParticipantSessionsResponse(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,callSessionId: null == callSessionId ? _self.callSessionId : callSessionId // ignore: cast_nullable_to_non_nullable
as String,callType: null == callType ? _self.callType : callType // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,participantsSessions: null == participantsSessions ? _self.participantsSessions : participantsSessions // ignore: cast_nullable_to_non_nullable
as List<ParticipantSessionDetails>,prev: freezed == prev ? _self.prev : prev // ignore: cast_nullable_to_non_nullable
as String?,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as CallSessionResponse?,totalParticipantDuration: null == totalParticipantDuration ? _self.totalParticipantDuration : totalParticipantDuration // ignore: cast_nullable_to_non_nullable
as int,totalParticipantSessions: null == totalParticipantSessions ? _self.totalParticipantSessions : totalParticipantSessions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [QueryCallParticipantSessionsResponse].
extension QueryCallParticipantSessionsResponsePatterns on QueryCallParticipantSessionsResponse {
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
