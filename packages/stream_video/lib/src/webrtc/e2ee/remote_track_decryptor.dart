import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../../stream_video.dart';
import 'e2ee_mapping.dart';

final _logger = taggedLogger(tag: 'SV:RemoteTrackDecryptor');

/// Attaches an end-to-end decryptor to the receiver of each remote track.
///
/// A track that arrives before its participant is known is queued until
/// [flush] runs after the participant joins, or dropped by [discard] when
/// they leave. Does nothing when the call is unencrypted.
@internal
class RemoteTrackDecryptor {
  RemoteTrackDecryptor({
    required rtc.EncryptionManager? this._manager,
    required String? Function(String trackIdPrefix) this._userIdForTrackPrefix,
    required Future<rtc.RTCRtpReceiver?> Function(RtcRemoteTrack)
    this._receiverFor,
  });

  final rtc.EncryptionManager? _manager;
  final String? Function(String trackIdPrefix) _userIdForTrackPrefix;
  final Future<rtc.RTCRtpReceiver?> Function(RtcRemoteTrack) _receiverFor;

  /// Remote tracks that arrived before their participant was known.
  final _pending = <String, RtcRemoteTrack>{};

  /// Decrypts everything [track]'s receiver delivers, or queues the track
  /// until its participant is known.
  Future<void> attach(RtcRemoteTrack track) async {
    final manager = _manager;
    if (manager == null) return;

    final userId = _userIdForTrackPrefix(track.trackIdPrefix);
    if (userId == null) {
      _logger.d(
        () =>
            '[attach] no participant yet for '
            '${track.trackIdPrefix}; queueing ${track.trackId}',
      );
      _pending[track.trackId] = track;
      return;
    }

    final receiver = await _receiverFor(track);
    if (receiver == null) {
      _logger.w(
        () =>
            '[attach] no RTP receiver for ${track.trackId}; '
            'frames from $userId stay encrypted',
      );
      return;
    }

    try {
      await manager.decrypt(
        receiver,
        userId: userId,
        trackType: track.trackType.e2eeTrackType,
      );

      _logger.d(
        () =>
            '[attach] attached for userId: $userId, '
            'trackType: ${track.trackType}',
      );
    } catch (e, stk) {
      _logger.e(
        () => '[attach] failed for userId: $userId: $e',
      );
      _logger.v(() => '[attach] $stk');
    }
  }

  /// Retries decryptors that were waiting on a participant.
  Future<void> flush() async {
    if (_manager == null || _pending.isEmpty) return;

    for (final trackId in [..._pending.keys]) {
      final track = _pending.remove(trackId);
      if (track == null) continue;

      await attach(track);
    }
  }

  /// Drops decryptors still waiting on a participant who has left.
  void discard(String trackIdPrefix) {
    _pending.removeWhere(
      (_, track) => track.trackIdPrefix == trackIdPrefix,
    );
  }

  /// Drops every queued track.
  void clear() => _pending.clear();
}
