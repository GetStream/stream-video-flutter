// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_user_permissions_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UpdateUserPermissionsRequest {

 List<UpdateUserPermissionsRequestGrantPermissions>? get grantPermissions; List<UpdateUserPermissionsRequestRevokePermissions>? get revokePermissions; String get userId;
/// Create a copy of UpdateUserPermissionsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateUserPermissionsRequestCopyWith<UpdateUserPermissionsRequest> get copyWith => _$UpdateUserPermissionsRequestCopyWithImpl<UpdateUserPermissionsRequest>(this as UpdateUserPermissionsRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateUserPermissionsRequest&&const DeepCollectionEquality().equals(other.grantPermissions, grantPermissions)&&const DeepCollectionEquality().equals(other.revokePermissions, revokePermissions)&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(grantPermissions),const DeepCollectionEquality().hash(revokePermissions),userId);

@override
String toString() {
  return 'UpdateUserPermissionsRequest(grantPermissions: $grantPermissions, revokePermissions: $revokePermissions, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $UpdateUserPermissionsRequestCopyWith<$Res>  {
  factory $UpdateUserPermissionsRequestCopyWith(UpdateUserPermissionsRequest value, $Res Function(UpdateUserPermissionsRequest) _then) = _$UpdateUserPermissionsRequestCopyWithImpl;
@useResult
$Res call({
 List<UpdateUserPermissionsRequestGrantPermissions>? grantPermissions, List<UpdateUserPermissionsRequestRevokePermissions>? revokePermissions, String userId
});




}
/// @nodoc
class _$UpdateUserPermissionsRequestCopyWithImpl<$Res>
    implements $UpdateUserPermissionsRequestCopyWith<$Res> {
  _$UpdateUserPermissionsRequestCopyWithImpl(this._self, this._then);

  final UpdateUserPermissionsRequest _self;
  final $Res Function(UpdateUserPermissionsRequest) _then;

/// Create a copy of UpdateUserPermissionsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? grantPermissions = freezed,Object? revokePermissions = freezed,Object? userId = null,}) {
  return _then(UpdateUserPermissionsRequest(
grantPermissions: freezed == grantPermissions ? _self.grantPermissions : grantPermissions // ignore: cast_nullable_to_non_nullable
as List<UpdateUserPermissionsRequestGrantPermissions>?,revokePermissions: freezed == revokePermissions ? _self.revokePermissions : revokePermissions // ignore: cast_nullable_to_non_nullable
as List<UpdateUserPermissionsRequestRevokePermissions>?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateUserPermissionsRequest].
extension UpdateUserPermissionsRequestPatterns on UpdateUserPermissionsRequest {
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
