// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encryption_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EncryptionSettingsResponse _$EncryptionSettingsResponseFromJson(
  Map<String, dynamic> json,
) => EncryptionSettingsResponse(
  mode: EncryptionSettingsResponseMode.fromJson(json['mode'] as String),
);

Map<String, dynamic> _$EncryptionSettingsResponseToJson(
  EncryptionSettingsResponse instance,
) => <String, dynamic>{'mode': instance.mode.toJson()};
