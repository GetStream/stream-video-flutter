// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_aggregate_user_feedback_report_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DailyAggregateUserFeedbackReportResponse
    extends DailyAggregateUserFeedbackReportResponse {
  @override
  final String date;
  @override
  final UserFeedbackReport report;

  factory _$DailyAggregateUserFeedbackReportResponse(
          [void Function(DailyAggregateUserFeedbackReportResponseBuilder)?
              updates]) =>
      (DailyAggregateUserFeedbackReportResponseBuilder()..update(updates))
          ._build();

  _$DailyAggregateUserFeedbackReportResponse._(
      {required this.date, required this.report})
      : super._();
  @override
  DailyAggregateUserFeedbackReportResponse rebuild(
          void Function(DailyAggregateUserFeedbackReportResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DailyAggregateUserFeedbackReportResponseBuilder toBuilder() =>
      DailyAggregateUserFeedbackReportResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DailyAggregateUserFeedbackReportResponse &&
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
            r'DailyAggregateUserFeedbackReportResponse')
          ..add('date', date)
          ..add('report', report))
        .toString();
  }
}

class DailyAggregateUserFeedbackReportResponseBuilder
    implements
        Builder<DailyAggregateUserFeedbackReportResponse,
            DailyAggregateUserFeedbackReportResponseBuilder> {
  _$DailyAggregateUserFeedbackReportResponse? _$v;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  UserFeedbackReportBuilder? _report;
  UserFeedbackReportBuilder get report =>
      _$this._report ??= UserFeedbackReportBuilder();
  set report(UserFeedbackReportBuilder? report) => _$this._report = report;

  DailyAggregateUserFeedbackReportResponseBuilder() {
    DailyAggregateUserFeedbackReportResponse._defaults(this);
  }

  DailyAggregateUserFeedbackReportResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _report = $v.report.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DailyAggregateUserFeedbackReportResponse other) {
    _$v = other as _$DailyAggregateUserFeedbackReportResponse;
  }

  @override
  void update(
      void Function(DailyAggregateUserFeedbackReportResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DailyAggregateUserFeedbackReportResponse build() => _build();

  _$DailyAggregateUserFeedbackReportResponse _build() {
    _$DailyAggregateUserFeedbackReportResponse _$result;
    try {
      _$result = _$v ??
          _$DailyAggregateUserFeedbackReportResponse._(
            date: BuiltValueNullFieldError.checkNotNull(
                date, r'DailyAggregateUserFeedbackReportResponse', 'date'),
            report: report.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'report';
        report.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DailyAggregateUserFeedbackReportResponse',
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
