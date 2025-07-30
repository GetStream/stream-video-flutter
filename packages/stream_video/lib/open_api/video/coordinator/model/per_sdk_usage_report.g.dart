// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'per_sdk_usage_report.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PerSDKUsageReport extends PerSDKUsageReport {
  @override
  final BuiltMap<String, int> byVersion;
  @override
  final int total;

  factory _$PerSDKUsageReport(
          [void Function(PerSDKUsageReportBuilder)? updates]) =>
      (PerSDKUsageReportBuilder()..update(updates))._build();

  _$PerSDKUsageReport._({required this.byVersion, required this.total})
      : super._();
  @override
  PerSDKUsageReport rebuild(void Function(PerSDKUsageReportBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PerSDKUsageReportBuilder toBuilder() =>
      PerSDKUsageReportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PerSDKUsageReport &&
        byVersion == other.byVersion &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, byVersion.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PerSDKUsageReport')
          ..add('byVersion', byVersion)
          ..add('total', total))
        .toString();
  }
}

class PerSDKUsageReportBuilder
    implements Builder<PerSDKUsageReport, PerSDKUsageReportBuilder> {
  _$PerSDKUsageReport? _$v;

  MapBuilder<String, int>? _byVersion;
  MapBuilder<String, int> get byVersion =>
      _$this._byVersion ??= MapBuilder<String, int>();
  set byVersion(MapBuilder<String, int>? byVersion) =>
      _$this._byVersion = byVersion;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  PerSDKUsageReportBuilder() {
    PerSDKUsageReport._defaults(this);
  }

  PerSDKUsageReportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _byVersion = $v.byVersion.toBuilder();
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PerSDKUsageReport other) {
    _$v = other as _$PerSDKUsageReport;
  }

  @override
  void update(void Function(PerSDKUsageReportBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PerSDKUsageReport build() => _build();

  _$PerSDKUsageReport _build() {
    _$PerSDKUsageReport _$result;
    try {
      _$result = _$v ??
          _$PerSDKUsageReport._(
            byVersion: byVersion.build(),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'PerSDKUsageReport', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'byVersion';
        byVersion.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PerSDKUsageReport', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
