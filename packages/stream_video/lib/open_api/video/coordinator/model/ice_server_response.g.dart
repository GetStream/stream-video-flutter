// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ice_server_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ICEServerResponse _$ICEServerResponseFromJson(Map<String, dynamic> json) =>
    ICEServerResponse(
      password: json['password'] as String,
      urls: (json['urls'] as List<dynamic>).map((e) => e as String).toList(),
      username: json['username'] as String,
    );

Map<String, dynamic> _$ICEServerResponseToJson(ICEServerResponse instance) =>
    <String, dynamic>{
      'password': instance.password,
      'urls': instance.urls,
      'username': instance.username,
    };
