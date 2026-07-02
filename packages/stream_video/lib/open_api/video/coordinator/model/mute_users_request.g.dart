// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mute_users_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MuteUsersRequest _$MuteUsersRequestFromJson(Map<String, dynamic> json) =>
    MuteUsersRequest(
      audio: json['audio'] as bool?,
      muteAllUsers: json['mute_all_users'] as bool?,
      screenshare: json['screenshare'] as bool?,
      screenshareAudio: json['screenshare_audio'] as bool?,
      userIds: (json['user_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      video: json['video'] as bool?,
    );

Map<String, dynamic> _$MuteUsersRequestToJson(MuteUsersRequest instance) =>
    <String, dynamic>{
      'audio': instance.audio,
      'mute_all_users': instance.muteAllUsers,
      'screenshare': instance.screenshare,
      'screenshare_audio': instance.screenshareAudio,
      'user_ids': instance.userIds,
      'video': instance.video,
    };
