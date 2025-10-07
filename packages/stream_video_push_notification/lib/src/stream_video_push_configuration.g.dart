// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_video_push_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StreamVideoPushConfiguration _$StreamVideoPushConfigurationFromJson(
  Map<String, dynamic> json,
) => StreamVideoPushConfiguration(
  headers: json['headers'] as Map<String, dynamic>?,
  android: json['android'] == null
      ? null
      : AndroidPushConfiguration.fromJson(
          json['android'] as Map<String, dynamic>,
        ),
  ios: json['ios'] == null
      ? null
      : IOSPushConfiguration.fromJson(json['ios'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StreamVideoPushConfigurationToJson(
  StreamVideoPushConfiguration instance,
) => <String, dynamic>{
  'headers': instance.headers,
  'android': instance.android?.toJson(),
  'ios': instance.ios?.toJson(),
};

AndroidPushConfiguration _$AndroidPushConfigurationFromJson(
  Map<String, dynamic> json,
) => AndroidPushConfiguration(
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
  defaultAvatar: json['defaultAvatar'] as String?,
  ringtonePath: json['ringtonePath'] as String?,
  incomingCallNotificationChannelName:
      json['incomingCallNotificationChannelName'] as String?,
  missedCallNotificationChannelName:
      json['missedCallNotificationChannelName'] as String?,
  showFullScreenOnLockScreen: json['showFullScreenOnLockScreen'] as bool?,
);

Map<String, dynamic> _$AndroidPushConfigurationToJson(
  AndroidPushConfiguration instance,
) => <String, dynamic>{
  'missedCallNotification': instance.missedCallNotification?.toJson(),
  'incomingCallNotification': instance.incomingCallNotification?.toJson(),
  'defaultAvatar': instance.defaultAvatar,
  'ringtonePath': instance.ringtonePath,
  'incomingCallNotificationChannelName':
      instance.incomingCallNotificationChannelName,
  'missedCallNotificationChannelName':
      instance.missedCallNotificationChannelName,
  'showFullScreenOnLockScreen': instance.showFullScreenOnLockScreen,
};

IOSPushConfiguration _$IOSPushConfigurationFromJson(
  Map<String, dynamic> json,
) => IOSPushConfiguration(
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

Map<String, dynamic> _$IOSPushConfigurationToJson(
  IOSPushConfiguration instance,
) => <String, dynamic>{
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
