// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_video_push_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StreamVideoPushParams _$StreamVideoPushParamsFromJson(
        Map<String, dynamic> json) =>
    StreamVideoPushParams(
      id: json['id'] as String?,
      callerName: json['callerName'] as String?,
      handle: json['handle'] as String?,
      type: (json['type'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
      textAccept: json['textAccept'] as String?,
      textDecline: json['textDecline'] as String?,
      extra: json['extra'] as Map<String, dynamic>?,
      headers: json['headers'] as Map<String, dynamic>?,
      android: json['android'] == null
          ? null
          : AndroidParams.fromJson(json['android'] as Map<String, dynamic>),
      ios: json['ios'] == null
          ? null
          : IOSParams.fromJson(json['ios'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StreamVideoPushParamsToJson(
        StreamVideoPushParams instance) =>
    <String, dynamic>{
      'id': instance.id,
      'callerName': instance.callerName,
      'handle': instance.handle,
      'type': instance.type,
      'duration': instance.duration,
      'textAccept': instance.textAccept,
      'textDecline': instance.textDecline,
      'extra': instance.extra,
      'headers': instance.headers,
      'android': instance.android?.toJson(),
      'ios': instance.ios?.toJson(),
    };

AndroidParams _$AndroidParamsFromJson(Map<String, dynamic> json) =>
    AndroidParams(
      avatar: json['avatar'] as String?,
      isCustomSmallExNotification: json['isCustomSmallExNotification'] as bool?,
      isShowLogo: json['isShowLogo'] as bool?,
      logoUrl: json['logoUrl'] as String?,
      defaultAvatar: json['defaultAvatar'] as String?,
      isShowCallID: json['isShowCallID'] as bool?,
      ringtonePath: json['ringtonePath'] as String?,
      backgroundColor: json['backgroundColor'] as String?,
      backgroundUrl: json['backgroundUrl'] as String?,
      actionColor: json['actionColor'] as String?,
      textColor: json['textColor'] as String?,
      incomingCallNotificationChannelName:
          json['incomingCallNotificationChannelName'] as String?,
      missedCallNotificationChannelName:
          json['missedCallNotificationChannelName'] as String?,
      isShowFullLockedScreen: json['isShowFullLockedScreen'] as bool?,
      isImportant: json['isImportant'] as bool?,
      isBot: json['isBot'] as bool?,
      missedCallNotification: json['missedCallNotification'] == null
          ? null
          : NotificationParams.fromJson(
              json['missedCallNotification'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AndroidParamsToJson(AndroidParams instance) =>
    <String, dynamic>{
      'missedCallNotification': instance.missedCallNotification?.toJson(),
      'avatar': instance.avatar,
      'isCustomSmallExNotification': instance.isCustomSmallExNotification,
      'isShowLogo': instance.isShowLogo,
      'logoUrl': instance.logoUrl,
      'defaultAvatar': instance.defaultAvatar,
      'isShowCallID': instance.isShowCallID,
      'ringtonePath': instance.ringtonePath,
      'backgroundColor': instance.backgroundColor,
      'backgroundUrl': instance.backgroundUrl,
      'actionColor': instance.actionColor,
      'textColor': instance.textColor,
      'incomingCallNotificationChannelName':
          instance.incomingCallNotificationChannelName,
      'missedCallNotificationChannelName':
          instance.missedCallNotificationChannelName,
      'isShowFullLockedScreen': instance.isShowFullLockedScreen,
      'isImportant': instance.isImportant,
      'isBot': instance.isBot,
    };

IOSParams _$IOSParamsFromJson(Map<String, dynamic> json) => IOSParams(
      iconName: json['iconName'] as String?,
      handleType: json['handleType'] as String?,
      useComplexHandle: json['useComplexHandle'] as bool?,
      supportsVideo: json['supportsVideo'] as bool?,
      maximumCallGroups: (json['maximumCallGroups'] as num?)?.toInt(),
      maximumCallsPerCallGroup:
          (json['maximumCallsPerCallGroup'] as num?)?.toInt(),
      audioSessionMode: json['audioSessionMode'] as String?,
      audioSessionActive: json['audioSessionActive'] as bool?,
      audioSessionPreferredSampleRate:
          (json['audioSessionPreferredSampleRate'] as num?)?.toDouble(),
      audioSessionPreferredIOBufferDuration:
          (json['audioSessionPreferredIOBufferDuration'] as num?)?.toDouble(),
      configureAudioSession: json['configureAudioSession'] as bool?,
      supportsDTMF: json['supportsDTMF'] as bool?,
      supportsHolding: json['supportsHolding'] as bool?,
      supportsGrouping: json['supportsGrouping'] as bool?,
      supportsUngrouping: json['supportsUngrouping'] as bool?,
      ringtonePath: json['ringtonePath'] as String?,
    );

Map<String, dynamic> _$IOSParamsToJson(IOSParams instance) => <String, dynamic>{
      'iconName': instance.iconName,
      'handleType': instance.handleType,
      'useComplexHandle': instance.useComplexHandle,
      'supportsVideo': instance.supportsVideo,
      'maximumCallGroups': instance.maximumCallGroups,
      'maximumCallsPerCallGroup': instance.maximumCallsPerCallGroup,
      'audioSessionMode': instance.audioSessionMode,
      'audioSessionActive': instance.audioSessionActive,
      'audioSessionPreferredSampleRate':
          instance.audioSessionPreferredSampleRate,
      'audioSessionPreferredIOBufferDuration':
          instance.audioSessionPreferredIOBufferDuration,
      'configureAudioSession': instance.configureAudioSession,
      'supportsDTMF': instance.supportsDTMF,
      'supportsHolding': instance.supportsHolding,
      'supportsGrouping': instance.supportsGrouping,
      'supportsUngrouping': instance.supportsUngrouping,
      'ringtonePath': instance.ringtonePath,
    };

NotificationParams _$NotificationParamsFromJson(Map<String, dynamic> json) =>
    NotificationParams(
      id: (json['id'] as num?)?.toInt(),
      showNotification: json['showNotification'] as bool?,
      subtitle: json['subtitle'] as String?,
      callbackText: json['callbackText'] as String?,
      isShowCallback: json['isShowCallback'] as bool?,
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NotificationParamsToJson(NotificationParams instance) =>
    <String, dynamic>{
      'id': instance.id,
      'showNotification': instance.showNotification,
      'subtitle': instance.subtitle,
      'callbackText': instance.callbackText,
      'isShowCallback': instance.isShowCallback,
      'count': instance.count,
    };
