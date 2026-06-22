// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ring_call_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RingCallResponse _$RingCallResponseFromJson(Map<String, dynamic> json) =>
    RingCallResponse(
      duration: json['duration'] as String,
      membersIds: (json['members_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$RingCallResponseToJson(RingCallResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'members_ids': instance.membersIds,
    };
