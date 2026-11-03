import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../../stream_video.dart';
import 'apple_audio_session.dart';

/// The audio session of a call and its audio output.
///
/// Only iOS has an audio session to configure; elsewhere [set] and [restore]
/// succeed without doing anything, so callers do not check the platform
/// themselves.
@internal
abstract interface class AudioSession {
  /// The audio session of the current platform: the Apple one on iOS, the
  /// default one elsewhere.
  factory AudioSession.forPlatform() {
    if (CurrentPlatform.isIos) return AppleAudioSession();
    return const DefaultAudioSession();
  }

  /// Applies [policy]'s audio session configuration, asking for the
  /// loudspeaker as the built-in output when [speakerOn].
  Future<Result<None>> set({
    required AudioConfigurationPolicy policy,
    bool speakerOn = false,
  });

  /// Re-applies the configuration last applied with [set], if any.
  Future<Result<None>> restore();

  /// Routes the call's audio to [device].
  Future<void> selectOutput(RtcMediaDevice device);
}

/// The audio session of a platform without one to configure: [set] and
/// [restore] succeed without doing anything, [selectOutput] switches the
/// output.
@internal
class DefaultAudioSession implements AudioSession {
  const DefaultAudioSession();

  @override
  Future<Result<None>> set({
    required AudioConfigurationPolicy policy,
    bool speakerOn = false,
  }) async => const Result.success(none);

  @override
  Future<Result<None>> restore() async => const Result.success(none);

  @override
  Future<void> selectOutput(RtcMediaDevice device) {
    return rtc.Helper.selectAudioOutput(device.id);
  }
}
