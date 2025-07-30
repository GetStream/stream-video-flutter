// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unblocked_user_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UnblockedUserEvent extends UnblockedUserEvent {
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final String type;
  @override
  final UserResponse user;

  factory _$UnblockedUserEvent(
          [void Function(UnblockedUserEventBuilder)? updates]) =>
      (UnblockedUserEventBuilder()..update(updates))._build();

  _$UnblockedUserEvent._(
      {required this.callCid,
      required this.createdAt,
      required this.type,
      required this.user})
      : super._();
  @override
  UnblockedUserEvent rebuild(
          void Function(UnblockedUserEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UnblockedUserEventBuilder toBuilder() =>
      UnblockedUserEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UnblockedUserEvent &&
        callCid == other.callCid &&
        createdAt == other.createdAt &&
        type == other.type &&
        user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UnblockedUserEvent')
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('type', type)
          ..add('user', user))
        .toString();
  }
}

class UnblockedUserEventBuilder
    implements Builder<UnblockedUserEvent, UnblockedUserEventBuilder> {
  _$UnblockedUserEvent? _$v;

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

  UnblockedUserEventBuilder() {
    UnblockedUserEvent._defaults(this);
  }

  UnblockedUserEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _callCid = $v.callCid;
      _createdAt = $v.createdAt;
      _type = $v.type;
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UnblockedUserEvent other) {
    _$v = other as _$UnblockedUserEvent;
  }

  @override
  void update(void Function(UnblockedUserEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UnblockedUserEvent build() => _build();

  _$UnblockedUserEvent _build() {
    _$UnblockedUserEvent _$result;
    try {
      _$result = _$v ??
          _$UnblockedUserEvent._(
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'UnblockedUserEvent', 'callCid'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'UnblockedUserEvent', 'createdAt'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'UnblockedUserEvent', 'type'),
            user: user.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UnblockedUserEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
