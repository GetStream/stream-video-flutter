// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credentials.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Credentials _$CredentialsFromJson(Map<String, dynamic> json) => Credentials(
  iceServers:
      (json['ice_servers'] as List<dynamic>?)
          ?.map((e) => ICEServerResponse.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  server: SFUResponse.fromJson(json['server'] as Map<String, dynamic>),
  token: json['token'] as String,
);

Map<String, dynamic> _$CredentialsToJson(Credentials instance) =>
    <String, dynamic>{
      'ice_servers': instance.iceServers.map((e) => e.toJson()).toList(),
      'server': instance.server.toJson(),
      'token': instance.token,
    };
