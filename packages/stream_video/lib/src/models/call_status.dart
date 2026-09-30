import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'disconnect_reason.dart';

@immutable
abstract class CallStatus extends Equatable {
  const CallStatus();

  factory CallStatus.idle() {
    return CallStatusIdle();
  }

  factory CallStatus.outgoing({
    bool acceptedByCallee = false,
  }) {
    return CallStatusOutgoing(acceptedByCallee: acceptedByCallee);
  }

  factory CallStatus.incoming({
    bool acceptedByMe = false,
  }) {
    return CallStatusIncoming(acceptedByMe: acceptedByMe);
  }

  factory CallStatus.connecting() {
    return CallStatusConnecting();
  }

  factory CallStatus.reconnecting(
    int attempt, {
    bool isFastReconnectAttempt = false,
    CallReconnectPhase phase = CallReconnectPhase.waiting,
  }) {
    return CallStatusReconnecting(
      attempt: attempt,
      isFastReconnectAttempt: isFastReconnectAttempt,
      phase: phase,
    );
  }

  factory CallStatus.migrating() {
    return const CallStatusMigrating();
  }

  factory CallStatus.reconnectingFailed() {
    return CallStatusReconnectionFailed();
  }

  factory CallStatus.connected() {
    return CallStatusConnected();
  }

  factory CallStatus.disconnected(DisconnectReason reason) {
    return CallStatusDisconnected(reason: reason);
  }

  factory CallStatus.joining() {
    return CallStatusJoining();
  }

  factory CallStatus.joined() {
    return CallStatusJoined();
  }

  @override
  List<Object?> get props => [];

  bool get isIdle => this is CallStatusIdle;

  bool get isActive => this is CallStatusActive;

  bool get isConnectable => this is CallStatusConnectable;

  bool get isOutgoing => this is CallStatusOutgoing;

  bool get isIncoming => this is CallStatusIncoming;

  bool get isConnecting => this is CallStatusConnecting;

  bool get isReconnecting => this is CallStatusReconnecting;
  bool get isFastReconnecting =>
      this is CallStatusReconnecting &&
      (this as CallStatusReconnecting).isFastReconnectAttempt;

  /// Whether a reconnect is waiting for the network to come back.
  bool get isOffline => switch (this) {
    CallStatusReconnecting(phase: CallReconnectPhase.offline) => true,
    _ => false,
  };

  bool get isMigrating => this is CallStatusMigrating;

  bool get isConnected => this is CallStatusConnected;

  bool get isDisconnected => this is CallStatusDisconnected;

  bool get isJoining => this is CallStatusJoining;

  bool get isJoined => this is CallStatusJoined;

  bool get isAlreadyJoined =>
      isReconnecting || isMigrating || isConnected || isJoined;

  /// Returns human readable text representation of [CallStatus].
  String toStatusString() {
    if (isIdle) {
      return 'Idle';
    } else if (isOutgoing) {
      return 'Outgoing';
    } else if (isIncoming) {
      return 'Incoming';
    } else if (isJoining) {
      return 'Joining';
    } else if (isJoined) {
      return 'Joined';
    } else if (isReconnecting) {
      return 'Reconnecting';
    } else if (isMigrating) {
      return 'Migrating';
    } else if (isConnecting) {
      return 'Connecting';
    } else if (isConnected) {
      return 'Connected';
    } else if (isDisconnected) {
      return 'Disconnected';
    } else {
      return '';
    }
  }
}

mixin CallStatusConnectable implements CallStatus {}

class CallStatusIdle extends CallStatus with CallStatusConnectable {
  factory CallStatusIdle() {
    return _instance;
  }

  const CallStatusIdle._internal();

  static const CallStatusIdle _instance = CallStatusIdle._internal();

  @override
  String toString() => 'Idle';
}

abstract class CallStatusActive extends CallStatus {
  const CallStatusActive();
}

class CallStatusOutgoing extends CallStatusActive with CallStatusConnectable {
  const CallStatusOutgoing({required this.acceptedByCallee});

  final bool acceptedByCallee;

  @override
  List<Object?> get props => [acceptedByCallee];

  @override
  String toString() => 'Outgoing{acceptedByCallee: $acceptedByCallee}';
}

class CallStatusIncoming extends CallStatusActive with CallStatusConnectable {
  const CallStatusIncoming({required this.acceptedByMe});

  final bool acceptedByMe;

  @override
  List<Object?> get props => [acceptedByMe];

  @override
  String toString() => 'Incoming{acceptedByMe: $acceptedByMe}';
}

class CallStatusConnecting extends CallStatusActive {
  factory CallStatusConnecting() {
    return _instance;
  }

  const CallStatusConnecting._internal();

  static const CallStatusConnecting _instance =
      CallStatusConnecting._internal();

  @override
  String toString() => 'Connecting';
}

/// Where a reconnect is, from losing the connection to having it back.
///
/// A reconnect runs as a loop of attempts, and each attempt passes through
/// these in order: it waits for the network, then joins. A failed attempt goes
/// back to [waiting] for the next one.
enum CallReconnectPhase {
  /// The network is down, and the next attempt waits for it to come back.
  offline,

  /// The network is up, and the next attempt is about to start: it is backing
  /// off after a failed one, or making sure the network holds before a rejoin.
  waiting,

  /// An attempt is in flight: the call is joining the SFU again.
  joining,
}

/// The call lost its connection to the SFU and is getting it back.
///
/// Only the fast and rejoin strategies report this; a migration to another
/// SFU reports [CallStatusMigrating] instead.
class CallStatusReconnecting extends CallStatusConnecting
    implements CallStatusConnectable {
  const CallStatusReconnecting({
    required this.attempt,
    this.isFastReconnectAttempt = false,
    this.phase = CallReconnectPhase.waiting,
  }) : super._internal();

  /// Which attempt of this reconnect is running, or about to, counting from 1.
  ///
  /// Counts fast and rejoin attempts alike, so it keeps rising across an
  /// escalation from one to the other.
  final int attempt;

  /// Whether the attempt is a fast reconnect, which keeps the peer connections,
  /// rather than a rejoin, which builds new ones.
  final bool isFastReconnectAttempt;

  /// Where the attempt is.
  final CallReconnectPhase phase;

  @override
  List<Object?> get props => [attempt, isFastReconnectAttempt, phase];

  @override
  String toString() {
    final strategy = isFastReconnectAttempt ? 'fast' : 'rejoin';
    return 'Reconnecting{attempt: $attempt, strategy: $strategy, '
        'phase: ${phase.name}}';
  }
}

class CallStatusReconnectionFailed extends CallStatus {
  factory CallStatusReconnectionFailed() {
    return _instance;
  }

  const CallStatusReconnectionFailed._internal();

  static const CallStatusReconnectionFailed _instance =
      CallStatusReconnectionFailed._internal();

  @override
  String toString() => 'Reconnect failed';
}

class CallStatusMigrating extends CallStatusConnecting
    implements CallStatusConnectable {
  const CallStatusMigrating() : super._internal();

  @override
  String toString() {
    return 'Migrating';
  }
}

class CallStatusConnected extends CallStatusActive {
  factory CallStatusConnected() {
    return _instance;
  }

  const CallStatusConnected._internal();

  static const CallStatusConnected _instance = CallStatusConnected._internal();

  @override
  String toString() => 'Connected';
}

class CallStatusDisconnected extends CallStatus {
  const CallStatusDisconnected({required this.reason});

  final DisconnectReason reason;

  @override
  List<Object?> get props => [reason];

  @override
  String toString() {
    return 'Disconnected{reason: $reason}';
  }
}

class CallStatusJoining extends CallStatusActive
    implements CallStatusConnectable {
  factory CallStatusJoining() {
    return _instance;
  }

  const CallStatusJoining._internal();

  static const CallStatusJoining _instance = CallStatusJoining._internal();

  @override
  String toString() => 'Joining';
}

class CallStatusJoined extends CallStatusActive
    implements CallStatusConnectable {
  factory CallStatusJoined() {
    return _instance;
  }

  const CallStatusJoined._internal();

  static const CallStatusJoined _instance = CallStatusJoined._internal();

  @override
  String toString() => 'Joined';
}
