import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../logger/impl/tagged_logger.dart';
import '../models/call_cid.dart';
import '../webrtc/model/stats/rtc_inbound_rtp_audio_stream.dart';
import '../webrtc/model/stats/rtc_stats.dart';
import 'client_event.dart';
import 'client_event_reporter.dart';
import 'client_event_types.dart';

const _tag = 'SV:MediaFrameReporter';

/// Emits the single-shot `FirstAudioFrame` / `FirstVideoFrame` telemetry events
/// for one call session. Each fires at most once.
///
/// - `FirstVideoFrame` uses a headless [rtc.RTCVideoRenderer] per remote video
///   track.
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

  final Map<String, rtc.RTCVideoRenderer> _renderers = {};

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

  /// Attaches a headless renderer to a remote video track to detect its first
  /// decoded/rendered frame.
  Future<void> onRemoteVideoTrack({
    required rtc.MediaStream stream,
    required String trackId,
  }) async {
    if (_videoReported || _disposed || _renderers.containsKey(trackId)) return;

    try {
      final renderer = rtc.RTCVideoRenderer();
      await renderer.initialize();

      // State may have changed while awaiting initialize().
      if (_videoReported || _disposed) {
        await renderer.dispose();
        return;
      }

      renderer.onFirstFrameRendered = () => _reportVideo(trackId);
      renderer.srcObject = stream;
      _renderers[trackId] = renderer;
    } catch (e) {
      _logger.w(() => '[onRemoteVideoTrack] renderer setup failed: $e');
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
    _disposeRenderers();
  }

  void _disposeRenderers() {
    for (final renderer in _renderers.values) {
      renderer
        ..srcObject = null
        ..dispose();
    }
    _renderers.clear();
  }

  void dispose() {
    _disposed = true;
    _disposeRenderers();
  }
}
