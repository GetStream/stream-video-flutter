// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_duration_report.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallDurationReport extends CallDurationReport {
  @override
  final BuiltList<ReportByHistogramBucket> histogram;

  factory _$CallDurationReport(
          [void Function(CallDurationReportBuilder)? updates]) =>
      (CallDurationReportBuilder()..update(updates))._build();

  _$CallDurationReport._({required this.histogram}) : super._();
  @override
  CallDurationReport rebuild(
          void Function(CallDurationReportBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallDurationReportBuilder toBuilder() =>
      CallDurationReportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallDurationReport && histogram == other.histogram;
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
    return (newBuiltValueToStringHelper(r'CallDurationReport')
          ..add('histogram', histogram))
        .toString();
  }
}

class CallDurationReportBuilder
    implements Builder<CallDurationReport, CallDurationReportBuilder> {
  _$CallDurationReport? _$v;

  ListBuilder<ReportByHistogramBucket>? _histogram;
  ListBuilder<ReportByHistogramBucket> get histogram =>
      _$this._histogram ??= ListBuilder<ReportByHistogramBucket>();
  set histogram(ListBuilder<ReportByHistogramBucket>? histogram) =>
      _$this._histogram = histogram;

  CallDurationReportBuilder() {
    CallDurationReport._defaults(this);
  }

  CallDurationReportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _histogram = $v.histogram.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallDurationReport other) {
    _$v = other as _$CallDurationReport;
  }

  @override
  void update(void Function(CallDurationReportBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallDurationReport build() => _build();

  _$CallDurationReport _build() {
    _$CallDurationReport _$result;
    try {
      _$result = _$v ??
          _$CallDurationReport._(
            histogram: histogram.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'histogram';
        histogram.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallDurationReport', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
