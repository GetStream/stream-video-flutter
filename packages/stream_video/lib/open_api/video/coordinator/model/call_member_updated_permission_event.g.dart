// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_member_updated_permission_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallMemberUpdatedPermissionEvent
    extends CallMemberUpdatedPermissionEvent {
  @override
  final CallResponse call;
  @override
  final String callCid;
  @override
  final BuiltMap<String, BuiltList<String>> capabilitiesByRole;
  @override
  final DateTime createdAt;
  @override
  final BuiltList<MemberResponse> members;
  @override
  final String type;

  factory _$CallMemberUpdatedPermissionEvent(
          [void Function(CallMemberUpdatedPermissionEventBuilder)? updates]) =>
      (CallMemberUpdatedPermissionEventBuilder()..update(updates))._build();

  _$CallMemberUpdatedPermissionEvent._(
      {required this.call,
      required this.callCid,
      required this.capabilitiesByRole,
      required this.createdAt,
      required this.members,
      required this.type})
      : super._();
  @override
  CallMemberUpdatedPermissionEvent rebuild(
          void Function(CallMemberUpdatedPermissionEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallMemberUpdatedPermissionEventBuilder toBuilder() =>
      CallMemberUpdatedPermissionEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallMemberUpdatedPermissionEvent &&
        call == other.call &&
        callCid == other.callCid &&
        capabilitiesByRole == other.capabilitiesByRole &&
        createdAt == other.createdAt &&
        members == other.members &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, call.hashCode);
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, capabilitiesByRole.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, members.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallMemberUpdatedPermissionEvent')
          ..add('call', call)
          ..add('callCid', callCid)
          ..add('capabilitiesByRole', capabilitiesByRole)
          ..add('createdAt', createdAt)
          ..add('members', members)
          ..add('type', type))
        .toString();
  }
}

class CallMemberUpdatedPermissionEventBuilder
    implements
        Builder<CallMemberUpdatedPermissionEvent,
            CallMemberUpdatedPermissionEventBuilder> {
  _$CallMemberUpdatedPermissionEvent? _$v;

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

  ListBuilder<MemberResponse>? _members;
  ListBuilder<MemberResponse> get members =>
      _$this._members ??= ListBuilder<MemberResponse>();
  set members(ListBuilder<MemberResponse>? members) =>
      _$this._members = members;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  CallMemberUpdatedPermissionEventBuilder() {
    CallMemberUpdatedPermissionEvent._defaults(this);
  }

  CallMemberUpdatedPermissionEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _call = $v.call.toBuilder();
      _callCid = $v.callCid;
      _capabilitiesByRole = $v.capabilitiesByRole.toBuilder();
      _createdAt = $v.createdAt;
      _members = $v.members.toBuilder();
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallMemberUpdatedPermissionEvent other) {
    _$v = other as _$CallMemberUpdatedPermissionEvent;
  }

  @override
  void update(void Function(CallMemberUpdatedPermissionEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallMemberUpdatedPermissionEvent build() => _build();

  _$CallMemberUpdatedPermissionEvent _build() {
    _$CallMemberUpdatedPermissionEvent _$result;
    try {
      _$result = _$v ??
          _$CallMemberUpdatedPermissionEvent._(
            call: call.build(),
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'CallMemberUpdatedPermissionEvent', 'callCid'),
            capabilitiesByRole: capabilitiesByRole.build(),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CallMemberUpdatedPermissionEvent', 'createdAt'),
            members: members.build(),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CallMemberUpdatedPermissionEvent', 'type'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'call';
        call.build();

        _$failedField = 'capabilitiesByRole';
        capabilitiesByRole.build();

        _$failedField = 'members';
        members.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallMemberUpdatedPermissionEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
