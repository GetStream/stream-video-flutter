// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resolve_sip_auth_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResolveSipAuthResponse {

 String get authResult; String get duration; String? get password; String? get trunkId; String? get username;
/// Create a copy of ResolveSipAuthResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResolveSipAuthResponseCopyWith<ResolveSipAuthResponse> get copyWith => _$ResolveSipAuthResponseCopyWithImpl<ResolveSipAuthResponse>(this as ResolveSipAuthResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResolveSipAuthResponse&&(identical(other.authResult, authResult) || other.authResult == authResult)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.password, password) || other.password == password)&&(identical(other.trunkId, trunkId) || other.trunkId == trunkId)&&(identical(other.username, username) || other.username == username));
}


@override
int get hashCode => Object.hash(runtimeType,authResult,duration,password,trunkId,username);

@override
String toString() {
  return 'ResolveSipAuthResponse(authResult: $authResult, duration: $duration, password: $password, trunkId: $trunkId, username: $username)';
}


}

/// @nodoc
abstract mixin class $ResolveSipAuthResponseCopyWith<$Res>  {
  factory $ResolveSipAuthResponseCopyWith(ResolveSipAuthResponse value, $Res Function(ResolveSipAuthResponse) _then) = _$ResolveSipAuthResponseCopyWithImpl;
@useResult
$Res call({
 String authResult, String duration, String? password, String? trunkId, String? username
});




}
/// @nodoc
class _$ResolveSipAuthResponseCopyWithImpl<$Res>
    implements $ResolveSipAuthResponseCopyWith<$Res> {
  _$ResolveSipAuthResponseCopyWithImpl(this._self, this._then);

  final ResolveSipAuthResponse _self;
  final $Res Function(ResolveSipAuthResponse) _then;

/// Create a copy of ResolveSipAuthResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? authResult = null,Object? duration = null,Object? password = freezed,Object? trunkId = freezed,Object? username = freezed,}) {
  return _then(ResolveSipAuthResponse(
authResult: null == authResult ? _self.authResult : authResult // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,trunkId: freezed == trunkId ? _self.trunkId : trunkId // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ResolveSipAuthResponse].
extension ResolveSipAuthResponsePatterns on ResolveSipAuthResponse {
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
