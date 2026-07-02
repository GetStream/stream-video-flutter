// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingress_stopped_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngressStoppedEvent _$IngressStoppedEventFromJson(Map<String, dynamic> json) =>
    IngressStoppedEvent(
      callCid: json['call_cid'] as String,
      createdAt: const EpochDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      ingressStreamId: json['ingress_stream_id'] as String,
      type: json['type'] as String,
      userId: json['user_id'] as String,
    );

Map<String, dynamic> _$IngressStoppedEventToJson(
  IngressStoppedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'ingress_stream_id': instance.ingressStreamId,
  'type': instance.type,
  'user_id': instance.userId,
};
