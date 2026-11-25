import 'third_party/flutter_webrtc/apple_audio_configuration.dart';

/// The app-wide audio of the platform: input and output selection, playout,
/// the Apple audio session and Android audio focus.
abstract class WebRtcAudio {
  /// Routes the audio output to [deviceId].
  Future<void> selectAudioOutput(String deviceId);

  /// Switches the running microphone capture to [deviceId]. Throws where
  /// `WebRtcCapabilities.switchesAudioInputInPlace` is false.
  Future<void> selectAudioInput(String deviceId);

  /// Pauses or resumes the playout of every remote audio track. Does nothing
  /// where `WebRtcCapabilities.supportsAudioPlayoutPause` is false.
  Future<void> setPlayoutPaused(bool paused);

  /// Applies [configuration] to the Apple audio session. iOS.
  Future<void> setAppleAudioConfiguration(
    AppleAudioConfiguration configuration,
  );

  /// Whether stereo playout is preferred, which bypasses voice processing.
  /// iOS.
  Future<void> setStereoPlayoutPreferred(bool preferred);

  /// Requests Android audio focus again for the call's audio after a loss.
  /// Throws on other platforms.
  Future<void> regainAndroidAudioFocus();

  /// Tells WebRTC whether the system manages Android audio focus for the call
  /// in progress. Throws where
  /// `WebRtcCapabilities.supportsSystemManagedAudioFocus` is false.
  Future<void> setAndroidAudioFocusHandledBySystem(bool handledBySystem);

  /// Shows the system picker for the audio output. iOS; throws elsewhere.
  Future<void> showAudioRoutePicker();

  /// Whether the microphone can be muted in the audio device module, see
  /// `PeerConnectionFactory.setMicrophoneMuted`. iOS and macOS.
  bool get supportsAudioModuleMicrophoneMute;
}
