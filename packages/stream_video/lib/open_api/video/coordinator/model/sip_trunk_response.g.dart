// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sip_trunk_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SIPTrunkResponse _$SIPTrunkResponseFromJson(Map<String, dynamic> json) =>
    SIPTrunkResponse(
      allowedIps: (json['allowed_ips'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt: const EpochDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      id: json['id'] as String,
      name: json['name'] as String,
      numbers: (json['numbers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      password: json['password'] as String,
      updatedAt: const EpochDateTimeConverter().fromJson(
        json['updated_at'] as Object,
      ),
      uri: json['uri'] as String,
      username: json['username'] as String,
    );

Map<String, dynamic> _$SIPTrunkResponseToJson(SIPTrunkResponse instance) =>
    <String, dynamic>{
      'allowed_ips': instance.allowedIps,
      'created_at': const EpochDateTimeConverter().toJson(instance.createdAt),
      'id': instance.id,
      'name': instance.name,
      'numbers': instance.numbers,
      'password': instance.password,
      'updated_at': const EpochDateTimeConverter().toJson(instance.updatedAt),
      'uri': instance.uri,
      'username': instance.username,
    };
