// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_rtmp_broadcasts_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StartRTMPBroadcastsRequest _$StartRTMPBroadcastsRequestFromJson(
  Map<String, dynamic> json,
) => StartRTMPBroadcastsRequest(
  broadcasts: (json['broadcasts'] as List<dynamic>)
      .map((e) => RTMPBroadcastRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StartRTMPBroadcastsRequestToJson(
  StartRTMPBroadcastsRequest instance,
) => <String, dynamic>{'broadcasts': instance.broadcasts};
