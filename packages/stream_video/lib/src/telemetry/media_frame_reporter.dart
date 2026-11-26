import 'dart:async';

import 'package:stream_webrtc_interface/stream_webrtc_interface.dart' as rtc;

import '../logger/impl/tagged_logger.dart';
import '../models/call_cid.dart';
import '../webrtc/model/stats/rtc_inbound_rtp_audio_stream.dart';
import '../webrtc/model/stats/rtc_stats.dart';
import '../webrtc/webrtc_engine.dart';
import 'client_event.dart';
import 'client_event_reporter.dart';
import 'client_event_types.dart';

const _tag = 'SV:MediaFrameReporter';

/// Emits the single-shot `FirstAudioFrame` / `FirstVideoFrame` telemetry events
/// for one call session. Each fires at most once.
///
/// - `FirstVideoFrame` watches each remote video track with a
///   [rtc.FirstFrameWatcher].
/// - `FirstAudioFrame` is detected from inbound-audio RTP stats
///   (`packetsReceived > 0`).
class MediaFrameReporter {
  MediaFrameReporter({
    required this.reporter,
    required this.callCid,
    this.sfuId,
  });

  final ClientEventReporter reporter;
  final StreamCallCid callCid;
  final String? sfuId;

  final _logger = taggedLogger(tag: _tag);

  bool _audioReported = false;
  bool _videoReported = false;
  bool _disposed = false;

  final Map<String, rtc.FirstFrameWatcher> _watchers = {};

  /// The tracks whose watch is starting or running.
  final Set<String> _watchedTrackIds = {};

  String? _audioTrackId;

  /// Records the remote audio track so [onSubscriberStats] can attribute the
  /// `FirstAudioFrame` event to it.
  void onRemoteAudioTrack({required String trackId}) {
    if (_audioReported || _disposed) return;
    _audioTrackId ??= trackId;
  }

  /// Fed the subscriber's periodic WebRTC stats; reports `FirstAudioFrame` the
  /// first time inbound audio packets are seen.
  void onSubscriberStats(List<RtcStats> stats) {
    if (_audioReported || _disposed || _audioTrackId == null) return;
    final flowing = stats.whereType<RtcInboundRtpAudioStream>().any(
      (s) => (s.packetsReceived ?? 0) > 0,
    );
    if (flowing) _reportAudio();
  }

  /// Watches a remote video track for its first decoded frame.
  Future<void> onRemoteVideoTrack({
    required rtc.MediaStream stream,
    required String trackId,
  }) async {
    if (_videoReported || _disposed) return;
    // Claimed before the await, so a second call for the track starts no
    // second watch.
    if (!_watchedTrackIds.add(trackId)) return;

    try {
      final watcher = await webRtcEngine.watchFirstFrame(
        stream,
        onFirstFrame: (_) => _reportVideo(trackId),
      );

      // State may have changed while the watch started.
      if (_videoReported || _disposed) {
        await watcher.dispose();
        return;
      }

      _watchers[trackId] = watcher;
    } catch (e) {
      _watchedTrackIds.remove(trackId);
      _logger.w(() => '[onRemoteVideoTrack] first frame watch failed: $e');
    }
  }

  void _reportAudio() {
    if (_audioReported || _disposed) return;
    _audioReported = true;
    reporter.reportEvent(
      callCid,
      ClientEventStage.firstAudioFrame,
      details: ClientEventDetails(trackId: _audioTrackId, sfuId: sfuId),
    );
  }

  void _reportVideo(String trackId) {
    if (_videoReported || _disposed) return;
    _videoReported = true;
    reporter.reportEvent(
      callCid,
      ClientEventStage.firstVideoFrame,
      details: ClientEventDetails(trackId: trackId, sfuId: sfuId),
    );
    _disposeWatchers();
  }

  void _disposeWatchers() {
    for (final MapEntry(key: trackId, value: watcher) in _watchers.entries) {
      unawaited(
        watcher.dispose().catchError((Object e) {
          _logger.w(() => '[dispose] watcher of $trackId failed: $e');
        }),
      );
    }
    _watchers.clear();
  }

  void dispose() {
    _disposed = true;
    _disposeWatchers();
  }
}
