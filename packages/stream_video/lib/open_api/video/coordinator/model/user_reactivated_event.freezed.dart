// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_reactivated_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserReactivatedEvent {

 DateTime get createdAt; UserResponseCommonFields? get createdBy; Map<String, Object?> get custom; DateTime? get receivedAt; String get type; UserResponseCommonFields get user;
/// Create a copy of UserReactivatedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserReactivatedEventCopyWith<UserReactivatedEvent> get copyWith => _$UserReactivatedEventCopyWithImpl<UserReactivatedEvent>(this as UserReactivatedEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserReactivatedEvent&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&const DeepCollectionEquality().equals(other.custom, custom)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt)&&(identical(other.type, type) || other.type == type)&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,createdAt,createdBy,const DeepCollectionEquality().hash(custom),receivedAt,type,user);

@override
String toString() {
  return 'UserReactivatedEvent(createdAt: $createdAt, createdBy: $createdBy, custom: $custom, receivedAt: $receivedAt, type: $type, user: $user)';
}


}

/// @nodoc
abstract mixin class $UserReactivatedEventCopyWith<$Res>  {
  factory $UserReactivatedEventCopyWith(UserReactivatedEvent value, $Res Function(UserReactivatedEvent) _then) = _$UserReactivatedEventCopyWithImpl;
@useResult
$Res call({
 DateTime createdAt, UserResponseCommonFields? createdBy, Map<String, Object?> custom, DateTime? receivedAt, String type, UserResponseCommonFields user
});




}
/// @nodoc
class _$UserReactivatedEventCopyWithImpl<$Res>
    implements $UserReactivatedEventCopyWith<$Res> {
  _$UserReactivatedEventCopyWithImpl(this._self, this._then);

  final UserReactivatedEvent _self;
  final $Res Function(UserReactivatedEvent) _then;

/// Create a copy of UserReactivatedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? createdAt = null,Object? createdBy = freezed,Object? custom = null,Object? receivedAt = freezed,Object? type = null,Object? user = null,}) {
  return _then(UserReactivatedEvent(
createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as UserResponseCommonFields?,custom: null == custom ? _self.custom : custom // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,receivedAt: freezed == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserResponseCommonFields,
  ));
}

}


/// Adds pattern-matching-related methods to [UserReactivatedEvent].
extension UserReactivatedEventPatterns on UserReactivatedEvent {
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
