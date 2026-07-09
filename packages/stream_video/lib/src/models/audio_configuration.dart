/// Neutral mirrors of `stream_webrtc_flutter`'s native audio-configuration
/// types, so `AudioConfigurationPolicy` doesn't leak a Flutter-plugin type
/// through its public API. Enum member names intentionally match the plugin
/// 1:1 so `StreamWebRtc` implementations can convert via `.name` round-trips.
library;

enum StreamAppleAudioMode {
  default_,
  gameChat,
  measurement,
  moviePlayback,
  spokenAudio,
  videoChat,
  videoRecording,
  voiceChat,
  voicePrompt,
}

enum StreamAppleAudioCategory {
  soloAmbient,
  playback,
  record,
  playAndRecord,
  multiRoute,
}

enum StreamAppleAudioCategoryOption {
  mixWithOthers,
  duckOthers,
  interruptSpokenAudioAndMixWithOthers,
  allowBluetooth,
  allowBluetoothA2DP,
  allowAirPlay,
  defaultToSpeaker,
}

class StreamAppleAudioConfiguration {
  const StreamAppleAudioConfiguration({
    this.appleAudioCategory,
    this.appleAudioCategoryOptions,
    this.appleAudioMode,
  });

  final StreamAppleAudioCategory? appleAudioCategory;
  final Set<StreamAppleAudioCategoryOption>? appleAudioCategoryOptions;
  final StreamAppleAudioMode? appleAudioMode;

  Map<String, dynamic> toMap() => <String, dynamic>{
    if (appleAudioCategory != null)
      'appleAudioCategory': appleAudioCategory!.name,
    if (appleAudioCategoryOptions != null)
      'appleAudioCategoryOptions': appleAudioCategoryOptions!
          .map((e) => e.name)
          .toList(),
    if (appleAudioMode != null) 'appleAudioMode': appleAudioMode!.name,
  };
}

enum StreamAndroidAudioMode {
  normal,
  callScreening,
  inCall,
  inCommunication,
  ringtone,
}

enum StreamAndroidAudioFocusMode {
  gain,
  gainTransient,
  gainTransientExclusive,
  gainTransientMayDuck,
}

enum StreamAndroidInterruptionSource {
  audioFocusOnly,
  telephonyOnly,
  audioFocusAndTelephony,
}

enum StreamAndroidAudioStreamType {
  accessibility,
  alarm,
  dtmf,
  music,
  notification,
  ring,
  system,
  voiceCall,
}

enum StreamAndroidAudioAttributesUsageType {
  alarm,
  assistanceAccessibility,
  assistanceNavigationGuidance,
  assistanceSonification,
  assistant,
  game,
  media,
  notification,
  notificationEvent,
  notificationRingtone,
  unknown,
  voiceCommunication,
  voiceCommunicationSignalling,
}

enum StreamAndroidAudioAttributesContentType {
  movie,
  music,
  sonification,
  speech,
  unknown,
}

class StreamAndroidAudioConfiguration {
  const StreamAndroidAudioConfiguration({
    this.manageAudioFocus,
    this.androidAudioMode,
    this.androidAudioFocusMode,
    this.androidAudioStreamType,
    this.androidAudioAttributesUsageType,
    this.androidAudioAttributesContentType,
    this.forceHandleAudioRouting,
  });

  /// Controls whether audio focus should be automatically managed during
  /// a WebRTC session.
  final bool? manageAudioFocus;
  final StreamAndroidAudioMode? androidAudioMode;
  final StreamAndroidAudioFocusMode? androidAudioFocusMode;
  final StreamAndroidAudioStreamType? androidAudioStreamType;
  final StreamAndroidAudioAttributesUsageType? androidAudioAttributesUsageType;
  final StreamAndroidAudioAttributesContentType?
  androidAudioAttributesContentType;

  /// On certain Android devices, audio routing does not function properly
  /// and bluetooth microphones will not work unless audio mode is set to
  /// `inCommunication` or `inCall`. Audio routing is turned off in those
  /// cases. If set to true, routing is attempted regardless of audio mode.
  final bool? forceHandleAudioRouting;

  Map<String, dynamic> toMap() => <String, dynamic>{
    if (manageAudioFocus != null) 'manageAudioFocus': manageAudioFocus,
    if (androidAudioMode != null) 'androidAudioMode': androidAudioMode!.name,
    if (androidAudioFocusMode != null)
      'androidAudioFocusMode': androidAudioFocusMode!.name,
    if (androidAudioStreamType != null)
      'androidAudioStreamType': androidAudioStreamType!.name,
    if (androidAudioAttributesUsageType != null)
      'androidAudioAttributesUsageType': androidAudioAttributesUsageType!.name,
    if (androidAudioAttributesContentType != null)
      'androidAudioAttributesContentType':
          androidAudioAttributesContentType!.name,
    if (forceHandleAudioRouting != null)
      'forceHandleAudioRouting': forceHandleAudioRouting,
  };
}
