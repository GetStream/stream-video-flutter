// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encryption_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EncryptionSettingsRequest _$EncryptionSettingsRequestFromJson(
  Map<String, dynamic> json,
) => EncryptionSettingsRequest(
  mode: $enumDecodeNullable(
    _$EncryptionSettingsRequestModeEnumMap,
    json['mode'],
    unknownValue: EncryptionSettingsRequestMode.unknown,
  ),
);

Map<String, dynamic> _$EncryptionSettingsRequestToJson(
  EncryptionSettingsRequest instance,
) => <String, dynamic>{
  'mode': _$EncryptionSettingsRequestModeEnumMap[instance.mode],
};

const _$EncryptionSettingsRequestModeEnumMap = {
  EncryptionSettingsRequestMode.autoOn: 'auto-on',
  EncryptionSettingsRequestMode.available: 'available',
  EncryptionSettingsRequestMode.disabled: 'disabled',
  EncryptionSettingsRequestMode.unknown: '_unknown',
};
