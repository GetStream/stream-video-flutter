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
/// ### HiFi Policy
/// [AudioConfigurationPolicy.hiFi] is designed for **broadcasting high-fidelity
/// audio**, such as:
/// - Live music streaming
/// - Screen sharing with stereo audio
///
/// This policy bypasses voice processing to enable stereo I/O and
/// treats the session as media on both platforms.
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
/// **HiFi Policy:**
/// - Same audio settings as Viewer Policy (media volume, no processing)
/// - Enables stereo input and output on the Audio Device Module
/// - Optimized for broadcasting high-fidelity / stereo audio
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
/// **HiFi Policy:**
/// - Voice processing **bypassed** for pure, high-fidelity audio
/// - Uses `playAndRecord` category for active microphone use
/// - Always uses speaker by default
///
/// ## Custom Configuration
/// - [AudioConfigurationPolicy.custom] - Full control over platform settings
sealed class AudioConfigurationPolicy {
  const AudioConfigurationPolicy();

  const factory AudioConfigurationPolicy.broadcaster() = BroadcasterAudioPolicy;

  const factory AudioConfigurationPolicy.viewer() = ViewerAudioPolicy;

  const factory AudioConfigurationPolicy.hiFi() = HiFiAudioPolicy;

  /// Custom policy allowing full control over platform-specific settings.
  ///
  /// Use this when you need specific audio configurations that differ from
  /// the predefined policies.
  ///
  /// You can provide only the configuration for the platform you want to customize,
  /// and use [basePolicy] to define defaults for the other platform.
  const factory AudioConfigurationPolicy.custom({
    AudioConfigurationPolicy basePolicy,
    rtc.AppleAudioConfiguration Function({bool defaultToSpeaker})?
    appleConfiguration,
    rtc.AndroidAudioConfiguration? androidConfiguration,
    bool bypassVoiceProcessing,
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
      appleAudioCategoryOptions: {
        if (defaultToSpeaker) rtc.AppleAudioCategoryOption.defaultToSpeaker,
        rtc.AppleAudioCategoryOption.mixWithOthers,
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

/// Audio policy optimized for broadcasting high-fidelity audio.
///
/// Use this policy when users need to **send** high-quality audio such as:
/// - Live music streaming or karaoke hosts
/// - Podcast hosts or professional streamers
/// - Screen sharing with stereo audio content
///
/// This policy bypasses voice processing (echo cancellation, noise suppression)
/// and configures the audio layer for stereo I/O and media-quality output.
///
/// On Android, this enables stereo input and output on the Audio Device Module
/// (ADM), which is required for capturing and sending stereo audio. Screen share
/// audio also benefits from this — it will be captured in stereo when this
/// policy is active.
///
/// **Requirements for stereo capture on Android:**
/// 1. The call type must have HiFi audio enabled (Stream Dashboard)
/// 2. The audio bitrate profile must be set to `musicHighQuality`
/// 3. This policy (or any policy with `bypassVoiceProcessing: true`) must be set
///
/// See [AudioConfigurationPolicy] for detailed platform-specific behavior.
class HiFiAudioPolicy extends AudioConfigurationPolicy {
  const HiFiAudioPolicy();

  @override
  rtc.AppleAudioConfiguration getAppleConfiguration({
    bool defaultToSpeaker = false,
  }) {
    return rtc.AppleAudioConfiguration(
      appleAudioMode: rtc.AppleAudioMode.default_,
      appleAudioCategory: rtc.AppleAudioCategory.playAndRecord,
      appleAudioCategoryOptions: {
        if (defaultToSpeaker) rtc.AppleAudioCategoryOption.defaultToSpeaker,
        rtc.AppleAudioCategoryOption.mixWithOthers,
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

  final rtc.AppleAudioConfiguration Function({bool defaultToSpeaker})?
  appleConfiguration;

  final rtc.AndroidAudioConfiguration? androidConfiguration;

  @override
  final bool bypassVoiceProcessing;

  @override
  rtc.AppleAudioConfiguration getAppleConfiguration({
    bool defaultToSpeaker = false,
  }) {
    return appleConfiguration?.call(defaultToSpeaker: defaultToSpeaker) ??
        basePolicy.getAppleConfiguration(defaultToSpeaker: defaultToSpeaker);
  }

  @override
  rtc.AndroidAudioConfiguration getAndroidConfiguration() {
    return androidConfiguration ?? basePolicy.getAndroidConfiguration();
  }
}
