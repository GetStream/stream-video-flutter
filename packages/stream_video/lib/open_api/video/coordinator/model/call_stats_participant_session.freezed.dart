// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_stats_participant_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallStatsParticipantSession {

 String? get browser; String? get browserVersion; int? get cqScore; String? get currentIp; String? get currentSfu; double? get distanceToSfuKilometers; DateTime? get endedAt; int? get freezesDurationMs; String? get ingress; bool get isLive; int? get jitterMs; int? get latencyMs; CallStatsLocation? get location; String? get os; PublishedTrackFlags get publishedTracks; String? get publisherType; String? get sdk; String? get sdkVersion; DateTime? get startedAt; String? get unifiedSessionId; String get userSessionId; String? get webrtcVersion;
/// Create a copy of CallStatsParticipantSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallStatsParticipantSessionCopyWith<CallStatsParticipantSession> get copyWith => _$CallStatsParticipantSessionCopyWithImpl<CallStatsParticipantSession>(this as CallStatsParticipantSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallStatsParticipantSession&&(identical(other.browser, browser) || other.browser == browser)&&(identical(other.browserVersion, browserVersion) || other.browserVersion == browserVersion)&&(identical(other.cqScore, cqScore) || other.cqScore == cqScore)&&(identical(other.currentIp, currentIp) || other.currentIp == currentIp)&&(identical(other.currentSfu, currentSfu) || other.currentSfu == currentSfu)&&(identical(other.distanceToSfuKilometers, distanceToSfuKilometers) || other.distanceToSfuKilometers == distanceToSfuKilometers)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.freezesDurationMs, freezesDurationMs) || other.freezesDurationMs == freezesDurationMs)&&(identical(other.ingress, ingress) || other.ingress == ingress)&&(identical(other.isLive, isLive) || other.isLive == isLive)&&(identical(other.jitterMs, jitterMs) || other.jitterMs == jitterMs)&&(identical(other.latencyMs, latencyMs) || other.latencyMs == latencyMs)&&(identical(other.location, location) || other.location == location)&&(identical(other.os, os) || other.os == os)&&(identical(other.publishedTracks, publishedTracks) || other.publishedTracks == publishedTracks)&&(identical(other.publisherType, publisherType) || other.publisherType == publisherType)&&(identical(other.sdk, sdk) || other.sdk == sdk)&&(identical(other.sdkVersion, sdkVersion) || other.sdkVersion == sdkVersion)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.unifiedSessionId, unifiedSessionId) || other.unifiedSessionId == unifiedSessionId)&&(identical(other.userSessionId, userSessionId) || other.userSessionId == userSessionId)&&(identical(other.webrtcVersion, webrtcVersion) || other.webrtcVersion == webrtcVersion));
}


@override
int get hashCode => Object.hashAll([runtimeType,browser,browserVersion,cqScore,currentIp,currentSfu,distanceToSfuKilometers,endedAt,freezesDurationMs,ingress,isLive,jitterMs,latencyMs,location,os,publishedTracks,publisherType,sdk,sdkVersion,startedAt,unifiedSessionId,userSessionId,webrtcVersion]);

@override
String toString() {
  return 'CallStatsParticipantSession(browser: $browser, browserVersion: $browserVersion, cqScore: $cqScore, currentIp: $currentIp, currentSfu: $currentSfu, distanceToSfuKilometers: $distanceToSfuKilometers, endedAt: $endedAt, freezesDurationMs: $freezesDurationMs, ingress: $ingress, isLive: $isLive, jitterMs: $jitterMs, latencyMs: $latencyMs, location: $location, os: $os, publishedTracks: $publishedTracks, publisherType: $publisherType, sdk: $sdk, sdkVersion: $sdkVersion, startedAt: $startedAt, unifiedSessionId: $unifiedSessionId, userSessionId: $userSessionId, webrtcVersion: $webrtcVersion)';
}


}

/// @nodoc
abstract mixin class $CallStatsParticipantSessionCopyWith<$Res>  {
  factory $CallStatsParticipantSessionCopyWith(CallStatsParticipantSession value, $Res Function(CallStatsParticipantSession) _then) = _$CallStatsParticipantSessionCopyWithImpl;
@useResult
$Res call({
 String? browser, String? browserVersion, int? cqScore, String? currentIp, String? currentSfu, double? distanceToSfuKilometers, DateTime? endedAt, int? freezesDurationMs, String? ingress, bool isLive, int? jitterMs, int? latencyMs, CallStatsLocation? location, String? os, PublishedTrackFlags publishedTracks, String? publisherType, String? sdk, String? sdkVersion, DateTime? startedAt, String? unifiedSessionId, String userSessionId, String? webrtcVersion
});




}
/// @nodoc
class _$CallStatsParticipantSessionCopyWithImpl<$Res>
    implements $CallStatsParticipantSessionCopyWith<$Res> {
  _$CallStatsParticipantSessionCopyWithImpl(this._self, this._then);

  final CallStatsParticipantSession _self;
  final $Res Function(CallStatsParticipantSession) _then;

/// Create a copy of CallStatsParticipantSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? browser = freezed,Object? browserVersion = freezed,Object? cqScore = freezed,Object? currentIp = freezed,Object? currentSfu = freezed,Object? distanceToSfuKilometers = freezed,Object? endedAt = freezed,Object? freezesDurationMs = freezed,Object? ingress = freezed,Object? isLive = null,Object? jitterMs = freezed,Object? latencyMs = freezed,Object? location = freezed,Object? os = freezed,Object? publishedTracks = null,Object? publisherType = freezed,Object? sdk = freezed,Object? sdkVersion = freezed,Object? startedAt = freezed,Object? unifiedSessionId = freezed,Object? userSessionId = null,Object? webrtcVersion = freezed,}) {
  return _then(CallStatsParticipantSession(
browser: freezed == browser ? _self.browser : browser // ignore: cast_nullable_to_non_nullable
as String?,browserVersion: freezed == browserVersion ? _self.browserVersion : browserVersion // ignore: cast_nullable_to_non_nullable
as String?,cqScore: freezed == cqScore ? _self.cqScore : cqScore // ignore: cast_nullable_to_non_nullable
as int?,currentIp: freezed == currentIp ? _self.currentIp : currentIp // ignore: cast_nullable_to_non_nullable
as String?,currentSfu: freezed == currentSfu ? _self.currentSfu : currentSfu // ignore: cast_nullable_to_non_nullable
as String?,distanceToSfuKilometers: freezed == distanceToSfuKilometers ? _self.distanceToSfuKilometers : distanceToSfuKilometers // ignore: cast_nullable_to_non_nullable
as double?,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,freezesDurationMs: freezed == freezesDurationMs ? _self.freezesDurationMs : freezesDurationMs // ignore: cast_nullable_to_non_nullable
as int?,ingress: freezed == ingress ? _self.ingress : ingress // ignore: cast_nullable_to_non_nullable
as String?,isLive: null == isLive ? _self.isLive : isLive // ignore: cast_nullable_to_non_nullable
as bool,jitterMs: freezed == jitterMs ? _self.jitterMs : jitterMs // ignore: cast_nullable_to_non_nullable
as int?,latencyMs: freezed == latencyMs ? _self.latencyMs : latencyMs // ignore: cast_nullable_to_non_nullable
as int?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as CallStatsLocation?,os: freezed == os ? _self.os : os // ignore: cast_nullable_to_non_nullable
as String?,publishedTracks: null == publishedTracks ? _self.publishedTracks : publishedTracks // ignore: cast_nullable_to_non_nullable
as PublishedTrackFlags,publisherType: freezed == publisherType ? _self.publisherType : publisherType // ignore: cast_nullable_to_non_nullable
as String?,sdk: freezed == sdk ? _self.sdk : sdk // ignore: cast_nullable_to_non_nullable
as String?,sdkVersion: freezed == sdkVersion ? _self.sdkVersion : sdkVersion // ignore: cast_nullable_to_non_nullable
as String?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,unifiedSessionId: freezed == unifiedSessionId ? _self.unifiedSessionId : unifiedSessionId // ignore: cast_nullable_to_non_nullable
as String?,userSessionId: null == userSessionId ? _self.userSessionId : userSessionId // ignore: cast_nullable_to_non_nullable
as String,webrtcVersion: freezed == webrtcVersion ? _self.webrtcVersion : webrtcVersion // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CallStatsParticipantSession].
extension CallStatsParticipantSessionPatterns on CallStatsParticipantSession {
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
