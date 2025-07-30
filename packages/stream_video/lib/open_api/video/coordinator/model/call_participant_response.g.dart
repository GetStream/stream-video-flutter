// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_participant_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CallParticipantResponse extends CallParticipantResponse {
  @override
  final DateTime joinedAt;
  @override
  final String role;
  @override
  final UserResponse user;
  @override
  final String userSessionId;

  factory _$CallParticipantResponse(
          [void Function(CallParticipantResponseBuilder)? updates]) =>
      (CallParticipantResponseBuilder()..update(updates))._build();

  _$CallParticipantResponse._(
      {required this.joinedAt,
      required this.role,
      required this.user,
      required this.userSessionId})
      : super._();
  @override
  CallParticipantResponse rebuild(
          void Function(CallParticipantResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CallParticipantResponseBuilder toBuilder() =>
      CallParticipantResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CallParticipantResponse &&
        joinedAt == other.joinedAt &&
        role == other.role &&
        user == other.user &&
        userSessionId == other.userSessionId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, joinedAt.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jc(_$hash, userSessionId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CallParticipantResponse')
          ..add('joinedAt', joinedAt)
          ..add('role', role)
          ..add('user', user)
          ..add('userSessionId', userSessionId))
        .toString();
  }
}

class CallParticipantResponseBuilder
    implements
        Builder<CallParticipantResponse, CallParticipantResponseBuilder> {
  _$CallParticipantResponse? _$v;

  DateTime? _joinedAt;
  DateTime? get joinedAt => _$this._joinedAt;
  set joinedAt(DateTime? joinedAt) => _$this._joinedAt = joinedAt;

  String? _role;
  String? get role => _$this._role;
  set role(String? role) => _$this._role = role;

  UserResponseBuilder? _user;
  UserResponseBuilder get user => _$this._user ??= UserResponseBuilder();
  set user(UserResponseBuilder? user) => _$this._user = user;

  String? _userSessionId;
  String? get userSessionId => _$this._userSessionId;
  set userSessionId(String? userSessionId) =>
      _$this._userSessionId = userSessionId;

  CallParticipantResponseBuilder() {
    CallParticipantResponse._defaults(this);
  }

  CallParticipantResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _joinedAt = $v.joinedAt;
      _role = $v.role;
      _user = $v.user.toBuilder();
      _userSessionId = $v.userSessionId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CallParticipantResponse other) {
    _$v = other as _$CallParticipantResponse;
  }

  @override
  void update(void Function(CallParticipantResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CallParticipantResponse build() => _build();

  _$CallParticipantResponse _build() {
    _$CallParticipantResponse _$result;
    try {
      _$result = _$v ??
          _$CallParticipantResponse._(
            joinedAt: BuiltValueNullFieldError.checkNotNull(
                joinedAt, r'CallParticipantResponse', 'joinedAt'),
            role: BuiltValueNullFieldError.checkNotNull(
                role, r'CallParticipantResponse', 'role'),
            user: user.build(),
            userSessionId: BuiltValueNullFieldError.checkNotNull(
                userSessionId, r'CallParticipantResponse', 'userSessionId'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CallParticipantResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
