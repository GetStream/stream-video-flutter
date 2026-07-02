// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'published_track_flags.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublishedTrackFlags _$PublishedTrackFlagsFromJson(Map<String, dynamic> json) =>
    PublishedTrackFlags(
      audio: json['audio'] as bool,
      screenshare: json['screenshare'] as bool,
      screenshareAudio: json['screenshare_audio'] as bool,
      video: json['video'] as bool,
    );

Map<String, dynamic> _$PublishedTrackFlagsToJson(
  PublishedTrackFlags instance,
) => <String, dynamic>{
  'audio': instance.audio,
  'screenshare': instance.screenshare,
  'screenshare_audio': instance.screenshareAudio,
  'video': instance.video,
};
