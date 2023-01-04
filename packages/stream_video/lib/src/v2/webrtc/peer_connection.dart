import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:stream_video/src/v2/errors/video_error.dart';
import 'package:stream_video/src/v2/utils/result.dart';
import 'package:stream_video/src/v2/webrtc/peer_type.dart';

/// Wrapper around the WebRTC connection that contains tracks.
class StreamPeerConnection {
  StreamPeerConnection({
    required this.sessionId,
    required this.callCid,
    required this.type,
    required this.pc,
  }) {
    _initRtcCallbacks();
  }
  final String sessionId;
  final String callCid;
  final StreamPeerType type;
  final rtc.RTCPeerConnection pc;

  final _pendingCandidates = <rtc.RTCIceCandidate>[];
  late rtc.RTCRtpTransceiver audioTransceiver;
  late rtc.RTCRtpTransceiver videoTransceiver;

  /// Creates an offer and sets it as the local description.
  Future<Result<rtc.RTCSessionDescription>> createOffer() async {
    try {
      final offer = await pc.createOffer();
      await pc.setLocalDescription(offer);
      return Success(offer);
    } catch (e) {
      return Failure(VideoError.from(e));
    }
  }

  /// Creates an answer and sets it as the local description.
  ///
  /// The remote description must be set before calling this method.
  Future<Result<rtc.RTCSessionDescription>> createAnswer() async {
    try {
      final answer = await pc.createAnswer();
      await pc.setLocalDescription(answer);
      return Success(answer);
    } catch (e) {
      return Failure(VideoError.from(e));
    }
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
    } catch (e) {
      return Failure(VideoError.from(e));
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
    } catch (e) {
      return Failure(VideoError.from(e));
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
      ..onRemoveTrack = _onRemoveTrack
      ..onIceCandidate = _onIceCandidate
      ..onIceConnectionState = _onIceConnectionState
      ..onRenegotiationNeeded = _onRenegotiationNeeded;
  }

  void _onAddStream(rtc.MediaStream stream) {
    //TODO
  }

  void _onRemoveStream(rtc.MediaStream stream) {
    //TODO
  }

  void _onAddTrack(rtc.MediaStream stream, rtc.MediaStreamTrack track) {
    //TODO
  }

  void _onRemoveTrack(rtc.MediaStream stream, rtc.MediaStreamTrack track) {
    //TODO
  }

  void _onIceCandidate(rtc.RTCIceCandidate stream) {
    //TODO
  }

  void _onIceConnectionState(rtc.RTCIceConnectionState state) {
    //TODO
  }

  void _onRenegotiationNeeded() {
    //TODO
  }
}
