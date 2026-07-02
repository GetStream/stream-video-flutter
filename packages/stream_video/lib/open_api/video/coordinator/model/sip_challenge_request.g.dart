// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sip_challenge_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SIPChallengeRequest _$SIPChallengeRequestFromJson(Map<String, dynamic> json) =>
    SIPChallengeRequest(
      a1: json['a1'] as String?,
      algorithm: json['algorithm'] as String?,
      charset: json['charset'] as String?,
      cnonce: json['cnonce'] as String?,
      domain: (json['domain'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      method: json['method'] as String?,
      nc: json['nc'] as String?,
      nonce: json['nonce'] as String?,
      opaque: json['opaque'] as String?,
      qop: (json['qop'] as List<dynamic>?)?.map((e) => e as String).toList(),
      realm: json['realm'] as String?,
      response: json['response'] as String?,
      stale: json['stale'] as bool?,
      uri: json['uri'] as String?,
      userhash: json['userhash'] as bool?,
      username: json['username'] as String?,
    );

Map<String, dynamic> _$SIPChallengeRequestToJson(
  SIPChallengeRequest instance,
) => <String, dynamic>{
  'a1': instance.a1,
  'algorithm': instance.algorithm,
  'charset': instance.charset,
  'cnonce': instance.cnonce,
  'domain': instance.domain,
  'method': instance.method,
  'nc': instance.nc,
  'nonce': instance.nonce,
  'opaque': instance.opaque,
  'qop': instance.qop,
  'realm': instance.realm,
  'response': instance.response,
  'stale': instance.stale,
  'uri': instance.uri,
  'userhash': instance.userhash,
  'username': instance.username,
};
