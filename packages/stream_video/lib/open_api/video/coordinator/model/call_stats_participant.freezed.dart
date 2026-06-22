// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_stats_participant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallStatsParticipant {

 DateTime? get latestActivityAt; String? get name; List<String>? get roles; List<CallStatsParticipantSession> get sessions; String get userId;
/// Create a copy of CallStatsParticipant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallStatsParticipantCopyWith<CallStatsParticipant> get copyWith => _$CallStatsParticipantCopyWithImpl<CallStatsParticipant>(this as CallStatsParticipant, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallStatsParticipant&&(identical(other.latestActivityAt, latestActivityAt) || other.latestActivityAt == latestActivityAt)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.roles, roles)&&const DeepCollectionEquality().equals(other.sessions, sessions)&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,latestActivityAt,name,const DeepCollectionEquality().hash(roles),const DeepCollectionEquality().hash(sessions),userId);

@override
String toString() {
  return 'CallStatsParticipant(latestActivityAt: $latestActivityAt, name: $name, roles: $roles, sessions: $sessions, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $CallStatsParticipantCopyWith<$Res>  {
  factory $CallStatsParticipantCopyWith(CallStatsParticipant value, $Res Function(CallStatsParticipant) _then) = _$CallStatsParticipantCopyWithImpl;
@useResult
$Res call({
 DateTime? latestActivityAt, String? name, List<String>? roles, List<CallStatsParticipantSession> sessions, String userId
});




}
/// @nodoc
class _$CallStatsParticipantCopyWithImpl<$Res>
    implements $CallStatsParticipantCopyWith<$Res> {
  _$CallStatsParticipantCopyWithImpl(this._self, this._then);

  final CallStatsParticipant _self;
  final $Res Function(CallStatsParticipant) _then;

/// Create a copy of CallStatsParticipant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latestActivityAt = freezed,Object? name = freezed,Object? roles = freezed,Object? sessions = null,Object? userId = null,}) {
  return _then(CallStatsParticipant(
latestActivityAt: freezed == latestActivityAt ? _self.latestActivityAt : latestActivityAt // ignore: cast_nullable_to_non_nullable
as DateTime?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,roles: freezed == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as List<String>?,sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<CallStatsParticipantSession>,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CallStatsParticipant].
extension CallStatsParticipantPatterns on CallStatsParticipant {
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
