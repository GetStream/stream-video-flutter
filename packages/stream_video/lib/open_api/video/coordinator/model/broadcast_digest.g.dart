// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'broadcast_digest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BroadcastDigest _$BroadcastDigestFromJson(Map<String, dynamic> json) =>
    BroadcastDigest(
      audience: Audience.fromJson(json['audience'] as Map<String, dynamic>),
      broadcast: BroadcastInfo.fromJson(
        json['broadcast'] as Map<String, dynamic>,
      ),
      coverage: Coverage.fromJson(json['coverage'] as Map<String, dynamic>),
      joins: Joins.fromJson(json['joins'] as Map<String, dynamic>),
      poorTail: PoorTail.fromJson(json['poor_tail'] as Map<String, dynamic>),
      quality: Quality.fromJson(json['quality'] as Map<String, dynamic>),
      schemaVersion: json['schema_version'] as String,
      segments: Segments.fromJson(json['segments'] as Map<String, dynamic>),
      source: SourceHealth.fromJson(json['source'] as Map<String, dynamic>),
      viewers: ViewerBehavior.fromJson(json['viewers'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BroadcastDigestToJson(BroadcastDigest instance) =>
    <String, dynamic>{
      'audience': instance.audience.toJson(),
      'broadcast': instance.broadcast.toJson(),
      'coverage': instance.coverage.toJson(),
      'joins': instance.joins.toJson(),
      'poor_tail': instance.poorTail.toJson(),
      'quality': instance.quality.toJson(),
      'schema_version': instance.schemaVersion,
      'segments': instance.segments.toJson(),
      'source': instance.source.toJson(),
      'viewers': instance.viewers.toJson(),
    };
