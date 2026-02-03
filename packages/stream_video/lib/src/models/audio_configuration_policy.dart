import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

/// A policy that defines how audio should be configured on both iOS and Android.
///
/// Use one of the predefined policies:
/// - [AudioConfigurationPolicy.call] - Optimized for voice/video calls
/// - [AudioConfigurationPolicy.livestream] - Optimized for livestream playback
///
/// Or create a custom configuration:
/// - [AudioConfigurationPolicy.custom] - Full control over platform settings
sealed class AudioConfigurationPolicy {
  const AudioConfigurationPolicy();

  const factory AudioConfigurationPolicy.call() = CallAudioPolicy;

  const factory AudioConfigurationPolicy.livestream() = LivestreamAudioPolicy;

  /// Custom policy allowing full control over platform-specific settings.
  ///
  /// Use this when you need specific audio configurations that differ from
  /// the predefined policies.
  ///
  /// You can provide only the configuration for the platform you want to customize,
  /// and use [basePolicy] to define defaults for the other platform.
  const factory AudioConfigurationPolicy.custom({
    AudioConfigurationPolicy basePolicy,
    rtc.AppleAudioConfiguration? appleConfiguration,
    rtc.AndroidAudioConfiguration? androidConfiguration,
  }) = CustomAudioPolicy;

  rtc.AppleAudioConfiguration getAppleConfiguration({
    bool defaultToSpeaker = false,
  });

  rtc.AndroidAudioConfiguration getAndroidConfiguration();
}

/// Audio policy optimized for normal video/audio calls.
class CallAudioPolicy extends AudioConfigurationPolicy {
  const CallAudioPolicy();

  @override
  rtc.AppleAudioConfiguration getAppleConfiguration({
    bool defaultToSpeaker = false,
  }) {
    return rtc.AppleAudioConfiguration(
      appleAudioMode: defaultToSpeaker
          ? rtc.AppleAudioMode.videoChat
          : rtc.AppleAudioMode.voiceChat,
      appleAudioCategory: rtc.AppleAudioCategory.playAndRecord,
      appleAudioCategoryOptions: {
        if (defaultToSpeaker) rtc.AppleAudioCategoryOption.defaultToSpeaker,
        rtc.AppleAudioCategoryOption.mixWithOthers,
        rtc.AppleAudioCategoryOption.allowBluetooth,
        rtc.AppleAudioCategoryOption.allowBluetoothA2DP,
        rtc.AppleAudioCategoryOption.allowAirPlay,
      },
    );
  }

  @override
  rtc.AndroidAudioConfiguration getAndroidConfiguration() {
    return rtc.AndroidAudioConfiguration(
      androidAudioMode: rtc.AndroidAudioMode.inCommunication,
      androidAudioStreamType: rtc.AndroidAudioStreamType.voiceCall,
      androidAudioAttributesUsageType:
          rtc.AndroidAudioAttributesUsageType.voiceCommunication,
      androidAudioAttributesContentType:
          rtc.AndroidAudioAttributesContentType.speech,
      androidAudioFocusMode: rtc.AndroidAudioFocusMode.gain,
      forceHandleAudioRouting: true,
    );
  }
}

/// Audio policy optimized for livestream/broadcast scenarios.
class LivestreamAudioPolicy extends AudioConfigurationPolicy {
  const LivestreamAudioPolicy();

  @override
  rtc.AppleAudioConfiguration getAppleConfiguration({
    bool defaultToSpeaker = false,
  }) {
    return rtc.AppleAudioConfiguration(
      appleAudioMode: rtc.AppleAudioMode.default_,
      appleAudioCategory: rtc.AppleAudioCategory.playAndRecord,
      appleAudioCategoryOptions: const {
        rtc.AppleAudioCategoryOption.defaultToSpeaker,
        rtc.AppleAudioCategoryOption.mixWithOthers,
        rtc.AppleAudioCategoryOption.allowBluetooth,
        rtc.AppleAudioCategoryOption.allowBluetoothA2DP,
        rtc.AppleAudioCategoryOption.allowAirPlay,
      },
    );
  }

  @override
  rtc.AndroidAudioConfiguration getAndroidConfiguration() {
    return rtc.AndroidAudioConfiguration(
      androidAudioMode: rtc.AndroidAudioMode.normal,
      androidAudioStreamType: rtc.AndroidAudioStreamType.music,
      androidAudioAttributesUsageType:
          rtc.AndroidAudioAttributesUsageType.media,
      androidAudioAttributesContentType:
          rtc.AndroidAudioAttributesContentType.music,
      androidAudioFocusMode: rtc.AndroidAudioFocusMode.gain,
      forceHandleAudioRouting: false,
    );
  }
}

/// Custom audio policy with full control over platform settings.
class CustomAudioPolicy extends AudioConfigurationPolicy {
  /// At least one of [appleConfiguration] or [androidConfiguration] should be
  /// provided. If a configuration is not provided, [basePolicy] will be used
  /// for that platform.
  const CustomAudioPolicy({
    this.basePolicy = const CallAudioPolicy(),
    this.appleConfiguration,
    this.androidConfiguration,
  });

  /// The base policy used for platforms where a custom configuration
  /// is not provided. Defaults to [CallAudioPolicy].
  final AudioConfigurationPolicy basePolicy;

  final rtc.AppleAudioConfiguration? appleConfiguration;

  final rtc.AndroidAudioConfiguration? androidConfiguration;

  @override
  rtc.AppleAudioConfiguration getAppleConfiguration({
    bool defaultToSpeaker = false,
  }) {
    return appleConfiguration ??
        basePolicy.getAppleConfiguration(defaultToSpeaker: defaultToSpeaker);
  }

  @override
  rtc.AndroidAudioConfiguration getAndroidConfiguration() {
    return androidConfiguration ?? basePolicy.getAndroidConfiguration();
  }
}
