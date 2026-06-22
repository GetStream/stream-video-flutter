// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_call_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UpdateCallResponse {

 CallResponse get call; String get duration; List<MemberResponse> get members; MemberResponse? get membership; List<OwnCapability> get ownCapabilities;
/// Create a copy of UpdateCallResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateCallResponseCopyWith<UpdateCallResponse> get copyWith => _$UpdateCallResponseCopyWithImpl<UpdateCallResponse>(this as UpdateCallResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateCallResponse&&(identical(other.call, call) || other.call == call)&&(identical(other.duration, duration) || other.duration == duration)&&const DeepCollectionEquality().equals(other.members, members)&&(identical(other.membership, membership) || other.membership == membership)&&const DeepCollectionEquality().equals(other.ownCapabilities, ownCapabilities));
}


@override
int get hashCode => Object.hash(runtimeType,call,duration,const DeepCollectionEquality().hash(members),membership,const DeepCollectionEquality().hash(ownCapabilities));

@override
String toString() {
  return 'UpdateCallResponse(call: $call, duration: $duration, members: $members, membership: $membership, ownCapabilities: $ownCapabilities)';
}


}

/// @nodoc
abstract mixin class $UpdateCallResponseCopyWith<$Res>  {
  factory $UpdateCallResponseCopyWith(UpdateCallResponse value, $Res Function(UpdateCallResponse) _then) = _$UpdateCallResponseCopyWithImpl;
@useResult
$Res call({
 CallResponse call, String duration, List<MemberResponse> members, MemberResponse? membership, List<OwnCapability> ownCapabilities
});




}
/// @nodoc
class _$UpdateCallResponseCopyWithImpl<$Res>
    implements $UpdateCallResponseCopyWith<$Res> {
  _$UpdateCallResponseCopyWithImpl(this._self, this._then);

  final UpdateCallResponse _self;
  final $Res Function(UpdateCallResponse) _then;

/// Create a copy of UpdateCallResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? call = null,Object? duration = null,Object? members = null,Object? membership = freezed,Object? ownCapabilities = null,}) {
  return _then(UpdateCallResponse(
call: null == call ? _self.call : call // ignore: cast_nullable_to_non_nullable
as CallResponse,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<MemberResponse>,membership: freezed == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as MemberResponse?,ownCapabilities: null == ownCapabilities ? _self.ownCapabilities : ownCapabilities // ignore: cast_nullable_to_non_nullable
as List<OwnCapability>,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateCallResponse].
extension UpdateCallResponsePatterns on UpdateCallResponse {
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
