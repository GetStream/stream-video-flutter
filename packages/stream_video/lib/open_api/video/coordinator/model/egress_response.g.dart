// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'egress_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EgressResponse _$EgressResponseFromJson(Map<String, dynamic> json) =>
    EgressResponse(
      broadcasting: json['broadcasting'] as bool,
      compositeRecording: json['composite_recording'] == null
          ? null
          : CompositeRecordingResponse.fromJson(
              json['composite_recording'] as Map<String, dynamic>,
            ),
      frameRecording: json['frame_recording'] == null
          ? null
          : FrameRecordingResponse.fromJson(
              json['frame_recording'] as Map<String, dynamic>,
            ),
      hls: json['hls'] == null
          ? null
          : EgressHLSResponse.fromJson(json['hls'] as Map<String, dynamic>),
      individualRecording: json['individual_recording'] == null
          ? null
          : IndividualRecordingResponse.fromJson(
              json['individual_recording'] as Map<String, dynamic>,
            ),
      rawRecording: json['raw_recording'] == null
          ? null
          : RawRecordingResponse.fromJson(
              json['raw_recording'] as Map<String, dynamic>,
            ),
      rtmps:
          (json['rtmps'] as List<dynamic>?)
              ?.map(
                (e) => EgressRTMPResponse.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );

Map<String, dynamic> _$EgressResponseToJson(EgressResponse instance) =>
    <String, dynamic>{
      'broadcasting': instance.broadcasting,
      'composite_recording': instance.compositeRecording?.toJson(),
      'frame_recording': instance.frameRecording?.toJson(),
      'hls': instance.hls?.toJson(),
      'individual_recording': instance.individualRecording?.toJson(),
      'raw_recording': instance.rawRecording?.toJson(),
      'rtmps': instance.rtmps.map((e) => e.toJson()).toList(),
    };
