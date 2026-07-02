// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingress_started_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngressStartedEvent _$IngressStartedEventFromJson(Map<String, dynamic> json) =>
    IngressStartedEvent(
      callCid: json['call_cid'] as String,
      clientIp: json['client_ip'] as String?,
      clientName: json['client_name'] as String?,
      createdAt: const EpochDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      ingressStreamId: json['ingress_stream_id'] as String,
      publisherType: json['publisher_type'] as String,
      type: json['type'] as String,
      userId: json['user_id'] as String,
      version: json['version'] as String?,
    );

Map<String, dynamic> _$IngressStartedEventToJson(
  IngressStartedEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'client_ip': instance.clientIp,
  'client_name': instance.clientName,
  'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
  'ingress_stream_id': instance.ingressStreamId,
  'publisher_type': instance.publisherType,
  'type': instance.type,
  'user_id': instance.userId,
  'version': instance.version,
};
