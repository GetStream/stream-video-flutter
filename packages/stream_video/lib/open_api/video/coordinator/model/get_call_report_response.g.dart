// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_call_report_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetCallReportResponse extends GetCallReportResponse {
  @override
  final ChatActivityStatsResponse? chatActivity;
  @override
  final String duration;
  @override
  final ReportResponse report;
  @override
  final String sessionId;
  @override
  final BuiltList<VideoReactionsResponse?>? videoReactions;

  factory _$GetCallReportResponse(
          [void Function(GetCallReportResponseBuilder)? updates]) =>
      (GetCallReportResponseBuilder()..update(updates))._build();

  _$GetCallReportResponse._(
      {this.chatActivity,
      required this.duration,
      required this.report,
      required this.sessionId,
      this.videoReactions})
      : super._();
  @override
  GetCallReportResponse rebuild(
          void Function(GetCallReportResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GetCallReportResponseBuilder toBuilder() =>
      GetCallReportResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetCallReportResponse &&
        chatActivity == other.chatActivity &&
        duration == other.duration &&
        report == other.report &&
        sessionId == other.sessionId &&
        videoReactions == other.videoReactions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, chatActivity.hashCode);
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jc(_$hash, report.hashCode);
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jc(_$hash, videoReactions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GetCallReportResponse')
          ..add('chatActivity', chatActivity)
          ..add('duration', duration)
          ..add('report', report)
          ..add('sessionId', sessionId)
          ..add('videoReactions', videoReactions))
        .toString();
  }
}

class GetCallReportResponseBuilder
    implements Builder<GetCallReportResponse, GetCallReportResponseBuilder> {
  _$GetCallReportResponse? _$v;

  ChatActivityStatsResponseBuilder? _chatActivity;
  ChatActivityStatsResponseBuilder get chatActivity =>
      _$this._chatActivity ??= ChatActivityStatsResponseBuilder();
  set chatActivity(ChatActivityStatsResponseBuilder? chatActivity) =>
      _$this._chatActivity = chatActivity;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  ReportResponseBuilder? _report;
  ReportResponseBuilder get report =>
      _$this._report ??= ReportResponseBuilder();
  set report(ReportResponseBuilder? report) => _$this._report = report;

  String? _sessionId;
  String? get sessionId => _$this._sessionId;
  set sessionId(String? sessionId) => _$this._sessionId = sessionId;

  ListBuilder<VideoReactionsResponse?>? _videoReactions;
  ListBuilder<VideoReactionsResponse?> get videoReactions =>
      _$this._videoReactions ??= ListBuilder<VideoReactionsResponse?>();
  set videoReactions(ListBuilder<VideoReactionsResponse?>? videoReactions) =>
      _$this._videoReactions = videoReactions;

  GetCallReportResponseBuilder() {
    GetCallReportResponse._defaults(this);
  }

  GetCallReportResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _chatActivity = $v.chatActivity?.toBuilder();
      _duration = $v.duration;
      _report = $v.report.toBuilder();
      _sessionId = $v.sessionId;
      _videoReactions = $v.videoReactions?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GetCallReportResponse other) {
    _$v = other as _$GetCallReportResponse;
  }

  @override
  void update(void Function(GetCallReportResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetCallReportResponse build() => _build();

  _$GetCallReportResponse _build() {
    _$GetCallReportResponse _$result;
    try {
      _$result = _$v ??
          _$GetCallReportResponse._(
            chatActivity: _chatActivity?.build(),
            duration: BuiltValueNullFieldError.checkNotNull(
                duration, r'GetCallReportResponse', 'duration'),
            report: report.build(),
            sessionId: BuiltValueNullFieldError.checkNotNull(
                sessionId, r'GetCallReportResponse', 'sessionId'),
            videoReactions: _videoReactions?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'chatActivity';
        _chatActivity?.build();

        _$failedField = 'report';
        report.build();

        _$failedField = 'videoReactions';
        _videoReactions?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GetCallReportResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
