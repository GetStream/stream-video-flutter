// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calls_per_day_report_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallsPerDayReportResponse extends CallsPerDayReportResponse {
  @override
  final BuiltList<DailyAggregateCallsPerDayReportResponse> daily;

  factory _$CallsPerDayReportResponse(
          [void Function(CallsPerDayReportResponseBuilder)? updates]) =>
      (CallsPerDayReportResponseBuilder()..update(updates))._build();

  _$CallsPerDayReportResponse._({required this.daily}) : super._();
  @override
  CallsPerDayReportResponse rebuild(
          void Function(CallsPerDayReportResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallsPerDayReportResponseBuilder toBuilder() =>
      CallsPerDayReportResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallsPerDayReportResponse && daily == other.daily;
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
    return (newBuiltValueToStringHelper(r'CallsPerDayReportResponse')
          ..add('daily', daily))
        .toString();
  }
}

class CallsPerDayReportResponseBuilder
    implements
        Builder<CallsPerDayReportResponse, CallsPerDayReportResponseBuilder> {
  _$CallsPerDayReportResponse? _$v;

  ListBuilder<DailyAggregateCallsPerDayReportResponse>? _daily;
  ListBuilder<DailyAggregateCallsPerDayReportResponse> get daily =>
      _$this._daily ??= ListBuilder<DailyAggregateCallsPerDayReportResponse>();
  set daily(ListBuilder<DailyAggregateCallsPerDayReportResponse>? daily) =>
      _$this._daily = daily;

  CallsPerDayReportResponseBuilder() {
    CallsPerDayReportResponse._defaults(this);
  }

  CallsPerDayReportResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _daily = $v.daily.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallsPerDayReportResponse other) {
    _$v = other as _$CallsPerDayReportResponse;
  }

  @override
  void update(void Function(CallsPerDayReportResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallsPerDayReportResponse build() => _build();

  _$CallsPerDayReportResponse _build() {
    _$CallsPerDayReportResponse _$result;
    try {
      _$result = _$v ??
          _$CallsPerDayReportResponse._(
            daily: daily.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'daily';
        daily.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallsPerDayReportResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
