// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_call_report_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GetCallReportResponse {

 ChatActivityStatsResponse? get chatActivity; String get duration; ReportResponse get report; CallSessionResponse? get session; String get sessionId; List<VideoReactionsResponse>? get videoReactions;
/// Create a copy of GetCallReportResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetCallReportResponseCopyWith<GetCallReportResponse> get copyWith => _$GetCallReportResponseCopyWithImpl<GetCallReportResponse>(this as GetCallReportResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetCallReportResponse&&(identical(other.chatActivity, chatActivity) || other.chatActivity == chatActivity)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.report, report) || other.report == report)&&(identical(other.session, session) || other.session == session)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&const DeepCollectionEquality().equals(other.videoReactions, videoReactions));
}


@override
int get hashCode => Object.hash(runtimeType,chatActivity,duration,report,session,sessionId,const DeepCollectionEquality().hash(videoReactions));

@override
String toString() {
  return 'GetCallReportResponse(chatActivity: $chatActivity, duration: $duration, report: $report, session: $session, sessionId: $sessionId, videoReactions: $videoReactions)';
}


}

/// @nodoc
abstract mixin class $GetCallReportResponseCopyWith<$Res>  {
  factory $GetCallReportResponseCopyWith(GetCallReportResponse value, $Res Function(GetCallReportResponse) _then) = _$GetCallReportResponseCopyWithImpl;
@useResult
$Res call({
 ChatActivityStatsResponse? chatActivity, String duration, ReportResponse report, CallSessionResponse? session, String sessionId, List<VideoReactionsResponse>? videoReactions
});




}
/// @nodoc
class _$GetCallReportResponseCopyWithImpl<$Res>
    implements $GetCallReportResponseCopyWith<$Res> {
  _$GetCallReportResponseCopyWithImpl(this._self, this._then);

  final GetCallReportResponse _self;
  final $Res Function(GetCallReportResponse) _then;

/// Create a copy of GetCallReportResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chatActivity = freezed,Object? duration = null,Object? report = null,Object? session = freezed,Object? sessionId = null,Object? videoReactions = freezed,}) {
  return _then(GetCallReportResponse(
chatActivity: freezed == chatActivity ? _self.chatActivity : chatActivity // ignore: cast_nullable_to_non_nullable
as ChatActivityStatsResponse?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,report: null == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as ReportResponse,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as CallSessionResponse?,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,videoReactions: freezed == videoReactions ? _self.videoReactions : videoReactions // ignore: cast_nullable_to_non_nullable
as List<VideoReactionsResponse>?,
  ));
}

}


/// Adds pattern-matching-related methods to [GetCallReportResponse].
extension GetCallReportResponsePatterns on GetCallReportResponse {
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
