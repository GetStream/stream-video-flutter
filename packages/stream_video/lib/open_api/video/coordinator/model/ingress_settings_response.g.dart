// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingress_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngressSettingsResponse _$IngressSettingsResponseFromJson(
  Map<String, dynamic> json,
) => IngressSettingsResponse(
  audioEncodingOptions: json['audio_encoding_options'] == null
      ? null
      : IngressAudioEncodingResponse.fromJson(
          json['audio_encoding_options'] as Map<String, dynamic>,
        ),
  enabled: json['enabled'] as bool,
  videoEncodingOptions:
      (json['video_encoding_options'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          IngressVideoEncodingResponse.fromJson(e as Map<String, dynamic>),
        ),
      ),
);

Map<String, dynamic> _$IngressSettingsResponseToJson(
  IngressSettingsResponse instance,
) => <String, dynamic>{
  'audio_encoding_options': instance.audioEncodingOptions?.toJson(),
  'enabled': instance.enabled,
  'video_encoding_options': instance.videoEncodingOptions?.map(
    (k, e) => MapEntry(k, e.toJson()),
  ),
};
