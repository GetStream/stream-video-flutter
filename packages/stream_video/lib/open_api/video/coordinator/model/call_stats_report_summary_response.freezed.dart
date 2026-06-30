// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_stats_report_summary_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallStatsReportSummaryResponse {
  String get callCid;
  int get callDurationSeconds;
  String get callSessionId;
  String get callStatus;
  DateTime? get createdAt;
  DateTime get firstStatsTime;
  int? get minUserRating;
  int? get qualityScore;

  /// Create a copy of CallStatsReportSummaryResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CallStatsReportSummaryResponseCopyWith<CallStatsReportSummaryResponse>
  get copyWith =>
      _$CallStatsReportSummaryResponseCopyWithImpl<
        CallStatsReportSummaryResponse
      >(this as CallStatsReportSummaryResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CallStatsReportSummaryResponse &&
            (identical(other.callCid, callCid) || other.callCid == callCid) &&
            (identical(other.callDurationSeconds, callDurationSeconds) ||
                other.callDurationSeconds == callDurationSeconds) &&
            (identical(other.callSessionId, callSessionId) ||
                other.callSessionId == callSessionId) &&
            (identical(other.callStatus, callStatus) ||
                other.callStatus == callStatus) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.firstStatsTime, firstStatsTime) ||
                other.firstStatsTime == firstStatsTime) &&
            (identical(other.minUserRating, minUserRating) ||
                other.minUserRating == minUserRating) &&
            (identical(other.qualityScore, qualityScore) ||
                other.qualityScore == qualityScore));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    callCid,
    callDurationSeconds,
    callSessionId,
    callStatus,
    createdAt,
    firstStatsTime,
    minUserRating,
    qualityScore,
  );

  @override
  String toString() {
    return 'CallStatsReportSummaryResponse(callCid: $callCid, callDurationSeconds: $callDurationSeconds, callSessionId: $callSessionId, callStatus: $callStatus, createdAt: $createdAt, firstStatsTime: $firstStatsTime, minUserRating: $minUserRating, qualityScore: $qualityScore)';
  }
}

/// @nodoc
abstract mixin class $CallStatsReportSummaryResponseCopyWith<$Res> {
  factory $CallStatsReportSummaryResponseCopyWith(
    CallStatsReportSummaryResponse value,
    $Res Function(CallStatsReportSummaryResponse) _then,
  ) = _$CallStatsReportSummaryResponseCopyWithImpl;
  @useResult
  $Res call({
    String callCid,
    int callDurationSeconds,
    String callSessionId,
    String callStatus,
    DateTime? createdAt,
    DateTime firstStatsTime,
    int? minUserRating,
    int? qualityScore,
  });
}

/// @nodoc
class _$CallStatsReportSummaryResponseCopyWithImpl<$Res>
    implements $CallStatsReportSummaryResponseCopyWith<$Res> {
  _$CallStatsReportSummaryResponseCopyWithImpl(this._self, this._then);

  final CallStatsReportSummaryResponse _self;
  final $Res Function(CallStatsReportSummaryResponse) _then;

  /// Create a copy of CallStatsReportSummaryResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? callCid = null,
    Object? callDurationSeconds = null,
    Object? callSessionId = null,
    Object? callStatus = null,
    Object? createdAt = freezed,
    Object? firstStatsTime = null,
    Object? minUserRating = freezed,
    Object? qualityScore = freezed,
  }) {
    return _then(
      CallStatsReportSummaryResponse(
        callCid: null == callCid
            ? _self.callCid
            : callCid // ignore: cast_nullable_to_non_nullable
                  as String,
        callDurationSeconds: null == callDurationSeconds
            ? _self.callDurationSeconds
            : callDurationSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        callSessionId: null == callSessionId
            ? _self.callSessionId
            : callSessionId // ignore: cast_nullable_to_non_nullable
                  as String,
        callStatus: null == callStatus
            ? _self.callStatus
            : callStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        firstStatsTime: null == firstStatsTime
            ? _self.firstStatsTime
            : firstStatsTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        minUserRating: freezed == minUserRating
            ? _self.minUserRating
            : minUserRating // ignore: cast_nullable_to_non_nullable
                  as int?,
        qualityScore: freezed == qualityScore
            ? _self.qualityScore
            : qualityScore // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}
