// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collect_user_feedback_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CollectUserFeedbackRequest {

 Map<String, Object?>? get custom; int get rating; String? get reason; String get sdk; String get sdkVersion; String? get userSessionId;
/// Create a copy of CollectUserFeedbackRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectUserFeedbackRequestCopyWith<CollectUserFeedbackRequest> get copyWith => _$CollectUserFeedbackRequestCopyWithImpl<CollectUserFeedbackRequest>(this as CollectUserFeedbackRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollectUserFeedbackRequest&&const DeepCollectionEquality().equals(other.custom, custom)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.sdk, sdk) || other.sdk == sdk)&&(identical(other.sdkVersion, sdkVersion) || other.sdkVersion == sdkVersion)&&(identical(other.userSessionId, userSessionId) || other.userSessionId == userSessionId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(custom),rating,reason,sdk,sdkVersion,userSessionId);

@override
String toString() {
  return 'CollectUserFeedbackRequest(custom: $custom, rating: $rating, reason: $reason, sdk: $sdk, sdkVersion: $sdkVersion, userSessionId: $userSessionId)';
}


}

/// @nodoc
abstract mixin class $CollectUserFeedbackRequestCopyWith<$Res>  {
  factory $CollectUserFeedbackRequestCopyWith(CollectUserFeedbackRequest value, $Res Function(CollectUserFeedbackRequest) _then) = _$CollectUserFeedbackRequestCopyWithImpl;
@useResult
$Res call({
 Map<String, Object?>? custom, int rating, String? reason, String sdk, String sdkVersion, String? userSessionId
});




}
/// @nodoc
class _$CollectUserFeedbackRequestCopyWithImpl<$Res>
    implements $CollectUserFeedbackRequestCopyWith<$Res> {
  _$CollectUserFeedbackRequestCopyWithImpl(this._self, this._then);

  final CollectUserFeedbackRequest _self;
  final $Res Function(CollectUserFeedbackRequest) _then;

/// Create a copy of CollectUserFeedbackRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? custom = freezed,Object? rating = null,Object? reason = freezed,Object? sdk = null,Object? sdkVersion = null,Object? userSessionId = freezed,}) {
  return _then(CollectUserFeedbackRequest(
custom: freezed == custom ? _self.custom : custom // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,sdk: null == sdk ? _self.sdk : sdk // ignore: cast_nullable_to_non_nullable
as String,sdkVersion: null == sdkVersion ? _self.sdkVersion : sdkVersion // ignore: cast_nullable_to_non_nullable
as String,userSessionId: freezed == userSessionId ? _self.userSessionId : userSessionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CollectUserFeedbackRequest].
extension CollectUserFeedbackRequestPatterns on CollectUserFeedbackRequest {
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
