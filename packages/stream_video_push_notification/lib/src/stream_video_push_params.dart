import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../stream_video_push_notification.dart';
import 'stream_video_push_configuration.dart';

part 'stream_video_push_params.g.dart';

@JsonSerializable(explicitToJson: true)
class StreamVideoPushParams {
  const StreamVideoPushParams({
    this.id,
    this.callerName,
    this.handle,
    this.type,
    this.duration,
    this.extra,
    this.headers,
    this.android,
    this.ios,
  });

  factory StreamVideoPushParams.fromPushConfiguration(
    StreamVideoPushConfiguration configuration,
  ) => StreamVideoPushParams(
    headers: configuration.headers,
    android: configuration.android != null
        ? AndroidParams.fromPushConfiguration(configuration.android!)
        : null,
    ios: configuration.ios != null
        ? IOSParams.fromPushConfiguration(configuration.ios!)
        : null,
  );

  factory StreamVideoPushParams.fromJson(Map<String, dynamic> json) =>
      _$StreamVideoPushParamsFromJson(json);

  const StreamVideoPushParams._internal({
    this.id,
    this.callerName,
    this.handle,
    this.type,
    this.duration,
    this.extra,
    this.headers,
    this.android,
    this.ios,
  });

  final String? id;
  final String? callerName;
  final String? handle;
  final int? type;
  final int? duration;
  final Map<String, dynamic>? extra;
  final Map<String, dynamic>? headers;
  final AndroidParams? android;
  final IOSParams? ios;

  @internal
  StreamVideoPushParams copyWith({
    String? id,
    String? callerName,
    String? handle,
    int? type,
    int? duration,
    Map<String, dynamic>? extra,
    Map<String, dynamic>? headers,
    AndroidParams? android,
    IOSParams? ios,
  }) {
    return StreamVideoPushParams._internal(
      id: id ?? this.id,
      callerName: callerName ?? this.callerName,
      handle: handle ?? this.handle,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      extra: extra ?? this.extra,
      headers: headers ?? this.headers,
      android: android ?? this.android,
      ios: ios ?? this.ios,
    );
  }

  @internal
  StreamVideoPushParams merge(StreamVideoPushParams? other) {
    if (other == null) return this;

    return copyWith(
      id: other.id,
      callerName: other.callerName,
      handle: other.handle,
      type: other.type,
      duration: other.duration,
      extra: other.extra,
      headers: other.headers,
      android: android?.merge(other.android) ?? other.android,
      ios: ios?.merge(other.ios) ?? other.ios,
    );
  }

  Map<String, dynamic> toJson() => _$StreamVideoPushParamsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AndroidParams {
  const AndroidParams({
    this.avatar,
    this.defaultAvatar,
    this.ringtonePath,
    this.incomingCallNotificationChannelName,
    this.missedCallNotificationChannelName,
    this.showFullScreenOnLockScreen,
    this.isImportant,
    this.isBot,
    this.missedCallNotification,
    this.incomingCallNotification,
  });

  factory AndroidParams.fromPushConfiguration(
    AndroidPushConfiguration configuration,
  ) => AndroidParams(
    defaultAvatar: configuration.defaultAvatar,
    ringtonePath: configuration.ringtonePath,
    incomingCallNotificationChannelName:
        configuration.incomingCallNotificationChannelName,
    missedCallNotificationChannelName:
        configuration.missedCallNotificationChannelName,
    showFullScreenOnLockScreen: configuration.showFullScreenOnLockScreen,
    missedCallNotification: configuration.missedCallNotification,
    incomingCallNotification: configuration.incomingCallNotification,
  );

  factory AndroidParams.fromJson(Map<String, dynamic> json) =>
      _$AndroidParamsFromJson(json);

  final MissedCallNotificationParams? missedCallNotification;

  final IncomingCallNotificationParams? incomingCallNotification;

  final String? avatar;

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

  /// Caller is important to the user of this device with regards to how frequently they interact.
  /// https://developer.android.com/reference/androidx/core/app/Person#isImportant()
  final bool? isImportant;

  /// Used primarily to identify automated tooling.
  /// https://developer.android.com/reference/androidx/core/app/Person#isBot()
  final bool? isBot;

  AndroidParams copyWith({
    String? avatar,
    String? defaultAvatar,
    String? ringtonePath,
    String? incomingCallNotificationChannelName,
    String? missedCallNotificationChannelName,
    bool? showFullScreenOnLockScreen,
    bool? isImportant,
    bool? isBot,
    IncomingCallNotificationParams? incomingCallNotification,
    MissedCallNotificationParams? missedCallNotification,
  }) {
    return AndroidParams(
      avatar: avatar ?? this.avatar,
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
      isImportant: isImportant ?? this.isImportant,
      isBot: isBot ?? this.isBot,
      incomingCallNotification:
          incomingCallNotification ?? this.incomingCallNotification,
      missedCallNotification:
          missedCallNotification ?? this.missedCallNotification,
    );
  }

  AndroidParams merge(AndroidParams? other) {
    if (other == null) return this;

    return copyWith(
      avatar: other.avatar,
      defaultAvatar: other.defaultAvatar,
      ringtonePath: other.ringtonePath,
      incomingCallNotificationChannelName:
          other.incomingCallNotificationChannelName,
      missedCallNotificationChannelName:
          other.missedCallNotificationChannelName,
      showFullScreenOnLockScreen: other.showFullScreenOnLockScreen,
      isImportant: other.isImportant,
      isBot: other.isBot,
      incomingCallNotification: other.incomingCallNotification,
      missedCallNotification: other.missedCallNotification,
    );
  }

  Map<String, dynamic> toJson() => _$AndroidParamsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class IOSParams {
  const IOSParams({
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

  factory IOSParams.fromPushConfiguration(IOSPushConfiguration configuration) =>
      IOSParams(
        iconName: configuration.iconName,
        handleType: configuration.handleType,
        useComplexHandle: configuration.useComplexHandle,
        supportsVideo: configuration.supportsVideo,
        maximumCallGroups: configuration.maximumCallGroups,
        maximumCallsPerCallGroup: configuration.maximumCallsPerCallGroup,
        audioSessionMode: configuration.audioSessionMode,
        audioSessionActive: configuration.audioSessionActive,
        audioSessionPreferredSampleRate:
            configuration.audioSessionPreferredSampleRate,
        audioSessionPreferredIOBufferDuration:
            configuration.audioSessionPreferredIOBufferDuration,
        configureAudioSession: configuration.configureAudioSession,
        supportsDTMF: configuration.supportsDTMF,
        supportsHolding: configuration.supportsHolding,
        supportsGrouping: configuration.supportsGrouping,
        supportsUngrouping: configuration.supportsUngrouping,
        ringtonePath: configuration.ringtonePath,
      );

  factory IOSParams.fromJson(Map<String, dynamic> json) =>
      _$IOSParamsFromJson(json);

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

  IOSParams copyWith({
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
    return IOSParams(
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

  IOSParams merge(IOSParams? other) {
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

  Map<String, dynamic> toJson() => _$IOSParamsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MissedCallNotificationParams {
  const MissedCallNotificationParams({
    this.id,
    this.showNotification,
    this.subtitle,
    this.callbackText,
    this.showCallbackButton,
    this.count,
  });
  factory MissedCallNotificationParams.fromJson(Map<String, dynamic> json) =>
      _$MissedCallNotificationParamsFromJson(json);

  final int? id;
  final bool? showNotification;
  final String? subtitle;
  final String? callbackText;
  final bool? showCallbackButton;
  final int? count;
  Map<String, dynamic> toJson() => _$MissedCallNotificationParamsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class IncomingCallNotificationParams {
  const IncomingCallNotificationParams({
    this.fullScreenShowLogo,
    this.fullScreenLogoUrl,
    this.fullScreenBackgroundColor,
    this.fullScreenBackgroundUrl,
    this.fullScreenTextColor,
    this.textAccept,
    this.textDecline,
    this.showCallHandle,
  });
  factory IncomingCallNotificationParams.fromJson(Map<String, dynamic> json) =>
      _$IncomingCallNotificationParamsFromJson(json);

  final bool? fullScreenShowLogo;
  final String? fullScreenLogoUrl;
  final String? fullScreenBackgroundColor;
  final String? fullScreenBackgroundUrl;
  final String? fullScreenTextColor;

  final String? textAccept;
  final String? textDecline;
  final bool? showCallHandle;
  Map<String, dynamic> toJson() => _$IncomingCallNotificationParamsToJson(this);
}
