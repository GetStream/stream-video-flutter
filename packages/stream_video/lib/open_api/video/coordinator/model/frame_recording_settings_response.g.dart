// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frame_recording_settings_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FrameRecordingSettingsResponseModeEnum
    _$frameRecordingSettingsResponseModeEnum_available =
    const FrameRecordingSettingsResponseModeEnum._('available');
const FrameRecordingSettingsResponseModeEnum
    _$frameRecordingSettingsResponseModeEnum_disabled =
    const FrameRecordingSettingsResponseModeEnum._('disabled');
const FrameRecordingSettingsResponseModeEnum
    _$frameRecordingSettingsResponseModeEnum_autoOn =
    const FrameRecordingSettingsResponseModeEnum._('autoOn');

FrameRecordingSettingsResponseModeEnum
    _$frameRecordingSettingsResponseModeEnumValueOf(String name) {
  switch (name) {
    case 'available':
      return _$frameRecordingSettingsResponseModeEnum_available;
    case 'disabled':
      return _$frameRecordingSettingsResponseModeEnum_disabled;
    case 'autoOn':
      return _$frameRecordingSettingsResponseModeEnum_autoOn;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FrameRecordingSettingsResponseModeEnum>
    _$frameRecordingSettingsResponseModeEnumValues = BuiltSet<
        FrameRecordingSettingsResponseModeEnum>(const <FrameRecordingSettingsResponseModeEnum>[
  _$frameRecordingSettingsResponseModeEnum_available,
  _$frameRecordingSettingsResponseModeEnum_disabled,
  _$frameRecordingSettingsResponseModeEnum_autoOn,
]);

Serializer<FrameRecordingSettingsResponseModeEnum>
    _$frameRecordingSettingsResponseModeEnumSerializer =
    _$FrameRecordingSettingsResponseModeEnumSerializer();

class _$FrameRecordingSettingsResponseModeEnumSerializer
    implements PrimitiveSerializer<FrameRecordingSettingsResponseModeEnum> {
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
    FrameRecordingSettingsResponseModeEnum
  ];
  @override
  final String wireName = 'FrameRecordingSettingsResponseModeEnum';

  @override
  Object serialize(Serializers serializers,
          FrameRecordingSettingsResponseModeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FrameRecordingSettingsResponseModeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FrameRecordingSettingsResponseModeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FrameRecordingSettingsResponse extends FrameRecordingSettingsResponse {
  @override
  final int captureIntervalInSeconds;
  @override
  final FrameRecordingSettingsResponseModeEnum mode;
  @override
  final String? quality;

  factory _$FrameRecordingSettingsResponse(
          [void Function(FrameRecordingSettingsResponseBuilder)? updates]) =>
      (FrameRecordingSettingsResponseBuilder()..update(updates))._build();

  _$FrameRecordingSettingsResponse._(
      {required this.captureIntervalInSeconds,
      required this.mode,
      this.quality})
      : super._();
  @override
  FrameRecordingSettingsResponse rebuild(
          void Function(FrameRecordingSettingsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FrameRecordingSettingsResponseBuilder toBuilder() =>
      FrameRecordingSettingsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FrameRecordingSettingsResponse &&
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
    return (newBuiltValueToStringHelper(r'FrameRecordingSettingsResponse')
          ..add('captureIntervalInSeconds', captureIntervalInSeconds)
          ..add('mode', mode)
          ..add('quality', quality))
        .toString();
  }
}

class FrameRecordingSettingsResponseBuilder
    implements
        Builder<FrameRecordingSettingsResponse,
            FrameRecordingSettingsResponseBuilder> {
  _$FrameRecordingSettingsResponse? _$v;

  int? _captureIntervalInSeconds;
  int? get captureIntervalInSeconds => _$this._captureIntervalInSeconds;
  set captureIntervalInSeconds(int? captureIntervalInSeconds) =>
      _$this._captureIntervalInSeconds = captureIntervalInSeconds;

  FrameRecordingSettingsResponseModeEnum? _mode;
  FrameRecordingSettingsResponseModeEnum? get mode => _$this._mode;
  set mode(FrameRecordingSettingsResponseModeEnum? mode) => _$this._mode = mode;

  String? _quality;
  String? get quality => _$this._quality;
  set quality(String? quality) => _$this._quality = quality;

  FrameRecordingSettingsResponseBuilder() {
    FrameRecordingSettingsResponse._defaults(this);
  }

  FrameRecordingSettingsResponseBuilder get _$this {
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
  void replace(FrameRecordingSettingsResponse other) {
    _$v = other as _$FrameRecordingSettingsResponse;
  }

  @override
  void update(void Function(FrameRecordingSettingsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FrameRecordingSettingsResponse build() => _build();

  _$FrameRecordingSettingsResponse _build() {
    final _$result = _$v ??
        _$FrameRecordingSettingsResponse._(
          captureIntervalInSeconds: BuiltValueNullFieldError.checkNotNull(
              captureIntervalInSeconds,
              r'FrameRecordingSettingsResponse',
              'captureIntervalInSeconds'),
          mode: BuiltValueNullFieldError.checkNotNull(
              mode, r'FrameRecordingSettingsResponse', 'mode'),
          quality: quality,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
