// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_user_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BlockedUserEvent extends BlockedUserEvent {
  @override
  final UserResponse? blockedByUser;
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final String type;
  @override
  final UserResponse user;

  factory _$BlockedUserEvent(
          [void Function(BlockedUserEventBuilder)? updates]) =>
      (BlockedUserEventBuilder()..update(updates))._build();

  _$BlockedUserEvent._(
      {this.blockedByUser,
      required this.callCid,
      required this.createdAt,
      required this.type,
      required this.user})
      : super._();
  @override
  BlockedUserEvent rebuild(void Function(BlockedUserEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BlockedUserEventBuilder toBuilder() =>
      BlockedUserEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BlockedUserEvent &&
        blockedByUser == other.blockedByUser &&
        callCid == other.callCid &&
        createdAt == other.createdAt &&
        type == other.type &&
        user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, blockedByUser.hashCode);
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BlockedUserEvent')
          ..add('blockedByUser', blockedByUser)
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('type', type)
          ..add('user', user))
        .toString();
  }
}

class BlockedUserEventBuilder
    implements Builder<BlockedUserEvent, BlockedUserEventBuilder> {
  _$BlockedUserEvent? _$v;

  UserResponseBuilder? _blockedByUser;
  UserResponseBuilder get blockedByUser =>
      _$this._blockedByUser ??= UserResponseBuilder();
  set blockedByUser(UserResponseBuilder? blockedByUser) =>
      _$this._blockedByUser = blockedByUser;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  UserResponseBuilder? _user;
  UserResponseBuilder get user => _$this._user ??= UserResponseBuilder();
  set user(UserResponseBuilder? user) => _$this._user = user;

  BlockedUserEventBuilder() {
    BlockedUserEvent._defaults(this);
  }

  BlockedUserEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _blockedByUser = $v.blockedByUser?.toBuilder();
      _callCid = $v.callCid;
      _createdAt = $v.createdAt;
      _type = $v.type;
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BlockedUserEvent other) {
    _$v = other as _$BlockedUserEvent;
  }

  @override
  void update(void Function(BlockedUserEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BlockedUserEvent build() => _build();

  _$BlockedUserEvent _build() {
    _$BlockedUserEvent _$result;
    try {
      _$result = _$v ??
          _$BlockedUserEvent._(
            blockedByUser: _blockedByUser?.build(),
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'BlockedUserEvent', 'callCid'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'BlockedUserEvent', 'createdAt'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'BlockedUserEvent', 'type'),
            user: user.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'blockedByUser';
        _blockedByUser?.build();

        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BlockedUserEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
