// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'published_track_metrics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublishedTrackMetrics _$PublishedTrackMetricsFromJson(
  Map<String, dynamic> json,
) => PublishedTrackMetrics(
  bitrate: json['bitrate'] == null
      ? null
      : MetricTimeSeries.fromJson(json['bitrate'] as Map<String, dynamic>),
  codec: json['codec'] as String?,
  framerate: json['framerate'] == null
      ? null
      : MetricTimeSeries.fromJson(json['framerate'] as Map<String, dynamic>),
  resolution: json['resolution'] == null
      ? null
      : ResolutionMetricsTimeSeries.fromJson(
          json['resolution'] as Map<String, dynamic>,
        ),
  trackId: json['track_id'] as String?,
  trackType: json['track_type'] as String?,
  warnings: (json['warnings'] as List<dynamic>?)
      ?.map((e) => SessionWarningResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PublishedTrackMetricsToJson(
  PublishedTrackMetrics instance,
) => <String, dynamic>{
  'bitrate': instance.bitrate?.toJson(),
  'codec': instance.codec,
  'framerate': instance.framerate?.toJson(),
  'resolution': instance.resolution?.toJson(),
  'track_id': instance.trackId,
  'track_type': instance.trackType,
  'warnings': instance.warnings?.map((e) => e.toJson()).toList(),
};
