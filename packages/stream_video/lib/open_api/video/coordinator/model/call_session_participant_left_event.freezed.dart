// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_session_participant_left_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallSessionParticipantLeftEvent {

 String get callCid; DateTime get createdAt; int get durationSeconds; CallParticipantResponse get participant; String? get reason; String get sessionId; String get type;
/// Create a copy of CallSessionParticipantLeftEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallSessionParticipantLeftEventCopyWith<CallSessionParticipantLeftEvent> get copyWith => _$CallSessionParticipantLeftEventCopyWithImpl<CallSessionParticipantLeftEvent>(this as CallSessionParticipantLeftEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallSessionParticipantLeftEvent&&(identical(other.callCid, callCid) || other.callCid == callCid)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.participant, participant) || other.participant == participant)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,callCid,createdAt,durationSeconds,participant,reason,sessionId,type);

@override
String toString() {
  return 'CallSessionParticipantLeftEvent(callCid: $callCid, createdAt: $createdAt, durationSeconds: $durationSeconds, participant: $participant, reason: $reason, sessionId: $sessionId, type: $type)';
}


}

/// @nodoc
abstract mixin class $CallSessionParticipantLeftEventCopyWith<$Res>  {
  factory $CallSessionParticipantLeftEventCopyWith(CallSessionParticipantLeftEvent value, $Res Function(CallSessionParticipantLeftEvent) _then) = _$CallSessionParticipantLeftEventCopyWithImpl;
@useResult
$Res call({
 String callCid, DateTime createdAt, int durationSeconds, CallParticipantResponse participant, String? reason, String sessionId, String type
});




}
/// @nodoc
class _$CallSessionParticipantLeftEventCopyWithImpl<$Res>
    implements $CallSessionParticipantLeftEventCopyWith<$Res> {
  _$CallSessionParticipantLeftEventCopyWithImpl(this._self, this._then);

  final CallSessionParticipantLeftEvent _self;
  final $Res Function(CallSessionParticipantLeftEvent) _then;

/// Create a copy of CallSessionParticipantLeftEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callCid = null,Object? createdAt = null,Object? durationSeconds = null,Object? participant = null,Object? reason = freezed,Object? sessionId = null,Object? type = null,}) {
  return _then(CallSessionParticipantLeftEvent(
callCid: null == callCid ? _self.callCid : callCid // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,participant: null == participant ? _self.participant : participant // ignore: cast_nullable_to_non_nullable
as CallParticipantResponse,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CallSessionParticipantLeftEvent].
extension CallSessionParticipantLeftEventPatterns on CallSessionParticipantLeftEvent {
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
