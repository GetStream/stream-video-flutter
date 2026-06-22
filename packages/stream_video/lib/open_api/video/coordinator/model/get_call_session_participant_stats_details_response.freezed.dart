// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_call_session_participant_stats_details_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GetCallSessionParticipantStatsDetailsResponse {

 String get callId; String get callSessionId; String get callType; String get duration; ParticipantSeriesPublisherStats? get publisher; ParticipantSeriesSubscriberStats? get subscriber; ParticipantSeriesTimeframe? get timeframe; ParticipantSeriesUserStats? get user; String get userId; String get userSessionId;
/// Create a copy of GetCallSessionParticipantStatsDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetCallSessionParticipantStatsDetailsResponseCopyWith<GetCallSessionParticipantStatsDetailsResponse> get copyWith => _$GetCallSessionParticipantStatsDetailsResponseCopyWithImpl<GetCallSessionParticipantStatsDetailsResponse>(this as GetCallSessionParticipantStatsDetailsResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetCallSessionParticipantStatsDetailsResponse&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.callSessionId, callSessionId) || other.callSessionId == callSessionId)&&(identical(other.callType, callType) || other.callType == callType)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.subscriber, subscriber) || other.subscriber == subscriber)&&(identical(other.timeframe, timeframe) || other.timeframe == timeframe)&&(identical(other.user, user) || other.user == user)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userSessionId, userSessionId) || other.userSessionId == userSessionId));
}


@override
int get hashCode => Object.hash(runtimeType,callId,callSessionId,callType,duration,publisher,subscriber,timeframe,user,userId,userSessionId);

@override
String toString() {
  return 'GetCallSessionParticipantStatsDetailsResponse(callId: $callId, callSessionId: $callSessionId, callType: $callType, duration: $duration, publisher: $publisher, subscriber: $subscriber, timeframe: $timeframe, user: $user, userId: $userId, userSessionId: $userSessionId)';
}


}

/// @nodoc
abstract mixin class $GetCallSessionParticipantStatsDetailsResponseCopyWith<$Res>  {
  factory $GetCallSessionParticipantStatsDetailsResponseCopyWith(GetCallSessionParticipantStatsDetailsResponse value, $Res Function(GetCallSessionParticipantStatsDetailsResponse) _then) = _$GetCallSessionParticipantStatsDetailsResponseCopyWithImpl;
@useResult
$Res call({
 String callId, String callSessionId, String callType, String duration, ParticipantSeriesPublisherStats? publisher, ParticipantSeriesSubscriberStats? subscriber, ParticipantSeriesTimeframe? timeframe, ParticipantSeriesUserStats? user, String userId, String userSessionId
});




}
/// @nodoc
class _$GetCallSessionParticipantStatsDetailsResponseCopyWithImpl<$Res>
    implements $GetCallSessionParticipantStatsDetailsResponseCopyWith<$Res> {
  _$GetCallSessionParticipantStatsDetailsResponseCopyWithImpl(this._self, this._then);

  final GetCallSessionParticipantStatsDetailsResponse _self;
  final $Res Function(GetCallSessionParticipantStatsDetailsResponse) _then;

/// Create a copy of GetCallSessionParticipantStatsDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callId = null,Object? callSessionId = null,Object? callType = null,Object? duration = null,Object? publisher = freezed,Object? subscriber = freezed,Object? timeframe = freezed,Object? user = freezed,Object? userId = null,Object? userSessionId = null,}) {
  return _then(GetCallSessionParticipantStatsDetailsResponse(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,callSessionId: null == callSessionId ? _self.callSessionId : callSessionId // ignore: cast_nullable_to_non_nullable
as String,callType: null == callType ? _self.callType : callType // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as ParticipantSeriesPublisherStats?,subscriber: freezed == subscriber ? _self.subscriber : subscriber // ignore: cast_nullable_to_non_nullable
as ParticipantSeriesSubscriberStats?,timeframe: freezed == timeframe ? _self.timeframe : timeframe // ignore: cast_nullable_to_non_nullable
as ParticipantSeriesTimeframe?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as ParticipantSeriesUserStats?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userSessionId: null == userSessionId ? _self.userSessionId : userSessionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GetCallSessionParticipantStatsDetailsResponse].
extension GetCallSessionParticipantStatsDetailsResponsePatterns on GetCallSessionParticipantStatsDetailsResponse {
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
