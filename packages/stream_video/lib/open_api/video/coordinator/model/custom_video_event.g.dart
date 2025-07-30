// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_video_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomVideoEvent extends CustomVideoEvent {
  @override
  final String callCid;
  @override
  final DateTime createdAt;
  @override
  final BuiltMap<String, JsonObject?> custom;
  @override
  final String type;
  @override
  final UserResponse user;

  factory _$CustomVideoEvent(
          [void Function(CustomVideoEventBuilder)? updates]) =>
      (CustomVideoEventBuilder()..update(updates))._build();

  _$CustomVideoEvent._(
      {required this.callCid,
      required this.createdAt,
      required this.custom,
      required this.type,
      required this.user})
      : super._();
  @override
  CustomVideoEvent rebuild(void Function(CustomVideoEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CustomVideoEventBuilder toBuilder() =>
      CustomVideoEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomVideoEvent &&
        callCid == other.callCid &&
        createdAt == other.createdAt &&
        custom == other.custom &&
        type == other.type &&
        user == other.user;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, callCid.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, custom.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomVideoEvent')
          ..add('callCid', callCid)
          ..add('createdAt', createdAt)
          ..add('custom', custom)
          ..add('type', type)
          ..add('user', user))
        .toString();
  }
}

class CustomVideoEventBuilder
    implements Builder<CustomVideoEvent, CustomVideoEventBuilder> {
  _$CustomVideoEvent? _$v;

  String? _callCid;
  String? get callCid => _$this._callCid;
  set callCid(String? callCid) => _$this._callCid = callCid;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  MapBuilder<String, JsonObject?>? _custom;
  MapBuilder<String, JsonObject?> get custom =>
      _$this._custom ??= MapBuilder<String, JsonObject?>();
  set custom(MapBuilder<String, JsonObject?>? custom) =>
      _$this._custom = custom;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  UserResponseBuilder? _user;
  UserResponseBuilder get user => _$this._user ??= UserResponseBuilder();
  set user(UserResponseBuilder? user) => _$this._user = user;

  CustomVideoEventBuilder() {
    CustomVideoEvent._defaults(this);
  }

  CustomVideoEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _callCid = $v.callCid;
      _createdAt = $v.createdAt;
      _custom = $v.custom.toBuilder();
      _type = $v.type;
      _user = $v.user.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomVideoEvent other) {
    _$v = other as _$CustomVideoEvent;
  }

  @override
  void update(void Function(CustomVideoEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomVideoEvent build() => _build();

  _$CustomVideoEvent _build() {
    _$CustomVideoEvent _$result;
    try {
      _$result = _$v ??
          _$CustomVideoEvent._(
            callCid: BuiltValueNullFieldError.checkNotNull(
                callCid, r'CustomVideoEvent', 'callCid'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'CustomVideoEvent', 'createdAt'),
            custom: custom.build(),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'CustomVideoEvent', 'type'),
            user: user.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'custom';
        custom.build();

        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CustomVideoEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
