import 'dart:async';

import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../../logger/impl/tagged_logger.dart';
import '../../sfu/data/models/sfu_error.dart';
import '../../utils/result.dart';
import '../../webrtc/peer_connection.dart';
import '../stats/trace_tag.dart';
import '../stats/tracer.dart';
import 'publisher_negotiator.dart';

/// Checks, [delay] after [start], that the publisher finished connecting.
///
/// Recovers two stalls: ICE still `new` (likely no SDP answer) → rejoin;
/// signaling `have-local-offer` (SetPublisher incomplete, no further
/// negotiation) → renegotiate, then fast reconnect if that fails.
@internal
class PublisherConnectionWatchdog {
  PublisherConnectionWatchdog({
    required this._publisher,
    required this._negotiator,
    required this._onReconnectionNeeded,
    required this._tracer,
    required this._isClosed,
    required String logTag,
    this.delay = const Duration(seconds: 15),
  }) : _logger = taggedLogger(tag: logTag);

  /// How long the publisher has to connect.
  final Duration delay;

  final StreamPeerConnection? Function() _publisher;
  final PublisherNegotiator _negotiator;
  final OnReconnectionNeeded _onReconnectionNeeded;
  final Tracer _tracer;
  final bool Function() _isClosed;
  final TaggedLogger _logger;

  Timer? _timer;

  /// Arms the check, replacing one already armed.
  void start() {
    _timer?.cancel();
    _timer = Timer(delay, _check);
  }

  /// Disarms the check.
  void cancel() => _timer?.cancel();

  Future<void> _check() async {
    if (_isClosed()) return;

    final publisher = _publisher();
    if (publisher == null) return;

    final iceState = publisher.pc.iceConnectionState;
    if (iceState == rtc.RTCIceConnectionState.RTCIceConnectionStateNew) {
      _rejoinOnIceStall(publisher, iceState);
      return;
    }

    final signalingState = publisher.pc.signalingState;
    if (signalingState ==
        rtc.RTCSignalingState.RTCSignalingStateHaveLocalOffer) {
      await _renegotiateOnSignalingStall(publisher, signalingState);
      return;
    }

    _logger.v(
      () =>
          '[publisherConnectionCheck] publisher ICE state: '
          '$iceState — OK',
    );
  }

  void _rejoinOnIceStall(
    StreamPeerConnection publisher,
    rtc.RTCIceConnectionState? iceState,
  ) {
    _logger.w(
      () =>
          '[publisherConnectionCheck] publisher ICE still in "new" '
          'state after ${delay.inSeconds}s '
          '— triggering reconnection',
    );
    _tracer.trace(TraceTag.publisherConnectionCheckStalled, {
      'iceState': iceState.toString(),
      'timeoutSeconds': delay.inSeconds,
    });

    _onReconnectionNeeded(
      publisher,
      SfuReconnectionStrategy.rejoin,
      ReconnectionNeededReason.stuck,
    );
  }

  /// Signaling stall: local offer created but SetPublisher never completed,
  /// leaving the peer connection wedged in `have-local-offer`. Negotiation
  /// won't resume on its own, so renegotiate and fall back to a fast
  /// reconnect if the recovery fails.
  Future<void> _renegotiateOnSignalingStall(
    StreamPeerConnection publisher,
    rtc.RTCSignalingState? signalingState,
  ) async {
    _logger.w(
      () =>
          '[publisherConnectionCheck] publisher stuck in '
          '"have-local-offer" after '
          '${delay.inSeconds}s — renegotiating',
    );
    _tracer.trace(TraceTag.publisherConnectionCheckStalled, {
      'signalingState': signalingState.toString(),
      'timeoutSeconds': delay.inSeconds,
    });

    final result = await _negotiator.negotiate(publisher);
    if (result.isFailure && !_isClosed()) {
      _logger.w(
        () =>
            '[publisherConnectionCheck] recovery renegotiation failed '
            '(${result.getErrorOrNull()}) — triggering fast reconnect',
      );
      _onReconnectionNeeded(
        publisher,
        SfuReconnectionStrategy.fast,
        ReconnectionNeededReason.stuck,
      );
    }
  }
}
