import 'dart:async';

import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../protobuf/video/sfu/models/models.pbenum.dart';
import '../../protobuf/video/sfu/signal_rpc/signal.pb.dart';
import '../disposable.dart';
import '../errors/video_error.dart';
import '../errors/video_error_composer.dart';
import '../logger/impl/tagged_logger.dart';
import '../models/call_cid.dart';
import '../sfu/data/models/sfu_error.dart';
import '../sfu/sfu_client.dart';
import '../utils/none.dart';
import '../utils/result.dart';
import '../utils/standard.dart';
import 'model/stats/rtc_printable_stats.dart';
import 'model/stats/rtc_stats.dart';
import 'model/stats/rtc_stats_mapper.dart';
import 'peer_type.dart';
import 'sdp/editor/sdp_editor.dart';
import 'sdp/sdp.dart';

/// {@template onStreamAdded}
/// Handler when a new [rtc.MediaStream] gets added.
/// {@endtemplate}
typedef OnStreamAdded = void Function(StreamPeerConnection, rtc.MediaStream);

/// {@template onRenegotiationNeeded}
/// Handler when there's a new negotiation.
/// {@endtemplate}
typedef OnRenegotiationNeeded = void Function(StreamPeerConnection);

/// {@template onReconnectionNeeded}
/// Handler when a reconnection is needed.
/// The [SfuReconnectionStrategy] indicates how the reconnection should be handled.
/// {@endtemplate}
typedef OnReconnectionNeeded = void Function(
  StreamPeerConnection,
  SfuReconnectionStrategy,
);

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
    required this.sfuClient,
    required this.sessionId,
    required this.callCid,
    required this.type,
    required this.pc,
    required this.sdpEditor,
    this.iceRestartDelay = const Duration(milliseconds: 2500),
  }) {
    _initRtcCallbacks();
  }

  final _logger = taggedLogger(tag: 'SV:PeerConnection');

  final SfuClient sfuClient;
  final String sessionId;
  final StreamCallCid callCid;
  final StreamPeerType type;
  final rtc.RTCPeerConnection pc;
  final SdpEditor sdpEditor;
  final Duration iceRestartDelay;

  Timer? iceRestartTimeout;

  /// {@macro onStreamAdded}
  OnStreamAdded? onStreamAdded;

  /// {@macro onRenegotiationNeeded}
  OnRenegotiationNeeded? onRenegotiationNeeded;

  /// {@macro onReconnectionNeeded}
  OnReconnectionNeeded? onReconnectionNeeded;

  /// {@macro onIceCandidate}
  OnIceCandidate? onIceCandidate;

  /// {@macro onTrack}
  OnTrack? onTrack;

  final _pendingCandidates = <rtc.RTCIceCandidate>[];

  /// Attempts to restart ICE on the `RTCPeerConnection`.
  /// If the restart fails, this method will trigger onReconnectionNeeded with
  /// the appropriate reconnection strategy based on the error.
  void _tryRestartIce() {
    _logger.v(() => '[restartIce] no args');
    restartIce().then((result) {
      if (result.isFailure) {
        final error = result.getErrorOrNull();
        if (error is VideoErrorWithCause && error.cause is SfuError) {
          final sfuError = error.cause as SfuError;
          if (sfuError.code == SfuErrorCode.participantSignalLost) {
            onReconnectionNeeded?.call(this, SfuReconnectionStrategy.fast);
            return;
          }
        }

        onReconnectionNeeded?.call(this, SfuReconnectionStrategy.rejoin);
      }
    });
  }

  Future<Result<void>> restartIce() async {
    _logger.v(() => '[restartIce] #$type; no args');
    try {
      if (type == StreamPeerType.publisher) {
        try {
          await pc.restartIce();
        } catch (e, stk) {
          return Result.failure(VideoErrors.compose(e, stk));
        }
        return const Result.success(null);
      } else {
        return await sfuClient.restartIce(
          ICERestartRequest(
            sessionId: sessionId,
            peerType: PeerType.PEER_TYPE_SUBSCRIBER,
          ),
        );
      }
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Creates an offer and sets it as the local description.
  Future<Result<rtc.RTCSessionDescription>> createOffer([
    Map<String, dynamic> mediaConstraints = const {},
  ]) async {
    try {
      final localOffer = await pc.createOffer(mediaConstraints);
      final modifiedSdp = sdpEditor.edit(localOffer.sdp?.let(Sdp.localOffer));
      final modifiedOffer = localOffer.copyWith(sdp: modifiedSdp);

      await setLocalDescription(modifiedOffer);
      return Result.success(modifiedOffer);
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
      _logger.v(
        () => '[createLocalAnswer] #$type; mediaConstraints: $mediaConstraints',
      );
      final localAnswer = await pc.createAnswer(mediaConstraints);
      final modifiedSdp = sdpEditor.edit(localAnswer.sdp?.let(Sdp.localAnswer));
      final modifiedAnswer = localAnswer.copyWith(sdp: modifiedSdp);
      _logger.v(
        () => '[createLocalAnswer] #$type; sdp:\n${modifiedAnswer.sdp}',
      );
      await setLocalDescription(modifiedAnswer);
      return Result.success(modifiedAnswer);
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Sets the offer session description.
  Future<Result<void>> setRemoteOffer(
    String remoteOfferSdp,
  ) async {
    final modifiedSdp = sdpEditor.edit(Sdp.remoteOffer(remoteOfferSdp));
    _logger.v(() => '[setRemoteOffer] #$type; sdp:\n$modifiedSdp');
    return setRemoteDescription(
      rtc.RTCSessionDescription(modifiedSdp, 'offer'),
    );
  }

  /// Sets the answer session description.
  Future<Result<void>> setRemoteAnswer(
    String remoteAnswerSdp,
  ) async {
    final modifiedSdp = sdpEditor.edit(Sdp.remoteAnswer(remoteAnswerSdp));
    _logger.v(() => '[setRemoteAnswer] #$type; sdp:\n$modifiedSdp');
    return setRemoteDescription(
      rtc.RTCSessionDescription(modifiedSdp, 'answer'),
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

  //Sets the local description
  Future<Result<void>> setLocalDescription(
    rtc.RTCSessionDescription description,
  ) async {
    try {
      final result = await pc.setLocalDescription(description);
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
      return const Result.success(none);
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Adds a local [rtc.MediaStreamTrack] with audio to the current connection.
  Future<Result<rtc.RTCRtpTransceiver>> addAudioTransceiver({
    required rtc.MediaStreamTrack track,
    List<rtc.RTCRtpEncoding>? encodings,
  }) async {
    try {
      final transceiver = await pc.addTransceiver(
        track: track,
        kind: rtc.RTCRtpMediaType.RTCRtpMediaTypeAudio,
        init: rtc.RTCRtpTransceiverInit(
          direction: rtc.TransceiverDirection.SendOnly,
          sendEncodings: encodings,
        ),
      );

      return Result.success(transceiver);
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Adds a local [rtc.MediaStreamTrack] with video to a given connection.
  ///
  /// The video is then sent in three different resolutions using simulcast.
  Future<Result<rtc.RTCRtpTransceiver>> addVideoTransceiver({
    required rtc.MediaStreamTrack track,
    List<rtc.RTCRtpEncoding>? encodings,
  }) async {
    try {
      final transceiver = await pc.addTransceiver(
        track: track,
        kind: rtc.RTCRtpMediaType.RTCRtpMediaTypeVideo,
        init: rtc.RTCRtpTransceiverInit(
          direction: rtc.TransceiverDirection.SendOnly,
          sendEncodings: encodings,
        ),
      );

      return Result.success(transceiver);
    } catch (e, stk) {
      return Result.failure(VideoErrors.compose(e, stk));
    }
  }

  /// Checks if the `RTCPeerConnection` is healthy.
  /// It checks the ICE connection state and the peer connection state.
  /// If either state is `failed`, `disconnected`, or `closed`,
  /// it returns `false`, otherwise it returns `true`.
  bool isHealthy() {
    const failedStates = {
      rtc.RTCIceConnectionState.RTCIceConnectionStateFailed,
      rtc.RTCIceConnectionState.RTCIceConnectionStateClosed,
      rtc.RTCIceConnectionState.RTCIceConnectionStateDisconnected,
      rtc.RTCPeerConnectionState.RTCPeerConnectionStateFailed,
      rtc.RTCPeerConnectionState.RTCPeerConnectionStateClosed,
      rtc.RTCPeerConnectionState.RTCPeerConnectionStateDisconnected,
    };

    final iceState = pc.iceConnectionState;
    final connectionState = pc.connectionState;
    return !failedStates.contains(iceState) &&
        !failedStates.contains(connectionState);
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
      ..onConnectionState = _onConnectionState
      ..onRenegotiationNeeded = _onRenegotiationNeeded;
  }

  void _dropRtcCallbacks() {
    pc
      ..onAddStream = null
      ..onRemoveStream = null
      ..onAddTrack = null
      ..onTrack = null
      ..onRemoveTrack = null
      ..onIceCandidate = null
      ..onIceConnectionState = null
      ..onRenegotiationNeeded = null
      ..onIceGatheringState = null
      ..onSignalingState = null
      ..onConnectionState = null
      ..onDataChannel = null;
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
      case rtc.RTCIceConnectionState.RTCIceConnectionStateFailed:
        // in the `failed` state, we try to restart ICE immediately
        _logger.i(() => 'restartICE due to failed connection');
        _tryRestartIce();
        break;
      case rtc.RTCIceConnectionState.RTCIceConnectionStateDisconnected:
        // in the `disconnected` state, we schedule a restartICE() after a delay
        // as the pc might recover the connection in the meantime
        _logger.i(() => 'disconnected connection, scheduling restartICE');
        iceRestartTimeout?.cancel();
        iceRestartTimeout = Timer(iceRestartDelay, () {
          final currentState = pc.iceConnectionState;
          if (currentState ==
                  rtc.RTCIceConnectionState.RTCIceConnectionStateDisconnected ||
              currentState ==
                  rtc.RTCIceConnectionState.RTCIceConnectionStateFailed) {
            _tryRestartIce();
          }
        });
        break;
      case rtc.RTCIceConnectionState.RTCIceConnectionStateConnected:
        // in the `connected` state, we clear the ice restart timeout if it exists
        _logger.i(() => 'connected connection, canceling restartICE');
        iceRestartTimeout?.cancel();
        iceRestartTimeout = null;
      default:
        break;
    }
  }

  void _onConnectionState(rtc.RTCPeerConnectionState state) {
    if (state == rtc.RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
      _logger.w(() => '[onConnectionState] state: $state');
      onReconnectionNeeded?.call(this, SfuReconnectionStrategy.rejoin);
    } else {
      _logger.v(() => '[onConnectionState] state: $state');
    }
  }

  void _onRenegotiationNeeded() {
    _logger.v(() => '[onRenegotiationNeeded] no args');

    onRenegotiationNeeded?.call(this);
  }

  Future<
      ({
        List<RtcStats> rtcStats,
        RtcPrintableStats printable,
        List<Map<String, dynamic>> rawStats,
      })> getStats() async {
    final stats = await pc.getStats();

    final rtcPrintableStats = stats.toPrintableRtcStats();
    final rawStats = stats.toRawStats();
    final rtcStats = stats
        .map((report) => report.toRtcStats())
        .where((element) => element != null)
        .cast<RtcStats>()
        .toList();

    return (
      rtcStats: rtcStats,
      printable: rtcPrintableStats,
      rawStats: rawStats,
    );
  }

  @override
  Future<void> dispose() async {
    _logger.d(() => '[dispose] no args');
    _dropRtcCallbacks();
    iceRestartTimeout?.cancel();
    iceRestartTimeout = null;
    onStreamAdded = null;
    onRenegotiationNeeded = null;
    onReconnectionNeeded = null;
    onIceCandidate = null;
    onTrack = null;
    _pendingCandidates.clear();
    await pc.dispose();
    return await super.dispose();
  }
}

extension on rtc.RTCSessionDescription {
  rtc.RTCSessionDescription copyWith({
    String? type,
    String? sdp,
  }) {
    return rtc.RTCSessionDescription(
      sdp ?? this.sdp,
      type ?? this.type,
    );
  }
}
