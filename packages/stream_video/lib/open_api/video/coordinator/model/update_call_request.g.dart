// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_call_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCallRequest _$UpdateCallRequestFromJson(Map<String, dynamic> json) =>
    UpdateCallRequest(
      custom: json['custom'] as Map<String, dynamic>?,
      settingsOverride: json['settings_override'] == null
          ? null
          : CallSettingsRequest.fromJson(
              json['settings_override'] as Map<String, dynamic>,
            ),
      startsAt: _$JsonConverterFromJson<Object, DateTime>(
        json['starts_at'],
        const EpochDateTimeConverter().fromJson,
      ),
    );

Map<String, dynamic> _$UpdateCallRequestToJson(UpdateCallRequest instance) =>
    <String, dynamic>{
      'custom': instance.custom,
      'settings_override': instance.settingsOverride?.toJson(),
      'starts_at': _$JsonConverterToJson<Object, DateTime>(
        instance.startsAt,
        const EpochDateTimeConverter().toJson,
      ),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
