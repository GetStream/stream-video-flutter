// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_participant_count_report.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallParticipantCountReport extends CallParticipantCountReport {
  @override
  final BuiltList<ReportByHistogramBucket> histogram;

  factory _$CallParticipantCountReport(
          [void Function(CallParticipantCountReportBuilder)? updates]) =>
      (CallParticipantCountReportBuilder()..update(updates))._build();

  _$CallParticipantCountReport._({required this.histogram}) : super._();
  @override
  CallParticipantCountReport rebuild(
          void Function(CallParticipantCountReportBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallParticipantCountReportBuilder toBuilder() =>
      CallParticipantCountReportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallParticipantCountReport && histogram == other.histogram;
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
    return (newBuiltValueToStringHelper(r'CallParticipantCountReport')
          ..add('histogram', histogram))
        .toString();
  }
}

class CallParticipantCountReportBuilder
    implements
        Builder<CallParticipantCountReport, CallParticipantCountReportBuilder> {
  _$CallParticipantCountReport? _$v;

  ListBuilder<ReportByHistogramBucket>? _histogram;
  ListBuilder<ReportByHistogramBucket> get histogram =>
      _$this._histogram ??= ListBuilder<ReportByHistogramBucket>();
  set histogram(ListBuilder<ReportByHistogramBucket>? histogram) =>
      _$this._histogram = histogram;

  CallParticipantCountReportBuilder() {
    CallParticipantCountReport._defaults(this);
  }

  CallParticipantCountReportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _histogram = $v.histogram.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallParticipantCountReport other) {
    _$v = other as _$CallParticipantCountReport;
  }

  @override
  void update(void Function(CallParticipantCountReportBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallParticipantCountReport build() => _build();

  _$CallParticipantCountReport _build() {
    _$CallParticipantCountReport _$result;
    try {
      _$result = _$v ??
          _$CallParticipantCountReport._(
            histogram: histogram.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'histogram';
        histogram.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallParticipantCountReport', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
