// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_device_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreateDeviceRequestPushProviderEnum
    _$createDeviceRequestPushProviderEnum_firebase =
    const CreateDeviceRequestPushProviderEnum._('firebase');
const CreateDeviceRequestPushProviderEnum
    _$createDeviceRequestPushProviderEnum_apn =
    const CreateDeviceRequestPushProviderEnum._('apn');
const CreateDeviceRequestPushProviderEnum
    _$createDeviceRequestPushProviderEnum_huawei =
    const CreateDeviceRequestPushProviderEnum._('huawei');
const CreateDeviceRequestPushProviderEnum
    _$createDeviceRequestPushProviderEnum_xiaomi =
    const CreateDeviceRequestPushProviderEnum._('xiaomi');

CreateDeviceRequestPushProviderEnum
    _$createDeviceRequestPushProviderEnumValueOf(String name) {
  switch (name) {
    case 'firebase':
      return _$createDeviceRequestPushProviderEnum_firebase;
    case 'apn':
      return _$createDeviceRequestPushProviderEnum_apn;
    case 'huawei':
      return _$createDeviceRequestPushProviderEnum_huawei;
    case 'xiaomi':
      return _$createDeviceRequestPushProviderEnum_xiaomi;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CreateDeviceRequestPushProviderEnum>
    _$createDeviceRequestPushProviderEnumValues = BuiltSet<
        CreateDeviceRequestPushProviderEnum>(const <CreateDeviceRequestPushProviderEnum>[
  _$createDeviceRequestPushProviderEnum_firebase,
  _$createDeviceRequestPushProviderEnum_apn,
  _$createDeviceRequestPushProviderEnum_huawei,
  _$createDeviceRequestPushProviderEnum_xiaomi,
]);

Serializer<CreateDeviceRequestPushProviderEnum>
    _$createDeviceRequestPushProviderEnumSerializer =
    _$CreateDeviceRequestPushProviderEnumSerializer();

class _$CreateDeviceRequestPushProviderEnumSerializer
    implements PrimitiveSerializer<CreateDeviceRequestPushProviderEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'firebase': 'firebase',
    'apn': 'apn',
    'huawei': 'huawei',
    'xiaomi': 'xiaomi',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'firebase': 'firebase',
    'apn': 'apn',
    'huawei': 'huawei',
    'xiaomi': 'xiaomi',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CreateDeviceRequestPushProviderEnum
  ];
  @override
  final String wireName = 'CreateDeviceRequestPushProviderEnum';

  @override
  Object serialize(
          Serializers serializers, CreateDeviceRequestPushProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateDeviceRequestPushProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateDeviceRequestPushProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateDeviceRequest extends CreateDeviceRequest {
  @override
  final String id;
  @override
  final CreateDeviceRequestPushProviderEnum pushProvider;
  @override
  final String? pushProviderName;
  @override
  final bool? voipToken;

  factory _$CreateDeviceRequest(
          [void Function(CreateDeviceRequestBuilder)? updates]) =>
      (CreateDeviceRequestBuilder()..update(updates))._build();

  _$CreateDeviceRequest._(
      {required this.id,
      required this.pushProvider,
      this.pushProviderName,
      this.voipToken})
      : super._();
  @override
  CreateDeviceRequest rebuild(
          void Function(CreateDeviceRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateDeviceRequestBuilder toBuilder() =>
      CreateDeviceRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateDeviceRequest &&
        id == other.id &&
        pushProvider == other.pushProvider &&
        pushProviderName == other.pushProviderName &&
        voipToken == other.voipToken;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, pushProvider.hashCode);
    _$hash = $jc(_$hash, pushProviderName.hashCode);
    _$hash = $jc(_$hash, voipToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateDeviceRequest')
          ..add('id', id)
          ..add('pushProvider', pushProvider)
          ..add('pushProviderName', pushProviderName)
          ..add('voipToken', voipToken))
        .toString();
  }
}

class CreateDeviceRequestBuilder
    implements Builder<CreateDeviceRequest, CreateDeviceRequestBuilder> {
  _$CreateDeviceRequest? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  CreateDeviceRequestPushProviderEnum? _pushProvider;
  CreateDeviceRequestPushProviderEnum? get pushProvider => _$this._pushProvider;
  set pushProvider(CreateDeviceRequestPushProviderEnum? pushProvider) =>
      _$this._pushProvider = pushProvider;

  String? _pushProviderName;
  String? get pushProviderName => _$this._pushProviderName;
  set pushProviderName(String? pushProviderName) =>
      _$this._pushProviderName = pushProviderName;

  bool? _voipToken;
  bool? get voipToken => _$this._voipToken;
  set voipToken(bool? voipToken) => _$this._voipToken = voipToken;

  CreateDeviceRequestBuilder() {
    CreateDeviceRequest._defaults(this);
  }

  CreateDeviceRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _pushProvider = $v.pushProvider;
      _pushProviderName = $v.pushProviderName;
      _voipToken = $v.voipToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateDeviceRequest other) {
    _$v = other as _$CreateDeviceRequest;
  }

  @override
  void update(void Function(CreateDeviceRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateDeviceRequest build() => _build();

  _$CreateDeviceRequest _build() {
    final _$result = _$v ??
        _$CreateDeviceRequest._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'CreateDeviceRequest', 'id'),
          pushProvider: BuiltValueNullFieldError.checkNotNull(
              pushProvider, r'CreateDeviceRequest', 'pushProvider'),
          pushProviderName: pushProviderName,
          voipToken: voipToken,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
