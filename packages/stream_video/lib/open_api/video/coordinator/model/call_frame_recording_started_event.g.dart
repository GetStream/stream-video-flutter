// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_frame_recording_started_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallFrameRecordingStartedEvent extends CallFrameRecordingStartedEvent {
  @override
  final CallResponse call;
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final String egressId;
  @override
  final String type;

  factory _$CallFrameRecordingStartedEvent(
          [void Function(CallFrameRecordingStartedEventBuilder)? updates]) =>
      (CallFrameRecordingStartedEventBuilder()..update(updates))._build();

  _$CallFrameRecordingStartedEvent._(
      {required this.call,
      required this.callCid,
      required this.createdAt,
      required this.egressId,
      required this.type})
      : super._();
  @override
  CallFrameRecordingStartedEvent rebuild(
          void Function(CallFrameRecordingStartedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallFrameRecordingStartedEventBuilder toBuilder() =>
      CallFrameRecordingStartedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallFrameRecordingStartedEvent &&
        call == other.call &&
        callCid == other.callCid &&
        createdAt == other.createdAt &&
        egressId == other.egressId &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, call.hashCode);
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, egressId.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallFrameRecordingStartedEvent')
          ..add('call', call)
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('egressId', egressId)
          ..add('type', type))
        .toString();
  }
}

class CallFrameRecordingStartedEventBuilder
    implements
        Builder<CallFrameRecordingStartedEvent,
            CallFrameRecordingStartedEventBuilder> {
  _$CallFrameRecordingStartedEvent? _$v;

  CallResponseBuilder? _call;
  CallResponseBuilder get call => _$this._call ??= CallResponseBuilder();
  set call(CallResponseBuilder? call) => _$this._call = call;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _egressId;
  String? get egressId => _$this._egressId;
  set egressId(String? egressId) => _$this._egressId = egressId;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  CallFrameRecordingStartedEventBuilder() {
    CallFrameRecordingStartedEvent._defaults(this);
  }

  CallFrameRecordingStartedEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _call = $v.call.toBuilder();
      _callCid = $v.callCid;
      _createdAt = $v.createdAt;
      _egressId = $v.egressId;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallFrameRecordingStartedEvent other) {
    _$v = other as _$CallFrameRecordingStartedEvent;
  }

  @override
  void update(void Function(CallFrameRecordingStartedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallFrameRecordingStartedEvent build() => _build();

  _$CallFrameRecordingStartedEvent _build() {
    _$CallFrameRecordingStartedEvent _$result;
    try {
      _$result = _$v ??
          _$CallFrameRecordingStartedEvent._(
            call: call.build(),
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'CallFrameRecordingStartedEvent', 'callCid'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CallFrameRecordingStartedEvent', 'createdAt'),
            egressId: BuiltValueNullFieldError.checkNotNull(
                egressId, r'CallFrameRecordingStartedEvent', 'egressId'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CallFrameRecordingStartedEvent', 'type'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'call';
        call.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallFrameRecordingStartedEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
