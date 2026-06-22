// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_or_create_call_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GetOrCreateCallResponse {

 CallResponse get call; bool get created; String get duration; List<MemberResponse> get members; MemberResponse? get membership; List<OwnCapability> get ownCapabilities;
/// Create a copy of GetOrCreateCallResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetOrCreateCallResponseCopyWith<GetOrCreateCallResponse> get copyWith => _$GetOrCreateCallResponseCopyWithImpl<GetOrCreateCallResponse>(this as GetOrCreateCallResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetOrCreateCallResponse&&(identical(other.call, call) || other.call == call)&&(identical(other.created, created) || other.created == created)&&(identical(other.duration, duration) || other.duration == duration)&&const DeepCollectionEquality().equals(other.members, members)&&(identical(other.membership, membership) || other.membership == membership)&&const DeepCollectionEquality().equals(other.ownCapabilities, ownCapabilities));
}


@override
int get hashCode => Object.hash(runtimeType,call,created,duration,const DeepCollectionEquality().hash(members),membership,const DeepCollectionEquality().hash(ownCapabilities));

@override
String toString() {
  return 'GetOrCreateCallResponse(call: $call, created: $created, duration: $duration, members: $members, membership: $membership, ownCapabilities: $ownCapabilities)';
}


}

/// @nodoc
abstract mixin class $GetOrCreateCallResponseCopyWith<$Res>  {
  factory $GetOrCreateCallResponseCopyWith(GetOrCreateCallResponse value, $Res Function(GetOrCreateCallResponse) _then) = _$GetOrCreateCallResponseCopyWithImpl;
@useResult
$Res call({
 CallResponse call, bool created, String duration, List<MemberResponse> members, MemberResponse? membership, List<OwnCapability> ownCapabilities
});




}
/// @nodoc
class _$GetOrCreateCallResponseCopyWithImpl<$Res>
    implements $GetOrCreateCallResponseCopyWith<$Res> {
  _$GetOrCreateCallResponseCopyWithImpl(this._self, this._then);

  final GetOrCreateCallResponse _self;
  final $Res Function(GetOrCreateCallResponse) _then;

/// Create a copy of GetOrCreateCallResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? call = null,Object? created = null,Object? duration = null,Object? members = null,Object? membership = freezed,Object? ownCapabilities = null,}) {
  return _then(GetOrCreateCallResponse(
call: null == call ? _self.call : call // ignore: cast_nullable_to_non_nullable
as CallResponse,created: null == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as bool,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<MemberResponse>,membership: freezed == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as MemberResponse?,ownCapabilities: null == ownCapabilities ? _self.ownCapabilities : ownCapabilities // ignore: cast_nullable_to_non_nullable
as List<OwnCapability>,
  ));
}

}


/// Adds pattern-matching-related methods to [GetOrCreateCallResponse].
extension GetOrCreateCallResponsePatterns on GetOrCreateCallResponse {
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
