// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_user_feedback_submitted_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallUserFeedbackSubmittedEvent {

 String get callCid; DateTime get createdAt; Map<String, Object?>? get custom; int get rating; String? get reason; String? get sdk; String? get sdkVersion; String get sessionId; String get type; UserResponse get user;
/// Create a copy of CallUserFeedbackSubmittedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallUserFeedbackSubmittedEventCopyWith<CallUserFeedbackSubmittedEvent> get copyWith => _$CallUserFeedbackSubmittedEventCopyWithImpl<CallUserFeedbackSubmittedEvent>(this as CallUserFeedbackSubmittedEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallUserFeedbackSubmittedEvent&&(identical(other.callCid, callCid) || other.callCid == callCid)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.custom, custom)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.sdk, sdk) || other.sdk == sdk)&&(identical(other.sdkVersion, sdkVersion) || other.sdkVersion == sdkVersion)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.type, type) || other.type == type)&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,callCid,createdAt,const DeepCollectionEquality().hash(custom),rating,reason,sdk,sdkVersion,sessionId,type,user);

@override
String toString() {
  return 'CallUserFeedbackSubmittedEvent(callCid: $callCid, createdAt: $createdAt, custom: $custom, rating: $rating, reason: $reason, sdk: $sdk, sdkVersion: $sdkVersion, sessionId: $sessionId, type: $type, user: $user)';
}


}

/// @nodoc
abstract mixin class $CallUserFeedbackSubmittedEventCopyWith<$Res>  {
  factory $CallUserFeedbackSubmittedEventCopyWith(CallUserFeedbackSubmittedEvent value, $Res Function(CallUserFeedbackSubmittedEvent) _then) = _$CallUserFeedbackSubmittedEventCopyWithImpl;
@useResult
$Res call({
 String callCid, DateTime createdAt, Map<String, Object?>? custom, int rating, String? reason, String? sdk, String? sdkVersion, String sessionId, String type, UserResponse user
});




}
/// @nodoc
class _$CallUserFeedbackSubmittedEventCopyWithImpl<$Res>
    implements $CallUserFeedbackSubmittedEventCopyWith<$Res> {
  _$CallUserFeedbackSubmittedEventCopyWithImpl(this._self, this._then);

  final CallUserFeedbackSubmittedEvent _self;
  final $Res Function(CallUserFeedbackSubmittedEvent) _then;

/// Create a copy of CallUserFeedbackSubmittedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callCid = null,Object? createdAt = null,Object? custom = freezed,Object? rating = null,Object? reason = freezed,Object? sdk = freezed,Object? sdkVersion = freezed,Object? sessionId = null,Object? type = null,Object? user = null,}) {
  return _then(CallUserFeedbackSubmittedEvent(
callCid: null == callCid ? _self.callCid : callCid // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,custom: freezed == custom ? _self.custom : custom // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,sdk: freezed == sdk ? _self.sdk : sdk // ignore: cast_nullable_to_non_nullable
as String?,sdkVersion: freezed == sdkVersion ? _self.sdkVersion : sdkVersion // ignore: cast_nullable_to_non_nullable
as String?,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserResponse,
  ));
}

}


/// Adds pattern-matching-related methods to [CallUserFeedbackSubmittedEvent].
extension CallUserFeedbackSubmittedEventPatterns on CallUserFeedbackSubmittedEvent {
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
