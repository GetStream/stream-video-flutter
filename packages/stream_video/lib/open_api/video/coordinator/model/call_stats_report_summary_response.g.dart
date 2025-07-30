// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_stats_report_summary_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallStatsReportSummaryResponse extends CallStatsReportSummaryResponse {
  @override
  final String callCid;
  @override
  final int callDurationSeconds;
  @override
  final String callSessionId;
  @override
  final String callStatus;
  @override
  final DateTime? createdAt;
  @override
  final DateTime firstStatsTime;
  @override
  final int? minUserRating;
  @override
  final int? qualityScore;

  factory _$CallStatsReportSummaryResponse(
          [void Function(CallStatsReportSummaryResponseBuilder)? updates]) =>
      (CallStatsReportSummaryResponseBuilder()..update(updates))._build();

  _$CallStatsReportSummaryResponse._(
      {required this.callCid,
      required this.callDurationSeconds,
      required this.callSessionId,
      required this.callStatus,
      this.createdAt,
      required this.firstStatsTime,
      this.minUserRating,
      this.qualityScore})
      : super._();
  @override
  CallStatsReportSummaryResponse rebuild(
          void Function(CallStatsReportSummaryResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallStatsReportSummaryResponseBuilder toBuilder() =>
      CallStatsReportSummaryResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallStatsReportSummaryResponse &&
        callCid == other.callCid &&
        callDurationSeconds == other.callDurationSeconds &&
        callSessionId == other.callSessionId &&
        callStatus == other.callStatus &&
        createdAt == other.createdAt &&
        firstStatsTime == other.firstStatsTime &&
        minUserRating == other.minUserRating &&
        qualityScore == other.qualityScore;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, callDurationSeconds.hashCode);
    _$hash = $jc(_$hash, callSessionId.hashCode);
    _$hash = $jc(_$hash, callStatus.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, firstStatsTime.hashCode);
    _$hash = $jc(_$hash, minUserRating.hashCode);
    _$hash = $jc(_$hash, qualityScore.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallStatsReportSummaryResponse')
          ..add('callCid', callCid)
          ..add('callDurationSeconds', callDurationSeconds)
          ..add('callSessionId', callSessionId)
          ..add('callStatus', callStatus)
          ..add('createdAt', createdAt)
          ..add('firstStatsTime', firstStatsTime)
          ..add('minUserRating', minUserRating)
          ..add('qualityScore', qualityScore))
        .toString();
  }
}

class CallStatsReportSummaryResponseBuilder
    implements
        Builder<CallStatsReportSummaryResponse,
            CallStatsReportSummaryResponseBuilder> {
  _$CallStatsReportSummaryResponse? _$v;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  int? _callDurationSeconds;
  int? get callDurationSeconds => _$this._callDurationSeconds;
  set callDurationSeconds(int? callDurationSeconds) =>
      _$this._callDurationSeconds = callDurationSeconds;

  String? _callSessionId;
  String? get callSessionId => _$this._callSessionId;
  set callSessionId(String? callSessionId) =>
      _$this._callSessionId = callSessionId;

  String? _callStatus;
  String? get callStatus => _$this._callStatus;
  set callStatus(String? callStatus) => _$this._callStatus = callStatus;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _firstStatsTime;
  DateTime? get firstStatsTime => _$this._firstStatsTime;
  set firstStatsTime(DateTime? firstStatsTime) =>
      _$this._firstStatsTime = firstStatsTime;

  int? _minUserRating;
  int? get minUserRating => _$this._minUserRating;
  set minUserRating(int? minUserRating) =>
      _$this._minUserRating = minUserRating;

  int? _qualityScore;
  int? get qualityScore => _$this._qualityScore;
  set qualityScore(int? qualityScore) => _$this._qualityScore = qualityScore;

  CallStatsReportSummaryResponseBuilder() {
    CallStatsReportSummaryResponse._defaults(this);
  }

  CallStatsReportSummaryResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _callCid = $v.callCid;
      _callDurationSeconds = $v.callDurationSeconds;
      _callSessionId = $v.callSessionId;
      _callStatus = $v.callStatus;
      _createdAt = $v.createdAt;
      _firstStatsTime = $v.firstStatsTime;
      _minUserRating = $v.minUserRating;
      _qualityScore = $v.qualityScore;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallStatsReportSummaryResponse other) {
    _$v = other as _$CallStatsReportSummaryResponse;
  }

  @override
  void update(void Function(CallStatsReportSummaryResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallStatsReportSummaryResponse build() => _build();

  _$CallStatsReportSummaryResponse _build() {
    final _$result = _$v ??
        _$CallStatsReportSummaryResponse._(
          callCid: BuiltValueNullFieldError.checkNotNull(
              callCid, r'CallStatsReportSummaryResponse', 'callCid'),
          callDurationSeconds: BuiltValueNullFieldError.checkNotNull(
              callDurationSeconds,
              r'CallStatsReportSummaryResponse',
              'callDurationSeconds'),
          callSessionId: BuiltValueNullFieldError.checkNotNull(callSessionId,
              r'CallStatsReportSummaryResponse', 'callSessionId'),
          callStatus: BuiltValueNullFieldError.checkNotNull(
              callStatus, r'CallStatsReportSummaryResponse', 'callStatus'),
          createdAt: createdAt,
          firstStatsTime: BuiltValueNullFieldError.checkNotNull(firstStatsTime,
              r'CallStatsReportSummaryResponse', 'firstStatsTime'),
          minUserRating: minUserRating,
          qualityScore: qualityScore,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
