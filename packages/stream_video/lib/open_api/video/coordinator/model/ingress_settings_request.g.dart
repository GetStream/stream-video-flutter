// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingress_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngressSettingsRequest _$IngressSettingsRequestFromJson(
  Map<String, dynamic> json,
) => IngressSettingsRequest(
  audioEncodingOptions: json['audio_encoding_options'] == null
      ? null
      : IngressAudioEncodingOptionsRequest.fromJson(
          json['audio_encoding_options'] as Map<String, dynamic>,
        ),
  enabled: json['enabled'] as bool?,
  videoEncodingOptions:
      (json['video_encoding_options'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          IngressVideoEncodingOptionsRequest.fromJson(
            e as Map<String, dynamic>,
          ),
        ),
      ),
);

Map<String, dynamic> _$IngressSettingsRequestToJson(
  IngressSettingsRequest instance,
) => <String, dynamic>{
  'audio_encoding_options': instance.audioEncodingOptions?.toJson(),
  'enabled': instance.enabled,
  'video_encoding_options': instance.videoEncodingOptions?.map(
    (k, e) => MapEntry(k, e.toJson()),
  ),
};
