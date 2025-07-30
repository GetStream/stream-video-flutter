// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rtmp_settings_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RTMPSettingsRequestQualityEnum _$rTMPSettingsRequestQualityEnum_n360p =
    const RTMPSettingsRequestQualityEnum._('n360p');
const RTMPSettingsRequestQualityEnum _$rTMPSettingsRequestQualityEnum_n480p =
    const RTMPSettingsRequestQualityEnum._('n480p');
const RTMPSettingsRequestQualityEnum _$rTMPSettingsRequestQualityEnum_n720p =
    const RTMPSettingsRequestQualityEnum._('n720p');
const RTMPSettingsRequestQualityEnum _$rTMPSettingsRequestQualityEnum_n1080p =
    const RTMPSettingsRequestQualityEnum._('n1080p');
const RTMPSettingsRequestQualityEnum _$rTMPSettingsRequestQualityEnum_n1440p =
    const RTMPSettingsRequestQualityEnum._('n1440p');
const RTMPSettingsRequestQualityEnum
    _$rTMPSettingsRequestQualityEnum_portrait360x640 =
    const RTMPSettingsRequestQualityEnum._('portrait360x640');
const RTMPSettingsRequestQualityEnum
    _$rTMPSettingsRequestQualityEnum_portrait480x854 =
    const RTMPSettingsRequestQualityEnum._('portrait480x854');
const RTMPSettingsRequestQualityEnum
    _$rTMPSettingsRequestQualityEnum_portrait720x1280 =
    const RTMPSettingsRequestQualityEnum._('portrait720x1280');
const RTMPSettingsRequestQualityEnum
    _$rTMPSettingsRequestQualityEnum_portrait1080x1920 =
    const RTMPSettingsRequestQualityEnum._('portrait1080x1920');
const RTMPSettingsRequestQualityEnum
    _$rTMPSettingsRequestQualityEnum_portrait1440x2560 =
    const RTMPSettingsRequestQualityEnum._('portrait1440x2560');

RTMPSettingsRequestQualityEnum _$rTMPSettingsRequestQualityEnumValueOf(
    String name) {
  switch (name) {
    case 'n360p':
      return _$rTMPSettingsRequestQualityEnum_n360p;
    case 'n480p':
      return _$rTMPSettingsRequestQualityEnum_n480p;
    case 'n720p':
      return _$rTMPSettingsRequestQualityEnum_n720p;
    case 'n1080p':
      return _$rTMPSettingsRequestQualityEnum_n1080p;
    case 'n1440p':
      return _$rTMPSettingsRequestQualityEnum_n1440p;
    case 'portrait360x640':
      return _$rTMPSettingsRequestQualityEnum_portrait360x640;
    case 'portrait480x854':
      return _$rTMPSettingsRequestQualityEnum_portrait480x854;
    case 'portrait720x1280':
      return _$rTMPSettingsRequestQualityEnum_portrait720x1280;
    case 'portrait1080x1920':
      return _$rTMPSettingsRequestQualityEnum_portrait1080x1920;
    case 'portrait1440x2560':
      return _$rTMPSettingsRequestQualityEnum_portrait1440x2560;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RTMPSettingsRequestQualityEnum>
    _$rTMPSettingsRequestQualityEnumValues = BuiltSet<
        RTMPSettingsRequestQualityEnum>(const <RTMPSettingsRequestQualityEnum>[
  _$rTMPSettingsRequestQualityEnum_n360p,
  _$rTMPSettingsRequestQualityEnum_n480p,
  _$rTMPSettingsRequestQualityEnum_n720p,
  _$rTMPSettingsRequestQualityEnum_n1080p,
  _$rTMPSettingsRequestQualityEnum_n1440p,
  _$rTMPSettingsRequestQualityEnum_portrait360x640,
  _$rTMPSettingsRequestQualityEnum_portrait480x854,
  _$rTMPSettingsRequestQualityEnum_portrait720x1280,
  _$rTMPSettingsRequestQualityEnum_portrait1080x1920,
  _$rTMPSettingsRequestQualityEnum_portrait1440x2560,
]);

Serializer<RTMPSettingsRequestQualityEnum>
    _$rTMPSettingsRequestQualityEnumSerializer =
    _$RTMPSettingsRequestQualityEnumSerializer();

class _$RTMPSettingsRequestQualityEnumSerializer
    implements PrimitiveSerializer<RTMPSettingsRequestQualityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'n360p': '360p',
    'n480p': '480p',
    'n720p': '720p',
    'n1080p': '1080p',
    'n1440p': '1440p',
    'portrait360x640': 'portrait-360x640',
    'portrait480x854': 'portrait-480x854',
    'portrait720x1280': 'portrait-720x1280',
    'portrait1080x1920': 'portrait-1080x1920',
    'portrait1440x2560': 'portrait-1440x2560',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    '360p': 'n360p',
    '480p': 'n480p',
    '720p': 'n720p',
    '1080p': 'n1080p',
    '1440p': 'n1440p',
    'portrait-360x640': 'portrait360x640',
    'portrait-480x854': 'portrait480x854',
    'portrait-720x1280': 'portrait720x1280',
    'portrait-1080x1920': 'portrait1080x1920',
    'portrait-1440x2560': 'portrait1440x2560',
  };

  @override
  final Iterable<Type> types = const <Type>[RTMPSettingsRequestQualityEnum];
  @override
  final String wireName = 'RTMPSettingsRequestQualityEnum';

  @override
  Object serialize(
          Serializers serializers, RTMPSettingsRequestQualityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RTMPSettingsRequestQualityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RTMPSettingsRequestQualityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RTMPSettingsRequest extends RTMPSettingsRequest {
  @override
  final bool? enabled;
  @override
  final RTMPSettingsRequestQualityEnum? quality;

  factory _$RTMPSettingsRequest(
          [void Function(RTMPSettingsRequestBuilder)? updates]) =>
      (RTMPSettingsRequestBuilder()..update(updates))._build();

  _$RTMPSettingsRequest._({this.enabled, this.quality}) : super._();
  @override
  RTMPSettingsRequest rebuild(
          void Function(RTMPSettingsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RTMPSettingsRequestBuilder toBuilder() =>
      RTMPSettingsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RTMPSettingsRequest &&
        enabled == other.enabled &&
        quality == other.quality;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, quality.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RTMPSettingsRequest')
          ..add('enabled', enabled)
          ..add('quality', quality))
        .toString();
  }
}

class RTMPSettingsRequestBuilder
    implements Builder<RTMPSettingsRequest, RTMPSettingsRequestBuilder> {
  _$RTMPSettingsRequest? _$v;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  RTMPSettingsRequestQualityEnum? _quality;
  RTMPSettingsRequestQualityEnum? get quality => _$this._quality;
  set quality(RTMPSettingsRequestQualityEnum? quality) =>
      _$this._quality = quality;

  RTMPSettingsRequestBuilder() {
    RTMPSettingsRequest._defaults(this);
  }

  RTMPSettingsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enabled = $v.enabled;
      _quality = $v.quality;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RTMPSettingsRequest other) {
    _$v = other as _$RTMPSettingsRequest;
  }

  @override
  void update(void Function(RTMPSettingsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RTMPSettingsRequest build() => _build();

  _$RTMPSettingsRequest _build() {
    final _$result = _$v ??
        _$RTMPSettingsRequest._(
          enabled: enabled,
          quality: quality,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
