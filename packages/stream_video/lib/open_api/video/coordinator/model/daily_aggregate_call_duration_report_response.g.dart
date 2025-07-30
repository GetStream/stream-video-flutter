// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_aggregate_call_duration_report_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DailyAggregateCallDurationReportResponse
    extends DailyAggregateCallDurationReportResponse {
  @override
  final String date;
  @override
  final CallDurationReport report;

  factory _$DailyAggregateCallDurationReportResponse(
          [void Function(DailyAggregateCallDurationReportResponseBuilder)?
              updates]) =>
      (DailyAggregateCallDurationReportResponseBuilder()..update(updates))
          ._build();

  _$DailyAggregateCallDurationReportResponse._(
      {required this.date, required this.report})
      : super._();
  @override
  DailyAggregateCallDurationReportResponse rebuild(
          void Function(DailyAggregateCallDurationReportResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DailyAggregateCallDurationReportResponseBuilder toBuilder() =>
      DailyAggregateCallDurationReportResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DailyAggregateCallDurationReportResponse &&
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
            r'DailyAggregateCallDurationReportResponse')
          ..add('date', date)
          ..add('report', report))
        .toString();
  }
}

class DailyAggregateCallDurationReportResponseBuilder
    implements
        Builder<DailyAggregateCallDurationReportResponse,
            DailyAggregateCallDurationReportResponseBuilder> {
  _$DailyAggregateCallDurationReportResponse? _$v;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  CallDurationReportBuilder? _report;
  CallDurationReportBuilder get report =>
      _$this._report ??= CallDurationReportBuilder();
  set report(CallDurationReportBuilder? report) => _$this._report = report;

  DailyAggregateCallDurationReportResponseBuilder() {
    DailyAggregateCallDurationReportResponse._defaults(this);
  }

  DailyAggregateCallDurationReportResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _report = $v.report.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DailyAggregateCallDurationReportResponse other) {
    _$v = other as _$DailyAggregateCallDurationReportResponse;
  }

  @override
  void update(
      void Function(DailyAggregateCallDurationReportResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DailyAggregateCallDurationReportResponse build() => _build();

  _$DailyAggregateCallDurationReportResponse _build() {
    _$DailyAggregateCallDurationReportResponse _$result;
    try {
      _$result = _$v ??
          _$DailyAggregateCallDurationReportResponse._(
            date: BuiltValueNullFieldError.checkNotNull(
                date, r'DailyAggregateCallDurationReportResponse', 'date'),
            report: report.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'report';
        report.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DailyAggregateCallDurationReportResponse',
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
