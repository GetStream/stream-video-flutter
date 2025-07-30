// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layout_settings_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const LayoutSettingsRequestNameEnum _$layoutSettingsRequestNameEnum_spotlight =
    const LayoutSettingsRequestNameEnum._('spotlight');
const LayoutSettingsRequestNameEnum _$layoutSettingsRequestNameEnum_grid =
    const LayoutSettingsRequestNameEnum._('grid');
const LayoutSettingsRequestNameEnum
    _$layoutSettingsRequestNameEnum_singleParticipant =
    const LayoutSettingsRequestNameEnum._('singleParticipant');
const LayoutSettingsRequestNameEnum _$layoutSettingsRequestNameEnum_mobile =
    const LayoutSettingsRequestNameEnum._('mobile');
const LayoutSettingsRequestNameEnum _$layoutSettingsRequestNameEnum_custom =
    const LayoutSettingsRequestNameEnum._('custom');

LayoutSettingsRequestNameEnum _$layoutSettingsRequestNameEnumValueOf(
    String name) {
  switch (name) {
    case 'spotlight':
      return _$layoutSettingsRequestNameEnum_spotlight;
    case 'grid':
      return _$layoutSettingsRequestNameEnum_grid;
    case 'singleParticipant':
      return _$layoutSettingsRequestNameEnum_singleParticipant;
    case 'mobile':
      return _$layoutSettingsRequestNameEnum_mobile;
    case 'custom':
      return _$layoutSettingsRequestNameEnum_custom;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<LayoutSettingsRequestNameEnum>
    _$layoutSettingsRequestNameEnumValues = BuiltSet<
        LayoutSettingsRequestNameEnum>(const <LayoutSettingsRequestNameEnum>[
  _$layoutSettingsRequestNameEnum_spotlight,
  _$layoutSettingsRequestNameEnum_grid,
  _$layoutSettingsRequestNameEnum_singleParticipant,
  _$layoutSettingsRequestNameEnum_mobile,
  _$layoutSettingsRequestNameEnum_custom,
]);

Serializer<LayoutSettingsRequestNameEnum>
    _$layoutSettingsRequestNameEnumSerializer =
    _$LayoutSettingsRequestNameEnumSerializer();

class _$LayoutSettingsRequestNameEnumSerializer
    implements PrimitiveSerializer<LayoutSettingsRequestNameEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'spotlight': 'spotlight',
    'grid': 'grid',
    'singleParticipant': 'single-participant',
    'mobile': 'mobile',
    'custom': 'custom',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'spotlight': 'spotlight',
    'grid': 'grid',
    'single-participant': 'singleParticipant',
    'mobile': 'mobile',
    'custom': 'custom',
  };

  @override
  final Iterable<Type> types = const <Type>[LayoutSettingsRequestNameEnum];
  @override
  final String wireName = 'LayoutSettingsRequestNameEnum';

  @override
  Object serialize(
          Serializers serializers, LayoutSettingsRequestNameEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  LayoutSettingsRequestNameEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      LayoutSettingsRequestNameEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$LayoutSettingsRequest extends LayoutSettingsRequest {
  @override
  final bool? detectOrientation;
  @override
  final String? externalAppUrl;
  @override
  final String? externalCssUrl;
  @override
  final LayoutSettingsRequestNameEnum name;
  @override
  final BuiltMap<String, JsonObject?>? options;

  factory _$LayoutSettingsRequest(
          [void Function(LayoutSettingsRequestBuilder)? updates]) =>
      (LayoutSettingsRequestBuilder()..update(updates))._build();

  _$LayoutSettingsRequest._(
      {this.detectOrientation,
      this.externalAppUrl,
      this.externalCssUrl,
      required this.name,
      this.options})
      : super._();
  @override
  LayoutSettingsRequest rebuild(
          void Function(LayoutSettingsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LayoutSettingsRequestBuilder toBuilder() =>
      LayoutSettingsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LayoutSettingsRequest &&
        detectOrientation == other.detectOrientation &&
        externalAppUrl == other.externalAppUrl &&
        externalCssUrl == other.externalCssUrl &&
        name == other.name &&
        options == other.options;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, detectOrientation.hashCode);
    _$hash = $jc(_$hash, externalAppUrl.hashCode);
    _$hash = $jc(_$hash, externalCssUrl.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, options.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LayoutSettingsRequest')
          ..add('detectOrientation', detectOrientation)
          ..add('externalAppUrl', externalAppUrl)
          ..add('externalCssUrl', externalCssUrl)
          ..add('name', name)
          ..add('options', options))
        .toString();
  }
}

class LayoutSettingsRequestBuilder
    implements Builder<LayoutSettingsRequest, LayoutSettingsRequestBuilder> {
  _$LayoutSettingsRequest? _$v;

  bool? _detectOrientation;
  bool? get detectOrientation => _$this._detectOrientation;
  set detectOrientation(bool? detectOrientation) =>
      _$this._detectOrientation = detectOrientation;

  String? _externalAppUrl;
  String? get externalAppUrl => _$this._externalAppUrl;
  set externalAppUrl(String? externalAppUrl) =>
      _$this._externalAppUrl = externalAppUrl;

  String? _externalCssUrl;
  String? get externalCssUrl => _$this._externalCssUrl;
  set externalCssUrl(String? externalCssUrl) =>
      _$this._externalCssUrl = externalCssUrl;

  LayoutSettingsRequestNameEnum? _name;
  LayoutSettingsRequestNameEnum? get name => _$this._name;
  set name(LayoutSettingsRequestNameEnum? name) => _$this._name = name;

  MapBuilder<String, JsonObject?>? _options;
  MapBuilder<String, JsonObject?> get options =>
      _$this._options ??= MapBuilder<String, JsonObject?>();
  set options(MapBuilder<String, JsonObject?>? options) =>
      _$this._options = options;

  LayoutSettingsRequestBuilder() {
    LayoutSettingsRequest._defaults(this);
  }

  LayoutSettingsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _detectOrientation = $v.detectOrientation;
      _externalAppUrl = $v.externalAppUrl;
      _externalCssUrl = $v.externalCssUrl;
      _name = $v.name;
      _options = $v.options?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LayoutSettingsRequest other) {
    _$v = other as _$LayoutSettingsRequest;
  }

  @override
  void update(void Function(LayoutSettingsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LayoutSettingsRequest build() => _build();

  _$LayoutSettingsRequest _build() {
    _$LayoutSettingsRequest _$result;
    try {
      _$result = _$v ??
          _$LayoutSettingsRequest._(
            detectOrientation: detectOrientation,
            externalAppUrl: externalAppUrl,
            externalCssUrl: externalCssUrl,
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'LayoutSettingsRequest', 'name'),
            options: _options?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'options';
        _options?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'LayoutSettingsRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
