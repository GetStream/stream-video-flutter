// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_aggregate_sdk_usage_report_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DailyAggregateSDKUsageReportResponse
    extends DailyAggregateSDKUsageReportResponse {
  @override
  final String date;
  @override
  final SDKUsageReport report;

  factory _$DailyAggregateSDKUsageReportResponse(
          [void Function(DailyAggregateSDKUsageReportResponseBuilder)?
              updates]) =>
      (DailyAggregateSDKUsageReportResponseBuilder()..update(updates))._build();

  _$DailyAggregateSDKUsageReportResponse._(
      {required this.date, required this.report})
      : super._();
  @override
  DailyAggregateSDKUsageReportResponse rebuild(
          void Function(DailyAggregateSDKUsageReportResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DailyAggregateSDKUsageReportResponseBuilder toBuilder() =>
      DailyAggregateSDKUsageReportResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DailyAggregateSDKUsageReportResponse &&
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
    return (newBuiltValueToStringHelper(r'DailyAggregateSDKUsageReportResponse')
          ..add('date', date)
          ..add('report', report))
        .toString();
  }
}

class DailyAggregateSDKUsageReportResponseBuilder
    implements
        Builder<DailyAggregateSDKUsageReportResponse,
            DailyAggregateSDKUsageReportResponseBuilder> {
  _$DailyAggregateSDKUsageReportResponse? _$v;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  SDKUsageReportBuilder? _report;
  SDKUsageReportBuilder get report =>
      _$this._report ??= SDKUsageReportBuilder();
  set report(SDKUsageReportBuilder? report) => _$this._report = report;

  DailyAggregateSDKUsageReportResponseBuilder() {
    DailyAggregateSDKUsageReportResponse._defaults(this);
  }

  DailyAggregateSDKUsageReportResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _report = $v.report.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DailyAggregateSDKUsageReportResponse other) {
    _$v = other as _$DailyAggregateSDKUsageReportResponse;
  }

  @override
  void update(
      void Function(DailyAggregateSDKUsageReportResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DailyAggregateSDKUsageReportResponse build() => _build();

  _$DailyAggregateSDKUsageReportResponse _build() {
    _$DailyAggregateSDKUsageReportResponse _$result;
    try {
      _$result = _$v ??
          _$DailyAggregateSDKUsageReportResponse._(
            date: BuiltValueNullFieldError.checkNotNull(
                date, r'DailyAggregateSDKUsageReportResponse', 'date'),
            report: report.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'report';
        report.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DailyAggregateSDKUsageReportResponse',
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
