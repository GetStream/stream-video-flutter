// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_reaction_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallReactionEvent _$CallReactionEventFromJson(Map<String, dynamic> json) =>
    CallReactionEvent(
      callCid: json['call_cid'] as String,
      createdAt: const EpochDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      reaction: VideoReactionResponse.fromJson(
        json['reaction'] as Map<String, dynamic>,
      ),
      type: json['type'] as String,
    );

Map<String, dynamic> _$CallReactionEventToJson(CallReactionEvent instance) =>
    <String, dynamic>{
      'call_cid': instance.callCid,
      'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
      'reaction': instance.reaction,
      'type': instance.type,
    };
