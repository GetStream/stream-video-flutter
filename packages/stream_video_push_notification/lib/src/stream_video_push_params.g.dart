// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_video_push_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StreamVideoPushParams _$StreamVideoPushParamsFromJson(
  Map<String, dynamic> json,
) => StreamVideoPushParams(
  id: json['id'] as String?,
  callerName: json['callerName'] as String?,
  handle: json['handle'] as String?,
  type: (json['type'] as num?)?.toInt(),
  duration: (json['duration'] as num?)?.toInt(),
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
  StreamVideoPushParams instance,
) => <String, dynamic>{
  'id': instance.id,
  'callerName': instance.callerName,
  'handle': instance.handle,
  'type': instance.type,
  'duration': instance.duration,
  'extra': instance.extra,
  'headers': instance.headers,
  'android': instance.android?.toJson(),
  'ios': instance.ios?.toJson(),
};

AndroidParams _$AndroidParamsFromJson(Map<String, dynamic> json) =>
    AndroidParams(
      avatar: json['avatar'] as String?,
      defaultAvatar: json['defaultAvatar'] as String?,
      ringtonePath: json['ringtonePath'] as String?,
      incomingCallNotificationChannelName:
          json['incomingCallNotificationChannelName'] as String?,
      missedCallNotificationChannelName:
          json['missedCallNotificationChannelName'] as String?,
      showFullScreenOnLockScreen: json['showFullScreenOnLockScreen'] as bool?,
      isImportant: json['isImportant'] as bool?,
      isBot: json['isBot'] as bool?,
      missedCallNotification: json['missedCallNotification'] == null
          ? null
          : MissedCallNotificationParams.fromJson(
              json['missedCallNotification'] as Map<String, dynamic>,
            ),
      incomingCallNotification: json['incomingCallNotification'] == null
          ? null
          : IncomingCallNotificationParams.fromJson(
              json['incomingCallNotification'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$AndroidParamsToJson(AndroidParams instance) =>
    <String, dynamic>{
      'missedCallNotification': instance.missedCallNotification?.toJson(),
      'incomingCallNotification': instance.incomingCallNotification?.toJson(),
      'avatar': instance.avatar,
      'defaultAvatar': instance.defaultAvatar,
      'ringtonePath': instance.ringtonePath,
      'incomingCallNotificationChannelName':
          instance.incomingCallNotificationChannelName,
      'missedCallNotificationChannelName':
          instance.missedCallNotificationChannelName,
      'showFullScreenOnLockScreen': instance.showFullScreenOnLockScreen,
      'isImportant': instance.isImportant,
      'isBot': instance.isBot,
    };

IOSParams _$IOSParamsFromJson(Map<String, dynamic> json) => IOSParams(
  iconName: json['iconName'] as String?,
  handleType: json['handleType'] as String?,
  useComplexHandle: json['useComplexHandle'] as bool?,
  supportsVideo: json['supportsVideo'] as bool?,
  maximumCallGroups: (json['maximumCallGroups'] as num?)?.toInt(),
  maximumCallsPerCallGroup: (json['maximumCallsPerCallGroup'] as num?)?.toInt(),
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
  'audioSessionPreferredSampleRate': instance.audioSessionPreferredSampleRate,
  'audioSessionPreferredIOBufferDuration':
      instance.audioSessionPreferredIOBufferDuration,
  'configureAudioSession': instance.configureAudioSession,
  'supportsDTMF': instance.supportsDTMF,
  'supportsHolding': instance.supportsHolding,
  'supportsGrouping': instance.supportsGrouping,
  'supportsUngrouping': instance.supportsUngrouping,
  'ringtonePath': instance.ringtonePath,
};

MissedCallNotificationParams _$MissedCallNotificationParamsFromJson(
  Map<String, dynamic> json,
) => MissedCallNotificationParams(
  id: (json['id'] as num?)?.toInt(),
  showNotification: json['showNotification'] as bool?,
  subtitle: json['subtitle'] as String?,
  callbackText: json['callbackText'] as String?,
  showCallbackButton: json['showCallbackButton'] as bool?,
  count: (json['count'] as num?)?.toInt(),
);

Map<String, dynamic> _$MissedCallNotificationParamsToJson(
  MissedCallNotificationParams instance,
) => <String, dynamic>{
  'id': instance.id,
  'showNotification': instance.showNotification,
  'subtitle': instance.subtitle,
  'callbackText': instance.callbackText,
  'showCallbackButton': instance.showCallbackButton,
  'count': instance.count,
};

IncomingCallNotificationParams _$IncomingCallNotificationParamsFromJson(
  Map<String, dynamic> json,
) => IncomingCallNotificationParams(
  fullScreenShowLogo: json['fullScreenShowLogo'] as bool?,
  fullScreenLogoUrl: json['fullScreenLogoUrl'] as String?,
  fullScreenBackgroundColor: json['fullScreenBackgroundColor'] as String?,
  fullScreenBackgroundUrl: json['fullScreenBackgroundUrl'] as String?,
  fullScreenTextColor: json['fullScreenTextColor'] as String?,
  textAccept: json['textAccept'] as String?,
  textDecline: json['textDecline'] as String?,
  showCallHandle: json['showCallHandle'] as bool?,
);

Map<String, dynamic> _$IncomingCallNotificationParamsToJson(
  IncomingCallNotificationParams instance,
) => <String, dynamic>{
  'fullScreenShowLogo': instance.fullScreenShowLogo,
  'fullScreenLogoUrl': instance.fullScreenLogoUrl,
  'fullScreenBackgroundColor': instance.fullScreenBackgroundColor,
  'fullScreenBackgroundUrl': instance.fullScreenBackgroundUrl,
  'fullScreenTextColor': instance.fullScreenTextColor,
  'textAccept': instance.textAccept,
  'textDecline': instance.textDecline,
  'showCallHandle': instance.showCallHandle,
};
