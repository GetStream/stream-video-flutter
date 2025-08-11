import 'package:json_annotation/json_annotation.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';

part 'stream_video_push_configuration.g.dart';

@JsonSerializable(explicitToJson: true)
class StreamVideoPushConfiguration {
  const StreamVideoPushConfiguration({
    this.headers,
    this.android,
    this.ios,
  });

  final Map<String, dynamic>? headers;
  final AndroidPushConfiguration? android;
  final IOSPushConfiguration? ios;

  StreamVideoPushConfiguration copyWith({
    Map<String, dynamic>? headers,
    AndroidPushConfiguration? android,
    IOSPushConfiguration? ios,
  }) {
    return StreamVideoPushConfiguration(
      headers: headers ?? this.headers,
      android: android ?? this.android,
      ios: ios ?? this.ios,
    );
  }

  StreamVideoPushConfiguration merge(StreamVideoPushConfiguration? other) {
    if (other == null) return this;

    return copyWith(
      headers: other.headers,
      android: android?.merge(other.android),
      ios: ios?.merge(other.ios),
    );
  }

  factory StreamVideoPushConfiguration.fromJson(Map<String, dynamic> json) =>
      _$StreamVideoPushConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$StreamVideoPushConfigurationToJson(this);
}

/// Object config for Android.
@JsonSerializable(explicitToJson: true)
class AndroidPushConfiguration {
  const AndroidPushConfiguration({
    this.missedCallNotification,
    this.isCustomSmallExNotification,
    this.isShowLogo,
    this.logoUrl,
    this.defaultAvatar,
    this.isShowCallID,
    this.ringtonePath,
    this.backgroundColor,
    this.backgroundUrl,
    this.actionColor,
    this.textColor,
    this.incomingCallNotificationChannelName,
    this.missedCallNotificationChannelName,
    this.isShowFullLockedScreen,
  });

  final NotificationParams? missedCallNotification;

  /// Using custom notification small on some devices clipped out in android.
  final bool? isCustomSmallExNotification;

  /// Show logo app inside full screen.
  final bool? isShowLogo;

  /// Logo aoo inside full screen, example: http://... https://... or "assets/abc.png"
  final String? logoUrl;

  /// Default avatar for call, example: http://... https://... or "assets/abc.png"
  final String? defaultAvatar;

  /// Show call id app inside full screen.
  final bool? isShowCallID;

  /// File name ringtone, put file into /android/app/src/main/res/raw/ringtone_default.mp3 -> value: `ringtone_default`
  final String? ringtonePath;

  /// Incoming call screen background color.
  final String? backgroundColor;

  /// Using image background for Incoming call screen. example: http://... https://... or "assets/abc.png"
  final String? backgroundUrl;

  /// Color used in button/text on notification.
  final String? actionColor;

  /// Color used for the text in the full screen notification
  final String? textColor;

  /// Notification channel name of incoming call.
  final String? incomingCallNotificationChannelName;

  /// Notification channel name of missed call.
  final String? missedCallNotificationChannelName;

  /// Show full locked screen.
  final bool? isShowFullLockedScreen;

  AndroidPushConfiguration copyWith({
    NotificationParams? missedCallNotification,
    bool? isCustomSmallExNotification,
    bool? isShowLogo,
    String? logoUrl,
    String? defaultAvatar,
    bool? isShowCallID,
    String? ringtonePath,
    String? backgroundColor,
    String? backgroundUrl,
    String? actionColor,
    String? textColor,
    String? incomingCallNotificationChannelName,
    String? missedCallNotificationChannelName,
    bool? isShowFullLockedScreen,
  }) {
    return AndroidPushConfiguration(
      missedCallNotification:
          missedCallNotification ?? this.missedCallNotification,
      isCustomSmallExNotification:
          isCustomSmallExNotification ?? this.isCustomSmallExNotification,
      isShowLogo: isShowLogo ?? this.isShowLogo,
      logoUrl: logoUrl ?? this.logoUrl,
      defaultAvatar: defaultAvatar ?? this.defaultAvatar,
      isShowCallID: isShowCallID ?? this.isShowCallID,
      ringtonePath: ringtonePath ?? this.ringtonePath,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundUrl: backgroundUrl ?? this.backgroundUrl,
      actionColor: actionColor ?? this.actionColor,
      textColor: textColor ?? this.textColor,
      incomingCallNotificationChannelName:
          incomingCallNotificationChannelName ??
              this.incomingCallNotificationChannelName,
      missedCallNotificationChannelName: missedCallNotificationChannelName ??
          this.missedCallNotificationChannelName,
      isShowFullLockedScreen:
          isShowFullLockedScreen ?? this.isShowFullLockedScreen,
    );
  }

  AndroidPushConfiguration merge(AndroidPushConfiguration? other) {
    if (other == null) return this;

    return copyWith(
      missedCallNotification: other.missedCallNotification,
      isCustomSmallExNotification: other.isCustomSmallExNotification,
      isShowLogo: other.isShowLogo,
      logoUrl: other.logoUrl,
      defaultAvatar: other.defaultAvatar,
      isShowCallID: other.isShowCallID,
      ringtonePath: other.ringtonePath,
      backgroundColor: other.backgroundColor,
      backgroundUrl: other.backgroundUrl,
      actionColor: other.actionColor,
      textColor: other.textColor,
      incomingCallNotificationChannelName:
          other.incomingCallNotificationChannelName,
      missedCallNotificationChannelName:
          other.missedCallNotificationChannelName,
      isShowFullLockedScreen: other.isShowFullLockedScreen,
    );
  }

  factory AndroidPushConfiguration.fromJson(Map<String, dynamic> json) =>
      _$AndroidPushConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$AndroidPushConfigurationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class IOSPushConfiguration {
  /// App's Icon. using for display inside Callkit(iOS)
  final String? iconName;

  /// Type handle call `generic`, `number`, `email`
  final String? handleType;
  final bool? useComplexHandle;
  final bool? supportsVideo;
  final int? maximumCallGroups;
  final int? maximumCallsPerCallGroup;
  final String? audioSessionMode;
  final bool? audioSessionActive;
  final double? audioSessionPreferredSampleRate;
  final double? audioSessionPreferredIOBufferDuration;
  final bool? configureAudioSession;
  final bool? supportsDTMF;
  final bool? supportsHolding;
  final bool? supportsGrouping;
  final bool? supportsUngrouping;

  /// Add file to root project xcode /ios/Runner/Ringtone.caf and Copy Bundle Resources(Build Phases) -> value: "Ringtone.caf"
  final String? ringtonePath;

  const IOSPushConfiguration({
    this.iconName,
    this.handleType,
    this.useComplexHandle,
    this.supportsVideo,
    this.maximumCallGroups,
    this.maximumCallsPerCallGroup,
    this.audioSessionMode,
    this.audioSessionActive,
    this.audioSessionPreferredSampleRate,
    this.audioSessionPreferredIOBufferDuration,
    this.configureAudioSession,
    this.supportsDTMF,
    this.supportsHolding,
    this.supportsGrouping,
    this.supportsUngrouping,
    this.ringtonePath,
  });

  IOSPushConfiguration copyWith({
    String? iconName,
    String? handleType,
    bool? useComplexHandle,
    bool? supportsVideo,
    int? maximumCallGroups,
    int? maximumCallsPerCallGroup,
    String? audioSessionMode,
    bool? audioSessionActive,
    double? audioSessionPreferredSampleRate,
    double? audioSessionPreferredIOBufferDuration,
    bool? configureAudioSession,
    bool? supportsDTMF,
    bool? supportsHolding,
    bool? supportsGrouping,
    bool? supportsUngrouping,
    String? ringtonePath,
  }) {
    return IOSPushConfiguration(
      iconName: iconName ?? this.iconName,
      handleType: handleType ?? this.handleType,
      useComplexHandle: useComplexHandle ?? this.useComplexHandle,
      supportsVideo: supportsVideo ?? this.supportsVideo,
      maximumCallGroups: maximumCallGroups ?? this.maximumCallGroups,
      maximumCallsPerCallGroup:
          maximumCallsPerCallGroup ?? this.maximumCallsPerCallGroup,
      audioSessionMode: audioSessionMode ?? this.audioSessionMode,
      audioSessionActive: audioSessionActive ?? this.audioSessionActive,
      audioSessionPreferredSampleRate: audioSessionPreferredSampleRate ??
          this.audioSessionPreferredSampleRate,
      audioSessionPreferredIOBufferDuration:
          audioSessionPreferredIOBufferDuration ??
              this.audioSessionPreferredIOBufferDuration,
      configureAudioSession:
          configureAudioSession ?? this.configureAudioSession,
      supportsDTMF: supportsDTMF ?? this.supportsDTMF,
      supportsHolding: supportsHolding ?? this.supportsHolding,
      supportsGrouping: supportsGrouping ?? this.supportsGrouping,
      supportsUngrouping: supportsUngrouping ?? this.supportsUngrouping,
      ringtonePath: ringtonePath ?? this.ringtonePath,
    );
  }

  IOSPushConfiguration merge(IOSPushConfiguration? other) {
    if (other == null) return this;

    return copyWith(
      iconName: other.iconName,
      handleType: other.handleType,
      useComplexHandle: other.useComplexHandle,
      supportsVideo: other.supportsVideo,
      maximumCallGroups: other.maximumCallGroups,
      maximumCallsPerCallGroup: other.maximumCallsPerCallGroup,
      audioSessionMode: other.audioSessionMode,
      audioSessionActive: other.audioSessionActive,
      audioSessionPreferredSampleRate: other.audioSessionPreferredSampleRate,
      audioSessionPreferredIOBufferDuration:
          other.audioSessionPreferredIOBufferDuration,
      configureAudioSession: other.configureAudioSession,
      supportsDTMF: other.supportsDTMF,
      supportsHolding: other.supportsHolding,
      supportsGrouping: other.supportsGrouping,
      supportsUngrouping: other.supportsUngrouping,
      ringtonePath: other.ringtonePath,
    );
  }

  factory IOSPushConfiguration.fromJson(Map<String, dynamic> json) =>
      _$IOSPushConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$IOSPushConfigurationToJson(this);
}
