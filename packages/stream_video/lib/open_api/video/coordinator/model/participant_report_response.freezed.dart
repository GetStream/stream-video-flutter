// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_report_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ParticipantReportResponse {

 List<GroupedStatsResponse>? get byBrowser; List<GroupedStatsResponse>? get byCountry; List<GroupedStatsResponse>? get byDevice; List<GroupedStatsResponse>? get byOperatingSystem; ParticipantCountOverTimeResponse? get countOverTime; int? get maxConcurrent; PublisherStatsResponse? get publishers; SubscriberStatsResponse? get subscribers; int get sum; int get unique;
/// Create a copy of ParticipantReportResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipantReportResponseCopyWith<ParticipantReportResponse> get copyWith => _$ParticipantReportResponseCopyWithImpl<ParticipantReportResponse>(this as ParticipantReportResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipantReportResponse&&const DeepCollectionEquality().equals(other.byBrowser, byBrowser)&&const DeepCollectionEquality().equals(other.byCountry, byCountry)&&const DeepCollectionEquality().equals(other.byDevice, byDevice)&&const DeepCollectionEquality().equals(other.byOperatingSystem, byOperatingSystem)&&(identical(other.countOverTime, countOverTime) || other.countOverTime == countOverTime)&&(identical(other.maxConcurrent, maxConcurrent) || other.maxConcurrent == maxConcurrent)&&(identical(other.publishers, publishers) || other.publishers == publishers)&&(identical(other.subscribers, subscribers) || other.subscribers == subscribers)&&(identical(other.sum, sum) || other.sum == sum)&&(identical(other.unique, unique) || other.unique == unique));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(byBrowser),const DeepCollectionEquality().hash(byCountry),const DeepCollectionEquality().hash(byDevice),const DeepCollectionEquality().hash(byOperatingSystem),countOverTime,maxConcurrent,publishers,subscribers,sum,unique);

@override
String toString() {
  return 'ParticipantReportResponse(byBrowser: $byBrowser, byCountry: $byCountry, byDevice: $byDevice, byOperatingSystem: $byOperatingSystem, countOverTime: $countOverTime, maxConcurrent: $maxConcurrent, publishers: $publishers, subscribers: $subscribers, sum: $sum, unique: $unique)';
}


}

/// @nodoc
abstract mixin class $ParticipantReportResponseCopyWith<$Res>  {
  factory $ParticipantReportResponseCopyWith(ParticipantReportResponse value, $Res Function(ParticipantReportResponse) _then) = _$ParticipantReportResponseCopyWithImpl;
@useResult
$Res call({
 List<GroupedStatsResponse>? byBrowser, List<GroupedStatsResponse>? byCountry, List<GroupedStatsResponse>? byDevice, List<GroupedStatsResponse>? byOperatingSystem, ParticipantCountOverTimeResponse? countOverTime, int? maxConcurrent, PublisherStatsResponse? publishers, SubscriberStatsResponse? subscribers, int sum, int unique
});




}
/// @nodoc
class _$ParticipantReportResponseCopyWithImpl<$Res>
    implements $ParticipantReportResponseCopyWith<$Res> {
  _$ParticipantReportResponseCopyWithImpl(this._self, this._then);

  final ParticipantReportResponse _self;
  final $Res Function(ParticipantReportResponse) _then;

/// Create a copy of ParticipantReportResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? byBrowser = freezed,Object? byCountry = freezed,Object? byDevice = freezed,Object? byOperatingSystem = freezed,Object? countOverTime = freezed,Object? maxConcurrent = freezed,Object? publishers = freezed,Object? subscribers = freezed,Object? sum = null,Object? unique = null,}) {
  return _then(ParticipantReportResponse(
byBrowser: freezed == byBrowser ? _self.byBrowser : byBrowser // ignore: cast_nullable_to_non_nullable
as List<GroupedStatsResponse>?,byCountry: freezed == byCountry ? _self.byCountry : byCountry // ignore: cast_nullable_to_non_nullable
as List<GroupedStatsResponse>?,byDevice: freezed == byDevice ? _self.byDevice : byDevice // ignore: cast_nullable_to_non_nullable
as List<GroupedStatsResponse>?,byOperatingSystem: freezed == byOperatingSystem ? _self.byOperatingSystem : byOperatingSystem // ignore: cast_nullable_to_non_nullable
as List<GroupedStatsResponse>?,countOverTime: freezed == countOverTime ? _self.countOverTime : countOverTime // ignore: cast_nullable_to_non_nullable
as ParticipantCountOverTimeResponse?,maxConcurrent: freezed == maxConcurrent ? _self.maxConcurrent : maxConcurrent // ignore: cast_nullable_to_non_nullable
as int?,publishers: freezed == publishers ? _self.publishers : publishers // ignore: cast_nullable_to_non_nullable
as PublisherStatsResponse?,subscribers: freezed == subscribers ? _self.subscribers : subscribers // ignore: cast_nullable_to_non_nullable
as SubscriberStatsResponse?,sum: null == sum ? _self.sum : sum // ignore: cast_nullable_to_non_nullable
as int,unique: null == unique ? _self.unique : unique // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ParticipantReportResponse].
extension ParticipantReportResponsePatterns on ParticipantReportResponse {
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
