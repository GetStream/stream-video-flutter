// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_settings_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AudioSettingsResponseDefaultDeviceEnum
    _$audioSettingsResponseDefaultDeviceEnum_speaker =
    const AudioSettingsResponseDefaultDeviceEnum._('speaker');
const AudioSettingsResponseDefaultDeviceEnum
    _$audioSettingsResponseDefaultDeviceEnum_earpiece =
    const AudioSettingsResponseDefaultDeviceEnum._('earpiece');

AudioSettingsResponseDefaultDeviceEnum
    _$audioSettingsResponseDefaultDeviceEnumValueOf(String name) {
  switch (name) {
    case 'speaker':
      return _$audioSettingsResponseDefaultDeviceEnum_speaker;
    case 'earpiece':
      return _$audioSettingsResponseDefaultDeviceEnum_earpiece;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AudioSettingsResponseDefaultDeviceEnum>
    _$audioSettingsResponseDefaultDeviceEnumValues = BuiltSet<
        AudioSettingsResponseDefaultDeviceEnum>(const <AudioSettingsResponseDefaultDeviceEnum>[
  _$audioSettingsResponseDefaultDeviceEnum_speaker,
  _$audioSettingsResponseDefaultDeviceEnum_earpiece,
]);

Serializer<AudioSettingsResponseDefaultDeviceEnum>
    _$audioSettingsResponseDefaultDeviceEnumSerializer =
    _$AudioSettingsResponseDefaultDeviceEnumSerializer();

class _$AudioSettingsResponseDefaultDeviceEnumSerializer
    implements PrimitiveSerializer<AudioSettingsResponseDefaultDeviceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'speaker': 'speaker',
    'earpiece': 'earpiece',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'speaker': 'speaker',
    'earpiece': 'earpiece',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AudioSettingsResponseDefaultDeviceEnum
  ];
  @override
  final String wireName = 'AudioSettingsResponseDefaultDeviceEnum';

  @override
  Object serialize(Serializers serializers,
          AudioSettingsResponseDefaultDeviceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AudioSettingsResponseDefaultDeviceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AudioSettingsResponseDefaultDeviceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AudioSettingsResponse extends AudioSettingsResponse {
  @override
  final bool accessRequestEnabled;
  @override
  final AudioSettingsResponseDefaultDeviceEnum defaultDevice;
  @override
  final bool micDefaultOn;
  @override
  final NoiseCancellationSettings? noiseCancellation;
  @override
  final bool opusDtxEnabled;
  @override
  final bool redundantCodingEnabled;
  @override
  final bool speakerDefaultOn;

  factory _$AudioSettingsResponse(
          [void Function(AudioSettingsResponseBuilder)? updates]) =>
      (AudioSettingsResponseBuilder()..update(updates))._build();

  _$AudioSettingsResponse._(
      {required this.accessRequestEnabled,
      required this.defaultDevice,
      required this.micDefaultOn,
      this.noiseCancellation,
      required this.opusDtxEnabled,
      required this.redundantCodingEnabled,
      required this.speakerDefaultOn})
      : super._();
  @override
  AudioSettingsResponse rebuild(
          void Function(AudioSettingsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AudioSettingsResponseBuilder toBuilder() =>
      AudioSettingsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AudioSettingsResponse &&
        accessRequestEnabled == other.accessRequestEnabled &&
        defaultDevice == other.defaultDevice &&
        micDefaultOn == other.micDefaultOn &&
        noiseCancellation == other.noiseCancellation &&
        opusDtxEnabled == other.opusDtxEnabled &&
        redundantCodingEnabled == other.redundantCodingEnabled &&
        speakerDefaultOn == other.speakerDefaultOn;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accessRequestEnabled.hashCode);
    _$hash = $jc(_$hash, defaultDevice.hashCode);
    _$hash = $jc(_$hash, micDefaultOn.hashCode);
    _$hash = $jc(_$hash, noiseCancellation.hashCode);
    _$hash = $jc(_$hash, opusDtxEnabled.hashCode);
    _$hash = $jc(_$hash, redundantCodingEnabled.hashCode);
    _$hash = $jc(_$hash, speakerDefaultOn.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AudioSettingsResponse')
          ..add('accessRequestEnabled', accessRequestEnabled)
          ..add('defaultDevice', defaultDevice)
          ..add('micDefaultOn', micDefaultOn)
          ..add('noiseCancellation', noiseCancellation)
          ..add('opusDtxEnabled', opusDtxEnabled)
          ..add('redundantCodingEnabled', redundantCodingEnabled)
          ..add('speakerDefaultOn', speakerDefaultOn))
        .toString();
  }
}

class AudioSettingsResponseBuilder
    implements Builder<AudioSettingsResponse, AudioSettingsResponseBuilder> {
  _$AudioSettingsResponse? _$v;

  bool? _accessRequestEnabled;
  bool? get accessRequestEnabled => _$this._accessRequestEnabled;
  set accessRequestEnabled(bool? accessRequestEnabled) =>
      _$this._accessRequestEnabled = accessRequestEnabled;

  AudioSettingsResponseDefaultDeviceEnum? _defaultDevice;
  AudioSettingsResponseDefaultDeviceEnum? get defaultDevice =>
      _$this._defaultDevice;
  set defaultDevice(AudioSettingsResponseDefaultDeviceEnum? defaultDevice) =>
      _$this._defaultDevice = defaultDevice;

  bool? _micDefaultOn;
  bool? get micDefaultOn => _$this._micDefaultOn;
  set micDefaultOn(bool? micDefaultOn) => _$this._micDefaultOn = micDefaultOn;

  NoiseCancellationSettingsBuilder? _noiseCancellation;
  NoiseCancellationSettingsBuilder get noiseCancellation =>
      _$this._noiseCancellation ??= NoiseCancellationSettingsBuilder();
  set noiseCancellation(NoiseCancellationSettingsBuilder? noiseCancellation) =>
      _$this._noiseCancellation = noiseCancellation;

  bool? _opusDtxEnabled;
  bool? get opusDtxEnabled => _$this._opusDtxEnabled;
  set opusDtxEnabled(bool? opusDtxEnabled) =>
      _$this._opusDtxEnabled = opusDtxEnabled;

  bool? _redundantCodingEnabled;
  bool? get redundantCodingEnabled => _$this._redundantCodingEnabled;
  set redundantCodingEnabled(bool? redundantCodingEnabled) =>
      _$this._redundantCodingEnabled = redundantCodingEnabled;

  bool? _speakerDefaultOn;
  bool? get speakerDefaultOn => _$this._speakerDefaultOn;
  set speakerDefaultOn(bool? speakerDefaultOn) =>
      _$this._speakerDefaultOn = speakerDefaultOn;

  AudioSettingsResponseBuilder() {
    AudioSettingsResponse._defaults(this);
  }

  AudioSettingsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accessRequestEnabled = $v.accessRequestEnabled;
      _defaultDevice = $v.defaultDevice;
      _micDefaultOn = $v.micDefaultOn;
      _noiseCancellation = $v.noiseCancellation?.toBuilder();
      _opusDtxEnabled = $v.opusDtxEnabled;
      _redundantCodingEnabled = $v.redundantCodingEnabled;
      _speakerDefaultOn = $v.speakerDefaultOn;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AudioSettingsResponse other) {
    _$v = other as _$AudioSettingsResponse;
  }

  @override
  void update(void Function(AudioSettingsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AudioSettingsResponse build() => _build();

  _$AudioSettingsResponse _build() {
    _$AudioSettingsResponse _$result;
    try {
      _$result = _$v ??
          _$AudioSettingsResponse._(
            accessRequestEnabled: BuiltValueNullFieldError.checkNotNull(
                accessRequestEnabled,
                r'AudioSettingsResponse',
                'accessRequestEnabled'),
            defaultDevice: BuiltValueNullFieldError.checkNotNull(
                defaultDevice, r'AudioSettingsResponse', 'defaultDevice'),
            micDefaultOn: BuiltValueNullFieldError.checkNotNull(
                micDefaultOn, r'AudioSettingsResponse', 'micDefaultOn'),
            noiseCancellation: _noiseCancellation?.build(),
            opusDtxEnabled: BuiltValueNullFieldError.checkNotNull(
                opusDtxEnabled, r'AudioSettingsResponse', 'opusDtxEnabled'),
            redundantCodingEnabled: BuiltValueNullFieldError.checkNotNull(
                redundantCodingEnabled,
                r'AudioSettingsResponse',
                'redundantCodingEnabled'),
            speakerDefaultOn: BuiltValueNullFieldError.checkNotNull(
                speakerDefaultOn, r'AudioSettingsResponse', 'speakerDefaultOn'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'noiseCancellation';
        _noiseCancellation?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AudioSettingsResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
