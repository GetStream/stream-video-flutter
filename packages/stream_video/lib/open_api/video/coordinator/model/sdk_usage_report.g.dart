// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sdk_usage_report.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SDKUsageReport extends SDKUsageReport {
  @override
  final BuiltMap<String, PerSDKUsageReport?> perSdkUsage;

  factory _$SDKUsageReport([void Function(SDKUsageReportBuilder)? updates]) =>
      (SDKUsageReportBuilder()..update(updates))._build();

  _$SDKUsageReport._({required this.perSdkUsage}) : super._();
  @override
  SDKUsageReport rebuild(void Function(SDKUsageReportBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SDKUsageReportBuilder toBuilder() => SDKUsageReportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SDKUsageReport && perSdkUsage == other.perSdkUsage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, perSdkUsage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SDKUsageReport')
          ..add('perSdkUsage', perSdkUsage))
        .toString();
  }
}

class SDKUsageReportBuilder
    implements Builder<SDKUsageReport, SDKUsageReportBuilder> {
  _$SDKUsageReport? _$v;

  MapBuilder<String, PerSDKUsageReport?>? _perSdkUsage;
  MapBuilder<String, PerSDKUsageReport?> get perSdkUsage =>
      _$this._perSdkUsage ??= MapBuilder<String, PerSDKUsageReport?>();
  set perSdkUsage(MapBuilder<String, PerSDKUsageReport?>? perSdkUsage) =>
      _$this._perSdkUsage = perSdkUsage;

  SDKUsageReportBuilder() {
    SDKUsageReport._defaults(this);
  }

  SDKUsageReportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _perSdkUsage = $v.perSdkUsage.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SDKUsageReport other) {
    _$v = other as _$SDKUsageReport;
  }

  @override
  void update(void Function(SDKUsageReportBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SDKUsageReport build() => _build();

  _$SDKUsageReport _build() {
    _$SDKUsageReport _$result;
    try {
      _$result = _$v ??
          _$SDKUsageReport._(
            perSdkUsage: perSdkUsage.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'perSdkUsage';
        perSdkUsage.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SDKUsageReport', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
