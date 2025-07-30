// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'noise_cancellation_settings.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const NoiseCancellationSettingsModeEnum
    _$noiseCancellationSettingsModeEnum_available =
    const NoiseCancellationSettingsModeEnum._('available');
const NoiseCancellationSettingsModeEnum
    _$noiseCancellationSettingsModeEnum_disabled =
    const NoiseCancellationSettingsModeEnum._('disabled');
const NoiseCancellationSettingsModeEnum
    _$noiseCancellationSettingsModeEnum_autoOn =
    const NoiseCancellationSettingsModeEnum._('autoOn');

NoiseCancellationSettingsModeEnum _$noiseCancellationSettingsModeEnumValueOf(
    String name) {
  switch (name) {
    case 'available':
      return _$noiseCancellationSettingsModeEnum_available;
    case 'disabled':
      return _$noiseCancellationSettingsModeEnum_disabled;
    case 'autoOn':
      return _$noiseCancellationSettingsModeEnum_autoOn;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<NoiseCancellationSettingsModeEnum>
    _$noiseCancellationSettingsModeEnumValues = BuiltSet<
        NoiseCancellationSettingsModeEnum>(const <NoiseCancellationSettingsModeEnum>[
  _$noiseCancellationSettingsModeEnum_available,
  _$noiseCancellationSettingsModeEnum_disabled,
  _$noiseCancellationSettingsModeEnum_autoOn,
]);

Serializer<NoiseCancellationSettingsModeEnum>
    _$noiseCancellationSettingsModeEnumSerializer =
    _$NoiseCancellationSettingsModeEnumSerializer();

class _$NoiseCancellationSettingsModeEnumSerializer
    implements PrimitiveSerializer<NoiseCancellationSettingsModeEnum> {
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
  final Iterable<Type> types = const <Type>[NoiseCancellationSettingsModeEnum];
  @override
  final String wireName = 'NoiseCancellationSettingsModeEnum';

  @override
  Object serialize(
          Serializers serializers, NoiseCancellationSettingsModeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  NoiseCancellationSettingsModeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      NoiseCancellationSettingsModeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$NoiseCancellationSettings extends NoiseCancellationSettings {
  @override
  final NoiseCancellationSettingsModeEnum mode;

  factory _$NoiseCancellationSettings(
          [void Function(NoiseCancellationSettingsBuilder)? updates]) =>
      (NoiseCancellationSettingsBuilder()..update(updates))._build();

  _$NoiseCancellationSettings._({required this.mode}) : super._();
  @override
  NoiseCancellationSettings rebuild(
          void Function(NoiseCancellationSettingsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NoiseCancellationSettingsBuilder toBuilder() =>
      NoiseCancellationSettingsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NoiseCancellationSettings && mode == other.mode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, mode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NoiseCancellationSettings')
          ..add('mode', mode))
        .toString();
  }
}

class NoiseCancellationSettingsBuilder
    implements
        Builder<NoiseCancellationSettings, NoiseCancellationSettingsBuilder> {
  _$NoiseCancellationSettings? _$v;

  NoiseCancellationSettingsModeEnum? _mode;
  NoiseCancellationSettingsModeEnum? get mode => _$this._mode;
  set mode(NoiseCancellationSettingsModeEnum? mode) => _$this._mode = mode;

  NoiseCancellationSettingsBuilder() {
    NoiseCancellationSettings._defaults(this);
  }

  NoiseCancellationSettingsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _mode = $v.mode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NoiseCancellationSettings other) {
    _$v = other as _$NoiseCancellationSettings;
  }

  @override
  void update(void Function(NoiseCancellationSettingsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NoiseCancellationSettings build() => _build();

  _$NoiseCancellationSettings _build() {
    final _$result = _$v ??
        _$NoiseCancellationSettings._(
          mode: BuiltValueNullFieldError.checkNotNull(
              mode, r'NoiseCancellationSettings', 'mode'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
