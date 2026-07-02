// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target_resolution.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TargetResolution _$TargetResolutionFromJson(Map<String, dynamic> json) =>
    TargetResolution(
      bitrate: (json['bitrate'] as num?)?.toInt(),
      height: (json['height'] as num).toInt(),
      width: (json['width'] as num).toInt(),
    );

Map<String, dynamic> _$TargetResolutionToJson(TargetResolution instance) =>
    <String, dynamic>{
      'bitrate': instance.bitrate,
      'height': instance.height,
      'width': instance.width,
    };
