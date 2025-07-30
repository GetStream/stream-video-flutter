// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_aggregate_quality_score_report_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DailyAggregateQualityScoreReportResponse
    extends DailyAggregateQualityScoreReportResponse {
  @override
  final String date;
  @override
  final QualityScoreReport report;

  factory _$DailyAggregateQualityScoreReportResponse(
          [void Function(DailyAggregateQualityScoreReportResponseBuilder)?
              updates]) =>
      (DailyAggregateQualityScoreReportResponseBuilder()..update(updates))
          ._build();

  _$DailyAggregateQualityScoreReportResponse._(
      {required this.date, required this.report})
      : super._();
  @override
  DailyAggregateQualityScoreReportResponse rebuild(
          void Function(DailyAggregateQualityScoreReportResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DailyAggregateQualityScoreReportResponseBuilder toBuilder() =>
      DailyAggregateQualityScoreReportResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DailyAggregateQualityScoreReportResponse &&
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
            r'DailyAggregateQualityScoreReportResponse')
          ..add('date', date)
          ..add('report', report))
        .toString();
  }
}

class DailyAggregateQualityScoreReportResponseBuilder
    implements
        Builder<DailyAggregateQualityScoreReportResponse,
            DailyAggregateQualityScoreReportResponseBuilder> {
  _$DailyAggregateQualityScoreReportResponse? _$v;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  QualityScoreReportBuilder? _report;
  QualityScoreReportBuilder get report =>
      _$this._report ??= QualityScoreReportBuilder();
  set report(QualityScoreReportBuilder? report) => _$this._report = report;

  DailyAggregateQualityScoreReportResponseBuilder() {
    DailyAggregateQualityScoreReportResponse._defaults(this);
  }

  DailyAggregateQualityScoreReportResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _report = $v.report.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DailyAggregateQualityScoreReportResponse other) {
    _$v = other as _$DailyAggregateQualityScoreReportResponse;
  }

  @override
  void update(
      void Function(DailyAggregateQualityScoreReportResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DailyAggregateQualityScoreReportResponse build() => _build();

  _$DailyAggregateQualityScoreReportResponse _build() {
    _$DailyAggregateQualityScoreReportResponse _$result;
    try {
      _$result = _$v ??
          _$DailyAggregateQualityScoreReportResponse._(
            date: BuiltValueNullFieldError.checkNotNull(
                date, r'DailyAggregateQualityScoreReportResponse', 'date'),
            report: report.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'report';
        report.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DailyAggregateQualityScoreReportResponse',
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
