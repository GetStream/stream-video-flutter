// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_duration_report_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallDurationReportResponse extends CallDurationReportResponse {
  @override
  final BuiltList<DailyAggregateCallDurationReportResponse> daily;

  factory _$CallDurationReportResponse(
          [void Function(CallDurationReportResponseBuilder)? updates]) =>
      (CallDurationReportResponseBuilder()..update(updates))._build();

  _$CallDurationReportResponse._({required this.daily}) : super._();
  @override
  CallDurationReportResponse rebuild(
          void Function(CallDurationReportResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallDurationReportResponseBuilder toBuilder() =>
      CallDurationReportResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallDurationReportResponse && daily == other.daily;
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
    return (newBuiltValueToStringHelper(r'CallDurationReportResponse')
          ..add('daily', daily))
        .toString();
  }
}

class CallDurationReportResponseBuilder
    implements
        Builder<CallDurationReportResponse, CallDurationReportResponseBuilder> {
  _$CallDurationReportResponse? _$v;

  ListBuilder<DailyAggregateCallDurationReportResponse>? _daily;
  ListBuilder<DailyAggregateCallDurationReportResponse> get daily =>
      _$this._daily ??= ListBuilder<DailyAggregateCallDurationReportResponse>();
  set daily(ListBuilder<DailyAggregateCallDurationReportResponse>? daily) =>
      _$this._daily = daily;

  CallDurationReportResponseBuilder() {
    CallDurationReportResponse._defaults(this);
  }

  CallDurationReportResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _daily = $v.daily.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallDurationReportResponse other) {
    _$v = other as _$CallDurationReportResponse;
  }

  @override
  void update(void Function(CallDurationReportResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallDurationReportResponse build() => _build();

  _$CallDurationReportResponse _build() {
    _$CallDurationReportResponse _$result;
    try {
      _$result = _$v ??
          _$CallDurationReportResponse._(
            daily: daily.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'daily';
        daily.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallDurationReportResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
