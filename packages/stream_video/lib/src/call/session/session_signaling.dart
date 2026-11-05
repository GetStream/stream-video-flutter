import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../../protobuf/video/sfu/models/models.pb.dart' as sfu_models;
import '../../../protobuf/video/sfu/signal_rpc/signal.pb.dart' as sfu;
import '../../logger/impl/tagged_logger.dart';
import '../../sfu/data/events/sfu_events.dart';
import '../../sfu/data/models/sfu_model_mapper_extensions.dart';
import '../../sfu/sfu_client.dart';
import '../../webrtc/peer_connection.dart';
import '../../webrtc/peer_type.dart';
import '../../webrtc/rtc_manager.dart';
import '../../webrtc/rtc_track/rtc_track.dart';
import 'publisher_negotiator.dart';

/// The signaling between a session's peer connections and the SFU: the
/// subscriber offer, ICE candidates both ways, ICE restarts and mute states.
@internal
class SessionSignaling {
  SessionSignaling({
    required this._sfuClient,
    required this._sessionId,
    required this._rtcManager,
    required this._negotiator,
    required this._isLeavingOrClosed,
    required this._isCallDisconnected,
    required String logTag,
  }) : _logger = taggedLogger(tag: logTag);

  final SfuClient _sfuClient;
  final String _sessionId;
  final RtcManager? Function() _rtcManager;
  final PublisherNegotiator _negotiator;
  final bool Function() _isLeavingOrClosed;
  final bool Function() _isCallDisconnected;
  final TaggedLogger _logger;

  /// Answers the SFU's subscriber offer.
  Future<void> onSubscriberOffer(SfuSubscriberOfferEvent event) async {
    if (_isLeavingOrClosed() || _isCallDisconnected()) {
      _logger.w(
        () => '[onSubscriberOffer] rejected (session is disconnecting)',
      );
      return;
    }

    final offerSdp = event.sdp;
    _logger.v(() => '[onSubscriberOffer] event: $event');

    final answerSdp = await _rtcManager()?.onSubscriberOffer(offerSdp);
    if (answerSdp == null) {
      _logger.w(() => '[onSubscriberOffer] rejected (answerSdp is null)');
      return;
    }

    // The session can leave or close while the answer is created; the SFU no
    // longer expects one then.
    if (_isLeavingOrClosed()) {
      _logger.w(() => '[onSubscriberOffer] dropped (session left mid-offer)');
      return;
    }

    final result = await _sfuClient.sendAnswer(
      sfu.SendAnswerRequest(
        sdp: answerSdp,
        sessionId: _sessionId,
        peerType: sfu_models.PeerType.PEER_TYPE_SUBSCRIBER,
        negotiationId: event.negotiationId,
      ),
    );
    _logger.v(() => '[onSubscriberOffer] result: $result');
  }

  /// Restarts ICE on the peer connection the SFU names. A publisher then
  /// renegotiates, without being awaited.
  Future<void> onIceRestart(SfuIceRestartEvent event) async {
    _logger.d(() => '[onIceRestart] event: $event');

    final peerType = event.peerType;

    if (peerType == StreamPeerType.publisher) {
      final publisher = _rtcManager()?.publisher;
      if (publisher == null) {
        _logger.w(() => '[onIceRestart] publisher peer connection is null');
        return;
      }

      _logger.i(() => '[onIceRestart] restarting ICE for publisher');
      final result = await publisher.restartIce();
      _logger.d(() => '[onIceRestart] publisher ICE restart result: $result');

      // After marking ICE restart, explicitly trigger renegotiation to create
      // a new offer with fresh ICE credentials and send it to the SFU.
      // pc.restartIce() only sets a flag; we must create and send the offer.
      //
      // Use unawaited so we don't hold the SFU events lock during the
      // SetPublisher HTTP call.
      _logger.i(() => '[onIceRestart] triggering publisher renegotiation');
      unawaited(
        _negotiator.negotiateOrRecover(publisher).catchError((
          Object e,
          StackTrace stk,
        ) {
          _logger.e(
            () => '[onIceRestart] publisher renegotiation error: $e\n$stk',
          );
        }),
      );
    } else if (peerType == StreamPeerType.subscriber) {
      final subscriber = _rtcManager()?.subscriber;
      if (subscriber == null) {
        _logger.w(() => '[onIceRestart] subscriber peer connection is null');
        return;
      }

      _logger.i(() => '[onIceRestart] restarting ICE for subscriber');
      final result = await subscriber.restartIce();
      _logger.d(() => '[onIceRestart] subscriber ICE restart result: $result');
    } else {
      _logger.w(() => '[onIceRestart] unknown peer type: $peerType');
    }
  }

  /// Sends [track]'s mute state to the SFU.
  ///
  /// The RPC is not awaited: its result is dropped, and nothing orders it
  /// against the next mute state sent.
  void sendMuteState(RtcLocalTrack track, bool muted) {
    _logger.d(() => '[sendMuteState] track: $track, muted: $muted');

    // Send a mute state update to the server.
    _sfuClient.updateMuteState(
      sfu.UpdateMuteStatesRequest(
        sessionId: _sessionId,
        muteStates: [
          sfu.TrackMuteState(
            trackType: track.trackType.toDTO(),
            muted: muted,
          ),
        ],
      ),
    );
  }

  /// Adds the SFU's ICE candidate to the peer connection it names.
  Future<void> onRemoteIceCandidate(SfuIceTrickleEvent event) async {
    _logger.d(() => '[onRemoteIceCandidate] event: $event');
    final result = await _rtcManager()?.onRemoteIceCandidate(
      peerType: event.peerType,
      iceCandidate: event.iceCandidate,
    );
    _logger.v(() => '[onRemoteIceCandidate] result: $result');
  }

  /// Sends [pc]'s local ICE candidate to the SFU.
  ///
  /// The RPC is not awaited; its result is logged when it lands.
  void onLocalIceCandidate(
    StreamPeerConnection pc,
    rtc.RTCIceCandidate candidate,
  ) {
    _logger.d(
      () => '[onLocalIceCandidate] type: ${pc.type}, candidate: $candidate',
    );

    final encodedIceCandidate = json.encode(candidate.toMap());
    final peerType = pc.type == StreamPeerType.publisher
        ? sfu_models.PeerType.PEER_TYPE_PUBLISHER_UNSPECIFIED
        : sfu_models.PeerType.PEER_TYPE_SUBSCRIBER;

    unawaited(
      _sfuClient
          .iceTrickle(
            sfu_models.ICETrickle(
              peerType: peerType,
              sessionId: _sessionId,
              iceCandidate: encodedIceCandidate,
            ),
          )
          .then((result) {
            _logger.v(() => '[onLocalIceCandidate] result: $result');
          }),
    );
  }
}
