// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_member_updated_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallMemberUpdatedEvent extends CallMemberUpdatedEvent {
  @override
  final CallResponse call;
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final BuiltList<MemberResponse> members;
  @override
  final String type;

  factory _$CallMemberUpdatedEvent(
          [void Function(CallMemberUpdatedEventBuilder)? updates]) =>
      (CallMemberUpdatedEventBuilder()..update(updates))._build();

  _$CallMemberUpdatedEvent._(
      {required this.call,
      required this.callCid,
      required this.createdAt,
      required this.members,
      required this.type})
      : super._();
  @override
  CallMemberUpdatedEvent rebuild(
          void Function(CallMemberUpdatedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallMemberUpdatedEventBuilder toBuilder() =>
      CallMemberUpdatedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallMemberUpdatedEvent &&
        call == other.call &&
        callCid == other.callCid &&
        createdAt == other.createdAt &&
        members == other.members &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, call.hashCode);
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, members.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallMemberUpdatedEvent')
          ..add('call', call)
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('members', members)
          ..add('type', type))
        .toString();
  }
}

class CallMemberUpdatedEventBuilder
    implements Builder<CallMemberUpdatedEvent, CallMemberUpdatedEventBuilder> {
  _$CallMemberUpdatedEvent? _$v;

  CallResponseBuilder? _call;
  CallResponseBuilder get call => _$this._call ??= CallResponseBuilder();
  set call(CallResponseBuilder? call) => _$this._call = call;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ListBuilder<MemberResponse>? _members;
  ListBuilder<MemberResponse> get members =>
      _$this._members ??= ListBuilder<MemberResponse>();
  set members(ListBuilder<MemberResponse>? members) =>
      _$this._members = members;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  CallMemberUpdatedEventBuilder() {
    CallMemberUpdatedEvent._defaults(this);
  }

  CallMemberUpdatedEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _call = $v.call.toBuilder();
      _callCid = $v.callCid;
      _createdAt = $v.createdAt;
      _members = $v.members.toBuilder();
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallMemberUpdatedEvent other) {
    _$v = other as _$CallMemberUpdatedEvent;
  }

  @override
  void update(void Function(CallMemberUpdatedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallMemberUpdatedEvent build() => _build();

  _$CallMemberUpdatedEvent _build() {
    _$CallMemberUpdatedEvent _$result;
    try {
      _$result = _$v ??
          _$CallMemberUpdatedEvent._(
            call: call.build(),
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'CallMemberUpdatedEvent', 'callCid'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CallMemberUpdatedEvent', 'createdAt'),
            members: members.build(),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CallMemberUpdatedEvent', 'type'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'call';
        call.build();

        _$failedField = 'members';
        members.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallMemberUpdatedEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
