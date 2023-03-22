import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;

import '../disposable.dart';
import '../errors/video_error_composer.dart';
import '../logger/impl/tagged_logger.dart';
import '../models/call_cid.dart';
import '../utils/none.dart';
import '../utils/result.dart';
import 'model/stats/rtc_printable_stats.dart';
import 'model/stats/rtc_stats_mapper.dart';
import 'peer_type.dart';

/// {@template onStreamAdded}
/// Handler when a new [rtc.MediaStream] gets added.
/// {@endtemplate}
typedef OnStreamAdded = void Function(StreamPeerConnection, rtc.MediaStream);

/// {@template onRenegotiationNeeded}
/// Handler when there's a new negotiation.
/// {@endtemplate}
typedef OnRenegotiationNeeded = void Function(StreamPeerConnection);

/// {@template onIceCandidate}
/// Handler whenever we receive [rtc.RTCIceCandidate]s.
/// {@endtemplate}
typedef OnIceCandidate = void Function(
  StreamPeerConnection,
  rtc.RTCIceCandidate,
);

/// {@template onTrack}
/// Handler whenever we receive [rtc.RTCTrackEvent]s.
/// {@endtemplate}
typedef OnTrack = void Function(
  StreamPeerConnection,
  rtc.RTCTrackEvent,
);

/// {@template onTrack}
/// Handler whenever we receive [RtcPrintableStats].
/// {@endtemplate}
typedef OnStats = void Function(
  StreamPeerConnection,
  RtcPrintableStats,
);

/// Wrapper around the WebRTC connection that contains tracks.
class StreamPeerConnection extends Disposable {
  /// Creates [StreamPeerConnection] instance.
  StreamPeerConnection({
    required this.sessionId,
    required this.callCid,
    required this.type,
    required this.pc,
  }) {
    _initRtcCallbacks();
  }

  final _logger = taggedLogger(tag: 'SV:PeerConnection');

  final String sessionId;
  final StreamCallCid callCid;
  final StreamPeerType type;
  final rtc.RTCPeerConnection pc;

  /// {@macro onStreamAdded}
  OnStreamAdded? onStreamAdded;

  /// {@macro onRenegotiationNeeded}
  OnRenegotiationNeeded? onRenegotiationNeeded;

  /// {@macro onIceCandidate}
  OnIceCandidate? onIceCandidate;

  /// {@macro onTrack}
  OnTrack? onTrack;

  /// {@macro onTrack}
  OnStats? onStats;

  final _pendingCandidates = <rtc.RTCIceCandidate>[];

  /// Creates an offer and sets it as the local description.
  Future<Result<rtc.RTCSessionDescription>> createOffer([
    Map<String, dynamic> mediaConstraints = const {},
  ]) async {
    try {
      final offer = await pc.createOffer(mediaConstraints);
      await pc.setLocalDescription(offer);
      return Result.success(offer);
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Creates an answer and sets it as the local description.
  ///
  /// The remote description must be set before calling this method.
  Future<Result<rtc.RTCSessionDescription>> createAnswer([
    Map<String, dynamic> mediaConstraints = const {},
  ]) async {
    try {
      final answer = await pc.createAnswer(mediaConstraints);
      await pc.setLocalDescription(answer);
      return Result.success(answer);
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Sets the offer session description.
  Future<Result<void>> setRemoteOffer(
    String offerSdp,
  ) async {
    return setRemoteDescription(
      rtc.RTCSessionDescription(offerSdp, 'offer'),
    );
  }

  /// Sets the answer session description.
  Future<Result<void>> setRemoteAnswer(
    String answerSdp,
  ) async {
    return setRemoteDescription(
      rtc.RTCSessionDescription(answerSdp, 'answer'),
    );
  }

  /// Sets the remote description and adds any pending ice candidates.
  Future<Result<void>> setRemoteDescription(
    rtc.RTCSessionDescription sd,
  ) async {
    try {
      final result = await pc.setRemoteDescription(sd);
      for (final candidate in _pendingCandidates) {
        await pc.addCandidate(candidate);
      }
      _pendingCandidates.clear();
      return Result.success(result);
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Adds an ice candidate to the peer connection.
  ///
  /// If the peer connection is not yet ready, the candidate is added to a list
  /// of pending candidates.
  Future<Result<None>> addIceCandidate(rtc.RTCIceCandidate candidate) async {
    try {
      final remoteDescription = await pc.getRemoteDescription();
      if (remoteDescription == null) {
        _pendingCandidates.add(candidate);
        return Result.error('no remoteDescription set');
      }
      await pc.addCandidate(candidate);
      return Result.success(None());
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Adds a local [rtc.MediaStreamTrack] with audio to a given [connection].
  Future<rtc.RTCRtpTransceiver> addAudioTransceiver({
    required rtc.MediaStream stream,
    required rtc.MediaStreamTrack track,
    List<rtc.RTCRtpEncoding>? encodings,
  }) async {
    final transceiver = await pc.addTransceiver(
      track: track,
      kind: rtc.RTCRtpMediaType.RTCRtpMediaTypeAudio,
      init: rtc.RTCRtpTransceiverInit(
        direction: rtc.TransceiverDirection.SendOnly,
        streams: [stream],
        sendEncodings: encodings,
      ),
    );

    return transceiver;
  }

  /// Adds a local [rtc.MediaStreamTrack] with video to a given [connection].
  ///
  /// The video is then sent in three different resolutions using simulcast.
  Future<rtc.RTCRtpTransceiver> addVideoTransceiver({
    required rtc.MediaStream stream,
    required rtc.MediaStreamTrack track,
    List<rtc.RTCRtpEncoding>? encodings,
  }) async {
    final transceiver = await pc.addTransceiver(
      track: track,
      kind: rtc.RTCRtpMediaType.RTCRtpMediaTypeVideo,
      init: rtc.RTCRtpTransceiverInit(
        streams: [stream],
        direction: rtc.TransceiverDirection.SendOnly,
        sendEncodings: encodings,
      ),
    );

    return transceiver;
  }

  void getStats() {
    pc.getStats();
  }

  void _initRtcCallbacks() {
    pc
      ..onAddStream = _onAddStream
      ..onRemoveStream = _onRemoveStream
      ..onAddTrack = _onAddTrack
      ..onTrack = _onTrack
      ..onRemoveTrack = _onRemoveTrack
      ..onIceCandidate = _onIceCandidate
      ..onIceConnectionState = _onIceConnectionState
      ..onRenegotiationNeeded = _onRenegotiationNeeded;
  }

  void _dropRtcCallbacks() {
    pc
      ..onAddStream = null
      ..onRemoveStream = null
      ..onAddTrack = null
      ..onRemoveTrack = null
      ..onIceCandidate = null
      ..onIceConnectionState = null
      ..onRenegotiationNeeded = null;
  }

  void _onAddStream(rtc.MediaStream stream) {
    _logger.v(() => '[onAddStream] stream.id: ${stream.id}');
    onStreamAdded?.call(this, stream);
  }

  void _onRemoveStream(rtc.MediaStream stream) {
    _logger.v(() => '[onRemoveStream] stream.id: ${stream.id}');
  }

  void _onAddTrack(rtc.MediaStream stream, rtc.MediaStreamTrack track) {
    _logger.v(
      () => '[onAddTrack] stream.id: ${stream.id}, track.id: ${track.id}, '
          'track.kind: ${track.kind}',
    );
  }

  void _onTrack(rtc.RTCTrackEvent event) {
    _logger.v(
      () => '[onTrack] event: $event',
    );
    onTrack?.call(this, event);
  }

  void _onRemoveTrack(rtc.MediaStream stream, rtc.MediaStreamTrack track) {
    _logger.v(
      () => '[onRemoveTrack] stream.id: ${stream.id}, track.id: ${track.id}, '
          'track.kind: ${track.kind}',
    );
  }

  void _onIceCandidate(rtc.RTCIceCandidate iceCandidate) {
    onIceCandidate?.call(this, iceCandidate);
  }

  void _onIceConnectionState(rtc.RTCIceConnectionState state) {
    _logger.v(() => '[onIceConnectionState] state: $state');

    switch (state) {
      case rtc.RTCIceConnectionState.RTCIceConnectionStateConnected:
        _observeStats();
        break;
      case rtc.RTCIceConnectionState.RTCIceConnectionStateClosed:
      case rtc.RTCIceConnectionState.RTCIceConnectionStateFailed:
      case rtc.RTCIceConnectionState.RTCIceConnectionStateDisconnected:
        _statsTimer?.cancel();
        break;
      default:
        break;
    }
  }

  Timer? _statsTimer;

  void _observeStats() {
    _statsTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        final stats = await pc.getStats();
        final rtcStats = stats.toRtcStats();
        onStats?.call(this, rtcStats);
      } catch (e, stk) {
        _logger.e(() => '[getStats] failed: $e; $stk');
      }
    });
  }

  void _onRenegotiationNeeded() {
    _logger.i(() => '[onRenegotiationNeeded] no args');
    onRenegotiationNeeded?.call(this);
  }

  @override
  Future<void> dispose() async {
    _dropRtcCallbacks();
    _statsTimer?.cancel();
    _statsTimer = null;
    onStreamAdded = null;
    onRenegotiationNeeded = null;
    onIceCandidate = null;
    onTrack = null;
    _pendingCandidates.clear();
    await pc.dispose();
    return await super.dispose();
  }
}

extension on rtc.StatsReport {
  String stringify() {
    return 'ts: $timestamp, id: $id, type: $type, values: $values';
  }
}
