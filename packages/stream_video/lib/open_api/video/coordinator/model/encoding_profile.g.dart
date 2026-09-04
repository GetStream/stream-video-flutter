// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encoding_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EncodingProfile _$EncodingProfileFromJson(Map<String, dynamic> json) =>
    EncodingProfile(
      avgSendKbps: (json['avg_send_kbps'] as num?)?.toInt(),
      codec: json['codec'] as String?,
      encoderImpl: json['encoder_impl'] as String?,
      fpsP10: (json['fps_p10'] as num?)?.toInt(),
      fpsP50: (json['fps_p50'] as num?)?.toInt(),
      getstatsSnapshots: (json['getstats_snapshots'] as num).toInt(),
      hardwareEncode: json['hardware_encode'] as bool?,
      ladderType: json['ladder_type'] as String?,
      powerEfficient: json['power_efficient'] as bool?,
      qualityLimitationDurationsS: Map<String, int>.from(
        json['quality_limitation_durations_s'] as Map,
      ),
      qualityLimitationSamples: Map<String, int>.from(
        json['quality_limitation_samples'] as Map,
      ),
      resolution: json['resolution'] as String?,
      simulcastLayers: (json['simulcast_layers'] as num?)?.toInt(),
      sourceFile: json['source_file'] as String,
      svcModes: (json['svc_modes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$EncodingProfileToJson(EncodingProfile instance) =>
    <String, dynamic>{
      'avg_send_kbps': instance.avgSendKbps,
      'codec': instance.codec,
      'encoder_impl': instance.encoderImpl,
      'fps_p10': instance.fpsP10,
      'fps_p50': instance.fpsP50,
      'getstats_snapshots': instance.getstatsSnapshots,
      'hardware_encode': instance.hardwareEncode,
      'ladder_type': instance.ladderType,
      'power_efficient': instance.powerEfficient,
      'quality_limitation_durations_s': instance.qualityLimitationDurationsS,
      'quality_limitation_samples': instance.qualityLimitationSamples,
      'resolution': instance.resolution,
      'simulcast_layers': instance.simulcastLayers,
      'source_file': instance.sourceFile,
      'svc_modes': instance.svcModes,
    };
