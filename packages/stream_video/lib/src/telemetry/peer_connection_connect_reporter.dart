import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import '../models/call_cid.dart';
import 'client_event.dart';
import 'client_event_reporter.dart';
import 'client_event_types.dart';

class PeerConnectionConnectReporter {
  PeerConnectionConnectReporter({
    required this.reporter,
    required this.callCid,
    required this.role,
    this.sfuId,
    this.retryCount = 0,
  });

  final ClientEventReporter reporter;
  final StreamCallCid callCid;
  final ClientEventPeerConnectionRole role;
  final String? sfuId;
  final int retryCount;

  String? _stageId;
  bool _wasPreviouslyConnected = false;
  DateTime? _previouslyConnectedAt;
  rtc.RTCIceConnectionState? _lastIceState;

  void onIceConnectionState(rtc.RTCIceConnectionState state) {
    _lastIceState = state;
    switch (state) {
      case rtc.RTCIceConnectionState.RTCIceConnectionStateChecking:
        _begin();
      case rtc.RTCIceConnectionState.RTCIceConnectionStateFailed:
        _fail(const ClientEventFailure.ice());
      default:
        break;
    }
  }

  void onConnectionState(rtc.RTCPeerConnectionState state) {
    switch (state) {
      case rtc.RTCPeerConnectionState.RTCPeerConnectionStateConnecting:
        _begin();
      case rtc.RTCPeerConnectionState.RTCPeerConnectionStateConnected:
        _succeed();
      case rtc.RTCPeerConnectionState.RTCPeerConnectionStateFailed:
        _fail(const ClientEventFailure.dtls());
      default:
        break;
    }
  }

  /// Fails any in-flight attempt — call when the peer connection is torn down
  /// before it finished connecting (e.g. a reconnect replaces it).
  void abortInFlight() {
    if (_stageId == null) return;
    _fail(
      const ClientEventFailure.ice('Peer connection closed before connecting'),
    );
  }

  void _begin() {
    if (_stageId != null) return;
    final stageId = reporter.beginStage(
      callCid,
      ClientEventStage.peerConnectionConnect,
      details: _details(_observedIceState()),
    );
    _stageId = stageId.isEmpty ? null : stageId;
  }

  void _succeed() {
    final stageId = _stageId;
    if (stageId == null) return;
    _stageId = null;

    reporter.completeStage(
      stageId,
      outcome: ClientEventOutcome.success,
      details: _details(ClientEventIceState.connected),
      retryCount: retryCount,
    );

    _wasPreviouslyConnected = true;
    _previouslyConnectedAt = DateTime.now();
  }

  void _fail(ClientEventFailure failure) {
    final stageId = _stageId;
    if (stageId == null) return;
    _stageId = null;

    reporter.failStage(
      stageId,
      failure: failure,
      details: _details(_observedIceState()),
      retryCount: retryCount,
    );
  }

  ClientEventDetails _details(ClientEventIceState iceState) {
    return ClientEventDetails(
      peerConnectionRole: role,
      wasPreviouslyConnected: _wasPreviouslyConnected,
      previouslyConnectedAt: _previouslyConnectedAt,
      sfuId: sfuId,
      iceState: iceState,
    );
  }

  ClientEventIceState _observedIceState() {
    return switch (_lastIceState) {
      rtc.RTCIceConnectionState.RTCIceConnectionStateConnected ||
      rtc.RTCIceConnectionState.RTCIceConnectionStateCompleted =>
        ClientEventIceState.connected,
      rtc.RTCIceConnectionState.RTCIceConnectionStateFailed =>
        ClientEventIceState.failed,
      _ => ClientEventIceState.notConnected,
    };
  }
}
