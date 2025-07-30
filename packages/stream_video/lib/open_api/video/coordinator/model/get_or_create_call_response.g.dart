// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_or_create_call_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GetOrCreateCallResponse extends GetOrCreateCallResponse {
  @override
  final CallResponse call;
  @override
  final bool created;
  @override
  final String duration;
  @override
  final BuiltList<MemberResponse> members;
  @override
  final MemberResponse? membership;
  @override
  final BuiltList<OwnCapability> ownCapabilities;

  factory _$GetOrCreateCallResponse(
          [void Function(GetOrCreateCallResponseBuilder)? updates]) =>
      (GetOrCreateCallResponseBuilder()..update(updates))._build();

  _$GetOrCreateCallResponse._(
      {required this.call,
      required this.created,
      required this.duration,
      required this.members,
      this.membership,
      required this.ownCapabilities})
      : super._();
  @override
  GetOrCreateCallResponse rebuild(
          void Function(GetOrCreateCallResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GetOrCreateCallResponseBuilder toBuilder() =>
      GetOrCreateCallResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GetOrCreateCallResponse &&
        call == other.call &&
        created == other.created &&
        duration == other.duration &&
        members == other.members &&
        membership == other.membership &&
        ownCapabilities == other.ownCapabilities;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, call.hashCode);
    _$hash = $jc(_$hash, created.hashCode);
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jc(_$hash, members.hashCode);
    _$hash = $jc(_$hash, membership.hashCode);
    _$hash = $jc(_$hash, ownCapabilities.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GetOrCreateCallResponse')
          ..add('call', call)
          ..add('created', created)
          ..add('duration', duration)
          ..add('members', members)
          ..add('membership', membership)
          ..add('ownCapabilities', ownCapabilities))
        .toString();
  }
}

class GetOrCreateCallResponseBuilder
    implements
        Builder<GetOrCreateCallResponse, GetOrCreateCallResponseBuilder> {
  _$GetOrCreateCallResponse? _$v;

  CallResponseBuilder? _call;
  CallResponseBuilder get call => _$this._call ??= CallResponseBuilder();
  set call(CallResponseBuilder? call) => _$this._call = call;

  bool? _created;
  bool? get created => _$this._created;
  set created(bool? created) => _$this._created = created;

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

  GetOrCreateCallResponseBuilder() {
    GetOrCreateCallResponse._defaults(this);
  }

  GetOrCreateCallResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _call = $v.call.toBuilder();
      _created = $v.created;
      _duration = $v.duration;
      _members = $v.members.toBuilder();
      _membership = $v.membership?.toBuilder();
      _ownCapabilities = $v.ownCapabilities.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GetOrCreateCallResponse other) {
    _$v = other as _$GetOrCreateCallResponse;
  }

  @override
  void update(void Function(GetOrCreateCallResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GetOrCreateCallResponse build() => _build();

  _$GetOrCreateCallResponse _build() {
    _$GetOrCreateCallResponse _$result;
    try {
      _$result = _$v ??
          _$GetOrCreateCallResponse._(
            call: call.build(),
            created: BuiltValueNullFieldError.checkNotNull(
                created, r'GetOrCreateCallResponse', 'created'),
            duration: BuiltValueNullFieldError.checkNotNull(
                duration, r'GetOrCreateCallResponse', 'duration'),
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
            r'GetOrCreateCallResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
