// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_aggregate_call_participant_count_report_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DailyAggregateCallParticipantCountReportResponse
    extends DailyAggregateCallParticipantCountReportResponse {
  @override
  final String date;
  @override
  final CallParticipantCountReport report;

  factory _$DailyAggregateCallParticipantCountReportResponse(
          [void Function(
                  DailyAggregateCallParticipantCountReportResponseBuilder)?
              updates]) =>
      (DailyAggregateCallParticipantCountReportResponseBuilder()
            ..update(updates))
          ._build();

  _$DailyAggregateCallParticipantCountReportResponse._(
      {required this.date, required this.report})
      : super._();
  @override
  DailyAggregateCallParticipantCountReportResponse rebuild(
          void Function(DailyAggregateCallParticipantCountReportResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DailyAggregateCallParticipantCountReportResponseBuilder toBuilder() =>
      DailyAggregateCallParticipantCountReportResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DailyAggregateCallParticipantCountReportResponse &&
        date == other.date &&
        report == other.report;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, report.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'DailyAggregateCallParticipantCountReportResponse')
          ..add('date', date)
          ..add('report', report))
        .toString();
  }
}

class DailyAggregateCallParticipantCountReportResponseBuilder
    implements
        Builder<DailyAggregateCallParticipantCountReportResponse,
            DailyAggregateCallParticipantCountReportResponseBuilder> {
  _$DailyAggregateCallParticipantCountReportResponse? _$v;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  CallParticipantCountReportBuilder? _report;
  CallParticipantCountReportBuilder get report =>
      _$this._report ??= CallParticipantCountReportBuilder();
  set report(CallParticipantCountReportBuilder? report) =>
      _$this._report = report;

  DailyAggregateCallParticipantCountReportResponseBuilder() {
    DailyAggregateCallParticipantCountReportResponse._defaults(this);
  }

  DailyAggregateCallParticipantCountReportResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _report = $v.report.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DailyAggregateCallParticipantCountReportResponse other) {
    _$v = other as _$DailyAggregateCallParticipantCountReportResponse;
  }

  @override
  void update(
      void Function(DailyAggregateCallParticipantCountReportResponseBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  DailyAggregateCallParticipantCountReportResponse build() => _build();

  _$DailyAggregateCallParticipantCountReportResponse _build() {
    _$DailyAggregateCallParticipantCountReportResponse _$result;
    try {
      _$result = _$v ??
          _$DailyAggregateCallParticipantCountReportResponse._(
            date: BuiltValueNullFieldError.checkNotNull(date,
                r'DailyAggregateCallParticipantCountReportResponse', 'date'),
            report: report.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'report';
        report.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DailyAggregateCallParticipantCountReportResponse',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
