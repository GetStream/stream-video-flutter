// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'limits_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LimitsSettingsResponse _$LimitsSettingsResponseFromJson(
  Map<String, dynamic> json,
) => LimitsSettingsResponse(
  maxDurationSeconds: (json['max_duration_seconds'] as num?)?.toInt(),
  maxParticipants: (json['max_participants'] as num?)?.toInt(),
  maxParticipantsExcludeOwner: json['max_participants_exclude_owner'] as bool?,
  maxParticipantsExcludeRoles:
      (json['max_participants_exclude_roles'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
);

Map<String, dynamic> _$LimitsSettingsResponseToJson(
  LimitsSettingsResponse instance,
) => <String, dynamic>{
  'max_duration_seconds': instance.maxDurationSeconds,
  'max_participants': instance.maxParticipants,
  'max_participants_exclude_owner': instance.maxParticipantsExcludeOwner,
  'max_participants_exclude_roles': instance.maxParticipantsExcludeRoles,
};
