import 'package:meta/meta.dart';

import '../../../stream_video.dart';
import '../peer_connection_factory.dart';
import 'apple_adm_microphone_mute.dart';

/// The microphone mute of the audio device module (ADM).
///
/// Muting there keeps the microphone track alive while no audio is captured,
/// the alternative to stopping the track on mute. Platforms without it get a
/// no-op, so callers do not check the platform themselves.
@internal
abstract interface class AdmMicrophoneMute {
  /// The ADM mute [pcFactory] supports: the Apple one on iOS and macOS, none
  /// elsewhere.
  factory AdmMicrophoneMute.forFactory(StreamPeerConnectionFactory pcFactory) {
    if (pcFactory.isAppleAdmMicrophoneMuteSupported) {
      return AppleAdmMicrophoneMute(pcFactory);
    }
    return const NoAdmMicrophoneMute();
  }

  /// Whether [track] can be muted in the ADM.
  bool isSupported(RtcLocalTrack track);

  /// Mutes or unmutes the microphone in the ADM. Never throws.
  Future<void> setMuted(bool muted);

  /// The ADM's own mute state, or `null` when it cannot be determined.
  Future<bool?> isMuted();

  /// Syncs the ADM mute state with [track], to avoid mismatches after audio
  /// restarts or suspends.
  Future<void> reconcile(RtcLocalTrack? track);
}

/// The ADM mute of a platform that has none: no track is supported and every
/// call does nothing.
@internal
class NoAdmMicrophoneMute implements AdmMicrophoneMute {
  const NoAdmMicrophoneMute();

  @override
  bool isSupported(RtcLocalTrack track) => false;

  @override
  Future<void> setMuted(bool muted) async {}

  @override
  Future<bool?> isMuted() async => null;

  @override
  Future<void> reconcile(RtcLocalTrack? track) async {}
}
