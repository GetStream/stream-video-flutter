// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_moderation_warning_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallModerationWarningEvent extends CallModerationWarningEvent {
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final BuiltMap<String, JsonObject?> custom;
  @override
  final String message;
  @override
  final String type;
  @override
  final String userId;

  factory _$CallModerationWarningEvent(
          [void Function(CallModerationWarningEventBuilder)? updates]) =>
      (CallModerationWarningEventBuilder()..update(updates))._build();

  _$CallModerationWarningEvent._(
      {required this.callCid,
      required this.createdAt,
      required this.custom,
      required this.message,
      required this.type,
      required this.userId})
      : super._();
  @override
  CallModerationWarningEvent rebuild(
          void Function(CallModerationWarningEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallModerationWarningEventBuilder toBuilder() =>
      CallModerationWarningEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallModerationWarningEvent &&
        callCid == other.callCid &&
        createdAt == other.createdAt &&
        custom == other.custom &&
        message == other.message &&
        type == other.type &&
        userId == other.userId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, custom.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallModerationWarningEvent')
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('custom', custom)
          ..add('message', message)
          ..add('type', type)
          ..add('userId', userId))
        .toString();
  }
}

class CallModerationWarningEventBuilder
    implements
        Builder<CallModerationWarningEvent, CallModerationWarningEventBuilder> {
  _$CallModerationWarningEvent? _$v;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  MapBuilder<String, JsonObject?>? _custom;
  MapBuilder<String, JsonObject?> get custom =>
      _$this._custom ??= MapBuilder<String, JsonObject?>();
  set custom(MapBuilder<String, JsonObject?>? custom) =>
      _$this._custom = custom;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  CallModerationWarningEventBuilder() {
    CallModerationWarningEvent._defaults(this);
  }

  CallModerationWarningEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _callCid = $v.callCid;
      _createdAt = $v.createdAt;
      _custom = $v.custom.toBuilder();
      _message = $v.message;
      _type = $v.type;
      _userId = $v.userId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallModerationWarningEvent other) {
    _$v = other as _$CallModerationWarningEvent;
  }

  @override
  void update(void Function(CallModerationWarningEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallModerationWarningEvent build() => _build();

  _$CallModerationWarningEvent _build() {
    _$CallModerationWarningEvent _$result;
    try {
      _$result = _$v ??
          _$CallModerationWarningEvent._(
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'CallModerationWarningEvent', 'callCid'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CallModerationWarningEvent', 'createdAt'),
            custom: custom.build(),
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'CallModerationWarningEvent', 'message'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CallModerationWarningEvent', 'type'),
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'CallModerationWarningEvent', 'userId'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'custom';
        custom.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallModerationWarningEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
