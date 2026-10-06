import 'package:meta/meta.dart';

import '../../models/call_status.dart';
import '../../models/disconnect_reason.dart';
import '../../sfu/data/models/sfu_error.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';

/// Where a call's connection to the SFU is.
///
/// [ConnectionLeaving] and [ConnectionDisconnected] are final: once a call
/// leaves, it never connects again.
@internal
sealed class ConnectionPhase {
  const ConnectionPhase();

  /// Whether the call is leaving or has left.
  bool get isLeftOrLeaving =>
      this is ConnectionLeaving || this is ConnectionDisconnected;
}

/// Not joined yet.
@internal
final class ConnectionIdle extends ConnectionPhase {
  const ConnectionIdle();

  @override
  String toString() => 'ConnectionIdle';
}

/// The first join is running; [request] completes when it does.
@internal
final class ConnectionJoining extends ConnectionPhase {
  const ConnectionJoining(this.request);

  final Future<Result<None>> request;

  @override
  String toString() => 'ConnectionJoining';
}

/// Connected to the SFU.
@internal
final class ConnectionConnected extends ConnectionPhase {
  const ConnectionConnected();

  @override
  String toString() => 'ConnectionConnected';
}

/// Reconnecting to the SFU after the connection was lost.
@internal
final class ConnectionReconnecting extends ConnectionPhase {
  const ConnectionReconnecting({
    required this.strategy,
    this.attempt = 0,
    this.rejoinAttempts = 0,
    this.step = CallReconnectPhase.waiting,
    this.rejoinPending = false,
  });

  /// How the current attempt reconnects: fast, rejoin or migrate.
  final SfuReconnectionStrategy strategy;

  /// Every attempt of this reconnect so far, counting from 1, as
  /// [CallStatusReconnecting.attempt] reports it.
  final int attempt;

  /// Rejoin and migrate attempts so far, which drive their backoff and the
  /// SFU session sequence number.
  final int rejoinAttempts;

  /// What the current attempt is doing.
  final CallReconnectPhase step;

  /// Whether a rejoin was asked for while an attempt was running, so the next
  /// attempt rejoins.
  final bool rejoinPending;

  ConnectionReconnecting copyWith({
    SfuReconnectionStrategy? strategy,
    int? attempt,
    int? rejoinAttempts,
    CallReconnectPhase? step,
    bool? rejoinPending,
  }) {
    return ConnectionReconnecting(
      strategy: strategy ?? this.strategy,
      attempt: attempt ?? this.attempt,
      rejoinAttempts: rejoinAttempts ?? this.rejoinAttempts,
      step: step ?? this.step,
      rejoinPending: rejoinPending ?? this.rejoinPending,
    );
  }

  @override
  String toString() {
    return 'ConnectionReconnecting(strategy: ${strategy.name}, '
        'attempt: $attempt, rejoinAttempts: $rejoinAttempts, '
        'step: ${step.name}, rejoinPending: $rejoinPending)';
  }
}

/// The reconnect gave up; the call leaves next.
@internal
final class ConnectionReconnectFailed extends ConnectionPhase {
  const ConnectionReconnectFailed();

  @override
  String toString() => 'ConnectionReconnectFailed';
}

/// Leaving the call.
@internal
final class ConnectionLeaving extends ConnectionPhase {
  const ConnectionLeaving();

  @override
  String toString() => 'ConnectionLeaving';
}

/// Left the call, for [reason].
@internal
final class ConnectionDisconnected extends ConnectionPhase {
  const ConnectionDisconnected([this.reason]);

  final DisconnectReason? reason;

  @override
  String toString() => 'ConnectionDisconnected(reason: $reason)';
}
