// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserRequest extends UserRequest {
  @override
  final BuiltMap<String, JsonObject?>? custom;
  @override
  final String id;
  @override
  final String? image;
  @override
  final bool? invisible;
  @override
  final String? language;
  @override
  final String? name;
  @override
  final JsonObject? privacySettings;

  factory _$UserRequest([void Function(UserRequestBuilder)? updates]) =>
      (UserRequestBuilder()..update(updates))._build();

  _$UserRequest._(
      {this.custom,
      required this.id,
      this.image,
      this.invisible,
      this.language,
      this.name,
      this.privacySettings})
      : super._();
  @override
  UserRequest rebuild(void Function(UserRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserRequestBuilder toBuilder() => UserRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserRequest &&
        custom == other.custom &&
        id == other.id &&
        image == other.image &&
        invisible == other.invisible &&
        language == other.language &&
        name == other.name &&
        privacySettings == other.privacySettings;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, custom.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jc(_$hash, invisible.hashCode);
    _$hash = $jc(_$hash, language.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, privacySettings.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserRequest')
          ..add('custom', custom)
          ..add('id', id)
          ..add('image', image)
          ..add('invisible', invisible)
          ..add('language', language)
          ..add('name', name)
          ..add('privacySettings', privacySettings))
        .toString();
  }
}

class UserRequestBuilder implements Builder<UserRequest, UserRequestBuilder> {
  _$UserRequest? _$v;

  MapBuilder<String, JsonObject?>? _custom;
  MapBuilder<String, JsonObject?> get custom =>
      _$this._custom ??= MapBuilder<String, JsonObject?>();
  set custom(MapBuilder<String, JsonObject?>? custom) =>
      _$this._custom = custom;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  bool? _invisible;
  bool? get invisible => _$this._invisible;
  set invisible(bool? invisible) => _$this._invisible = invisible;

  String? _language;
  String? get language => _$this._language;
  set language(String? language) => _$this._language = language;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  JsonObject? _privacySettings;
  JsonObject? get privacySettings => _$this._privacySettings;
  set privacySettings(JsonObject? privacySettings) =>
      _$this._privacySettings = privacySettings;

  UserRequestBuilder() {
    UserRequest._defaults(this);
  }

  UserRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _custom = $v.custom?.toBuilder();
      _id = $v.id;
      _image = $v.image;
      _invisible = $v.invisible;
      _language = $v.language;
      _name = $v.name;
      _privacySettings = $v.privacySettings;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserRequest other) {
    _$v = other as _$UserRequest;
  }

  @override
  void update(void Function(UserRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserRequest build() => _build();

  _$UserRequest _build() {
    _$UserRequest _$result;
    try {
      _$result = _$v ??
          _$UserRequest._(
            custom: _custom?.build(),
            id: BuiltValueNullFieldError.checkNotNull(id, r'UserRequest', 'id'),
            image: image,
            invisible: invisible,
            language: language,
            name: name,
            privacySettings: privacySettings,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'custom';
        _custom?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UserRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
