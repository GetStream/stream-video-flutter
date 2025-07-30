// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'updated_call_permissions_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdatedCallPermissionsEvent extends UpdatedCallPermissionsEvent {
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final BuiltList<OwnCapability> ownCapabilities;
  @override
  final String type;
  @override
  final UserResponse user;

  factory _$UpdatedCallPermissionsEvent(
          [void Function(UpdatedCallPermissionsEventBuilder)? updates]) =>
      (UpdatedCallPermissionsEventBuilder()..update(updates))._build();

  _$UpdatedCallPermissionsEvent._(
      {required this.callCid,
      required this.createdAt,
      required this.ownCapabilities,
      required this.type,
      required this.user})
      : super._();
  @override
  UpdatedCallPermissionsEvent rebuild(
          void Function(UpdatedCallPermissionsEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdatedCallPermissionsEventBuilder toBuilder() =>
      UpdatedCallPermissionsEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdatedCallPermissionsEvent &&
        callCid == other.callCid &&
        createdAt == other.createdAt &&
        ownCapabilities == other.ownCapabilities &&
        type == other.type &&
        user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, ownCapabilities.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdatedCallPermissionsEvent')
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('ownCapabilities', ownCapabilities)
          ..add('type', type)
          ..add('user', user))
        .toString();
  }
}

class UpdatedCallPermissionsEventBuilder
    implements
        Builder<UpdatedCallPermissionsEvent,
            UpdatedCallPermissionsEventBuilder> {
  _$UpdatedCallPermissionsEvent? _$v;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ListBuilder<OwnCapability>? _ownCapabilities;
  ListBuilder<OwnCapability> get ownCapabilities =>
      _$this._ownCapabilities ??= ListBuilder<OwnCapability>();
  set ownCapabilities(ListBuilder<OwnCapability>? ownCapabilities) =>
      _$this._ownCapabilities = ownCapabilities;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  UserResponseBuilder? _user;
  UserResponseBuilder get user => _$this._user ??= UserResponseBuilder();
  set user(UserResponseBuilder? user) => _$this._user = user;

  UpdatedCallPermissionsEventBuilder() {
    UpdatedCallPermissionsEvent._defaults(this);
  }

  UpdatedCallPermissionsEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _callCid = $v.callCid;
      _createdAt = $v.createdAt;
      _ownCapabilities = $v.ownCapabilities.toBuilder();
      _type = $v.type;
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdatedCallPermissionsEvent other) {
    _$v = other as _$UpdatedCallPermissionsEvent;
  }

  @override
  void update(void Function(UpdatedCallPermissionsEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdatedCallPermissionsEvent build() => _build();

  _$UpdatedCallPermissionsEvent _build() {
    _$UpdatedCallPermissionsEvent _$result;
    try {
      _$result = _$v ??
          _$UpdatedCallPermissionsEvent._(
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'UpdatedCallPermissionsEvent', 'callCid'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'UpdatedCallPermissionsEvent', 'createdAt'),
            ownCapabilities: ownCapabilities.build(),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'UpdatedCallPermissionsEvent', 'type'),
            user: user.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ownCapabilities';
        ownCapabilities.build();

        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UpdatedCallPermissionsEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
