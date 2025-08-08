// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_video_push_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StreamVideoPushConfiguration _$StreamVideoPushConfigurationFromJson(
        Map<String, dynamic> json) =>
    StreamVideoPushConfiguration(
      headers: json['headers'] as Map<String, dynamic>?,
      android: json['android'] == null
          ? null
          : AndroidPushConfiguration.fromJson(
              json['android'] as Map<String, dynamic>),
      ios: json['ios'] == null
          ? null
          : IOSPushConfiguration.fromJson(json['ios'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StreamVideoPushConfigurationToJson(
        StreamVideoPushConfiguration instance) =>
    <String, dynamic>{
      'headers': instance.headers,
      'android': instance.android?.toJson(),
      'ios': instance.ios?.toJson(),
    };

AndroidPushConfiguration _$AndroidPushConfigurationFromJson(
        Map<String, dynamic> json) =>
    AndroidPushConfiguration(
      missedCallNotification: json['missedCallNotification'] == null
          ? null
          : NotificationParams.fromJson(
              json['missedCallNotification'] as Map<String, dynamic>),
      isCustomSmallExNotification: json['isCustomSmallExNotification'] as bool?,
      isShowLogo: json['isShowLogo'] as bool?,
      logoUrl: json['logoUrl'] as String?,
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
    );

Map<String, dynamic> _$AndroidPushConfigurationToJson(
        AndroidPushConfiguration instance) =>
    <String, dynamic>{
      'missedCallNotification': instance.missedCallNotification?.toJson(),
      'isCustomSmallExNotification': instance.isCustomSmallExNotification,
      'isShowLogo': instance.isShowLogo,
      'logoUrl': instance.logoUrl,
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
    };

IOSPushConfiguration _$IOSPushConfigurationFromJson(
        Map<String, dynamic> json) =>
    IOSPushConfiguration(
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

Map<String, dynamic> _$IOSPushConfigurationToJson(
        IOSPushConfiguration instance) =>
    <String, dynamic>{
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
