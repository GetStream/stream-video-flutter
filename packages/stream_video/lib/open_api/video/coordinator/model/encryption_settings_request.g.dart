// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encryption_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EncryptionSettingsRequest _$EncryptionSettingsRequestFromJson(
  Map<String, dynamic> json,
) => EncryptionSettingsRequest(
  mode: json['mode'] == null
      ? null
      : EncryptionSettingsRequestMode.fromJson(json['mode'] as String),
);

Map<String, dynamic> _$EncryptionSettingsRequestToJson(
  EncryptionSettingsRequest instance,
) => <String, dynamic>{'mode': instance.mode?.toJson()};
