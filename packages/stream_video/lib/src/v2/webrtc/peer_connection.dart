import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:stream_video/src/disposable.dart';
import 'package:stream_video/src/logger/stream_logger.dart';
import 'package:stream_video/src/v2/errors/video_error.dart';
import 'package:stream_video/src/v2/errors/video_error_composer.dart';
import 'package:stream_video/src/v2/utils/result.dart';
import 'package:stream_video/src/v2/webrtc/peer_type.dart';
import 'package:stream_video/stream_video.dart';

/// {@template onStreamAdded}
/// Handler when a new [MediaStream] gets added.
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
  final String callCid;
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

  final _pendingCandidates = <rtc.RTCIceCandidate>[];
  late rtc.RTCRtpTransceiver audioTransceiver;
  late rtc.RTCRtpTransceiver videoTransceiver;

  /// Creates an offer and sets it as the local description.
  Future<Result<rtc.RTCSessionDescription>> createOffer([
    Map<String, dynamic> mediaConstraints = const {},
  ]) async {
    try {
      final offer = await pc.createOffer(mediaConstraints);
      await pc.setLocalDescription(offer);
      return Success(offer);
    } catch (e, stk) {
      return Failure(VideoErrors.compose(e, stk));
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
      return Success(answer);
    } catch (e, stk) {
      return Failure(VideoErrors.compose(e, stk));
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
      return Success(result);
    } catch (e, stk) {
      return Failure(VideoErrors.compose(e, stk));
    }
  }

  /// Adds an ice candidate to the peer connection.
  ///
  /// If the peer connection is not yet ready, the candidate is added to a list
  /// of pending candidates.
  Future<Result<void>> addIceCandidate(rtc.RTCIceCandidate candidate) async {
    try {
      final remoteDescription = await pc.getRemoteDescription();
      if (remoteDescription == null) {
        _pendingCandidates.add(candidate);
        return Failure(VideoError(message: 'no remoteDescription set'));
      }
      final result = await pc.addCandidate(candidate);
      return Success(result);
    } catch (e, stk) {
      return Failure(VideoErrors.compose(e, stk));
    }
  }

  /// Adds a local [MediaStreamTrack] with audio to a given [connection],
  /// with its [streamIds].
  Future<void> addAudioTransceiver({
    required rtc.MediaStreamTrack track,
    required List<String> streamIds,
  }) async {
    final fullQuality = rtc.RTCRtpEncoding(
      rid: 'a',
    );

    final transceiverInit = rtc.RTCRtpTransceiverInit(
      direction: rtc.TransceiverDirection.SendOnly,
      //streams: streamIds,
      sendEncodings: [fullQuality],
    );

    final transceiver = await pc.addTransceiver(
      track: track,
      kind: rtc.RTCRtpMediaType.RTCRtpMediaTypeAudio,
      init: transceiverInit,
    );

    audioTransceiver = transceiver;
  }

  /// Adds a local [MediaStreamTrack] with video to a given [connection],
  /// with its [streamIds].
  ///
  /// The video is then sent in three different resolutions using simulcast.
  Future<void> addVideoTransceiver({
    required rtc.MediaStreamTrack track,
    required List<String> streamIds,
    List<rtc.RTCRtpEncoding>? encodings,
  }) async {
    final transceiverInit = rtc.RTCRtpTransceiverInit(
      direction: rtc.TransceiverDirection.SendOnly,
      //streams: streamIds,
      sendEncodings: _buildVideoEncodings(),
    );

    final transceiver = await pc.addTransceiver(
      track: track,
      kind: rtc.RTCRtpMediaType.RTCRtpMediaTypeAudio,
      init: transceiverInit,
    );

    videoTransceiver = transceiver;
  }

  List<rtc.RTCRtpEncoding> _buildVideoEncodings() {
    final fullQuality = rtc.RTCRtpEncoding(
      rid: 'f',
      maxBitrate: 1200000,
    );
    final halfQuality = rtc.RTCRtpEncoding(
      rid: 'h',
      scaleResolutionDownBy: 2,
      maxBitrate: 500000,
    );

    final quarterQuality = rtc.RTCRtpEncoding(
      rid: 'q',
      scaleResolutionDownBy: 4,
      maxBitrate: 125000,
    );
    return [fullQuality, halfQuality, quarterQuality];
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
  }

  void _onRenegotiationNeeded() {
    _logger.i(() => '[onRenegotiationNeeded] no args');
    onRenegotiationNeeded?.call(this);
  }

  @override
  Future<void> dispose() async {
    _dropRtcCallbacks();
    await pc.dispose();
    return await super.dispose();
  }
}
