// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_or_create_call_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetOrCreateCallRequest _$GetOrCreateCallRequestFromJson(
  Map<String, dynamic> json,
) => GetOrCreateCallRequest(
  data: json['data'] == null
      ? null
      : CallRequest.fromJson(json['data'] as Map<String, dynamic>),
  membersLimit: (json['members_limit'] as num?)?.toInt(),
  notify: json['notify'] as bool?,
  ring: json['ring'] as bool?,
  video: json['video'] as bool?,
);

Map<String, dynamic> _$GetOrCreateCallRequestToJson(
  GetOrCreateCallRequest instance,
) => <String, dynamic>{
  'data': instance.data,
  'members_limit': instance.membersLimit,
  'notify': instance.notify,
  'ring': instance.ring,
  'video': instance.video,
};
