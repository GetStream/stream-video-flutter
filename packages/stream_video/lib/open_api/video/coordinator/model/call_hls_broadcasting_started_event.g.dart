// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_hls_broadcasting_started_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallHLSBroadcastingStartedEvent
    extends CallHLSBroadcastingStartedEvent {
  @override
  final CallResponse call;
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final String hlsPlaylistUrl;
  @override
  final String type;

  factory _$CallHLSBroadcastingStartedEvent(
          [void Function(CallHLSBroadcastingStartedEventBuilder)? updates]) =>
      (CallHLSBroadcastingStartedEventBuilder()..update(updates))._build();

  _$CallHLSBroadcastingStartedEvent._(
      {required this.call,
      required this.callCid,
      required this.createdAt,
      required this.hlsPlaylistUrl,
      required this.type})
      : super._();
  @override
  CallHLSBroadcastingStartedEvent rebuild(
          void Function(CallHLSBroadcastingStartedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallHLSBroadcastingStartedEventBuilder toBuilder() =>
      CallHLSBroadcastingStartedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallHLSBroadcastingStartedEvent &&
        call == other.call &&
        callCid == other.callCid &&
        createdAt == other.createdAt &&
        hlsPlaylistUrl == other.hlsPlaylistUrl &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, call.hashCode);
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, hlsPlaylistUrl.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallHLSBroadcastingStartedEvent')
          ..add('call', call)
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('hlsPlaylistUrl', hlsPlaylistUrl)
          ..add('type', type))
        .toString();
  }
}

class CallHLSBroadcastingStartedEventBuilder
    implements
        Builder<CallHLSBroadcastingStartedEvent,
            CallHLSBroadcastingStartedEventBuilder> {
  _$CallHLSBroadcastingStartedEvent? _$v;

  CallResponseBuilder? _call;
  CallResponseBuilder get call => _$this._call ??= CallResponseBuilder();
  set call(CallResponseBuilder? call) => _$this._call = call;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _hlsPlaylistUrl;
  String? get hlsPlaylistUrl => _$this._hlsPlaylistUrl;
  set hlsPlaylistUrl(String? hlsPlaylistUrl) =>
      _$this._hlsPlaylistUrl = hlsPlaylistUrl;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  CallHLSBroadcastingStartedEventBuilder() {
    CallHLSBroadcastingStartedEvent._defaults(this);
  }

  CallHLSBroadcastingStartedEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _call = $v.call.toBuilder();
      _callCid = $v.callCid;
      _createdAt = $v.createdAt;
      _hlsPlaylistUrl = $v.hlsPlaylistUrl;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallHLSBroadcastingStartedEvent other) {
    _$v = other as _$CallHLSBroadcastingStartedEvent;
  }

  @override
  void update(void Function(CallHLSBroadcastingStartedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallHLSBroadcastingStartedEvent build() => _build();

  _$CallHLSBroadcastingStartedEvent _build() {
    _$CallHLSBroadcastingStartedEvent _$result;
    try {
      _$result = _$v ??
          _$CallHLSBroadcastingStartedEvent._(
            call: call.build(),
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'CallHLSBroadcastingStartedEvent', 'callCid'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CallHLSBroadcastingStartedEvent', 'createdAt'),
            hlsPlaylistUrl: BuiltValueNullFieldError.checkNotNull(
                hlsPlaylistUrl,
                r'CallHLSBroadcastingStartedEvent',
                'hlsPlaylistUrl'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CallHLSBroadcastingStartedEvent', 'type'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'call';
        call.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallHLSBroadcastingStartedEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
