// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_preferences.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PushPreferences extends PushPreferences {
  @override
  final String? callLevel;
  @override
  final String? chatLevel;
  @override
  final DateTime? disabledUntil;

  factory _$PushPreferences([void Function(PushPreferencesBuilder)? updates]) =>
      (PushPreferencesBuilder()..update(updates))._build();

  _$PushPreferences._({this.callLevel, this.chatLevel, this.disabledUntil})
      : super._();
  @override
  PushPreferences rebuild(void Function(PushPreferencesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PushPreferencesBuilder toBuilder() => PushPreferencesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PushPreferences &&
        callLevel == other.callLevel &&
        chatLevel == other.chatLevel &&
        disabledUntil == other.disabledUntil;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, callLevel.hashCode);
    _$hash = $jc(_$hash, chatLevel.hashCode);
    _$hash = $jc(_$hash, disabledUntil.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PushPreferences')
          ..add('callLevel', callLevel)
          ..add('chatLevel', chatLevel)
          ..add('disabledUntil', disabledUntil))
        .toString();
  }
}

class PushPreferencesBuilder
    implements Builder<PushPreferences, PushPreferencesBuilder> {
  _$PushPreferences? _$v;

  String? _callLevel;
  String? get callLevel => _$this._callLevel;
  set callLevel(String? callLevel) => _$this._callLevel = callLevel;

  String? _chatLevel;
  String? get chatLevel => _$this._chatLevel;
  set chatLevel(String? chatLevel) => _$this._chatLevel = chatLevel;

  DateTime? _disabledUntil;
  DateTime? get disabledUntil => _$this._disabledUntil;
  set disabledUntil(DateTime? disabledUntil) =>
      _$this._disabledUntil = disabledUntil;

  PushPreferencesBuilder() {
    PushPreferences._defaults(this);
  }

  PushPreferencesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _callLevel = $v.callLevel;
      _chatLevel = $v.chatLevel;
      _disabledUntil = $v.disabledUntil;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PushPreferences other) {
    _$v = other as _$PushPreferences;
  }

  @override
  void update(void Function(PushPreferencesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PushPreferences build() => _build();

  _$PushPreferences _build() {
    final _$result = _$v ??
        _$PushPreferences._(
          callLevel: callLevel,
          chatLevel: chatLevel,
          disabledUntil: disabledUntil,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
