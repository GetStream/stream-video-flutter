// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_member_added_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallMemberAddedEvent extends CallMemberAddedEvent {
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

  factory _$CallMemberAddedEvent(
          [void Function(CallMemberAddedEventBuilder)? updates]) =>
      (CallMemberAddedEventBuilder()..update(updates))._build();

  _$CallMemberAddedEvent._(
      {required this.call,
      required this.callCid,
      required this.createdAt,
      required this.members,
      required this.type})
      : super._();
  @override
  CallMemberAddedEvent rebuild(
          void Function(CallMemberAddedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallMemberAddedEventBuilder toBuilder() =>
      CallMemberAddedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallMemberAddedEvent &&
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
    return (newBuiltValueToStringHelper(r'CallMemberAddedEvent')
          ..add('call', call)
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('members', members)
          ..add('type', type))
        .toString();
  }
}

class CallMemberAddedEventBuilder
    implements Builder<CallMemberAddedEvent, CallMemberAddedEventBuilder> {
  _$CallMemberAddedEvent? _$v;

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

  CallMemberAddedEventBuilder() {
    CallMemberAddedEvent._defaults(this);
  }

  CallMemberAddedEventBuilder get _$this {
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
  void replace(CallMemberAddedEvent other) {
    _$v = other as _$CallMemberAddedEvent;
  }

  @override
  void update(void Function(CallMemberAddedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallMemberAddedEvent build() => _build();

  _$CallMemberAddedEvent _build() {
    _$CallMemberAddedEvent _$result;
    try {
      _$result = _$v ??
          _$CallMemberAddedEvent._(
            call: call.build(),
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'CallMemberAddedEvent', 'callCid'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CallMemberAddedEvent', 'createdAt'),
            members: members.build(),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CallMemberAddedEvent', 'type'),
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
            r'CallMemberAddedEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
