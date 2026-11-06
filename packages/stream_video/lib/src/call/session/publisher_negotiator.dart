import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;
import 'package:synchronized/synchronized.dart';

import '../../../protobuf/video/sfu/signal_rpc/signal.pb.dart' as sfu;
import '../../errors/stream_video_exception.dart';
import '../../errors/stream_video_exception_composer.dart';
import '../../logger/impl/tagged_logger.dart';
import '../../sfu/data/models/sfu_error.dart';
import '../../sfu/data/models/sfu_model_mapper_extensions.dart';
import '../../sfu/sfu_client.dart';
import '../../utils/result.dart';
import '../../webrtc/model/rtc_tracks_info.dart';
import '../../webrtc/peer_connection.dart';
import '../../webrtc/peer_type.dart';
import '../../webrtc/rtc_manager.dart';

class _UnresolvedTrackMidError extends StreamVideoException {
  const _UnresolvedTrackMidError()
    : super(message: 'Could not resolve the mid of every published track');
}

/// Negotiates the publisher with the SFU, one negotiation at a time.
@internal
class PublisherNegotiator {
  PublisherNegotiator({
    required this.sfuClient,
    required this.sessionId,
    required this._rtcManager,
    required this._isLeavingOrClosed,
    required this._isCallDisconnected,
    required this._isSfuConnected,
    required this.onReconnectionNeeded,
    required String logTag,
  }) : _logger = taggedLogger(tag: logTag);

  final SfuClient sfuClient;
  final String sessionId;
  final OnReconnectionNeeded onReconnectionNeeded;

  final RtcManager? Function() _rtcManager;
  final bool Function() _isLeavingOrClosed;
  final bool Function() _isCallDisconnected;
  final bool Function() _isSfuConnected;
  final TaggedLogger _logger;

  final Lock _negotiationLock = Lock();

  /// Offers [pc]'s current state to the SFU and applies its answer.
  ///
  /// Fails without negotiating while the session is leaving or closed, the
  /// call is disconnected, or the SFU socket is down.
  Future<Result<void>> negotiate(StreamPeerConnection pc) async {
    if (_isLeavingOrClosed() || _isCallDisconnected()) {
      _logger.w(() => '[negotiate] call is disconnected');
      return failureWithError('Call is disconnected');
    }

    if (!_isSfuConnected()) {
      _logger.w(() => '[negotiate] skipped — SFU WS not connected');
      return failureWithError('SFU WS is not connected');
    }

    return _negotiationLock.synchronized(() => _negotiateLocked(pc));
  }

  /// Runs publisher negotiation as fire-and-forget for renegotiation triggers.
  /// Only a track mid resolution failure escalates (triggers fast reconnect).
  Future<void> negotiateOrRecover(StreamPeerConnection pc) async {
    // Awaiting this means `_negotiationLock` has been released by the time we
    // reach `onReconnectionNeeded`, so the reconnect cannot re-enter it.
    final result = await negotiate(pc);
    if (result is! Failure) return;

    _logger.w(() => '[negotiate] renegotiation failed: ${result.error}');

    if (result.error is! _UnresolvedTrackMidError || _isLeavingOrClosed()) {
      return;
    }

    _logger.w(
      () => '[negotiate] unresolved track mid — triggering fast reconnect',
    );

    onReconnectionNeeded(
      pc,
      SfuReconnectionStrategy.fast,
      ReconnectionNeededReason.stuck,
    );
  }

  Future<Result<void>> _negotiateLocked(StreamPeerConnection pc) async {
    _logger.d(() => '[negotiate] type: ${pc.type}');

    // A subscribe-only client's publisher has no transceivers. There is
    // nothing to negotiate. Covers fast reconnect and ICE restart alike.
    final manager = _rtcManager();
    if (pc.type == StreamPeerType.publisher &&
        manager != null &&
        await manager.isPublisherEmpty()) {
      _logger.d(() => '[negotiate] skipped — publisher has no transceivers');
      return const Result.success(null);
    }

    final offer = await pc.createOffer();
    if (offer is! Success<rtc.RTCSessionDescription>) {
      return failureWithError<void>(
        'Failed to create offer: ${offer.getErrorOrNull()}',
      );
    }

    final sdp = offer.data.sdp;
    final tracksInfo = manager == null
        ? const <RtcTrackInfo>[]
        : await manager.getAnnouncedTracks(sdp: sdp);

    if (tracksInfo == null) return _rejectUnresolvedMid(pc);
    if (tracksInfo.isEmpty) return _rejectEmptyAnnounce(pc, tracksInfo);

    _logger.v(() => '[negotiate] announcing tracks: $tracksInfo');
    return _announce(pc, sdp, tracksInfo);
  }

  Future<Result<void>> _rejectUnresolvedMid(StreamPeerConnection pc) async {
    _logger.w(
      () => '[negotiate] rejected(unresolved track mid); rolling back',
    );

    // Announcing a subset would leave the omitted m-lines sending media the
    // SFU cannot map, so drop the whole offer. The rollback returns the
    // publisher to `stable`, which the publisher connection check reads as
    // healthy, so the failure is typed for [negotiateOrRecover] to escalate.
    await pc.rollbackLocalDescription();

    return const Result.failure(_UnresolvedTrackMidError());
  }

  Future<Result<void>> _rejectEmptyAnnounce(
    StreamPeerConnection pc,
    List<RtcTrackInfo> tracksInfo,
  ) async {
    _logger.w(
      () => '[negotiate] rejected(tracksInfo is empty): $tracksInfo',
    );

    // Nothing to publish is a no-op, not a negotiation failure — but a
    // failed rollback leaves the publisher wedged in `have-local-offer`,
    // which is.
    final rollback = await pc.rollbackLocalDescription();
    if (rollback.isFailure) return rollback;

    return const Result.success(null);
  }

  Future<Result<void>> _announce(
    StreamPeerConnection pc,
    String? sdp,
    List<RtcTrackInfo> tracksInfo,
  ) async {
    try {
      final pubResult = await sfuClient.setPublisher(
        sfu.SetPublisherRequest(
          sdp: sdp,
          sessionId: sessionId,
          tracks: tracksInfo.toDTO(),
        ),
      );

      if (pubResult is! Success<sfu.SetPublisherResponse>) {
        _logger.w(() => '[negotiate] #setPublisher; failed: $pubResult');
        await pc.rollbackLocalDescription();
        return failureWithError<void>(
          'SetPublisher failed: ${pubResult.getErrorOrNull()}',
        );
      }

      if (pubResult.data.hasSdp()) {
        final ansResult = await pc.setRemoteAnswer(pubResult.data.sdp);
        if (ansResult is! Success<void>) {
          _logger.w(
            () => '[negotiate] #setRemoteAnswer; failed: $ansResult',
          );
          return failureWithError<void>(
            'Failed to set remote answer: ${ansResult.getErrorOrNull()}',
          );
        }
      }

      _rtcManager()?.markNegotiated(tracksInfo);

      return const Result.success(null);
    } catch (e, stk) {
      _logger.e(() => '[negotiate] failed: $e\n$stk');
      await pc.rollbackLocalDescription();
      return Result.failure(StreamVideoExceptions.compose(e, stk), stk);
    }
  }
}
