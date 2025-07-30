// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_aggregate_call_stats_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$QueryAggregateCallStatsResponse
    extends QueryAggregateCallStatsResponse {
  @override
  final CallDurationReportResponse? callDurationReport;
  @override
  final CallParticipantCountReportResponse? callParticipantCountReport;
  @override
  final CallsPerDayReportResponse? callsPerDayReport;
  @override
  final String duration;
  @override
  final NetworkMetricsReportResponse? networkMetricsReport;
  @override
  final QualityScoreReportResponse? qualityScoreReport;
  @override
  final SDKUsageReportResponse? sdkUsageReport;
  @override
  final UserFeedbackReportResponse? userFeedbackReport;

  factory _$QueryAggregateCallStatsResponse(
          [void Function(QueryAggregateCallStatsResponseBuilder)? updates]) =>
      (QueryAggregateCallStatsResponseBuilder()..update(updates))._build();

  _$QueryAggregateCallStatsResponse._(
      {this.callDurationReport,
      this.callParticipantCountReport,
      this.callsPerDayReport,
      required this.duration,
      this.networkMetricsReport,
      this.qualityScoreReport,
      this.sdkUsageReport,
      this.userFeedbackReport})
      : super._();
  @override
  QueryAggregateCallStatsResponse rebuild(
          void Function(QueryAggregateCallStatsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QueryAggregateCallStatsResponseBuilder toBuilder() =>
      QueryAggregateCallStatsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is QueryAggregateCallStatsResponse &&
        callDurationReport == other.callDurationReport &&
        callParticipantCountReport == other.callParticipantCountReport &&
        callsPerDayReport == other.callsPerDayReport &&
        duration == other.duration &&
        networkMetricsReport == other.networkMetricsReport &&
        qualityScoreReport == other.qualityScoreReport &&
        sdkUsageReport == other.sdkUsageReport &&
        userFeedbackReport == other.userFeedbackReport;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, callDurationReport.hashCode);
    _$hash = $jc(_$hash, callParticipantCountReport.hashCode);
    _$hash = $jc(_$hash, callsPerDayReport.hashCode);
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jc(_$hash, networkMetricsReport.hashCode);
    _$hash = $jc(_$hash, qualityScoreReport.hashCode);
    _$hash = $jc(_$hash, sdkUsageReport.hashCode);
    _$hash = $jc(_$hash, userFeedbackReport.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'QueryAggregateCallStatsResponse')
          ..add('callDurationReport', callDurationReport)
          ..add('callParticipantCountReport', callParticipantCountReport)
          ..add('callsPerDayReport', callsPerDayReport)
          ..add('duration', duration)
          ..add('networkMetricsReport', networkMetricsReport)
          ..add('qualityScoreReport', qualityScoreReport)
          ..add('sdkUsageReport', sdkUsageReport)
          ..add('userFeedbackReport', userFeedbackReport))
        .toString();
  }
}

class QueryAggregateCallStatsResponseBuilder
    implements
        Builder<QueryAggregateCallStatsResponse,
            QueryAggregateCallStatsResponseBuilder> {
  _$QueryAggregateCallStatsResponse? _$v;

  CallDurationReportResponseBuilder? _callDurationReport;
  CallDurationReportResponseBuilder get callDurationReport =>
      _$this._callDurationReport ??= CallDurationReportResponseBuilder();
  set callDurationReport(
          CallDurationReportResponseBuilder? callDurationReport) =>
      _$this._callDurationReport = callDurationReport;

  CallParticipantCountReportResponseBuilder? _callParticipantCountReport;
  CallParticipantCountReportResponseBuilder get callParticipantCountReport =>
      _$this._callParticipantCountReport ??=
          CallParticipantCountReportResponseBuilder();
  set callParticipantCountReport(
          CallParticipantCountReportResponseBuilder?
              callParticipantCountReport) =>
      _$this._callParticipantCountReport = callParticipantCountReport;

  CallsPerDayReportResponseBuilder? _callsPerDayReport;
  CallsPerDayReportResponseBuilder get callsPerDayReport =>
      _$this._callsPerDayReport ??= CallsPerDayReportResponseBuilder();
  set callsPerDayReport(CallsPerDayReportResponseBuilder? callsPerDayReport) =>
      _$this._callsPerDayReport = callsPerDayReport;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  NetworkMetricsReportResponseBuilder? _networkMetricsReport;
  NetworkMetricsReportResponseBuilder get networkMetricsReport =>
      _$this._networkMetricsReport ??= NetworkMetricsReportResponseBuilder();
  set networkMetricsReport(
          NetworkMetricsReportResponseBuilder? networkMetricsReport) =>
      _$this._networkMetricsReport = networkMetricsReport;

  QualityScoreReportResponseBuilder? _qualityScoreReport;
  QualityScoreReportResponseBuilder get qualityScoreReport =>
      _$this._qualityScoreReport ??= QualityScoreReportResponseBuilder();
  set qualityScoreReport(
          QualityScoreReportResponseBuilder? qualityScoreReport) =>
      _$this._qualityScoreReport = qualityScoreReport;

  SDKUsageReportResponseBuilder? _sdkUsageReport;
  SDKUsageReportResponseBuilder get sdkUsageReport =>
      _$this._sdkUsageReport ??= SDKUsageReportResponseBuilder();
  set sdkUsageReport(SDKUsageReportResponseBuilder? sdkUsageReport) =>
      _$this._sdkUsageReport = sdkUsageReport;

  UserFeedbackReportResponseBuilder? _userFeedbackReport;
  UserFeedbackReportResponseBuilder get userFeedbackReport =>
      _$this._userFeedbackReport ??= UserFeedbackReportResponseBuilder();
  set userFeedbackReport(
          UserFeedbackReportResponseBuilder? userFeedbackReport) =>
      _$this._userFeedbackReport = userFeedbackReport;

  QueryAggregateCallStatsResponseBuilder() {
    QueryAggregateCallStatsResponse._defaults(this);
  }

  QueryAggregateCallStatsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _callDurationReport = $v.callDurationReport?.toBuilder();
      _callParticipantCountReport = $v.callParticipantCountReport?.toBuilder();
      _callsPerDayReport = $v.callsPerDayReport?.toBuilder();
      _duration = $v.duration;
      _networkMetricsReport = $v.networkMetricsReport?.toBuilder();
      _qualityScoreReport = $v.qualityScoreReport?.toBuilder();
      _sdkUsageReport = $v.sdkUsageReport?.toBuilder();
      _userFeedbackReport = $v.userFeedbackReport?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(QueryAggregateCallStatsResponse other) {
    _$v = other as _$QueryAggregateCallStatsResponse;
  }

  @override
  void update(void Function(QueryAggregateCallStatsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  QueryAggregateCallStatsResponse build() => _build();

  _$QueryAggregateCallStatsResponse _build() {
    _$QueryAggregateCallStatsResponse _$result;
    try {
      _$result = _$v ??
          _$QueryAggregateCallStatsResponse._(
            callDurationReport: _callDurationReport?.build(),
            callParticipantCountReport: _callParticipantCountReport?.build(),
            callsPerDayReport: _callsPerDayReport?.build(),
            duration: BuiltValueNullFieldError.checkNotNull(
                duration, r'QueryAggregateCallStatsResponse', 'duration'),
            networkMetricsReport: _networkMetricsReport?.build(),
            qualityScoreReport: _qualityScoreReport?.build(),
            sdkUsageReport: _sdkUsageReport?.build(),
            userFeedbackReport: _userFeedbackReport?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'callDurationReport';
        _callDurationReport?.build();
        _$failedField = 'callParticipantCountReport';
        _callParticipantCountReport?.build();
        _$failedField = 'callsPerDayReport';
        _callsPerDayReport?.build();

        _$failedField = 'networkMetricsReport';
        _networkMetricsReport?.build();
        _$failedField = 'qualityScoreReport';
        _qualityScoreReport?.build();
        _$failedField = 'sdkUsageReport';
        _sdkUsageReport?.build();
        _$failedField = 'userFeedbackReport';
        _userFeedbackReport?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'QueryAggregateCallStatsResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
