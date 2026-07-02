// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'noise_cancellation_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoiseCancellationSettings _$NoiseCancellationSettingsFromJson(
  Map<String, dynamic> json,
) => NoiseCancellationSettings(
  mode: $enumDecode(
    _$NoiseCancellationSettingsModeEnumMap,
    json['mode'],
    unknownValue: NoiseCancellationSettingsMode.unknown,
  ),
);

Map<String, dynamic> _$NoiseCancellationSettingsToJson(
  NoiseCancellationSettings instance,
) => <String, dynamic>{
  'mode': _$NoiseCancellationSettingsModeEnumMap[instance.mode]!,
};

const _$NoiseCancellationSettingsModeEnumMap = {
  NoiseCancellationSettingsMode.autoOn: 'auto-on',
  NoiseCancellationSettingsMode.available: 'available',
  NoiseCancellationSettingsMode.disabled: 'disabled',
  NoiseCancellationSettingsMode.unknown: '_unknown',
};
