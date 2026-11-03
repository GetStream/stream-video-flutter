import 'dart:async';

import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../stream_video.dart';
import '../webrtc/traced_peer_connection.dart';
import 'client_event_reporter.dart';
import 'client_event_types.dart';
import 'media_frame_reporter.dart';
import 'peer_connection_connect_reporter.dart';

/// The client events one call session reports about its peer connections
/// and its first remote frames.
@internal
class RtcSessionTelemetry {
  RtcSessionTelemetry({
    required ClientEventReporter reporter,
    required StreamCallCid callCid,
    String? sfuId,
    int retryCount = 0,
  }) : _reporter = reporter,
       _callCid = callCid,
       _sfuId = sfuId,
       _retryCount = retryCount,
       _mediaFrameReporter = MediaFrameReporter(
         reporter: reporter,
         callCid: callCid,
         sfuId: sfuId,
       );

  final ClientEventReporter _reporter;
  final StreamCallCid _callCid;
  final String? _sfuId;
  final int _retryCount;

  final MediaFrameReporter _mediaFrameReporter;
  PeerConnectionConnectReporter? _publisherConnectReporter;
  PeerConnectionConnectReporter? _subscriberConnectReporter;

  /// Reports how [subscriber] and, when there is one, [publisher] connect.
  void attach({
    required TracedStreamPeerConnection? publisher,
    required TracedStreamPeerConnection subscriber,
  }) {
    final subscriberReporter = _subscriberConnectReporter = _connectReporter(
      ClientEventPeerConnectionRole.subscribe,
    );
    subscriber
      ..onIceConnectionStateUpdated = subscriberReporter.onIceConnectionState
      ..onConnectionStateUpdated = subscriberReporter.onConnectionState;

    if (publisher == null) return;

    final publisherReporter = _publisherConnectReporter = _connectReporter(
      ClientEventPeerConnectionRole.publish,
    );
    publisher
      ..onIceConnectionStateUpdated = publisherReporter.onIceConnectionState
      ..onConnectionStateUpdated = publisherReporter.onConnectionState;
  }

  PeerConnectionConnectReporter _connectReporter(
    ClientEventPeerConnectionRole role,
  ) {
    return PeerConnectionConnectReporter(
      reporter: _reporter,
      callCid: _callCid,
      role: role,
      sfuId: _sfuId,
      retryCount: _retryCount,
    );
  }

  /// Watches [track], which arrived in [stream], for its first frame.
  void onRemoteTrack(RtcRemoteTrack track, rtc.MediaStream stream) {
    final kind = track.mediaTrack.kind;
    if (kind == 'audio') {
      _mediaFrameReporter.onRemoteAudioTrack(trackId: track.trackId);
    } else if (kind == 'video') {
      unawaited(
        _mediaFrameReporter.onRemoteVideoTrack(
          stream: stream,
          trackId: track.trackId,
        ),
      );
    }
  }

  /// Feeds the subscriber's periodic WebRTC [stats] to first-frame telemetry.
  void onSubscriberStats(List<RtcStats> stats) {
    _mediaFrameReporter.onSubscriberStats(stats);
  }

  /// Fails any peer connection attempt that never finished connecting, and
  /// stops watching for first frames.
  void dispose() {
    _publisherConnectReporter?.abortInFlight();
    _subscriberConnectReporter?.abortInFlight();
    _mediaFrameReporter.dispose();
  }
}
