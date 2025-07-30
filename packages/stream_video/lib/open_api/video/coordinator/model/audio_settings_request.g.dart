// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_settings_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AudioSettingsRequestDefaultDeviceEnum
    _$audioSettingsRequestDefaultDeviceEnum_speaker =
    const AudioSettingsRequestDefaultDeviceEnum._('speaker');
const AudioSettingsRequestDefaultDeviceEnum
    _$audioSettingsRequestDefaultDeviceEnum_earpiece =
    const AudioSettingsRequestDefaultDeviceEnum._('earpiece');

AudioSettingsRequestDefaultDeviceEnum
    _$audioSettingsRequestDefaultDeviceEnumValueOf(String name) {
  switch (name) {
    case 'speaker':
      return _$audioSettingsRequestDefaultDeviceEnum_speaker;
    case 'earpiece':
      return _$audioSettingsRequestDefaultDeviceEnum_earpiece;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AudioSettingsRequestDefaultDeviceEnum>
    _$audioSettingsRequestDefaultDeviceEnumValues = BuiltSet<
        AudioSettingsRequestDefaultDeviceEnum>(const <AudioSettingsRequestDefaultDeviceEnum>[
  _$audioSettingsRequestDefaultDeviceEnum_speaker,
  _$audioSettingsRequestDefaultDeviceEnum_earpiece,
]);

Serializer<AudioSettingsRequestDefaultDeviceEnum>
    _$audioSettingsRequestDefaultDeviceEnumSerializer =
    _$AudioSettingsRequestDefaultDeviceEnumSerializer();

class _$AudioSettingsRequestDefaultDeviceEnumSerializer
    implements PrimitiveSerializer<AudioSettingsRequestDefaultDeviceEnum> {
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
    AudioSettingsRequestDefaultDeviceEnum
  ];
  @override
  final String wireName = 'AudioSettingsRequestDefaultDeviceEnum';

  @override
  Object serialize(
          Serializers serializers, AudioSettingsRequestDefaultDeviceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AudioSettingsRequestDefaultDeviceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AudioSettingsRequestDefaultDeviceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AudioSettingsRequest extends AudioSettingsRequest {
  @override
  final bool? accessRequestEnabled;
  @override
  final AudioSettingsRequestDefaultDeviceEnum defaultDevice;
  @override
  final bool? micDefaultOn;
  @override
  final NoiseCancellationSettings? noiseCancellation;
  @override
  final bool? opusDtxEnabled;
  @override
  final bool? redundantCodingEnabled;
  @override
  final bool? speakerDefaultOn;

  factory _$AudioSettingsRequest(
          [void Function(AudioSettingsRequestBuilder)? updates]) =>
      (AudioSettingsRequestBuilder()..update(updates))._build();

  _$AudioSettingsRequest._(
      {this.accessRequestEnabled,
      required this.defaultDevice,
      this.micDefaultOn,
      this.noiseCancellation,
      this.opusDtxEnabled,
      this.redundantCodingEnabled,
      this.speakerDefaultOn})
      : super._();
  @override
  AudioSettingsRequest rebuild(
          void Function(AudioSettingsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AudioSettingsRequestBuilder toBuilder() =>
      AudioSettingsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AudioSettingsRequest &&
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
    return (newBuiltValueToStringHelper(r'AudioSettingsRequest')
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

class AudioSettingsRequestBuilder
    implements Builder<AudioSettingsRequest, AudioSettingsRequestBuilder> {
  _$AudioSettingsRequest? _$v;

  bool? _accessRequestEnabled;
  bool? get accessRequestEnabled => _$this._accessRequestEnabled;
  set accessRequestEnabled(bool? accessRequestEnabled) =>
      _$this._accessRequestEnabled = accessRequestEnabled;

  AudioSettingsRequestDefaultDeviceEnum? _defaultDevice;
  AudioSettingsRequestDefaultDeviceEnum? get defaultDevice =>
      _$this._defaultDevice;
  set defaultDevice(AudioSettingsRequestDefaultDeviceEnum? defaultDevice) =>
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

  AudioSettingsRequestBuilder() {
    AudioSettingsRequest._defaults(this);
  }

  AudioSettingsRequestBuilder get _$this {
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
  void replace(AudioSettingsRequest other) {
    _$v = other as _$AudioSettingsRequest;
  }

  @override
  void update(void Function(AudioSettingsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AudioSettingsRequest build() => _build();

  _$AudioSettingsRequest _build() {
    _$AudioSettingsRequest _$result;
    try {
      _$result = _$v ??
          _$AudioSettingsRequest._(
            accessRequestEnabled: accessRequestEnabled,
            defaultDevice: BuiltValueNullFieldError.checkNotNull(
                defaultDevice, r'AudioSettingsRequest', 'defaultDevice'),
            micDefaultOn: micDefaultOn,
            noiseCancellation: _noiseCancellation?.build(),
            opusDtxEnabled: opusDtxEnabled,
            redundantCodingEnabled: redundantCodingEnabled,
            speakerDefaultOn: speakerDefaultOn,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'noiseCancellation';
        _noiseCancellation?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AudioSettingsRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
