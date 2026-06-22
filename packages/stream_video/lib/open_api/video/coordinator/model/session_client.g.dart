// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionClient _$SessionClientFromJson(Map<String, dynamic> json) =>
    SessionClient(
      ip: json['ip'] as String?,
      location: json['location'] == null
          ? null
          : CallStatsLocation.fromJson(
              json['location'] as Map<String, dynamic>,
            ),
      name: json['name'] as String?,
      networkType: json['network_type'] as String?,
      version: json['version'] as String?,
    );

Map<String, dynamic> _$SessionClientToJson(SessionClient instance) =>
    <String, dynamic>{
      'ip': instance.ip,
      'location': instance.location,
      'name': instance.name,
      'network_type': instance.networkType,
      'version': instance.version,
    };
