import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

/// A policy that defines how audio should be configured on both iOS and Android.
///
/// ## Predefined Policies
///
/// ### Broadcaster Policy
/// [AudioConfigurationPolicy.broadcaster] is designed for **active participation**
/// in calls, such as:
/// - Hosts or co-hosts in a livestream
/// - Participants in meetings or video calls
/// - Users who actively speak and interact
///
/// This policy treats the call as a **voice/video communication session**.
///
/// ### Viewer Policy
/// [AudioConfigurationPolicy.viewer] is designed for **passive consumption**
/// of audio/video content, such as:
/// - Viewers watching a livestream
/// - Audience members who only listen
/// - Users in watch-only mode
///
/// This policy treats the call as **media playback**.
///
/// ## Platform-Specific Differences
///
/// ### Android
///
/// **Broadcaster Policy:**
/// - Hardware volume buttons control **call volume** (not media volume)
/// - Echo cancellation and noise suppression are **enabled**
/// - Can automatically route between earpiece and speaker
///
/// **Viewer Policy:**
/// - Hardware volume buttons control **media volume**
/// - No echo cancellation or audio processing (higher fidelity)
/// - Enables stereo playout
/// - Always uses speaker/media output path
/// - Treated as regular media playback
///
/// ### iOS
///
/// **Broadcaster Policy:**
/// - Voice processing **enabled** (echo cancellation, noise reduction)
/// - Compatible with CallKit for system call integration
/// - Optimized for voice clarity over audio quality
///
/// **Viewer Policy:**
/// - Voice processing **bypassed** for pure, high-fidelity audio
/// - Always uses speaker by default
/// - Optimized for music/media quality
///
/// ## Custom Configuration
/// - [AudioConfigurationPolicy.custom] - Full control over platform settings
sealed class AudioConfigurationPolicy {
  const AudioConfigurationPolicy();

  const factory AudioConfigurationPolicy.broadcaster() = BroadcasterAudioPolicy;

  const factory AudioConfigurationPolicy.viewer() = ViewerAudioPolicy;

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

  bool get bypassVoiceProcessing;
}

/// Audio policy optimized for active participation in calls.
///
/// Use this policy when users have an active role such as:
/// - Meeting participants who speak
/// - Livestream hosts or co-hosts
/// - Interactive voice/video communication
///
/// This enables voice processing (echo cancellation, noise suppression)
/// and treats the session as a call on both platforms.
///
/// See [AudioConfigurationPolicy] for detailed platform-specific behavior.
class BroadcasterAudioPolicy extends AudioConfigurationPolicy {
  const BroadcasterAudioPolicy();

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

  @override
  bool get bypassVoiceProcessing => false;
}

/// Audio policy optimized for passive consumption of audio/video content.
///
/// Use this policy when users have a passive role such as:
/// - Livestream viewers (watch-only)
/// - Audience members who only listen
/// - Playback of recorded content
///
/// This disables voice processing and treats the session as media playback
/// on both platforms, providing higher audio fidelity.
///
/// See [AudioConfigurationPolicy] for detailed platform-specific behavior.
class ViewerAudioPolicy extends AudioConfigurationPolicy {
  const ViewerAudioPolicy();

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

  @override
  bool get bypassVoiceProcessing => true;
}

/// Custom audio policy with full control over platform settings.
class CustomAudioPolicy extends AudioConfigurationPolicy {
  /// At least one of [appleConfiguration] or [androidConfiguration] should be
  /// provided. If a configuration is not provided, [basePolicy] will be used
  /// for that platform.
  const CustomAudioPolicy({
    this.basePolicy = const BroadcasterAudioPolicy(),
    this.appleConfiguration,
    this.androidConfiguration,
    this.bypassVoiceProcessing = false,
  });

  /// The base policy used for platforms where a custom configuration
  /// is not provided. Defaults to [BroadcasterAudioPolicy].
  final AudioConfigurationPolicy basePolicy;

  final rtc.AppleAudioConfiguration? appleConfiguration;

  final rtc.AndroidAudioConfiguration? androidConfiguration;

  @override
  final bool bypassVoiceProcessing;

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
