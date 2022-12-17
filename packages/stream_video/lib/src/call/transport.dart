import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import '../disposable.dart';
import '../logger/logger.dart';
import '../types/other.dart';

/// a wrapper around PeerConnection
class Transport with Disposable {
  Transport._(this.pc);

  /// create a new Transport with the given [configuration] and [constraints].
  static Future<Transport> create({
    required RTCConfiguration configuration,
    Map<String, dynamic> constraints = const {},
  }) async {
    logger.fine('[PCTransport] creating ${configuration.toMap()}');
    final pc = await rtc.createPeerConnection(
      configuration.toMap(),
      constraints,
    );
    return Transport._(pc);
  }

  /// The underlying PeerConnection instance used by this transport.
  final rtc.RTCPeerConnection pc;
  final _pendingCandidates = <rtc.RTCIceCandidate>[];

  /// Creates an offer and sets it as the local description.
  Future<rtc.RTCSessionDescription> createOffer() async {
    final offer = await pc.createOffer();
    await pc.setLocalDescription(offer);
    return offer;
  }

  /// Creates an answer and sets it as the local description.
  ///
  /// The remote description must be set before calling this method.
  Future<rtc.RTCSessionDescription> createAnswer() async {
    final answer = await pc.createAnswer();
    await pc.setLocalDescription(answer);
    return answer;
  }

  /// Sets the remote description and adds any pending ice candidates.
  Future<void> setRemoteDescription(rtc.RTCSessionDescription sd) async {
    await pc.setRemoteDescription(sd);

    for (final candidate in _pendingCandidates) {
      await pc.addCandidate(candidate);
    }

    _pendingCandidates.clear();
  }

  /// Adds an ice candidate to the peer connection.
  ///
  /// If the peer connection is not yet ready, the candidate is added to a list
  /// of pending candidates.
  Future<void> addIceCandidate(rtc.RTCIceCandidate candidate) async {
    final desc = await getRemoteDescription();

    if (desc == null) {
      _pendingCandidates.add(candidate);
      return;
    }

    return pc.addCandidate(candidate);
  }

  /// Returns the remote description.
  ///
  /// Returns null if the remote description is not set.
  Future<rtc.RTCSessionDescription?> getRemoteDescription() async {
    try {
      final result = await pc.getRemoteDescription();
      logger.fine('pc.getRemoteDescription $result');
      return result;
    } catch (_) {
      logger.warning('pc.getRemoteDescription failed with error: $_');
    }
    return null;
  }

  /// Returns the local description.
  ///
  /// Returns null if the local description is not set.
  Future<rtc.RTCSessionDescription?> getLocalDescription() async {
    try {
      final result = await pc.getLocalDescription();
      logger.fine('pc.getLocalDescription $result');
      return result;
    } catch (_) {
      logger.warning('pc.getLocalDescription failed with error: $_');
    }
    return null;
  }

  /// Creates and adds a audio transceiver to the peer connection.
  ///
  /// Returns the created transceiver.
  Future<rtc.RTCRtpTransceiver> addAudioTransceiver({
    required rtc.MediaStreamTrack track,
    List<rtc.RTCRtpEncoding>? encodings,
  }) async {
    final transceiver = await pc.addTransceiver(
      track: track,
      kind: rtc.RTCRtpMediaType.RTCRtpMediaTypeAudio,
      init: rtc.RTCRtpTransceiverInit(
        direction: rtc.TransceiverDirection.SendOnly,
        sendEncodings: encodings,
      ),
    );

    return transceiver;
  }

  /// Creates and adds a video transceiver to the peer connection.
  ///
  /// Returns the created transceiver.
  Future<rtc.RTCRtpTransceiver> addVideoTransceiver({
    required rtc.MediaStreamTrack track,
    required rtc.MediaStream stream,
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

  /// Removes all the tracks from the [sender].
  Future<bool> removeTrack(rtc.RTCRtpSender sender) => pc.removeTrack(sender);

  @override
  Future<void> dispose() async {
    // Ensure callbacks won't fire any more
    pc
      ..onRenegotiationNeeded = null
      ..onIceCandidate = null
      ..onConnectionState = null
      ..onTrack = null;

    // Remove all senders
    var senders = <rtc.RTCRtpSender>[];
    try {
      senders = await pc.getSenders();
    } catch (_) {
      logger.warning('getSenders() failed with error: $_');
    }

    for (final e in senders) {
      try {
        await pc.removeTrack(e);
      } catch (_) {
        logger.warning('removeTrack() failed with error: $_');
      }
    }

    await pc.close();
    await pc.dispose();

    return super.dispose();
  }
}
