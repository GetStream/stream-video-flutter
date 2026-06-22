// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_session_participant_counts_updated_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallSessionParticipantCountsUpdatedEvent {

 int get anonymousParticipantCount; String get callCid; DateTime get createdAt; Map<String, int> get participantsCountByRole; String get sessionId; String get type;
/// Create a copy of CallSessionParticipantCountsUpdatedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallSessionParticipantCountsUpdatedEventCopyWith<CallSessionParticipantCountsUpdatedEvent> get copyWith => _$CallSessionParticipantCountsUpdatedEventCopyWithImpl<CallSessionParticipantCountsUpdatedEvent>(this as CallSessionParticipantCountsUpdatedEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallSessionParticipantCountsUpdatedEvent&&(identical(other.anonymousParticipantCount, anonymousParticipantCount) || other.anonymousParticipantCount == anonymousParticipantCount)&&(identical(other.callCid, callCid) || other.callCid == callCid)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.participantsCountByRole, participantsCountByRole)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,anonymousParticipantCount,callCid,createdAt,const DeepCollectionEquality().hash(participantsCountByRole),sessionId,type);

@override
String toString() {
  return 'CallSessionParticipantCountsUpdatedEvent(anonymousParticipantCount: $anonymousParticipantCount, callCid: $callCid, createdAt: $createdAt, participantsCountByRole: $participantsCountByRole, sessionId: $sessionId, type: $type)';
}


}

/// @nodoc
abstract mixin class $CallSessionParticipantCountsUpdatedEventCopyWith<$Res>  {
  factory $CallSessionParticipantCountsUpdatedEventCopyWith(CallSessionParticipantCountsUpdatedEvent value, $Res Function(CallSessionParticipantCountsUpdatedEvent) _then) = _$CallSessionParticipantCountsUpdatedEventCopyWithImpl;
@useResult
$Res call({
 int anonymousParticipantCount, String callCid, DateTime createdAt, Map<String, int> participantsCountByRole, String sessionId, String type
});




}
/// @nodoc
class _$CallSessionParticipantCountsUpdatedEventCopyWithImpl<$Res>
    implements $CallSessionParticipantCountsUpdatedEventCopyWith<$Res> {
  _$CallSessionParticipantCountsUpdatedEventCopyWithImpl(this._self, this._then);

  final CallSessionParticipantCountsUpdatedEvent _self;
  final $Res Function(CallSessionParticipantCountsUpdatedEvent) _then;

/// Create a copy of CallSessionParticipantCountsUpdatedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? anonymousParticipantCount = null,Object? callCid = null,Object? createdAt = null,Object? participantsCountByRole = null,Object? sessionId = null,Object? type = null,}) {
  return _then(CallSessionParticipantCountsUpdatedEvent(
anonymousParticipantCount: null == anonymousParticipantCount ? _self.anonymousParticipantCount : anonymousParticipantCount // ignore: cast_nullable_to_non_nullable
as int,callCid: null == callCid ? _self.callCid : callCid // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,participantsCountByRole: null == participantsCountByRole ? _self.participantsCountByRole : participantsCountByRole // ignore: cast_nullable_to_non_nullable
as Map<String, int>,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CallSessionParticipantCountsUpdatedEvent].
extension CallSessionParticipantCountsUpdatedEventPatterns on CallSessionParticipantCountsUpdatedEvent {
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
