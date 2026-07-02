// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_closed_captions_failed_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallClosedCaptionsFailedEvent _$CallClosedCaptionsFailedEventFromJson(
  Map<String, dynamic> json,
) => CallClosedCaptionsFailedEvent(
  callCid: json['call_cid'] as String,
  createdAt: const EpochDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$CallClosedCaptionsFailedEventToJson(
  CallClosedCaptionsFailedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'type': instance.type,
};
