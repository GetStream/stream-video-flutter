// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calls_per_day_report.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallsPerDayReport extends CallsPerDayReport {
  @override
  final int count;

  factory _$CallsPerDayReport(
          [void Function(CallsPerDayReportBuilder)? updates]) =>
      (CallsPerDayReportBuilder()..update(updates))._build();

  _$CallsPerDayReport._({required this.count}) : super._();
  @override
  CallsPerDayReport rebuild(void Function(CallsPerDayReportBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallsPerDayReportBuilder toBuilder() =>
      CallsPerDayReportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallsPerDayReport && count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallsPerDayReport')
          ..add('count', count))
        .toString();
  }
}

class CallsPerDayReportBuilder
    implements Builder<CallsPerDayReport, CallsPerDayReportBuilder> {
  _$CallsPerDayReport? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  CallsPerDayReportBuilder() {
    CallsPerDayReport._defaults(this);
  }

  CallsPerDayReportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallsPerDayReport other) {
    _$v = other as _$CallsPerDayReport;
  }

  @override
  void update(void Function(CallsPerDayReportBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallsPerDayReport build() => _build();

  _$CallsPerDayReport _build() {
    final _$result = _$v ??
        _$CallsPerDayReport._(
          count: BuiltValueNullFieldError.checkNotNull(
              count, r'CallsPerDayReport', 'count'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
