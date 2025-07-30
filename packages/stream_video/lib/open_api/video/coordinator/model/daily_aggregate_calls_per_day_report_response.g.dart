// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_aggregate_calls_per_day_report_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DailyAggregateCallsPerDayReportResponse
    extends DailyAggregateCallsPerDayReportResponse {
  @override
  final String date;
  @override
  final CallsPerDayReport report;

  factory _$DailyAggregateCallsPerDayReportResponse(
          [void Function(DailyAggregateCallsPerDayReportResponseBuilder)?
              updates]) =>
      (DailyAggregateCallsPerDayReportResponseBuilder()..update(updates))
          ._build();

  _$DailyAggregateCallsPerDayReportResponse._(
      {required this.date, required this.report})
      : super._();
  @override
  DailyAggregateCallsPerDayReportResponse rebuild(
          void Function(DailyAggregateCallsPerDayReportResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DailyAggregateCallsPerDayReportResponseBuilder toBuilder() =>
      DailyAggregateCallsPerDayReportResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DailyAggregateCallsPerDayReportResponse &&
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
            r'DailyAggregateCallsPerDayReportResponse')
          ..add('date', date)
          ..add('report', report))
        .toString();
  }
}

class DailyAggregateCallsPerDayReportResponseBuilder
    implements
        Builder<DailyAggregateCallsPerDayReportResponse,
            DailyAggregateCallsPerDayReportResponseBuilder> {
  _$DailyAggregateCallsPerDayReportResponse? _$v;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  CallsPerDayReportBuilder? _report;
  CallsPerDayReportBuilder get report =>
      _$this._report ??= CallsPerDayReportBuilder();
  set report(CallsPerDayReportBuilder? report) => _$this._report = report;

  DailyAggregateCallsPerDayReportResponseBuilder() {
    DailyAggregateCallsPerDayReportResponse._defaults(this);
  }

  DailyAggregateCallsPerDayReportResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _report = $v.report.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DailyAggregateCallsPerDayReportResponse other) {
    _$v = other as _$DailyAggregateCallsPerDayReportResponse;
  }

  @override
  void update(
      void Function(DailyAggregateCallsPerDayReportResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DailyAggregateCallsPerDayReportResponse build() => _build();

  _$DailyAggregateCallsPerDayReportResponse _build() {
    _$DailyAggregateCallsPerDayReportResponse _$result;
    try {
      _$result = _$v ??
          _$DailyAggregateCallsPerDayReportResponse._(
            date: BuiltValueNullFieldError.checkNotNull(
                date, r'DailyAggregateCallsPerDayReportResponse', 'date'),
            report: report.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'report';
        report.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DailyAggregateCallsPerDayReportResponse',
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
