// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_video_push_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StreamVideoPushParams _$StreamVideoPushParamsFromJson(
        Map<String, dynamic> json) =>
    StreamVideoPushParams(
      appName: json['appName'] as String?,
      avatar: json['avatar'] as String?,
      duration: json['duration'] as int?,
      textAccept: json['textAccept'] as String?,
      textDecline: json['textDecline'] as String?,
      missedCallNotification: json['missedCallNotification'] == null
          ? null
          : NotificationParams.fromJson(
              json['missedCallNotification'] as Map<String, dynamic>),
      extra: json['extra'] as Map<String, dynamic>?,
      headers: json['headers'] as Map<String, dynamic>?,
      android: json['android'] == null
          ? null
          : AndroidParams.fromJson(json['android'] as Map<String, dynamic>),
      ios: json['ios'] == null
          ? null
          : IOSParams.fromJson(json['ios'] as Map<String, dynamic>),
      incomingCallerNameOverride: json['incomingCallerNameOverride'] as String?,
      incomingCallerHandlerOverride:
          json['incomingCallerHandlerOverride'] as String?,
    );

Map<String, dynamic> _$StreamVideoPushParamsToJson(
        StreamVideoPushParams instance) =>
    <String, dynamic>{
      'appName': instance.appName,
      'avatar': instance.avatar,
      'duration': instance.duration,
      'textAccept': instance.textAccept,
      'textDecline': instance.textDecline,
      'missedCallNotification': instance.missedCallNotification?.toJson(),
      'extra': instance.extra,
      'headers': instance.headers,
      'android': instance.android?.toJson(),
      'ios': instance.ios?.toJson(),
      'incomingCallerNameOverride': instance.incomingCallerNameOverride,
      'incomingCallerHandlerOverride': instance.incomingCallerHandlerOverride,
    };
