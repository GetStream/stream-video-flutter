// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingress_error_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngressErrorEvent _$IngressErrorEventFromJson(Map<String, dynamic> json) =>
    IngressErrorEvent(
      callCid: json['call_cid'] as String,
      code: json['code'] as String?,
      createdAt: const EpochDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      error: json['error'] as String,
      ingressStreamId: json['ingress_stream_id'] as String,
      type: json['type'] as String,
      userId: json['user_id'] as String,
    );

Map<String, dynamic> _$IngressErrorEventToJson(IngressErrorEvent instance) =>
    <String, dynamic>{
      'call_cid': instance.callCid,
      'code': instance.code,
      'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
      'error': instance.error,
      'ingress_stream_id': instance.ingressStreamId,
      'type': instance.type,
      'user_id': instance.userId,
    };
