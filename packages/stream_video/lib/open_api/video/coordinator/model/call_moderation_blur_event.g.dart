// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_moderation_blur_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallModerationBlurEvent extends CallModerationBlurEvent {
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final BuiltMap<String, JsonObject?> custom;
  @override
  final String type;
  @override
  final String userId;

  factory _$CallModerationBlurEvent(
          [void Function(CallModerationBlurEventBuilder)? updates]) =>
      (CallModerationBlurEventBuilder()..update(updates))._build();

  _$CallModerationBlurEvent._(
      {required this.callCid,
      required this.createdAt,
      required this.custom,
      required this.type,
      required this.userId})
      : super._();
  @override
  CallModerationBlurEvent rebuild(
          void Function(CallModerationBlurEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallModerationBlurEventBuilder toBuilder() =>
      CallModerationBlurEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallModerationBlurEvent &&
        callCid == other.callCid &&
        createdAt == other.createdAt &&
        custom == other.custom &&
        type == other.type &&
        userId == other.userId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, custom.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallModerationBlurEvent')
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('custom', custom)
          ..add('type', type)
          ..add('userId', userId))
        .toString();
  }
}

class CallModerationBlurEventBuilder
    implements
        Builder<CallModerationBlurEvent, CallModerationBlurEventBuilder> {
  _$CallModerationBlurEvent? _$v;

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

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  CallModerationBlurEventBuilder() {
    CallModerationBlurEvent._defaults(this);
  }

  CallModerationBlurEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _callCid = $v.callCid;
      _createdAt = $v.createdAt;
      _custom = $v.custom.toBuilder();
      _type = $v.type;
      _userId = $v.userId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallModerationBlurEvent other) {
    _$v = other as _$CallModerationBlurEvent;
  }

  @override
  void update(void Function(CallModerationBlurEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallModerationBlurEvent build() => _build();

  _$CallModerationBlurEvent _build() {
    _$CallModerationBlurEvent _$result;
    try {
      _$result = _$v ??
          _$CallModerationBlurEvent._(
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'CallModerationBlurEvent', 'callCid'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CallModerationBlurEvent', 'createdAt'),
            custom: custom.build(),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CallModerationBlurEvent', 'type'),
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'CallModerationBlurEvent', 'userId'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'custom';
        custom.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallModerationBlurEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
