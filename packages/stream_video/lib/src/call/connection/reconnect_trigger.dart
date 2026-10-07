import 'package:meta/meta.dart';

import '../../webrtc/peer_connection.dart';
import '../session/call_session.dart';

/// What asked for a reconnect, and how to tell whether it still needs one.
///
/// A reconnect asked for while other connection work runs is held until that
/// work is done. By then the cause may have cleared, so a held request is
/// dropped when [isStillNeeded] is false.
@internal
sealed class ReconnectTrigger {
  const ReconnectTrigger();

  /// Whether the cause is still there. False only when it can be seen to
  /// have cleared; a cause that cannot be checked always counts as still
  /// there.
  bool get isStillNeeded;
}

/// A peer connection failed: its state turned failed, or an ICE restart did
/// not bring it back.
@internal
final class PeerConnectionFailed extends ReconnectTrigger {
  const PeerConnectionFailed(this.peerConnection);

  final StreamPeerConnection peerConnection;

  /// False once the peer connection is connected again.
  @override
  bool get isStillNeeded => !peerConnection.isConnected();

  @override
  String toString() => 'PeerConnectionFailed(${peerConnection.type.name})';
}

/// A peer connection cannot recover by itself even though its state may look
/// connected, such as a failed negotiation or a publisher that never
/// connected.
@internal
final class PeerConnectionStuck extends ReconnectTrigger {
  const PeerConnectionStuck(this.peerConnection);

  final StreamPeerConnection peerConnection;

  @override
  bool get isStillNeeded => true;

  @override
  String toString() => 'PeerConnectionStuck(${peerConnection.type.name})';
}

/// The SFU signalling socket of [session] closed or failed.
@internal
final class SfuSocketLost extends ReconnectTrigger {
  const SfuSocketLost(this.session);

  final CallSession session;

  /// False once the socket is connected again.
  @override
  bool get isStillNeeded => !session.isSfuConnected;

  @override
  String toString() => 'SfuSocketLost';
}

/// The device went offline.
@internal
final class NetworkLost extends ReconnectTrigger {
  const NetworkLost();

  /// Always: connections set up around a network drop can be stale even when
  /// the network is back, without anything reporting it. While the device is
  /// still offline, the reconnect waits for the network before it joins.
  @override
  bool get isStillNeeded => true;

  @override
  String toString() => 'NetworkLost';
}

/// The SFU asked for the reconnect: an error event, a GoAway, or a session it
/// did not resume.
@internal
final class SfuRequested extends ReconnectTrigger {
  const SfuRequested();

  @override
  bool get isStillNeeded => true;

  @override
  String toString() => 'SfuRequested';
}
