// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mute_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MuteResponse {

 String get duration; List<UserMuteResponse>? get mutes; List<String>? get nonExistingUsers; OwnUserResponse? get ownUser;
/// Create a copy of MuteResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MuteResponseCopyWith<MuteResponse> get copyWith => _$MuteResponseCopyWithImpl<MuteResponse>(this as MuteResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MuteResponse&&(identical(other.duration, duration) || other.duration == duration)&&const DeepCollectionEquality().equals(other.mutes, mutes)&&const DeepCollectionEquality().equals(other.nonExistingUsers, nonExistingUsers)&&(identical(other.ownUser, ownUser) || other.ownUser == ownUser));
}


@override
int get hashCode => Object.hash(runtimeType,duration,const DeepCollectionEquality().hash(mutes),const DeepCollectionEquality().hash(nonExistingUsers),ownUser);

@override
String toString() {
  return 'MuteResponse(duration: $duration, mutes: $mutes, nonExistingUsers: $nonExistingUsers, ownUser: $ownUser)';
}


}

/// @nodoc
abstract mixin class $MuteResponseCopyWith<$Res>  {
  factory $MuteResponseCopyWith(MuteResponse value, $Res Function(MuteResponse) _then) = _$MuteResponseCopyWithImpl;
@useResult
$Res call({
 String duration, List<UserMuteResponse>? mutes, List<String>? nonExistingUsers, OwnUserResponse? ownUser
});




}
/// @nodoc
class _$MuteResponseCopyWithImpl<$Res>
    implements $MuteResponseCopyWith<$Res> {
  _$MuteResponseCopyWithImpl(this._self, this._then);

  final MuteResponse _self;
  final $Res Function(MuteResponse) _then;

/// Create a copy of MuteResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? duration = null,Object? mutes = freezed,Object? nonExistingUsers = freezed,Object? ownUser = freezed,}) {
  return _then(MuteResponse(
duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,mutes: freezed == mutes ? _self.mutes : mutes // ignore: cast_nullable_to_non_nullable
as List<UserMuteResponse>?,nonExistingUsers: freezed == nonExistingUsers ? _self.nonExistingUsers : nonExistingUsers // ignore: cast_nullable_to_non_nullable
as List<String>?,ownUser: freezed == ownUser ? _self.ownUser : ownUser // ignore: cast_nullable_to_non_nullable
as OwnUserResponse?,
  ));
}

}


/// Adds pattern-matching-related methods to [MuteResponse].
extension MuteResponsePatterns on MuteResponse {
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
