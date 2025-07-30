// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_settings_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RecordSettingsRequestModeEnum _$recordSettingsRequestModeEnum_available =
    const RecordSettingsRequestModeEnum._('available');
const RecordSettingsRequestModeEnum _$recordSettingsRequestModeEnum_disabled =
    const RecordSettingsRequestModeEnum._('disabled');
const RecordSettingsRequestModeEnum _$recordSettingsRequestModeEnum_autoOn =
    const RecordSettingsRequestModeEnum._('autoOn');

RecordSettingsRequestModeEnum _$recordSettingsRequestModeEnumValueOf(
    String name) {
  switch (name) {
    case 'available':
      return _$recordSettingsRequestModeEnum_available;
    case 'disabled':
      return _$recordSettingsRequestModeEnum_disabled;
    case 'autoOn':
      return _$recordSettingsRequestModeEnum_autoOn;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RecordSettingsRequestModeEnum>
    _$recordSettingsRequestModeEnumValues = BuiltSet<
        RecordSettingsRequestModeEnum>(const <RecordSettingsRequestModeEnum>[
  _$recordSettingsRequestModeEnum_available,
  _$recordSettingsRequestModeEnum_disabled,
  _$recordSettingsRequestModeEnum_autoOn,
]);

const RecordSettingsRequestQualityEnum
    _$recordSettingsRequestQualityEnum_n360p =
    const RecordSettingsRequestQualityEnum._('n360p');
const RecordSettingsRequestQualityEnum
    _$recordSettingsRequestQualityEnum_n480p =
    const RecordSettingsRequestQualityEnum._('n480p');
const RecordSettingsRequestQualityEnum
    _$recordSettingsRequestQualityEnum_n720p =
    const RecordSettingsRequestQualityEnum._('n720p');
const RecordSettingsRequestQualityEnum
    _$recordSettingsRequestQualityEnum_n1080p =
    const RecordSettingsRequestQualityEnum._('n1080p');
const RecordSettingsRequestQualityEnum
    _$recordSettingsRequestQualityEnum_n1440p =
    const RecordSettingsRequestQualityEnum._('n1440p');
const RecordSettingsRequestQualityEnum
    _$recordSettingsRequestQualityEnum_portrait360x640 =
    const RecordSettingsRequestQualityEnum._('portrait360x640');
const RecordSettingsRequestQualityEnum
    _$recordSettingsRequestQualityEnum_portrait480x854 =
    const RecordSettingsRequestQualityEnum._('portrait480x854');
const RecordSettingsRequestQualityEnum
    _$recordSettingsRequestQualityEnum_portrait720x1280 =
    const RecordSettingsRequestQualityEnum._('portrait720x1280');
const RecordSettingsRequestQualityEnum
    _$recordSettingsRequestQualityEnum_portrait1080x1920 =
    const RecordSettingsRequestQualityEnum._('portrait1080x1920');
const RecordSettingsRequestQualityEnum
    _$recordSettingsRequestQualityEnum_portrait1440x2560 =
    const RecordSettingsRequestQualityEnum._('portrait1440x2560');

RecordSettingsRequestQualityEnum _$recordSettingsRequestQualityEnumValueOf(
    String name) {
  switch (name) {
    case 'n360p':
      return _$recordSettingsRequestQualityEnum_n360p;
    case 'n480p':
      return _$recordSettingsRequestQualityEnum_n480p;
    case 'n720p':
      return _$recordSettingsRequestQualityEnum_n720p;
    case 'n1080p':
      return _$recordSettingsRequestQualityEnum_n1080p;
    case 'n1440p':
      return _$recordSettingsRequestQualityEnum_n1440p;
    case 'portrait360x640':
      return _$recordSettingsRequestQualityEnum_portrait360x640;
    case 'portrait480x854':
      return _$recordSettingsRequestQualityEnum_portrait480x854;
    case 'portrait720x1280':
      return _$recordSettingsRequestQualityEnum_portrait720x1280;
    case 'portrait1080x1920':
      return _$recordSettingsRequestQualityEnum_portrait1080x1920;
    case 'portrait1440x2560':
      return _$recordSettingsRequestQualityEnum_portrait1440x2560;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RecordSettingsRequestQualityEnum>
    _$recordSettingsRequestQualityEnumValues = BuiltSet<
        RecordSettingsRequestQualityEnum>(const <RecordSettingsRequestQualityEnum>[
  _$recordSettingsRequestQualityEnum_n360p,
  _$recordSettingsRequestQualityEnum_n480p,
  _$recordSettingsRequestQualityEnum_n720p,
  _$recordSettingsRequestQualityEnum_n1080p,
  _$recordSettingsRequestQualityEnum_n1440p,
  _$recordSettingsRequestQualityEnum_portrait360x640,
  _$recordSettingsRequestQualityEnum_portrait480x854,
  _$recordSettingsRequestQualityEnum_portrait720x1280,
  _$recordSettingsRequestQualityEnum_portrait1080x1920,
  _$recordSettingsRequestQualityEnum_portrait1440x2560,
]);

Serializer<RecordSettingsRequestModeEnum>
    _$recordSettingsRequestModeEnumSerializer =
    _$RecordSettingsRequestModeEnumSerializer();
Serializer<RecordSettingsRequestQualityEnum>
    _$recordSettingsRequestQualityEnumSerializer =
    _$RecordSettingsRequestQualityEnumSerializer();

class _$RecordSettingsRequestModeEnumSerializer
    implements PrimitiveSerializer<RecordSettingsRequestModeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'available': 'available',
    'disabled': 'disabled',
    'autoOn': 'auto-on',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'available': 'available',
    'disabled': 'disabled',
    'auto-on': 'autoOn',
  };

  @override
  final Iterable<Type> types = const <Type>[RecordSettingsRequestModeEnum];
  @override
  final String wireName = 'RecordSettingsRequestModeEnum';

  @override
  Object serialize(
          Serializers serializers, RecordSettingsRequestModeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RecordSettingsRequestModeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RecordSettingsRequestModeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RecordSettingsRequestQualityEnumSerializer
    implements PrimitiveSerializer<RecordSettingsRequestQualityEnum> {
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
  final Iterable<Type> types = const <Type>[RecordSettingsRequestQualityEnum];
  @override
  final String wireName = 'RecordSettingsRequestQualityEnum';

  @override
  Object serialize(
          Serializers serializers, RecordSettingsRequestQualityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RecordSettingsRequestQualityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RecordSettingsRequestQualityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RecordSettingsRequest extends RecordSettingsRequest {
  @override
  final bool? audioOnly;
  @override
  final RecordSettingsRequestModeEnum mode;
  @override
  final RecordSettingsRequestQualityEnum? quality;

  factory _$RecordSettingsRequest(
          [void Function(RecordSettingsRequestBuilder)? updates]) =>
      (RecordSettingsRequestBuilder()..update(updates))._build();

  _$RecordSettingsRequest._({this.audioOnly, required this.mode, this.quality})
      : super._();
  @override
  RecordSettingsRequest rebuild(
          void Function(RecordSettingsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RecordSettingsRequestBuilder toBuilder() =>
      RecordSettingsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RecordSettingsRequest &&
        audioOnly == other.audioOnly &&
        mode == other.mode &&
        quality == other.quality;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, audioOnly.hashCode);
    _$hash = $jc(_$hash, mode.hashCode);
    _$hash = $jc(_$hash, quality.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RecordSettingsRequest')
          ..add('audioOnly', audioOnly)
          ..add('mode', mode)
          ..add('quality', quality))
        .toString();
  }
}

class RecordSettingsRequestBuilder
    implements Builder<RecordSettingsRequest, RecordSettingsRequestBuilder> {
  _$RecordSettingsRequest? _$v;

  bool? _audioOnly;
  bool? get audioOnly => _$this._audioOnly;
  set audioOnly(bool? audioOnly) => _$this._audioOnly = audioOnly;

  RecordSettingsRequestModeEnum? _mode;
  RecordSettingsRequestModeEnum? get mode => _$this._mode;
  set mode(RecordSettingsRequestModeEnum? mode) => _$this._mode = mode;

  RecordSettingsRequestQualityEnum? _quality;
  RecordSettingsRequestQualityEnum? get quality => _$this._quality;
  set quality(RecordSettingsRequestQualityEnum? quality) =>
      _$this._quality = quality;

  RecordSettingsRequestBuilder() {
    RecordSettingsRequest._defaults(this);
  }

  RecordSettingsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _audioOnly = $v.audioOnly;
      _mode = $v.mode;
      _quality = $v.quality;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RecordSettingsRequest other) {
    _$v = other as _$RecordSettingsRequest;
  }

  @override
  void update(void Function(RecordSettingsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RecordSettingsRequest build() => _build();

  _$RecordSettingsRequest _build() {
    final _$result = _$v ??
        _$RecordSettingsRequest._(
          audioOnly: audioOnly,
          mode: BuiltValueNullFieldError.checkNotNull(
              mode, r'RecordSettingsRequest', 'mode'),
          quality: quality,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
