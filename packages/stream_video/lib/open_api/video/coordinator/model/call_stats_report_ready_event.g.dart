// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_stats_report_ready_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallStatsReportReadyEvent extends CallStatsReportReadyEvent {
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final String sessionId;
  @override
  final String type;

  factory _$CallStatsReportReadyEvent(
          [void Function(CallStatsReportReadyEventBuilder)? updates]) =>
      (CallStatsReportReadyEventBuilder()..update(updates))._build();

  _$CallStatsReportReadyEvent._(
      {required this.callCid,
      required this.createdAt,
      required this.sessionId,
      required this.type})
      : super._();
  @override
  CallStatsReportReadyEvent rebuild(
          void Function(CallStatsReportReadyEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallStatsReportReadyEventBuilder toBuilder() =>
      CallStatsReportReadyEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallStatsReportReadyEvent &&
        callCid == other.callCid &&
        createdAt == other.createdAt &&
        sessionId == other.sessionId &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallStatsReportReadyEvent')
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('sessionId', sessionId)
          ..add('type', type))
        .toString();
  }
}

class CallStatsReportReadyEventBuilder
    implements
        Builder<CallStatsReportReadyEvent, CallStatsReportReadyEventBuilder> {
  _$CallStatsReportReadyEvent? _$v;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _sessionId;
  String? get sessionId => _$this._sessionId;
  set sessionId(String? sessionId) => _$this._sessionId = sessionId;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  CallStatsReportReadyEventBuilder() {
    CallStatsReportReadyEvent._defaults(this);
  }

  CallStatsReportReadyEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _callCid = $v.callCid;
      _createdAt = $v.createdAt;
      _sessionId = $v.sessionId;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallStatsReportReadyEvent other) {
    _$v = other as _$CallStatsReportReadyEvent;
  }

  @override
  void update(void Function(CallStatsReportReadyEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallStatsReportReadyEvent build() => _build();

  _$CallStatsReportReadyEvent _build() {
    final _$result = _$v ??
        _$CallStatsReportReadyEvent._(
          callCid: BuiltValueNullFieldError.checkNotNull(
              callCid, r'CallStatsReportReadyEvent', 'callCid'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'CallStatsReportReadyEvent', 'createdAt'),
          sessionId: BuiltValueNullFieldError.checkNotNull(
              sessionId, r'CallStatsReportReadyEvent', 'sessionId'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'CallStatsReportReadyEvent', 'type'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
