// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_call_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JoinCallResponse _$JoinCallResponseFromJson(Map<String, dynamic> json) =>
    JoinCallResponse(
      call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
      created: json['created'] as bool,
      credentials: Credentials.fromJson(
        json['credentials'] as Map<String, dynamic>,
      ),
      duration: json['duration'] as String,
      members: (json['members'] as List<dynamic>)
          .map((e) => MemberResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      membership: json['membership'] == null
          ? null
          : MemberResponse.fromJson(json['membership'] as Map<String, dynamic>),
      ownCapabilities: (json['own_capabilities'] as List<dynamic>)
          .map((e) => OwnCapability.fromJson(e as String))
          .toList(),
      statsOptions: StatsOptions.fromJson(
        json['stats_options'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$JoinCallResponseToJson(
  JoinCallResponse instance,
) => <String, dynamic>{
  'call': instance.call.toJson(),
  'created': instance.created,
  'credentials': instance.credentials.toJson(),
  'duration': instance.duration,
  'members': instance.members.map((e) => e.toJson()).toList(),
  'membership': instance.membership?.toJson(),
  'own_capabilities': instance.ownCapabilities.map((e) => e.toJson()).toList(),
  'stats_options': instance.statsOptions.toJson(),
};
