// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_state_response_fields.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallStateResponseFields extends CallStateResponseFields {
  @override
  final CallResponse call;
  @override
  final BuiltList<MemberResponse> members;
  @override
  final MemberResponse? membership;
  @override
  final BuiltList<OwnCapability> ownCapabilities;

  factory _$CallStateResponseFields(
          [void Function(CallStateResponseFieldsBuilder)? updates]) =>
      (CallStateResponseFieldsBuilder()..update(updates))._build();

  _$CallStateResponseFields._(
      {required this.call,
      required this.members,
      this.membership,
      required this.ownCapabilities})
      : super._();
  @override
  CallStateResponseFields rebuild(
          void Function(CallStateResponseFieldsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallStateResponseFieldsBuilder toBuilder() =>
      CallStateResponseFieldsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallStateResponseFields &&
        call == other.call &&
        members == other.members &&
        membership == other.membership &&
        ownCapabilities == other.ownCapabilities;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, call.hashCode);
    _$hash = $jc(_$hash, members.hashCode);
    _$hash = $jc(_$hash, membership.hashCode);
    _$hash = $jc(_$hash, ownCapabilities.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallStateResponseFields')
          ..add('call', call)
          ..add('members', members)
          ..add('membership', membership)
          ..add('ownCapabilities', ownCapabilities))
        .toString();
  }
}

class CallStateResponseFieldsBuilder
    implements
        Builder<CallStateResponseFields, CallStateResponseFieldsBuilder> {
  _$CallStateResponseFields? _$v;

  CallResponseBuilder? _call;
  CallResponseBuilder get call => _$this._call ??= CallResponseBuilder();
  set call(CallResponseBuilder? call) => _$this._call = call;

  ListBuilder<MemberResponse>? _members;
  ListBuilder<MemberResponse> get members =>
      _$this._members ??= ListBuilder<MemberResponse>();
  set members(ListBuilder<MemberResponse>? members) =>
      _$this._members = members;

  MemberResponseBuilder? _membership;
  MemberResponseBuilder get membership =>
      _$this._membership ??= MemberResponseBuilder();
  set membership(MemberResponseBuilder? membership) =>
      _$this._membership = membership;

  ListBuilder<OwnCapability>? _ownCapabilities;
  ListBuilder<OwnCapability> get ownCapabilities =>
      _$this._ownCapabilities ??= ListBuilder<OwnCapability>();
  set ownCapabilities(ListBuilder<OwnCapability>? ownCapabilities) =>
      _$this._ownCapabilities = ownCapabilities;

  CallStateResponseFieldsBuilder() {
    CallStateResponseFields._defaults(this);
  }

  CallStateResponseFieldsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _call = $v.call.toBuilder();
      _members = $v.members.toBuilder();
      _membership = $v.membership?.toBuilder();
      _ownCapabilities = $v.ownCapabilities.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallStateResponseFields other) {
    _$v = other as _$CallStateResponseFields;
  }

  @override
  void update(void Function(CallStateResponseFieldsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallStateResponseFields build() => _build();

  _$CallStateResponseFields _build() {
    _$CallStateResponseFields _$result;
    try {
      _$result = _$v ??
          _$CallStateResponseFields._(
            call: call.build(),
            members: members.build(),
            membership: _membership?.build(),
            ownCapabilities: ownCapabilities.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'call';
        call.build();
        _$failedField = 'members';
        members.build();
        _$failedField = 'membership';
        _membership?.build();
        _$failedField = 'ownCapabilities';
        ownCapabilities.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallStateResponseFields', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
