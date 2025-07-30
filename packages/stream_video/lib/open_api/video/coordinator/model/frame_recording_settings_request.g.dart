// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frame_recording_settings_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FrameRecordingSettingsRequestModeEnum
    _$frameRecordingSettingsRequestModeEnum_available =
    const FrameRecordingSettingsRequestModeEnum._('available');
const FrameRecordingSettingsRequestModeEnum
    _$frameRecordingSettingsRequestModeEnum_disabled =
    const FrameRecordingSettingsRequestModeEnum._('disabled');
const FrameRecordingSettingsRequestModeEnum
    _$frameRecordingSettingsRequestModeEnum_autoOn =
    const FrameRecordingSettingsRequestModeEnum._('autoOn');

FrameRecordingSettingsRequestModeEnum
    _$frameRecordingSettingsRequestModeEnumValueOf(String name) {
  switch (name) {
    case 'available':
      return _$frameRecordingSettingsRequestModeEnum_available;
    case 'disabled':
      return _$frameRecordingSettingsRequestModeEnum_disabled;
    case 'autoOn':
      return _$frameRecordingSettingsRequestModeEnum_autoOn;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FrameRecordingSettingsRequestModeEnum>
    _$frameRecordingSettingsRequestModeEnumValues = BuiltSet<
        FrameRecordingSettingsRequestModeEnum>(const <FrameRecordingSettingsRequestModeEnum>[
  _$frameRecordingSettingsRequestModeEnum_available,
  _$frameRecordingSettingsRequestModeEnum_disabled,
  _$frameRecordingSettingsRequestModeEnum_autoOn,
]);

const FrameRecordingSettingsRequestQualityEnum
    _$frameRecordingSettingsRequestQualityEnum_n360p =
    const FrameRecordingSettingsRequestQualityEnum._('n360p');
const FrameRecordingSettingsRequestQualityEnum
    _$frameRecordingSettingsRequestQualityEnum_n480p =
    const FrameRecordingSettingsRequestQualityEnum._('n480p');
const FrameRecordingSettingsRequestQualityEnum
    _$frameRecordingSettingsRequestQualityEnum_n720p =
    const FrameRecordingSettingsRequestQualityEnum._('n720p');
const FrameRecordingSettingsRequestQualityEnum
    _$frameRecordingSettingsRequestQualityEnum_n1080p =
    const FrameRecordingSettingsRequestQualityEnum._('n1080p');
const FrameRecordingSettingsRequestQualityEnum
    _$frameRecordingSettingsRequestQualityEnum_n1440p =
    const FrameRecordingSettingsRequestQualityEnum._('n1440p');

FrameRecordingSettingsRequestQualityEnum
    _$frameRecordingSettingsRequestQualityEnumValueOf(String name) {
  switch (name) {
    case 'n360p':
      return _$frameRecordingSettingsRequestQualityEnum_n360p;
    case 'n480p':
      return _$frameRecordingSettingsRequestQualityEnum_n480p;
    case 'n720p':
      return _$frameRecordingSettingsRequestQualityEnum_n720p;
    case 'n1080p':
      return _$frameRecordingSettingsRequestQualityEnum_n1080p;
    case 'n1440p':
      return _$frameRecordingSettingsRequestQualityEnum_n1440p;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FrameRecordingSettingsRequestQualityEnum>
    _$frameRecordingSettingsRequestQualityEnumValues = BuiltSet<
        FrameRecordingSettingsRequestQualityEnum>(const <FrameRecordingSettingsRequestQualityEnum>[
  _$frameRecordingSettingsRequestQualityEnum_n360p,
  _$frameRecordingSettingsRequestQualityEnum_n480p,
  _$frameRecordingSettingsRequestQualityEnum_n720p,
  _$frameRecordingSettingsRequestQualityEnum_n1080p,
  _$frameRecordingSettingsRequestQualityEnum_n1440p,
]);

Serializer<FrameRecordingSettingsRequestModeEnum>
    _$frameRecordingSettingsRequestModeEnumSerializer =
    _$FrameRecordingSettingsRequestModeEnumSerializer();
Serializer<FrameRecordingSettingsRequestQualityEnum>
    _$frameRecordingSettingsRequestQualityEnumSerializer =
    _$FrameRecordingSettingsRequestQualityEnumSerializer();

class _$FrameRecordingSettingsRequestModeEnumSerializer
    implements PrimitiveSerializer<FrameRecordingSettingsRequestModeEnum> {
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
  final Iterable<Type> types = const <Type>[
    FrameRecordingSettingsRequestModeEnum
  ];
  @override
  final String wireName = 'FrameRecordingSettingsRequestModeEnum';

  @override
  Object serialize(
          Serializers serializers, FrameRecordingSettingsRequestModeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FrameRecordingSettingsRequestModeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FrameRecordingSettingsRequestModeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FrameRecordingSettingsRequestQualityEnumSerializer
    implements PrimitiveSerializer<FrameRecordingSettingsRequestQualityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'n360p': '360p',
    'n480p': '480p',
    'n720p': '720p',
    'n1080p': '1080p',
    'n1440p': '1440p',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    '360p': 'n360p',
    '480p': 'n480p',
    '720p': 'n720p',
    '1080p': 'n1080p',
    '1440p': 'n1440p',
  };

  @override
  final Iterable<Type> types = const <Type>[
    FrameRecordingSettingsRequestQualityEnum
  ];
  @override
  final String wireName = 'FrameRecordingSettingsRequestQualityEnum';

  @override
  Object serialize(Serializers serializers,
          FrameRecordingSettingsRequestQualityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FrameRecordingSettingsRequestQualityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FrameRecordingSettingsRequestQualityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FrameRecordingSettingsRequest extends FrameRecordingSettingsRequest {
  @override
  final int captureIntervalInSeconds;
  @override
  final FrameRecordingSettingsRequestModeEnum mode;
  @override
  final FrameRecordingSettingsRequestQualityEnum? quality;

  factory _$FrameRecordingSettingsRequest(
          [void Function(FrameRecordingSettingsRequestBuilder)? updates]) =>
      (FrameRecordingSettingsRequestBuilder()..update(updates))._build();

  _$FrameRecordingSettingsRequest._(
      {required this.captureIntervalInSeconds,
      required this.mode,
      this.quality})
      : super._();
  @override
  FrameRecordingSettingsRequest rebuild(
          void Function(FrameRecordingSettingsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FrameRecordingSettingsRequestBuilder toBuilder() =>
      FrameRecordingSettingsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FrameRecordingSettingsRequest &&
        captureIntervalInSeconds == other.captureIntervalInSeconds &&
        mode == other.mode &&
        quality == other.quality;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, captureIntervalInSeconds.hashCode);
    _$hash = $jc(_$hash, mode.hashCode);
    _$hash = $jc(_$hash, quality.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FrameRecordingSettingsRequest')
          ..add('captureIntervalInSeconds', captureIntervalInSeconds)
          ..add('mode', mode)
          ..add('quality', quality))
        .toString();
  }
}

class FrameRecordingSettingsRequestBuilder
    implements
        Builder<FrameRecordingSettingsRequest,
            FrameRecordingSettingsRequestBuilder> {
  _$FrameRecordingSettingsRequest? _$v;

  int? _captureIntervalInSeconds;
  int? get captureIntervalInSeconds => _$this._captureIntervalInSeconds;
  set captureIntervalInSeconds(int? captureIntervalInSeconds) =>
      _$this._captureIntervalInSeconds = captureIntervalInSeconds;

  FrameRecordingSettingsRequestModeEnum? _mode;
  FrameRecordingSettingsRequestModeEnum? get mode => _$this._mode;
  set mode(FrameRecordingSettingsRequestModeEnum? mode) => _$this._mode = mode;

  FrameRecordingSettingsRequestQualityEnum? _quality;
  FrameRecordingSettingsRequestQualityEnum? get quality => _$this._quality;
  set quality(FrameRecordingSettingsRequestQualityEnum? quality) =>
      _$this._quality = quality;

  FrameRecordingSettingsRequestBuilder() {
    FrameRecordingSettingsRequest._defaults(this);
  }

  FrameRecordingSettingsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _captureIntervalInSeconds = $v.captureIntervalInSeconds;
      _mode = $v.mode;
      _quality = $v.quality;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FrameRecordingSettingsRequest other) {
    _$v = other as _$FrameRecordingSettingsRequest;
  }

  @override
  void update(void Function(FrameRecordingSettingsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FrameRecordingSettingsRequest build() => _build();

  _$FrameRecordingSettingsRequest _build() {
    final _$result = _$v ??
        _$FrameRecordingSettingsRequest._(
          captureIntervalInSeconds: BuiltValueNullFieldError.checkNotNull(
              captureIntervalInSeconds,
              r'FrameRecordingSettingsRequest',
              'captureIntervalInSeconds'),
          mode: BuiltValueNullFieldError.checkNotNull(
              mode, r'FrameRecordingSettingsRequest', 'mode'),
          quality: quality,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
