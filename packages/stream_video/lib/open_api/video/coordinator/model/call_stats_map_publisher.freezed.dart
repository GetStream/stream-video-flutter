// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_stats_map_publisher.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallStatsMapPublisher {

 bool get isLive; CallStatsLocation? get location; String? get name; PublishedTrackFlags get publishedTracks; String? get publisherType; String get userId; String get userSessionId;
/// Create a copy of CallStatsMapPublisher
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallStatsMapPublisherCopyWith<CallStatsMapPublisher> get copyWith => _$CallStatsMapPublisherCopyWithImpl<CallStatsMapPublisher>(this as CallStatsMapPublisher, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallStatsMapPublisher&&(identical(other.isLive, isLive) || other.isLive == isLive)&&(identical(other.location, location) || other.location == location)&&(identical(other.name, name) || other.name == name)&&(identical(other.publishedTracks, publishedTracks) || other.publishedTracks == publishedTracks)&&(identical(other.publisherType, publisherType) || other.publisherType == publisherType)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userSessionId, userSessionId) || other.userSessionId == userSessionId));
}


@override
int get hashCode => Object.hash(runtimeType,isLive,location,name,publishedTracks,publisherType,userId,userSessionId);

@override
String toString() {
  return 'CallStatsMapPublisher(isLive: $isLive, location: $location, name: $name, publishedTracks: $publishedTracks, publisherType: $publisherType, userId: $userId, userSessionId: $userSessionId)';
}


}

/// @nodoc
abstract mixin class $CallStatsMapPublisherCopyWith<$Res>  {
  factory $CallStatsMapPublisherCopyWith(CallStatsMapPublisher value, $Res Function(CallStatsMapPublisher) _then) = _$CallStatsMapPublisherCopyWithImpl;
@useResult
$Res call({
 bool isLive, CallStatsLocation? location, String? name, PublishedTrackFlags publishedTracks, String? publisherType, String userId, String userSessionId
});




}
/// @nodoc
class _$CallStatsMapPublisherCopyWithImpl<$Res>
    implements $CallStatsMapPublisherCopyWith<$Res> {
  _$CallStatsMapPublisherCopyWithImpl(this._self, this._then);

  final CallStatsMapPublisher _self;
  final $Res Function(CallStatsMapPublisher) _then;

/// Create a copy of CallStatsMapPublisher
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLive = null,Object? location = freezed,Object? name = freezed,Object? publishedTracks = null,Object? publisherType = freezed,Object? userId = null,Object? userSessionId = null,}) {
  return _then(CallStatsMapPublisher(
isLive: null == isLive ? _self.isLive : isLive // ignore: cast_nullable_to_non_nullable
as bool,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as CallStatsLocation?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,publishedTracks: null == publishedTracks ? _self.publishedTracks : publishedTracks // ignore: cast_nullable_to_non_nullable
as PublishedTrackFlags,publisherType: freezed == publisherType ? _self.publisherType : publisherType // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userSessionId: null == userSessionId ? _self.userSessionId : userSessionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CallStatsMapPublisher].
extension CallStatsMapPublisherPatterns on CallStatsMapPublisher {
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
