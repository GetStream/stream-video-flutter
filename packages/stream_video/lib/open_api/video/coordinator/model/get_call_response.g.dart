// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_call_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetCallResponse extends GetCallResponse {
  @override
  final CallResponse call;
  @override
  final String duration;
  @override
  final BuiltList<MemberResponse> members;
  @override
  final MemberResponse? membership;
  @override
  final BuiltList<OwnCapability> ownCapabilities;

  factory _$GetCallResponse([void Function(GetCallResponseBuilder)? updates]) =>
      (GetCallResponseBuilder()..update(updates))._build();

  _$GetCallResponse._(
      {required this.call,
      required this.duration,
      required this.members,
      this.membership,
      required this.ownCapabilities})
      : super._();
  @override
  GetCallResponse rebuild(void Function(GetCallResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GetCallResponseBuilder toBuilder() => GetCallResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetCallResponse &&
        call == other.call &&
        duration == other.duration &&
        members == other.members &&
        membership == other.membership &&
        ownCapabilities == other.ownCapabilities;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, call.hashCode);
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jc(_$hash, members.hashCode);
    _$hash = $jc(_$hash, membership.hashCode);
    _$hash = $jc(_$hash, ownCapabilities.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GetCallResponse')
          ..add('call', call)
          ..add('duration', duration)
          ..add('members', members)
          ..add('membership', membership)
          ..add('ownCapabilities', ownCapabilities))
        .toString();
  }
}

class GetCallResponseBuilder
    implements Builder<GetCallResponse, GetCallResponseBuilder> {
  _$GetCallResponse? _$v;

  CallResponseBuilder? _call;
  CallResponseBuilder get call => _$this._call ??= CallResponseBuilder();
  set call(CallResponseBuilder? call) => _$this._call = call;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

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

  GetCallResponseBuilder() {
    GetCallResponse._defaults(this);
  }

  GetCallResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _call = $v.call.toBuilder();
      _duration = $v.duration;
      _members = $v.members.toBuilder();
      _membership = $v.membership?.toBuilder();
      _ownCapabilities = $v.ownCapabilities.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GetCallResponse other) {
    _$v = other as _$GetCallResponse;
  }

  @override
  void update(void Function(GetCallResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetCallResponse build() => _build();

  _$GetCallResponse _build() {
    _$GetCallResponse _$result;
    try {
      _$result = _$v ??
          _$GetCallResponse._(
            call: call.build(),
            duration: BuiltValueNullFieldError.checkNotNull(
                duration, r'GetCallResponse', 'duration'),
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
            r'GetCallResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
