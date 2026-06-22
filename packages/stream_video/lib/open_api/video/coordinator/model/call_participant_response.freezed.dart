// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_participant_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallParticipantResponse {

 DateTime get joinedAt; String get role; UserResponse get user; String get userSessionId;
/// Create a copy of CallParticipantResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallParticipantResponseCopyWith<CallParticipantResponse> get copyWith => _$CallParticipantResponseCopyWithImpl<CallParticipantResponse>(this as CallParticipantResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallParticipantResponse&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.role, role) || other.role == role)&&(identical(other.user, user) || other.user == user)&&(identical(other.userSessionId, userSessionId) || other.userSessionId == userSessionId));
}


@override
int get hashCode => Object.hash(runtimeType,joinedAt,role,user,userSessionId);

@override
String toString() {
  return 'CallParticipantResponse(joinedAt: $joinedAt, role: $role, user: $user, userSessionId: $userSessionId)';
}


}

/// @nodoc
abstract mixin class $CallParticipantResponseCopyWith<$Res>  {
  factory $CallParticipantResponseCopyWith(CallParticipantResponse value, $Res Function(CallParticipantResponse) _then) = _$CallParticipantResponseCopyWithImpl;
@useResult
$Res call({
 DateTime joinedAt, String role, UserResponse user, String userSessionId
});




}
/// @nodoc
class _$CallParticipantResponseCopyWithImpl<$Res>
    implements $CallParticipantResponseCopyWith<$Res> {
  _$CallParticipantResponseCopyWithImpl(this._self, this._then);

  final CallParticipantResponse _self;
  final $Res Function(CallParticipantResponse) _then;

/// Create a copy of CallParticipantResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? joinedAt = null,Object? role = null,Object? user = null,Object? userSessionId = null,}) {
  return _then(CallParticipantResponse(
joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserResponse,userSessionId: null == userSessionId ? _self.userSessionId : userSessionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CallParticipantResponse].
extension CallParticipantResponsePatterns on CallParticipantResponse {
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
