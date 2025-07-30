// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_participant_count_report_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallParticipantCountReportResponse
    extends CallParticipantCountReportResponse {
  @override
  final BuiltList<DailyAggregateCallParticipantCountReportResponse> daily;

  factory _$CallParticipantCountReportResponse(
          [void Function(CallParticipantCountReportResponseBuilder)?
              updates]) =>
      (CallParticipantCountReportResponseBuilder()..update(updates))._build();

  _$CallParticipantCountReportResponse._({required this.daily}) : super._();
  @override
  CallParticipantCountReportResponse rebuild(
          void Function(CallParticipantCountReportResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallParticipantCountReportResponseBuilder toBuilder() =>
      CallParticipantCountReportResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallParticipantCountReportResponse && daily == other.daily;
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
    return (newBuiltValueToStringHelper(r'CallParticipantCountReportResponse')
          ..add('daily', daily))
        .toString();
  }
}

class CallParticipantCountReportResponseBuilder
    implements
        Builder<CallParticipantCountReportResponse,
            CallParticipantCountReportResponseBuilder> {
  _$CallParticipantCountReportResponse? _$v;

  ListBuilder<DailyAggregateCallParticipantCountReportResponse>? _daily;
  ListBuilder<DailyAggregateCallParticipantCountReportResponse> get daily =>
      _$this._daily ??=
          ListBuilder<DailyAggregateCallParticipantCountReportResponse>();
  set daily(
          ListBuilder<DailyAggregateCallParticipantCountReportResponse>?
              daily) =>
      _$this._daily = daily;

  CallParticipantCountReportResponseBuilder() {
    CallParticipantCountReportResponse._defaults(this);
  }

  CallParticipantCountReportResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _daily = $v.daily.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallParticipantCountReportResponse other) {
    _$v = other as _$CallParticipantCountReportResponse;
  }

  @override
  void update(
      void Function(CallParticipantCountReportResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallParticipantCountReportResponse build() => _build();

  _$CallParticipantCountReportResponse _build() {
    _$CallParticipantCountReportResponse _$result;
    try {
      _$result = _$v ??
          _$CallParticipantCountReportResponse._(
            daily: daily.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'daily';
        daily.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallParticipantCountReportResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
