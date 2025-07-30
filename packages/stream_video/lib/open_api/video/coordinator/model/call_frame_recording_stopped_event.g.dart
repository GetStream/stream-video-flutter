// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_frame_recording_stopped_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallFrameRecordingStoppedEvent extends CallFrameRecordingStoppedEvent {
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

  factory _$CallFrameRecordingStoppedEvent(
          [void Function(CallFrameRecordingStoppedEventBuilder)? updates]) =>
      (CallFrameRecordingStoppedEventBuilder()..update(updates))._build();

  _$CallFrameRecordingStoppedEvent._(
      {required this.call,
      required this.callCid,
      required this.createdAt,
      required this.egressId,
      required this.type})
      : super._();
  @override
  CallFrameRecordingStoppedEvent rebuild(
          void Function(CallFrameRecordingStoppedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallFrameRecordingStoppedEventBuilder toBuilder() =>
      CallFrameRecordingStoppedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallFrameRecordingStoppedEvent &&
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
    return (newBuiltValueToStringHelper(r'CallFrameRecordingStoppedEvent')
          ..add('call', call)
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('egressId', egressId)
          ..add('type', type))
        .toString();
  }
}

class CallFrameRecordingStoppedEventBuilder
    implements
        Builder<CallFrameRecordingStoppedEvent,
            CallFrameRecordingStoppedEventBuilder> {
  _$CallFrameRecordingStoppedEvent? _$v;

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

  CallFrameRecordingStoppedEventBuilder() {
    CallFrameRecordingStoppedEvent._defaults(this);
  }

  CallFrameRecordingStoppedEventBuilder get _$this {
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
  void replace(CallFrameRecordingStoppedEvent other) {
    _$v = other as _$CallFrameRecordingStoppedEvent;
  }

  @override
  void update(void Function(CallFrameRecordingStoppedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallFrameRecordingStoppedEvent build() => _build();

  _$CallFrameRecordingStoppedEvent _build() {
    _$CallFrameRecordingStoppedEvent _$result;
    try {
      _$result = _$v ??
          _$CallFrameRecordingStoppedEvent._(
            call: call.build(),
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'CallFrameRecordingStoppedEvent', 'callCid'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CallFrameRecordingStoppedEvent', 'createdAt'),
            egressId: BuiltValueNullFieldError.checkNotNull(
                egressId, r'CallFrameRecordingStoppedEvent', 'egressId'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CallFrameRecordingStoppedEvent', 'type'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'call';
        call.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallFrameRecordingStoppedEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
