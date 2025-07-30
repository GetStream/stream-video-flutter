// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sdk_usage_report_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SDKUsageReportResponse extends SDKUsageReportResponse {
  @override
  final BuiltList<DailyAggregateSDKUsageReportResponse> daily;

  factory _$SDKUsageReportResponse(
          [void Function(SDKUsageReportResponseBuilder)? updates]) =>
      (SDKUsageReportResponseBuilder()..update(updates))._build();

  _$SDKUsageReportResponse._({required this.daily}) : super._();
  @override
  SDKUsageReportResponse rebuild(
          void Function(SDKUsageReportResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SDKUsageReportResponseBuilder toBuilder() =>
      SDKUsageReportResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SDKUsageReportResponse && daily == other.daily;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, daily.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SDKUsageReportResponse')
          ..add('daily', daily))
        .toString();
  }
}

class SDKUsageReportResponseBuilder
    implements Builder<SDKUsageReportResponse, SDKUsageReportResponseBuilder> {
  _$SDKUsageReportResponse? _$v;

  ListBuilder<DailyAggregateSDKUsageReportResponse>? _daily;
  ListBuilder<DailyAggregateSDKUsageReportResponse> get daily =>
      _$this._daily ??= ListBuilder<DailyAggregateSDKUsageReportResponse>();
  set daily(ListBuilder<DailyAggregateSDKUsageReportResponse>? daily) =>
      _$this._daily = daily;

  SDKUsageReportResponseBuilder() {
    SDKUsageReportResponse._defaults(this);
  }

  SDKUsageReportResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _daily = $v.daily.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SDKUsageReportResponse other) {
    _$v = other as _$SDKUsageReportResponse;
  }

  @override
  void update(void Function(SDKUsageReportResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SDKUsageReportResponse build() => _build();

  _$SDKUsageReportResponse _build() {
    _$SDKUsageReportResponse _$result;
    try {
      _$result = _$v ??
          _$SDKUsageReportResponse._(
            daily: daily.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'daily';
        daily.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SDKUsageReportResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
