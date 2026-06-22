// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_member_updated_permission_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallMemberUpdatedPermissionEvent {

 CallResponse get call; String get callCid; Map<String, List<String>> get capabilitiesByRole; DateTime get createdAt; List<MemberResponse> get members; String get type;
/// Create a copy of CallMemberUpdatedPermissionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallMemberUpdatedPermissionEventCopyWith<CallMemberUpdatedPermissionEvent> get copyWith => _$CallMemberUpdatedPermissionEventCopyWithImpl<CallMemberUpdatedPermissionEvent>(this as CallMemberUpdatedPermissionEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallMemberUpdatedPermissionEvent&&(identical(other.call, call) || other.call == call)&&(identical(other.callCid, callCid) || other.callCid == callCid)&&const DeepCollectionEquality().equals(other.capabilitiesByRole, capabilitiesByRole)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.members, members)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,call,callCid,const DeepCollectionEquality().hash(capabilitiesByRole),createdAt,const DeepCollectionEquality().hash(members),type);

@override
String toString() {
  return 'CallMemberUpdatedPermissionEvent(call: $call, callCid: $callCid, capabilitiesByRole: $capabilitiesByRole, createdAt: $createdAt, members: $members, type: $type)';
}


}

/// @nodoc
abstract mixin class $CallMemberUpdatedPermissionEventCopyWith<$Res>  {
  factory $CallMemberUpdatedPermissionEventCopyWith(CallMemberUpdatedPermissionEvent value, $Res Function(CallMemberUpdatedPermissionEvent) _then) = _$CallMemberUpdatedPermissionEventCopyWithImpl;
@useResult
$Res call({
 CallResponse call, String callCid, Map<String, List<String>> capabilitiesByRole, DateTime createdAt, List<MemberResponse> members, String type
});




}
/// @nodoc
class _$CallMemberUpdatedPermissionEventCopyWithImpl<$Res>
    implements $CallMemberUpdatedPermissionEventCopyWith<$Res> {
  _$CallMemberUpdatedPermissionEventCopyWithImpl(this._self, this._then);

  final CallMemberUpdatedPermissionEvent _self;
  final $Res Function(CallMemberUpdatedPermissionEvent) _then;

/// Create a copy of CallMemberUpdatedPermissionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? call = null,Object? callCid = null,Object? capabilitiesByRole = null,Object? createdAt = null,Object? members = null,Object? type = null,}) {
  return _then(CallMemberUpdatedPermissionEvent(
call: null == call ? _self.call : call // ignore: cast_nullable_to_non_nullable
as CallResponse,callCid: null == callCid ? _self.callCid : callCid // ignore: cast_nullable_to_non_nullable
as String,capabilitiesByRole: null == capabilitiesByRole ? _self.capabilitiesByRole : capabilitiesByRole // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<MemberResponse>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CallMemberUpdatedPermissionEvent].
extension CallMemberUpdatedPermissionEventPatterns on CallMemberUpdatedPermissionEvent {
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
