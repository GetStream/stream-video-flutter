// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_call_members_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateCallMembersResponse extends UpdateCallMembersResponse {
  @override
  final String duration;
  @override
  final BuiltList<MemberResponse> members;

  factory _$UpdateCallMembersResponse(
          [void Function(UpdateCallMembersResponseBuilder)? updates]) =>
      (UpdateCallMembersResponseBuilder()..update(updates))._build();

  _$UpdateCallMembersResponse._({required this.duration, required this.members})
      : super._();
  @override
  UpdateCallMembersResponse rebuild(
          void Function(UpdateCallMembersResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateCallMembersResponseBuilder toBuilder() =>
      UpdateCallMembersResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateCallMembersResponse &&
        duration == other.duration &&
        members == other.members;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jc(_$hash, members.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateCallMembersResponse')
          ..add('duration', duration)
          ..add('members', members))
        .toString();
  }
}

class UpdateCallMembersResponseBuilder
    implements
        Builder<UpdateCallMembersResponse, UpdateCallMembersResponseBuilder> {
  _$UpdateCallMembersResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  ListBuilder<MemberResponse>? _members;
  ListBuilder<MemberResponse> get members =>
      _$this._members ??= ListBuilder<MemberResponse>();
  set members(ListBuilder<MemberResponse>? members) =>
      _$this._members = members;

  UpdateCallMembersResponseBuilder() {
    UpdateCallMembersResponse._defaults(this);
  }

  UpdateCallMembersResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _members = $v.members.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateCallMembersResponse other) {
    _$v = other as _$UpdateCallMembersResponse;
  }

  @override
  void update(void Function(UpdateCallMembersResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateCallMembersResponse build() => _build();

  _$UpdateCallMembersResponse _build() {
    _$UpdateCallMembersResponse _$result;
    try {
      _$result = _$v ??
          _$UpdateCallMembersResponse._(
            duration: BuiltValueNullFieldError.checkNotNull(
                duration, r'UpdateCallMembersResponse', 'duration'),
            members: members.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'members';
        members.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UpdateCallMembersResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
