import 'package:meta/meta.dart';

import 'third_party/flutter_webrtc/apple_audio_configuration.dart';

/// The app-wide audio of the platform: input and output selection, playout,
/// the Apple audio session and Android audio focus.
///
/// Implemented by the WebRTC packages only.
@sealed
abstract class WebRtcAudio {
  /// Routes the audio output to [deviceId].
  Future<void> selectAudioOutput(String deviceId);

  /// Switches the running microphone capture to [deviceId]. Throws where
  /// `WebRtcCapabilities.switchesAudioInputInPlace` is false.
  Future<void> selectAudioInput(String deviceId);

  /// Pauses or resumes the playout of every remote audio track. Does nothing
  /// where `WebRtcCapabilities.supportsAudioPlayoutPause` is false.
  Future<void> setPlayoutPaused(bool paused);

  /// Whether the app has an audio session to configure with
  /// [setAppleAudioConfiguration]. iOS.
  bool get hasAudioSession;

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

  /// Whether the audio device in the group [groupId], as
  /// `MediaDeviceInfo.groupId` or `AudioRoute.groupId` report it, is
  /// external, such as a headset or a car. Browsers report an opaque
  /// `groupId`, so it is rarely true there.
  bool isExternalDevice(String? groupId);
}
