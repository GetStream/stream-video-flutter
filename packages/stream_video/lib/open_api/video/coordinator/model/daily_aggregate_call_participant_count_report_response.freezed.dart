// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_aggregate_call_participant_count_report_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DailyAggregateCallParticipantCountReportResponse {

 String get date; CallParticipantCountReport get report;
/// Create a copy of DailyAggregateCallParticipantCountReportResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyAggregateCallParticipantCountReportResponseCopyWith<DailyAggregateCallParticipantCountReportResponse> get copyWith => _$DailyAggregateCallParticipantCountReportResponseCopyWithImpl<DailyAggregateCallParticipantCountReportResponse>(this as DailyAggregateCallParticipantCountReportResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyAggregateCallParticipantCountReportResponse&&(identical(other.date, date) || other.date == date)&&(identical(other.report, report) || other.report == report));
}


@override
int get hashCode => Object.hash(runtimeType,date,report);

@override
String toString() {
  return 'DailyAggregateCallParticipantCountReportResponse(date: $date, report: $report)';
}


}

/// @nodoc
abstract mixin class $DailyAggregateCallParticipantCountReportResponseCopyWith<$Res>  {
  factory $DailyAggregateCallParticipantCountReportResponseCopyWith(DailyAggregateCallParticipantCountReportResponse value, $Res Function(DailyAggregateCallParticipantCountReportResponse) _then) = _$DailyAggregateCallParticipantCountReportResponseCopyWithImpl;
@useResult
$Res call({
 String date, CallParticipantCountReport report
});




}
/// @nodoc
class _$DailyAggregateCallParticipantCountReportResponseCopyWithImpl<$Res>
    implements $DailyAggregateCallParticipantCountReportResponseCopyWith<$Res> {
  _$DailyAggregateCallParticipantCountReportResponseCopyWithImpl(this._self, this._then);

  final DailyAggregateCallParticipantCountReportResponse _self;
  final $Res Function(DailyAggregateCallParticipantCountReportResponse) _then;

/// Create a copy of DailyAggregateCallParticipantCountReportResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? report = null,}) {
  return _then(DailyAggregateCallParticipantCountReportResponse(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,report: null == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as CallParticipantCountReport,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyAggregateCallParticipantCountReportResponse].
extension DailyAggregateCallParticipantCountReportResponsePatterns on DailyAggregateCallParticipantCountReportResponse {
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
