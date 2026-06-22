// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_call_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JoinCallRequest _$JoinCallRequestFromJson(Map<String, dynamic> json) =>
    JoinCallRequest(
      create: json['create'] as bool?,
      data: json['data'] == null
          ? null
          : CallRequest.fromJson(json['data'] as Map<String, dynamic>),
      hintHighScaleLivestreamPublisher:
          json['hint_high_scale_livestream_publisher'] as bool?,
      location: json['location'] as String,
      membersLimit: (json['members_limit'] as num?)?.toInt(),
      migratingFrom: json['migrating_from'] as String?,
      migratingFromList: (json['migrating_from_list'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      notify: json['notify'] as bool?,
      ring: json['ring'] as bool?,
      video: json['video'] as bool?,
    );

Map<String, dynamic> _$JoinCallRequestToJson(JoinCallRequest instance) =>
    <String, dynamic>{
      'create': instance.create,
      'data': instance.data,
      'hint_high_scale_livestream_publisher':
          instance.hintHighScaleLivestreamPublisher,
      'location': instance.location,
      'members_limit': instance.membersLimit,
      'migrating_from': instance.migratingFrom,
      'migrating_from_list': instance.migratingFromList,
      'notify': instance.notify,
      'ring': instance.ring,
      'video': instance.video,
    };
