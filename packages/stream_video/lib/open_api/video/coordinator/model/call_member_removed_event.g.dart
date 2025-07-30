// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_member_removed_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallMemberRemovedEvent extends CallMemberRemovedEvent {
  @override
  final CallResponse call;
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final BuiltList<String> members;
  @override
  final String type;

  factory _$CallMemberRemovedEvent(
          [void Function(CallMemberRemovedEventBuilder)? updates]) =>
      (CallMemberRemovedEventBuilder()..update(updates))._build();

  _$CallMemberRemovedEvent._(
      {required this.call,
      required this.callCid,
      required this.createdAt,
      required this.members,
      required this.type})
      : super._();
  @override
  CallMemberRemovedEvent rebuild(
          void Function(CallMemberRemovedEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallMemberRemovedEventBuilder toBuilder() =>
      CallMemberRemovedEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallMemberRemovedEvent &&
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
    return (newBuiltValueToStringHelper(r'CallMemberRemovedEvent')
          ..add('call', call)
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('members', members)
          ..add('type', type))
        .toString();
  }
}

class CallMemberRemovedEventBuilder
    implements Builder<CallMemberRemovedEvent, CallMemberRemovedEventBuilder> {
  _$CallMemberRemovedEvent? _$v;

  CallResponseBuilder? _call;
  CallResponseBuilder get call => _$this._call ??= CallResponseBuilder();
  set call(CallResponseBuilder? call) => _$this._call = call;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ListBuilder<String>? _members;
  ListBuilder<String> get members => _$this._members ??= ListBuilder<String>();
  set members(ListBuilder<String>? members) => _$this._members = members;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  CallMemberRemovedEventBuilder() {
    CallMemberRemovedEvent._defaults(this);
  }

  CallMemberRemovedEventBuilder get _$this {
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
  void replace(CallMemberRemovedEvent other) {
    _$v = other as _$CallMemberRemovedEvent;
  }

  @override
  void update(void Function(CallMemberRemovedEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallMemberRemovedEvent build() => _build();

  _$CallMemberRemovedEvent _build() {
    _$CallMemberRemovedEvent _$result;
    try {
      _$result = _$v ??
          _$CallMemberRemovedEvent._(
            call: call.build(),
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'CallMemberRemovedEvent', 'callCid'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CallMemberRemovedEvent', 'createdAt'),
            members: members.build(),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CallMemberRemovedEvent', 'type'),
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
            r'CallMemberRemovedEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
