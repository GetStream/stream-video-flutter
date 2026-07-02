// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_closed_captions_started_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallClosedCaptionsStartedEvent _$CallClosedCaptionsStartedEventFromJson(
  Map<String, dynamic> json,
) => CallClosedCaptionsStartedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$CallClosedCaptionsStartedEventToJson(
  CallClosedCaptionsStartedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'type': instance.type,
};
