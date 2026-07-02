// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_closed_captions_stopped_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallClosedCaptionsStoppedEvent _$CallClosedCaptionsStoppedEventFromJson(
  Map<String, dynamic> json,
) => CallClosedCaptionsStoppedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$CallClosedCaptionsStoppedEventToJson(
  CallClosedCaptionsStoppedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'type': instance.type,
};
