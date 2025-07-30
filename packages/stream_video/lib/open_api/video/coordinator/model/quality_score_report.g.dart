// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quality_score_report.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$QualityScoreReport extends QualityScoreReport {
  @override
  final BuiltList<ReportByHistogramBucket> histogram;

  factory _$QualityScoreReport(
          [void Function(QualityScoreReportBuilder)? updates]) =>
      (QualityScoreReportBuilder()..update(updates))._build();

  _$QualityScoreReport._({required this.histogram}) : super._();
  @override
  QualityScoreReport rebuild(
          void Function(QualityScoreReportBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QualityScoreReportBuilder toBuilder() =>
      QualityScoreReportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is QualityScoreReport && histogram == other.histogram;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, histogram.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'QualityScoreReport')
          ..add('histogram', histogram))
        .toString();
  }
}

class QualityScoreReportBuilder
    implements Builder<QualityScoreReport, QualityScoreReportBuilder> {
  _$QualityScoreReport? _$v;

  ListBuilder<ReportByHistogramBucket>? _histogram;
  ListBuilder<ReportByHistogramBucket> get histogram =>
      _$this._histogram ??= ListBuilder<ReportByHistogramBucket>();
  set histogram(ListBuilder<ReportByHistogramBucket>? histogram) =>
      _$this._histogram = histogram;

  QualityScoreReportBuilder() {
    QualityScoreReport._defaults(this);
  }

  QualityScoreReportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _histogram = $v.histogram.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(QualityScoreReport other) {
    _$v = other as _$QualityScoreReport;
  }

  @override
  void update(void Function(QualityScoreReportBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  QualityScoreReport build() => _build();

  _$QualityScoreReport _build() {
    _$QualityScoreReport _$result;
    try {
      _$result = _$v ??
          _$QualityScoreReport._(
            histogram: histogram.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'histogram';
        histogram.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'QualityScoreReport', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
