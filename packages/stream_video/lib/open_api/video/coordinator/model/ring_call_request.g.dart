// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ring_call_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RingCallRequest _$RingCallRequestFromJson(Map<String, dynamic> json) =>
    RingCallRequest(
      membersIds: (json['members_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      video: json['video'] as bool?,
    );

Map<String, dynamic> _$RingCallRequestToJson(RingCallRequest instance) =>
    <String, dynamic>{
      'members_ids': instance.membersIds,
      'video': instance.video,
    };
