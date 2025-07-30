// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_call_members_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$QueryCallMembersResponse extends QueryCallMembersResponse {
  @override
  final String duration;
  @override
  final BuiltList<MemberResponse> members;
  @override
  final String? next;
  @override
  final String? prev;

  factory _$QueryCallMembersResponse(
          [void Function(QueryCallMembersResponseBuilder)? updates]) =>
      (QueryCallMembersResponseBuilder()..update(updates))._build();

  _$QueryCallMembersResponse._(
      {required this.duration, required this.members, this.next, this.prev})
      : super._();
  @override
  QueryCallMembersResponse rebuild(
          void Function(QueryCallMembersResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  QueryCallMembersResponseBuilder toBuilder() =>
      QueryCallMembersResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is QueryCallMembersResponse &&
        duration == other.duration &&
        members == other.members &&
        next == other.next &&
        prev == other.prev;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jc(_$hash, members.hashCode);
    _$hash = $jc(_$hash, next.hashCode);
    _$hash = $jc(_$hash, prev.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'QueryCallMembersResponse')
          ..add('duration', duration)
          ..add('members', members)
          ..add('next', next)
          ..add('prev', prev))
        .toString();
  }
}

class QueryCallMembersResponseBuilder
    implements
        Builder<QueryCallMembersResponse, QueryCallMembersResponseBuilder> {
  _$QueryCallMembersResponse? _$v;

  String? _duration;
  String? get duration => _$this._duration;
  set duration(String? duration) => _$this._duration = duration;

  ListBuilder<MemberResponse>? _members;
  ListBuilder<MemberResponse> get members =>
      _$this._members ??= ListBuilder<MemberResponse>();
  set members(ListBuilder<MemberResponse>? members) =>
      _$this._members = members;

  String? _next;
  String? get next => _$this._next;
  set next(String? next) => _$this._next = next;

  String? _prev;
  String? get prev => _$this._prev;
  set prev(String? prev) => _$this._prev = prev;

  QueryCallMembersResponseBuilder() {
    QueryCallMembersResponse._defaults(this);
  }

  QueryCallMembersResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _duration = $v.duration;
      _members = $v.members.toBuilder();
      _next = $v.next;
      _prev = $v.prev;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(QueryCallMembersResponse other) {
    _$v = other as _$QueryCallMembersResponse;
  }

  @override
  void update(void Function(QueryCallMembersResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  QueryCallMembersResponse build() => _build();

  _$QueryCallMembersResponse _build() {
    _$QueryCallMembersResponse _$result;
    try {
      _$result = _$v ??
          _$QueryCallMembersResponse._(
            duration: BuiltValueNullFieldError.checkNotNull(
                duration, r'QueryCallMembersResponse', 'duration'),
            members: members.build(),
            next: next,
            prev: prev,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'members';
        members.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'QueryCallMembersResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
