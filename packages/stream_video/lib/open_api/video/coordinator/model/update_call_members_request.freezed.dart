// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_call_members_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UpdateCallMembersRequest {

 List<String>? get removeMembers; List<MemberRequest>? get updateMembers;
/// Create a copy of UpdateCallMembersRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateCallMembersRequestCopyWith<UpdateCallMembersRequest> get copyWith => _$UpdateCallMembersRequestCopyWithImpl<UpdateCallMembersRequest>(this as UpdateCallMembersRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateCallMembersRequest&&const DeepCollectionEquality().equals(other.removeMembers, removeMembers)&&const DeepCollectionEquality().equals(other.updateMembers, updateMembers));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(removeMembers),const DeepCollectionEquality().hash(updateMembers));

@override
String toString() {
  return 'UpdateCallMembersRequest(removeMembers: $removeMembers, updateMembers: $updateMembers)';
}


}

/// @nodoc
abstract mixin class $UpdateCallMembersRequestCopyWith<$Res>  {
  factory $UpdateCallMembersRequestCopyWith(UpdateCallMembersRequest value, $Res Function(UpdateCallMembersRequest) _then) = _$UpdateCallMembersRequestCopyWithImpl;
@useResult
$Res call({
 List<String>? removeMembers, List<MemberRequest>? updateMembers
});




}
/// @nodoc
class _$UpdateCallMembersRequestCopyWithImpl<$Res>
    implements $UpdateCallMembersRequestCopyWith<$Res> {
  _$UpdateCallMembersRequestCopyWithImpl(this._self, this._then);

  final UpdateCallMembersRequest _self;
  final $Res Function(UpdateCallMembersRequest) _then;

/// Create a copy of UpdateCallMembersRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? removeMembers = freezed,Object? updateMembers = freezed,}) {
  return _then(UpdateCallMembersRequest(
removeMembers: freezed == removeMembers ? _self.removeMembers : removeMembers // ignore: cast_nullable_to_non_nullable
as List<String>?,updateMembers: freezed == updateMembers ? _self.updateMembers : updateMembers // ignore: cast_nullable_to_non_nullable
as List<MemberRequest>?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateCallMembersRequest].
extension UpdateCallMembersRequestPatterns on UpdateCallMembersRequest {
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
