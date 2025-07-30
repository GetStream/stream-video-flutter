// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rtmp_broadcast_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RTMPBroadcastRequestQualityEnum _$rTMPBroadcastRequestQualityEnum_n360p =
    const RTMPBroadcastRequestQualityEnum._('n360p');
const RTMPBroadcastRequestQualityEnum _$rTMPBroadcastRequestQualityEnum_n480p =
    const RTMPBroadcastRequestQualityEnum._('n480p');
const RTMPBroadcastRequestQualityEnum _$rTMPBroadcastRequestQualityEnum_n720p =
    const RTMPBroadcastRequestQualityEnum._('n720p');
const RTMPBroadcastRequestQualityEnum _$rTMPBroadcastRequestQualityEnum_n1080p =
    const RTMPBroadcastRequestQualityEnum._('n1080p');
const RTMPBroadcastRequestQualityEnum _$rTMPBroadcastRequestQualityEnum_n1440p =
    const RTMPBroadcastRequestQualityEnum._('n1440p');
const RTMPBroadcastRequestQualityEnum
    _$rTMPBroadcastRequestQualityEnum_portrait360x640 =
    const RTMPBroadcastRequestQualityEnum._('portrait360x640');
const RTMPBroadcastRequestQualityEnum
    _$rTMPBroadcastRequestQualityEnum_portrait480x854 =
    const RTMPBroadcastRequestQualityEnum._('portrait480x854');
const RTMPBroadcastRequestQualityEnum
    _$rTMPBroadcastRequestQualityEnum_portrait720x1280 =
    const RTMPBroadcastRequestQualityEnum._('portrait720x1280');
const RTMPBroadcastRequestQualityEnum
    _$rTMPBroadcastRequestQualityEnum_portrait1080x1920 =
    const RTMPBroadcastRequestQualityEnum._('portrait1080x1920');
const RTMPBroadcastRequestQualityEnum
    _$rTMPBroadcastRequestQualityEnum_portrait1440x2560 =
    const RTMPBroadcastRequestQualityEnum._('portrait1440x2560');

RTMPBroadcastRequestQualityEnum _$rTMPBroadcastRequestQualityEnumValueOf(
    String name) {
  switch (name) {
    case 'n360p':
      return _$rTMPBroadcastRequestQualityEnum_n360p;
    case 'n480p':
      return _$rTMPBroadcastRequestQualityEnum_n480p;
    case 'n720p':
      return _$rTMPBroadcastRequestQualityEnum_n720p;
    case 'n1080p':
      return _$rTMPBroadcastRequestQualityEnum_n1080p;
    case 'n1440p':
      return _$rTMPBroadcastRequestQualityEnum_n1440p;
    case 'portrait360x640':
      return _$rTMPBroadcastRequestQualityEnum_portrait360x640;
    case 'portrait480x854':
      return _$rTMPBroadcastRequestQualityEnum_portrait480x854;
    case 'portrait720x1280':
      return _$rTMPBroadcastRequestQualityEnum_portrait720x1280;
    case 'portrait1080x1920':
      return _$rTMPBroadcastRequestQualityEnum_portrait1080x1920;
    case 'portrait1440x2560':
      return _$rTMPBroadcastRequestQualityEnum_portrait1440x2560;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RTMPBroadcastRequestQualityEnum>
    _$rTMPBroadcastRequestQualityEnumValues = BuiltSet<
        RTMPBroadcastRequestQualityEnum>(const <RTMPBroadcastRequestQualityEnum>[
  _$rTMPBroadcastRequestQualityEnum_n360p,
  _$rTMPBroadcastRequestQualityEnum_n480p,
  _$rTMPBroadcastRequestQualityEnum_n720p,
  _$rTMPBroadcastRequestQualityEnum_n1080p,
  _$rTMPBroadcastRequestQualityEnum_n1440p,
  _$rTMPBroadcastRequestQualityEnum_portrait360x640,
  _$rTMPBroadcastRequestQualityEnum_portrait480x854,
  _$rTMPBroadcastRequestQualityEnum_portrait720x1280,
  _$rTMPBroadcastRequestQualityEnum_portrait1080x1920,
  _$rTMPBroadcastRequestQualityEnum_portrait1440x2560,
]);

Serializer<RTMPBroadcastRequestQualityEnum>
    _$rTMPBroadcastRequestQualityEnumSerializer =
    _$RTMPBroadcastRequestQualityEnumSerializer();

class _$RTMPBroadcastRequestQualityEnumSerializer
    implements PrimitiveSerializer<RTMPBroadcastRequestQualityEnum> {
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
  final Iterable<Type> types = const <Type>[RTMPBroadcastRequestQualityEnum];
  @override
  final String wireName = 'RTMPBroadcastRequestQualityEnum';

  @override
  Object serialize(
          Serializers serializers, RTMPBroadcastRequestQualityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RTMPBroadcastRequestQualityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RTMPBroadcastRequestQualityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RTMPBroadcastRequest extends RTMPBroadcastRequest {
  @override
  final LayoutSettingsRequest? layout;
  @override
  final String name;
  @override
  final RTMPBroadcastRequestQualityEnum? quality;
  @override
  final String? streamKey;
  @override
  final String streamUrl;

  factory _$RTMPBroadcastRequest(
          [void Function(RTMPBroadcastRequestBuilder)? updates]) =>
      (RTMPBroadcastRequestBuilder()..update(updates))._build();

  _$RTMPBroadcastRequest._(
      {this.layout,
      required this.name,
      this.quality,
      this.streamKey,
      required this.streamUrl})
      : super._();
  @override
  RTMPBroadcastRequest rebuild(
          void Function(RTMPBroadcastRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RTMPBroadcastRequestBuilder toBuilder() =>
      RTMPBroadcastRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RTMPBroadcastRequest &&
        layout == other.layout &&
        name == other.name &&
        quality == other.quality &&
        streamKey == other.streamKey &&
        streamUrl == other.streamUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, layout.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, quality.hashCode);
    _$hash = $jc(_$hash, streamKey.hashCode);
    _$hash = $jc(_$hash, streamUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RTMPBroadcastRequest')
          ..add('layout', layout)
          ..add('name', name)
          ..add('quality', quality)
          ..add('streamKey', streamKey)
          ..add('streamUrl', streamUrl))
        .toString();
  }
}

class RTMPBroadcastRequestBuilder
    implements Builder<RTMPBroadcastRequest, RTMPBroadcastRequestBuilder> {
  _$RTMPBroadcastRequest? _$v;

  LayoutSettingsRequestBuilder? _layout;
  LayoutSettingsRequestBuilder get layout =>
      _$this._layout ??= LayoutSettingsRequestBuilder();
  set layout(LayoutSettingsRequestBuilder? layout) => _$this._layout = layout;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  RTMPBroadcastRequestQualityEnum? _quality;
  RTMPBroadcastRequestQualityEnum? get quality => _$this._quality;
  set quality(RTMPBroadcastRequestQualityEnum? quality) =>
      _$this._quality = quality;

  String? _streamKey;
  String? get streamKey => _$this._streamKey;
  set streamKey(String? streamKey) => _$this._streamKey = streamKey;

  String? _streamUrl;
  String? get streamUrl => _$this._streamUrl;
  set streamUrl(String? streamUrl) => _$this._streamUrl = streamUrl;

  RTMPBroadcastRequestBuilder() {
    RTMPBroadcastRequest._defaults(this);
  }

  RTMPBroadcastRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _layout = $v.layout?.toBuilder();
      _name = $v.name;
      _quality = $v.quality;
      _streamKey = $v.streamKey;
      _streamUrl = $v.streamUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RTMPBroadcastRequest other) {
    _$v = other as _$RTMPBroadcastRequest;
  }

  @override
  void update(void Function(RTMPBroadcastRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RTMPBroadcastRequest build() => _build();

  _$RTMPBroadcastRequest _build() {
    _$RTMPBroadcastRequest _$result;
    try {
      _$result = _$v ??
          _$RTMPBroadcastRequest._(
            layout: _layout?.build(),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'RTMPBroadcastRequest', 'name'),
            quality: quality,
            streamKey: streamKey,
            streamUrl: BuiltValueNullFieldError.checkNotNull(
                streamUrl, r'RTMPBroadcastRequest', 'streamUrl'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'layout';
        _layout?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RTMPBroadcastRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
