// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_options.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StatsOptions extends StatsOptions {
  @override
  final bool enableRtcStats;
  @override
  final int reportingIntervalMs;

  factory _$StatsOptions([void Function(StatsOptionsBuilder)? updates]) =>
      (StatsOptionsBuilder()..update(updates))._build();

  _$StatsOptions._(
      {required this.enableRtcStats, required this.reportingIntervalMs})
      : super._();
  @override
  StatsOptions rebuild(void Function(StatsOptionsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StatsOptionsBuilder toBuilder() => StatsOptionsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StatsOptions &&
        enableRtcStats == other.enableRtcStats &&
        reportingIntervalMs == other.reportingIntervalMs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enableRtcStats.hashCode);
    _$hash = $jc(_$hash, reportingIntervalMs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StatsOptions')
          ..add('enableRtcStats', enableRtcStats)
          ..add('reportingIntervalMs', reportingIntervalMs))
        .toString();
  }
}

class StatsOptionsBuilder
    implements Builder<StatsOptions, StatsOptionsBuilder> {
  _$StatsOptions? _$v;

  bool? _enableRtcStats;
  bool? get enableRtcStats => _$this._enableRtcStats;
  set enableRtcStats(bool? enableRtcStats) =>
      _$this._enableRtcStats = enableRtcStats;

  int? _reportingIntervalMs;
  int? get reportingIntervalMs => _$this._reportingIntervalMs;
  set reportingIntervalMs(int? reportingIntervalMs) =>
      _$this._reportingIntervalMs = reportingIntervalMs;

  StatsOptionsBuilder() {
    StatsOptions._defaults(this);
  }

  StatsOptionsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enableRtcStats = $v.enableRtcStats;
      _reportingIntervalMs = $v.reportingIntervalMs;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StatsOptions other) {
    _$v = other as _$StatsOptions;
  }

  @override
  void update(void Function(StatsOptionsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StatsOptions build() => _build();

  _$StatsOptions _build() {
    final _$result = _$v ??
        _$StatsOptions._(
          enableRtcStats: BuiltValueNullFieldError.checkNotNull(
              enableRtcStats, r'StatsOptions', 'enableRtcStats'),
          reportingIntervalMs: BuiltValueNullFieldError.checkNotNull(
              reportingIntervalMs, r'StatsOptions', 'reportingIntervalMs'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
