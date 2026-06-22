// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_updated_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallUpdatedEvent _$CallUpdatedEventFromJson(Map<String, dynamic> json) =>
    CallUpdatedEvent(
      call: CallResponse.fromJson(json['call'] as Map<String, dynamic>),
      callCid: json['call_cid'] as String,
      capabilitiesByRole: (json['capabilities_by_role'] as Map<String, dynamic>)
          .map(
            (k, e) => MapEntry(
              k,
              (e as List<dynamic>).map((e) => e as String).toList(),
            ),
          ),
      createdAt: const EpochDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      type: json['type'] as String,
    );

Map<String, dynamic> _$CallUpdatedEventToJson(CallUpdatedEvent instance) =>
    <String, dynamic>{
      'call': instance.call,
      'call_cid': instance.callCid,
      'capabilities_by_role': instance.capabilitiesByRole,
      'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
      'type': instance.type,
    };
