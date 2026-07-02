// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallRequest _$CallRequestFromJson(Map<String, dynamic> json) => CallRequest(
  channelCid: json['channel_cid'] as String?,
  custom: json['custom'] as Map<String, dynamic>?,
  members: (json['members'] as List<dynamic>?)
      ?.map((e) => MemberRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
  settingsOverride: json['settings_override'] == null
      ? null
      : CallSettingsRequest.fromJson(
          json['settings_override'] as Map<String, dynamic>,
        ),
  startsAt: _$JsonConverterFromJson<Object, DateTime>(
    json['starts_at'],
    const EpochDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  video: json['video'] as bool?,
);

Map<String, dynamic> _$CallRequestToJson(CallRequest instance) =>
    <String, dynamic>{
      'channel_cid': instance.channelCid,
      'custom': instance.custom,
      'members': instance.members?.map((e) => e.toJson()).toList(),
      'settings_override': instance.settingsOverride?.toJson(),
      'starts_at': _$JsonConverterToJson<Object, DateTime>(
        instance.startsAt,
        const EpochDateTimeConverter().toJson,
      ),
      'team': instance.team,
      'video': instance.video,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
