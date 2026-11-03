import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../../stream_video.dart';
import '../../errors/stream_video_exception_composer.dart';
import '../apple_audio_route.dart';

/// The Apple audio session of a call and its audio output.
///
/// A thin wrapper over `Helper.setAppleAudioConfiguration` and
/// `Helper.selectAudioOutput`, which remembers the configuration it applied
/// last so it can be restored.
@internal
class AppleAudioSession {
  AppleAudioSession({
    Future<void> Function(rtc.AppleAudioConfiguration) apply =
        rtc.Helper.setAppleAudioConfiguration,
  }) : _apply = apply;

  /// Sends a configuration to the platform.
  final Future<void> Function(rtc.AppleAudioConfiguration) _apply;

  rtc.AppleAudioConfiguration? _configuration;

  /// The configuration last applied with [set], if any.
  @visibleForTesting
  rtc.AppleAudioConfiguration? get configuration => _configuration;

  /// Applies [policy]'s Apple audio session configuration, asking for the
  /// loudspeaker as the built-in output when [speakerOn].
  Future<Result<None>> set({
    required AudioConfigurationPolicy policy,
    bool speakerOn = false,
  }) async {
    final configuration = policy.getAppleConfiguration(
      defaultToSpeaker: speakerOn,
    );
    try {
      await _apply(configuration);
      _configuration = configuration;
      return const Result.success(none);
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  /// Re-applies the configuration last applied with [set], if any.
  ///
  /// Resuming suspended audio restores the configuration the call's factory
  /// was built with, which asks for the loudspeaker only under a policy that
  /// defaults to it. This brings back the loudspeaker the call settings or
  /// an output change asked for since.
  Future<Result<None>> restore() async {
    final configuration = _configuration;
    if (configuration == null) return const Result.success(none);

    try {
      await _apply(configuration);
      return const Result.success(none);
    } catch (e, stk) {
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }

  /// Whether selecting [device] under [policy] asks for the loudspeaker as
  /// the built-in output.
  static bool speakerOnFor(
    RtcMediaDevice device,
    AudioConfigurationPolicy policy,
  ) {
    return resolveAppleSpeakerOn(
      policy: policy,
      speakerRequested: device.isBuiltInSpeaker,
      earpieceRequested: device.isBuiltInEarpiece,
    );
  }

  /// Routes the call's audio to [device].
  Future<void> selectOutput(RtcMediaDevice device) {
    return rtc.Helper.selectAudioOutput(device.id);
  }
}
