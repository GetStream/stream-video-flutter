// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_frame_recording_frame_ready_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallFrameRecordingFrameReadyEvent
    extends CallFrameRecordingFrameReadyEvent {
  @override
  final String callCid;
  @override
  final DateTime capturedAt;
  @override
  final DateTime createdAt;
  @override
  final String egressId;
  @override
  final String sessionId;
  @override
  final String trackType;
  @override
  final String type;
  @override
  final String url;
  @override
  final BuiltMap<String, UserResponse> users;

  factory _$CallFrameRecordingFrameReadyEvent(
          [void Function(CallFrameRecordingFrameReadyEventBuilder)? updates]) =>
      (CallFrameRecordingFrameReadyEventBuilder()..update(updates))._build();

  _$CallFrameRecordingFrameReadyEvent._(
      {required this.callCid,
      required this.capturedAt,
      required this.createdAt,
      required this.egressId,
      required this.sessionId,
      required this.trackType,
      required this.type,
      required this.url,
      required this.users})
      : super._();
  @override
  CallFrameRecordingFrameReadyEvent rebuild(
          void Function(CallFrameRecordingFrameReadyEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallFrameRecordingFrameReadyEventBuilder toBuilder() =>
      CallFrameRecordingFrameReadyEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallFrameRecordingFrameReadyEvent &&
        callCid == other.callCid &&
        capturedAt == other.capturedAt &&
        createdAt == other.createdAt &&
        egressId == other.egressId &&
        sessionId == other.sessionId &&
        trackType == other.trackType &&
        type == other.type &&
        url == other.url &&
        users == other.users;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, capturedAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, egressId.hashCode);
    _$hash = $jc(_$hash, sessionId.hashCode);
    _$hash = $jc(_$hash, trackType.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, users.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallFrameRecordingFrameReadyEvent')
          ..add('callCid', callCid)
          ..add('capturedAt', capturedAt)
          ..add('createdAt', createdAt)
          ..add('egressId', egressId)
          ..add('sessionId', sessionId)
          ..add('trackType', trackType)
          ..add('type', type)
          ..add('url', url)
          ..add('users', users))
        .toString();
  }
}

class CallFrameRecordingFrameReadyEventBuilder
    implements
        Builder<CallFrameRecordingFrameReadyEvent,
            CallFrameRecordingFrameReadyEventBuilder> {
  _$CallFrameRecordingFrameReadyEvent? _$v;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _capturedAt;
  DateTime? get capturedAt => _$this._capturedAt;
  set capturedAt(DateTime? capturedAt) => _$this._capturedAt = capturedAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _egressId;
  String? get egressId => _$this._egressId;
  set egressId(String? egressId) => _$this._egressId = egressId;

  String? _sessionId;
  String? get sessionId => _$this._sessionId;
  set sessionId(String? sessionId) => _$this._sessionId = sessionId;

  String? _trackType;
  String? get trackType => _$this._trackType;
  set trackType(String? trackType) => _$this._trackType = trackType;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  MapBuilder<String, UserResponse>? _users;
  MapBuilder<String, UserResponse> get users =>
      _$this._users ??= MapBuilder<String, UserResponse>();
  set users(MapBuilder<String, UserResponse>? users) => _$this._users = users;

  CallFrameRecordingFrameReadyEventBuilder() {
    CallFrameRecordingFrameReadyEvent._defaults(this);
  }

  CallFrameRecordingFrameReadyEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _callCid = $v.callCid;
      _capturedAt = $v.capturedAt;
      _createdAt = $v.createdAt;
      _egressId = $v.egressId;
      _sessionId = $v.sessionId;
      _trackType = $v.trackType;
      _type = $v.type;
      _url = $v.url;
      _users = $v.users.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallFrameRecordingFrameReadyEvent other) {
    _$v = other as _$CallFrameRecordingFrameReadyEvent;
  }

  @override
  void update(
      void Function(CallFrameRecordingFrameReadyEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallFrameRecordingFrameReadyEvent build() => _build();

  _$CallFrameRecordingFrameReadyEvent _build() {
    _$CallFrameRecordingFrameReadyEvent _$result;
    try {
      _$result = _$v ??
          _$CallFrameRecordingFrameReadyEvent._(
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'CallFrameRecordingFrameReadyEvent', 'callCid'),
            capturedAt: BuiltValueNullFieldError.checkNotNull(
                capturedAt, r'CallFrameRecordingFrameReadyEvent', 'capturedAt'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CallFrameRecordingFrameReadyEvent', 'createdAt'),
            egressId: BuiltValueNullFieldError.checkNotNull(
                egressId, r'CallFrameRecordingFrameReadyEvent', 'egressId'),
            sessionId: BuiltValueNullFieldError.checkNotNull(
                sessionId, r'CallFrameRecordingFrameReadyEvent', 'sessionId'),
            trackType: BuiltValueNullFieldError.checkNotNull(
                trackType, r'CallFrameRecordingFrameReadyEvent', 'trackType'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CallFrameRecordingFrameReadyEvent', 'type'),
            url: BuiltValueNullFieldError.checkNotNull(
                url, r'CallFrameRecordingFrameReadyEvent', 'url'),
            users: users.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'users';
        users.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallFrameRecordingFrameReadyEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
