import 'package:json_annotation/json_annotation.dart';
import '../stream_video_push_notification.dart';

part 'stream_video_push_configuration.g.dart';

@JsonSerializable(explicitToJson: true)
class StreamVideoPushConfiguration {
  const StreamVideoPushConfiguration({
    this.headers,
    this.android,
    this.ios,
  });

  factory StreamVideoPushConfiguration.fromJson(Map<String, dynamic> json) =>
      _$StreamVideoPushConfigurationFromJson(json);

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

    final mergedHeaders = {
      if (headers != null) ...headers!,
      if (other.headers != null) ...other.headers!,
    };

    return StreamVideoPushConfiguration(
      headers: mergedHeaders.isEmpty ? null : mergedHeaders,
      android: other.android != null
          ? (android?.merge(other.android) ?? other.android)
          : android,
      ios: other.ios != null ? (ios?.merge(other.ios) ?? other.ios) : ios,
    );
  }

  Map<String, dynamic> toJson() => _$StreamVideoPushConfigurationToJson(this);
}

/// Object config for Android.
@JsonSerializable(explicitToJson: true)
class AndroidPushConfiguration {
  const AndroidPushConfiguration({
    this.missedCallNotification,
    this.incomingCallNotification,
    this.defaultAvatar,
    this.ringtonePath,
    this.incomingCallNotificationChannelName,
    this.missedCallNotificationChannelName,
    this.showFullScreenOnLockScreen,
  });

  factory AndroidPushConfiguration.fromJson(Map<String, dynamic> json) =>
      _$AndroidPushConfigurationFromJson(json);

  final MissedCallNotificationParams? missedCallNotification;

  final IncomingCallNotificationParams? incomingCallNotification;

  /// Default avatar for call, example: http://... https://... or "assets/abc.png"
  final String? defaultAvatar;

  /// File name ringtone, put file into /android/app/src/main/res/raw/ringtone_default.mp3 -> value: `ringtone_default`
  final String? ringtonePath;

  /// Notification channel name of incoming call.
  final String? incomingCallNotificationChannelName;

  /// Notification channel name of missed call.
  final String? missedCallNotificationChannelName;

  /// Show full locked screen.
  final bool? showFullScreenOnLockScreen;

  AndroidPushConfiguration copyWith({
    MissedCallNotificationParams? missedCallNotification,
    IncomingCallNotificationParams? incomingCallNotification,
    String? defaultAvatar,
    String? ringtonePath,
    String? incomingCallNotificationChannelName,
    String? missedCallNotificationChannelName,
    bool? showFullScreenOnLockScreen,
  }) {
    return AndroidPushConfiguration(
      missedCallNotification:
          missedCallNotification ?? this.missedCallNotification,
      incomingCallNotification:
          incomingCallNotification ?? this.incomingCallNotification,
      defaultAvatar: defaultAvatar ?? this.defaultAvatar,
      ringtonePath: ringtonePath ?? this.ringtonePath,
      incomingCallNotificationChannelName:
          incomingCallNotificationChannelName ??
          this.incomingCallNotificationChannelName,
      missedCallNotificationChannelName:
          missedCallNotificationChannelName ??
          this.missedCallNotificationChannelName,
      showFullScreenOnLockScreen:
          showFullScreenOnLockScreen ?? this.showFullScreenOnLockScreen,
    );
  }

  AndroidPushConfiguration merge(AndroidPushConfiguration? other) {
    if (other == null) return this;

    return copyWith(
      missedCallNotification: other.missedCallNotification,
      incomingCallNotification: other.incomingCallNotification,
      defaultAvatar: other.defaultAvatar,
      ringtonePath: other.ringtonePath,
      incomingCallNotificationChannelName:
          other.incomingCallNotificationChannelName,
      missedCallNotificationChannelName:
          other.missedCallNotificationChannelName,
      showFullScreenOnLockScreen: other.showFullScreenOnLockScreen,
    );
  }

  Map<String, dynamic> toJson() => _$AndroidPushConfigurationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class IOSPushConfiguration {
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

  factory IOSPushConfiguration.fromJson(Map<String, dynamic> json) =>
      _$IOSPushConfigurationFromJson(json);

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
      audioSessionPreferredSampleRate:
          audioSessionPreferredSampleRate ??
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

  Map<String, dynamic> toJson() => _$IOSPushConfigurationToJson(this);
}
