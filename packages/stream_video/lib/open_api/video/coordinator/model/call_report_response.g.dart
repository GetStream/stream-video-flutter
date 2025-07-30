// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_report_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallReportResponse extends CallReportResponse {
  @override
  final DateTime? endedAt;
  @override
  final double score;
  @override
  final DateTime? startedAt;

  factory _$CallReportResponse(
          [void Function(CallReportResponseBuilder)? updates]) =>
      (CallReportResponseBuilder()..update(updates))._build();

  _$CallReportResponse._({this.endedAt, required this.score, this.startedAt})
      : super._();
  @override
  CallReportResponse rebuild(
          void Function(CallReportResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallReportResponseBuilder toBuilder() =>
      CallReportResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallReportResponse &&
        endedAt == other.endedAt &&
        score == other.score &&
        startedAt == other.startedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, endedAt.hashCode);
    _$hash = $jc(_$hash, score.hashCode);
    _$hash = $jc(_$hash, startedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallReportResponse')
          ..add('endedAt', endedAt)
          ..add('score', score)
          ..add('startedAt', startedAt))
        .toString();
  }
}

class CallReportResponseBuilder
    implements Builder<CallReportResponse, CallReportResponseBuilder> {
  _$CallReportResponse? _$v;

  DateTime? _endedAt;
  DateTime? get endedAt => _$this._endedAt;
  set endedAt(DateTime? endedAt) => _$this._endedAt = endedAt;

  double? _score;
  double? get score => _$this._score;
  set score(double? score) => _$this._score = score;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  CallReportResponseBuilder() {
    CallReportResponse._defaults(this);
  }

  CallReportResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _endedAt = $v.endedAt;
      _score = $v.score;
      _startedAt = $v.startedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallReportResponse other) {
    _$v = other as _$CallReportResponse;
  }

  @override
  void update(void Function(CallReportResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallReportResponse build() => _build();

  _$CallReportResponse _build() {
    final _$result = _$v ??
        _$CallReportResponse._(
          endedAt: endedAt,
          score: BuiltValueNullFieldError.checkNotNull(
              score, r'CallReportResponse', 'score'),
          startedAt: startedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
