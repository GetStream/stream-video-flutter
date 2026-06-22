// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallRequest {

 String? get channelCid; Map<String, Object?>? get custom; List<MemberRequest>? get members; CallSettingsRequest? get settingsOverride; DateTime? get startsAt; String? get team; bool? get video;
/// Create a copy of CallRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallRequestCopyWith<CallRequest> get copyWith => _$CallRequestCopyWithImpl<CallRequest>(this as CallRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallRequest&&(identical(other.channelCid, channelCid) || other.channelCid == channelCid)&&const DeepCollectionEquality().equals(other.custom, custom)&&const DeepCollectionEquality().equals(other.members, members)&&(identical(other.settingsOverride, settingsOverride) || other.settingsOverride == settingsOverride)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.team, team) || other.team == team)&&(identical(other.video, video) || other.video == video));
}


@override
int get hashCode => Object.hash(runtimeType,channelCid,const DeepCollectionEquality().hash(custom),const DeepCollectionEquality().hash(members),settingsOverride,startsAt,team,video);

@override
String toString() {
  return 'CallRequest(channelCid: $channelCid, custom: $custom, members: $members, settingsOverride: $settingsOverride, startsAt: $startsAt, team: $team, video: $video)';
}


}

/// @nodoc
abstract mixin class $CallRequestCopyWith<$Res>  {
  factory $CallRequestCopyWith(CallRequest value, $Res Function(CallRequest) _then) = _$CallRequestCopyWithImpl;
@useResult
$Res call({
 String? channelCid, Map<String, Object?>? custom, List<MemberRequest>? members, CallSettingsRequest? settingsOverride, DateTime? startsAt, String? team, bool? video
});




}
/// @nodoc
class _$CallRequestCopyWithImpl<$Res>
    implements $CallRequestCopyWith<$Res> {
  _$CallRequestCopyWithImpl(this._self, this._then);

  final CallRequest _self;
  final $Res Function(CallRequest) _then;

/// Create a copy of CallRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? channelCid = freezed,Object? custom = freezed,Object? members = freezed,Object? settingsOverride = freezed,Object? startsAt = freezed,Object? team = freezed,Object? video = freezed,}) {
  return _then(CallRequest(
channelCid: freezed == channelCid ? _self.channelCid : channelCid // ignore: cast_nullable_to_non_nullable
as String?,custom: freezed == custom ? _self.custom : custom // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,members: freezed == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<MemberRequest>?,settingsOverride: freezed == settingsOverride ? _self.settingsOverride : settingsOverride // ignore: cast_nullable_to_non_nullable
as CallSettingsRequest?,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,team: freezed == team ? _self.team : team // ignore: cast_nullable_to_non_nullable
as String?,video: freezed == video ? _self.video : video // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [CallRequest].
extension CallRequestPatterns on CallRequest {
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
