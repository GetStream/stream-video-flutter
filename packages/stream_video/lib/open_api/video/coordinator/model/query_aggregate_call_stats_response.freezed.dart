// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_aggregate_call_stats_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QueryAggregateCallStatsResponse {

 CallDurationReportResponse? get callDurationReport; CallParticipantCountReportResponse? get callParticipantCountReport; CallsPerDayReportResponse? get callsPerDayReport; String get duration; NetworkMetricsReportResponse? get networkMetricsReport; QualityScoreReportResponse? get qualityScoreReport; SDKUsageReportResponse? get sdkUsageReport; UserFeedbackReportResponse? get userFeedbackReport;
/// Create a copy of QueryAggregateCallStatsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueryAggregateCallStatsResponseCopyWith<QueryAggregateCallStatsResponse> get copyWith => _$QueryAggregateCallStatsResponseCopyWithImpl<QueryAggregateCallStatsResponse>(this as QueryAggregateCallStatsResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueryAggregateCallStatsResponse&&(identical(other.callDurationReport, callDurationReport) || other.callDurationReport == callDurationReport)&&(identical(other.callParticipantCountReport, callParticipantCountReport) || other.callParticipantCountReport == callParticipantCountReport)&&(identical(other.callsPerDayReport, callsPerDayReport) || other.callsPerDayReport == callsPerDayReport)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.networkMetricsReport, networkMetricsReport) || other.networkMetricsReport == networkMetricsReport)&&(identical(other.qualityScoreReport, qualityScoreReport) || other.qualityScoreReport == qualityScoreReport)&&(identical(other.sdkUsageReport, sdkUsageReport) || other.sdkUsageReport == sdkUsageReport)&&(identical(other.userFeedbackReport, userFeedbackReport) || other.userFeedbackReport == userFeedbackReport));
}


@override
int get hashCode => Object.hash(runtimeType,callDurationReport,callParticipantCountReport,callsPerDayReport,duration,networkMetricsReport,qualityScoreReport,sdkUsageReport,userFeedbackReport);

@override
String toString() {
  return 'QueryAggregateCallStatsResponse(callDurationReport: $callDurationReport, callParticipantCountReport: $callParticipantCountReport, callsPerDayReport: $callsPerDayReport, duration: $duration, networkMetricsReport: $networkMetricsReport, qualityScoreReport: $qualityScoreReport, sdkUsageReport: $sdkUsageReport, userFeedbackReport: $userFeedbackReport)';
}


}

/// @nodoc
abstract mixin class $QueryAggregateCallStatsResponseCopyWith<$Res>  {
  factory $QueryAggregateCallStatsResponseCopyWith(QueryAggregateCallStatsResponse value, $Res Function(QueryAggregateCallStatsResponse) _then) = _$QueryAggregateCallStatsResponseCopyWithImpl;
@useResult
$Res call({
 CallDurationReportResponse? callDurationReport, CallParticipantCountReportResponse? callParticipantCountReport, CallsPerDayReportResponse? callsPerDayReport, String duration, NetworkMetricsReportResponse? networkMetricsReport, QualityScoreReportResponse? qualityScoreReport, SDKUsageReportResponse? sdkUsageReport, UserFeedbackReportResponse? userFeedbackReport
});




}
/// @nodoc
class _$QueryAggregateCallStatsResponseCopyWithImpl<$Res>
    implements $QueryAggregateCallStatsResponseCopyWith<$Res> {
  _$QueryAggregateCallStatsResponseCopyWithImpl(this._self, this._then);

  final QueryAggregateCallStatsResponse _self;
  final $Res Function(QueryAggregateCallStatsResponse) _then;

/// Create a copy of QueryAggregateCallStatsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callDurationReport = freezed,Object? callParticipantCountReport = freezed,Object? callsPerDayReport = freezed,Object? duration = null,Object? networkMetricsReport = freezed,Object? qualityScoreReport = freezed,Object? sdkUsageReport = freezed,Object? userFeedbackReport = freezed,}) {
  return _then(QueryAggregateCallStatsResponse(
callDurationReport: freezed == callDurationReport ? _self.callDurationReport : callDurationReport // ignore: cast_nullable_to_non_nullable
as CallDurationReportResponse?,callParticipantCountReport: freezed == callParticipantCountReport ? _self.callParticipantCountReport : callParticipantCountReport // ignore: cast_nullable_to_non_nullable
as CallParticipantCountReportResponse?,callsPerDayReport: freezed == callsPerDayReport ? _self.callsPerDayReport : callsPerDayReport // ignore: cast_nullable_to_non_nullable
as CallsPerDayReportResponse?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,networkMetricsReport: freezed == networkMetricsReport ? _self.networkMetricsReport : networkMetricsReport // ignore: cast_nullable_to_non_nullable
as NetworkMetricsReportResponse?,qualityScoreReport: freezed == qualityScoreReport ? _self.qualityScoreReport : qualityScoreReport // ignore: cast_nullable_to_non_nullable
as QualityScoreReportResponse?,sdkUsageReport: freezed == sdkUsageReport ? _self.sdkUsageReport : sdkUsageReport // ignore: cast_nullable_to_non_nullable
as SDKUsageReportResponse?,userFeedbackReport: freezed == userFeedbackReport ? _self.userFeedbackReport : userFeedbackReport // ignore: cast_nullable_to_non_nullable
as UserFeedbackReportResponse?,
  ));
}

}


/// Adds pattern-matching-related methods to [QueryAggregateCallStatsResponse].
extension QueryAggregateCallStatsResponsePatterns on QueryAggregateCallStatsResponse {
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
