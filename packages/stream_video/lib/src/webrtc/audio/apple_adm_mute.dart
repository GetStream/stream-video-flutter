import 'package:meta/meta.dart';

import '../../../stream_video.dart';
import '../peer_connection_factory.dart';

final _logger = taggedLogger(tag: 'SV:AppleAdmMute');

/// The microphone mute of the audio device module (ADM) on iOS and macOS.
///
/// Muting there keeps the audio track alive while no audio is captured, the
/// alternative to stopping the track on mute. A thin wrapper over the
/// factory's ADM calls, which never throws: failures are logged.
@internal
class AppleAdmMute {
  AppleAdmMute(this._pcFactory);

  final StreamPeerConnectionFactory _pcFactory;

  /// Whether [track] can be muted in the ADM: microphone tracks on iOS and
  /// macOS only.
  bool isSupported(RtcLocalTrack track) =>
      _pcFactory.isAppleAdmMicrophoneMuteSupported &&
      track.trackType == SfuTrackType.audio;

  /// Mutes or unmutes the microphone in the ADM.
  Future<void> setMuted(bool muted) async {
    try {
      await _pcFactory.setAppleAdmMicrophoneMuted(muted);
    } catch (e, stk) {
      _logger.w(() => '[setAppleAdmMicrophoneMuted] failed: $e\n$stk');
    }
  }

  /// Reads the ADM's own mute state, or `null` when it cannot be determined.
  Future<bool?> isMuted() async {
    try {
      return await _pcFactory.isAppleAdmMicrophoneMuted();
    } catch (e, stk) {
      _logger.w(() => '[getAppleAdmMicrophoneMuted] failed: $e\n$stk');
      return null;
    }
  }

  /// Syncs the ADM mute state with [track], to avoid mismatches after
  /// audio restarts or suspends. Idempotent: only updates when needed.
  ///
  /// A live track is never left muted; a disabled track that is not stopped
  /// on mute is kept muted; a track stopped on mute leaves the ADM alone.
  /// No-op without a track or on platforms without ADM-level mute.
  Future<void> reconcile(RtcLocalTrack? track) async {
    if (track == null) return;
    if (!isSupported(track)) return;

    final bool desiredMuted;
    if (track.mediaTrack.enabled) {
      // A live track must never stay silenced by a leftover ADM mute.
      desiredMuted = false;
    } else if (!track.stopTrackOnMute) {
      // A disabled track is the SDK's muted state when using ADM-level mute.
      desiredMuted = true;
    } else {
      // When the track is muted by stopping it, ADM mute is not used.
      return;
    }

    final actual = await isMuted();
    if (actual == desiredMuted) return;

    _logger.w(
      () =>
          '[reconcileAppleAdmMicrophoneMute] ADM mute out of sync '
          '(adm reported: $actual, expected: $desiredMuted), re-applying for '
          'track ${track.trackId}',
    );
    await setMuted(desiredMuted);
  }
}
