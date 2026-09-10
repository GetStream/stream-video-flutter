// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'updated_call_permissions_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdatedCallPermissionsEvent _$UpdatedCallPermissionsEventFromJson(
  Map<String, dynamic> json,
) => UpdatedCallPermissionsEvent(
  callCid: json['call_cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  ownCapabilities: (json['own_capabilities'] as List<dynamic>)
      .map((e) => OwnCapability.fromJson(e as String))
      .toList(),
  type: json['type'] as String,
  user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UpdatedCallPermissionsEventToJson(
  UpdatedCallPermissionsEvent instance,
) => <String, dynamic>{
  'call_cid': instance.callCid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'own_capabilities': instance.ownCapabilities.map((e) => e.toJson()).toList(),
  'type': instance.type,
  'user': instance.user.toJson(),
};
