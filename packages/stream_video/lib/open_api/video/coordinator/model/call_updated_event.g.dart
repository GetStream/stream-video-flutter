// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_updated_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallUpdatedEvent extends CallUpdatedEvent {
  @override
  final CallResponse call;
  @override
  final String callCid;
  @override
  final BuiltMap<String, BuiltList<String>> capabilitiesByRole;
  @override
  final DateTime createdAt;
  @override
  final String type;

  factory _$CallUpdatedEvent(
          [void Function(CallUpdatedEventBuilder)? updates]) =>
      (CallUpdatedEventBuilder()..update(updates))._build();

  _$CallUpdatedEvent._(
      {required this.call,
      required this.callCid,
      required this.capabilitiesByRole,
      required this.createdAt,
      required this.type})
      : super._();
  @override
  CallUpdatedEvent rebuild(void Function(CallUpdatedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallUpdatedEventBuilder toBuilder() =>
      CallUpdatedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallUpdatedEvent &&
        call == other.call &&
        callCid == other.callCid &&
        capabilitiesByRole == other.capabilitiesByRole &&
        createdAt == other.createdAt &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, call.hashCode);
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, capabilitiesByRole.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallUpdatedEvent')
          ..add('call', call)
          ..add('callCid', callCid)
          ..add('capabilitiesByRole', capabilitiesByRole)
          ..add('createdAt', createdAt)
          ..add('type', type))
        .toString();
  }
}

class CallUpdatedEventBuilder
    implements Builder<CallUpdatedEvent, CallUpdatedEventBuilder> {
  _$CallUpdatedEvent? _$v;

  CallResponseBuilder? _call;
  CallResponseBuilder get call => _$this._call ??= CallResponseBuilder();
  set call(CallResponseBuilder? call) => _$this._call = call;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  MapBuilder<String, BuiltList<String>>? _capabilitiesByRole;
  MapBuilder<String, BuiltList<String>> get capabilitiesByRole =>
      _$this._capabilitiesByRole ??= MapBuilder<String, BuiltList<String>>();
  set capabilitiesByRole(
          MapBuilder<String, BuiltList<String>>? capabilitiesByRole) =>
      _$this._capabilitiesByRole = capabilitiesByRole;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  CallUpdatedEventBuilder() {
    CallUpdatedEvent._defaults(this);
  }

  CallUpdatedEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _call = $v.call.toBuilder();
      _callCid = $v.callCid;
      _capabilitiesByRole = $v.capabilitiesByRole.toBuilder();
      _createdAt = $v.createdAt;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallUpdatedEvent other) {
    _$v = other as _$CallUpdatedEvent;
  }

  @override
  void update(void Function(CallUpdatedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallUpdatedEvent build() => _build();

  _$CallUpdatedEvent _build() {
    _$CallUpdatedEvent _$result;
    try {
      _$result = _$v ??
          _$CallUpdatedEvent._(
            call: call.build(),
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'CallUpdatedEvent', 'callCid'),
            capabilitiesByRole: capabilitiesByRole.build(),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CallUpdatedEvent', 'createdAt'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CallUpdatedEvent', 'type'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'call';
        call.build();

        _$failedField = 'capabilitiesByRole';
        capabilitiesByRole.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallUpdatedEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
