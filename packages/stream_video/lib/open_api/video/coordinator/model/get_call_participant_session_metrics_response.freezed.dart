// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_call_participant_session_metrics_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GetCallParticipantSessionMetricsResponse {

 SessionClient? get client; String get duration; bool? get isPublisher; bool? get isSubscriber; DateTime? get joinedAt; List<PublishedTrackMetrics>? get publishedTracks; String? get publisherType; String? get userId; String? get userSessionId;
/// Create a copy of GetCallParticipantSessionMetricsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetCallParticipantSessionMetricsResponseCopyWith<GetCallParticipantSessionMetricsResponse> get copyWith => _$GetCallParticipantSessionMetricsResponseCopyWithImpl<GetCallParticipantSessionMetricsResponse>(this as GetCallParticipantSessionMetricsResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetCallParticipantSessionMetricsResponse&&(identical(other.client, client) || other.client == client)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.isPublisher, isPublisher) || other.isPublisher == isPublisher)&&(identical(other.isSubscriber, isSubscriber) || other.isSubscriber == isSubscriber)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&const DeepCollectionEquality().equals(other.publishedTracks, publishedTracks)&&(identical(other.publisherType, publisherType) || other.publisherType == publisherType)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userSessionId, userSessionId) || other.userSessionId == userSessionId));
}


@override
int get hashCode => Object.hash(runtimeType,client,duration,isPublisher,isSubscriber,joinedAt,const DeepCollectionEquality().hash(publishedTracks),publisherType,userId,userSessionId);

@override
String toString() {
  return 'GetCallParticipantSessionMetricsResponse(client: $client, duration: $duration, isPublisher: $isPublisher, isSubscriber: $isSubscriber, joinedAt: $joinedAt, publishedTracks: $publishedTracks, publisherType: $publisherType, userId: $userId, userSessionId: $userSessionId)';
}


}

/// @nodoc
abstract mixin class $GetCallParticipantSessionMetricsResponseCopyWith<$Res>  {
  factory $GetCallParticipantSessionMetricsResponseCopyWith(GetCallParticipantSessionMetricsResponse value, $Res Function(GetCallParticipantSessionMetricsResponse) _then) = _$GetCallParticipantSessionMetricsResponseCopyWithImpl;
@useResult
$Res call({
 SessionClient? client, String duration, bool? isPublisher, bool? isSubscriber, DateTime? joinedAt, List<PublishedTrackMetrics>? publishedTracks, String? publisherType, String? userId, String? userSessionId
});




}
/// @nodoc
class _$GetCallParticipantSessionMetricsResponseCopyWithImpl<$Res>
    implements $GetCallParticipantSessionMetricsResponseCopyWith<$Res> {
  _$GetCallParticipantSessionMetricsResponseCopyWithImpl(this._self, this._then);

  final GetCallParticipantSessionMetricsResponse _self;
  final $Res Function(GetCallParticipantSessionMetricsResponse) _then;

/// Create a copy of GetCallParticipantSessionMetricsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? client = freezed,Object? duration = null,Object? isPublisher = freezed,Object? isSubscriber = freezed,Object? joinedAt = freezed,Object? publishedTracks = freezed,Object? publisherType = freezed,Object? userId = freezed,Object? userSessionId = freezed,}) {
  return _then(GetCallParticipantSessionMetricsResponse(
client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as SessionClient?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,isPublisher: freezed == isPublisher ? _self.isPublisher : isPublisher // ignore: cast_nullable_to_non_nullable
as bool?,isSubscriber: freezed == isSubscriber ? _self.isSubscriber : isSubscriber // ignore: cast_nullable_to_non_nullable
as bool?,joinedAt: freezed == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,publishedTracks: freezed == publishedTracks ? _self.publishedTracks : publishedTracks // ignore: cast_nullable_to_non_nullable
as List<PublishedTrackMetrics>?,publisherType: freezed == publisherType ? _self.publisherType : publisherType // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,userSessionId: freezed == userSessionId ? _self.userSessionId : userSessionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GetCallParticipantSessionMetricsResponse].
extension GetCallParticipantSessionMetricsResponsePatterns on GetCallParticipantSessionMetricsResponse {
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
