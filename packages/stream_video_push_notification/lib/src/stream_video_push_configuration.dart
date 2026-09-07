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
    this.telecom,
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

  /// Android Telecom integration. Follows the platform default when omitted — on from Android 17,
  /// off below it. See [TelecomPushConfiguration.enabled].
  final TelecomPushConfiguration? telecom;

  AndroidPushConfiguration copyWith({
    MissedCallNotificationParams? missedCallNotification,
    IncomingCallNotificationParams? incomingCallNotification,
    String? defaultAvatar,
    String? ringtonePath,
    String? incomingCallNotificationChannelName,
    String? missedCallNotificationChannelName,
    bool? showFullScreenOnLockScreen,
    TelecomPushConfiguration? telecom,
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
      telecom: telecom ?? this.telecom,
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
      telecom: other.telecom,
    );
  }

  Map<String, dynamic> toJson() => _$AndroidPushConfigurationToJson(this);
}

/// Configures the Android Telecom integration for the ringing flow.
///
/// When enabled, incoming and outgoing ringing calls are additionally registered with the Android
/// Telecom stack via Jetpack Telecom.
///
/// Requires Android 8.0 (API 26) or newer and the `MANAGE_OWN_CALLS` permission, which the plugin
/// declares for you. On devices without a telephony stack or a default dialer, the integration is
/// skipped and the ringing flow behaves exactly as it does with Telecom disabled.
@JsonSerializable(explicitToJson: true)
class TelecomPushConfiguration {
  const TelecomPushConfiguration({
    this.enabled,
    this.schema,
  });

  factory TelecomPushConfiguration.fromJson(Map<String, dynamic> json) =>
      _$TelecomPushConfigurationFromJson(json);

  /// Whether calls should be registered with the Android Telecom stack.
  ///
  /// Leave it unset to take the platform default, which depends on the Android version:
  ///
  /// - **Android 17 and above: on.** The platform will not let a ringtone play from a service
  ///   started by a push unless the call is in the Telecom stack, so ringing does not work
  ///   correctly without it. Pass `false` to opt out anyway and accept that.
  /// - **Below Android 17: off.** Ringing works without it, so it stays opt-in and nothing about
  ///   an existing integration changes unless you pass `true`.
  ///
  /// An explicit value always wins on both. Note the integration also turns itself off on devices
  /// that cannot support it, whatever this says.
  final bool? enabled;

  /// URI scheme used to build the call address reported to Telecom.
  ///
  /// For example `myapp` produces an address of `myapp:<callCid>`. Defaults to the application id
  /// when omitted. Characters that are not valid in a URI scheme are replaced with `-`.
  final String? schema;

  /// Note [enabled] cannot be cleared back to unset through this; construct a new instance.
  TelecomPushConfiguration copyWith({
    bool? enabled,
    String? schema,
  }) {
    return TelecomPushConfiguration(
      enabled: enabled ?? this.enabled,
      schema: schema ?? this.schema,
    );
  }

  Map<String, dynamic> toJson() => _$TelecomPushConfigurationToJson(this);
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
    this.includesCallsInRecents,
  });

  factory IOSPushConfiguration.fromJson(Map<String, dynamic> json) =>
      _$IOSPushConfigurationFromJson(json);

  /// App's Icon. using for display inside Callkit(iOS)
  final String? iconName;

  /// Type of handle CallKit should expect. The SDK sets the user ID as the
  /// handle value, so choose the type that matches your user ID format:
  /// - `generic`: arbitrary identifier (default).
  /// - `number`: phone-like digits, it's formatted as a number in CallKit.
  /// - `email`: an email address, it's displayed as an email in CallKit.
  final String? handleType;

  /// When true, wraps callerName/handle/extra into an encrypted JSON blob
  /// before sending to CallKit. Use this to hide raw IDs,
  /// but note the visible handle (ex. in Recents) will look like encoded text. Leave
  /// false for a clean, user-friendly handle string.
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

  /// Whether calls handled by this provider should be included in the system's Recents list.
  /// Defaults to true. Set to false to prevent calls from appearing in Recents.
  final bool? includesCallsInRecents;

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
    bool? includesCallsInRecents,
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
      includesCallsInRecents:
          includesCallsInRecents ?? this.includesCallsInRecents,
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
      includesCallsInRecents: other.includesCallsInRecents,
    );
  }

  Map<String, dynamic> toJson() => _$IOSPushConfigurationToJson(this);
}
