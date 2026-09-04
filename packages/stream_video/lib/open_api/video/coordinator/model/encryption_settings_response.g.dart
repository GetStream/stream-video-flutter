// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encryption_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EncryptionSettingsResponse _$EncryptionSettingsResponseFromJson(
  Map<String, dynamic> json,
) => EncryptionSettingsResponse(
  mode: $enumDecode(
    _$EncryptionSettingsResponseModeEnumMap,
    json['mode'],
    unknownValue: EncryptionSettingsResponseMode.unknown,
  ),
);

Map<String, dynamic> _$EncryptionSettingsResponseToJson(
  EncryptionSettingsResponse instance,
) => <String, dynamic>{
  'mode': _$EncryptionSettingsResponseModeEnumMap[instance.mode]!,
};

const _$EncryptionSettingsResponseModeEnumMap = {
  EncryptionSettingsResponseMode.autoOn: 'auto-on',
  EncryptionSettingsResponseMode.available: 'available',
  EncryptionSettingsResponseMode.disabled: 'disabled',
  EncryptionSettingsResponseMode.unknown: '_unknown',
};
