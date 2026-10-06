import 'package:meta/meta.dart';

import '../../models/call_status.dart';
import '../../models/disconnect_reason.dart';
import '../../sfu/data/models/sfu_error.dart';
import '../../utils/none.dart';
import '../../utils/result.dart';

/// Where a call's connection to the SFU is.
///
/// [ConnectionLeaving] and [ConnectionDisconnected] are terminal: once a call
/// starts leaving, it never connects again.
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

  /// The attempts of this reconnect so far, as
  /// [CallStatusReconnecting.attempt] reports them: 0 until the first one
  /// starts.
  final int attempt;

  /// Rejoin and migrate attempts so far, which drive their backoff and the
  /// SFU session sequence number.
  final int rejoinAttempts;

  /// What the current attempt is doing.
  final CallReconnectPhase step;

  /// Whether the next attempt has to rejoin: a rejoin was asked for while an
  /// attempt was running, or a fast reconnect found the SFU session gone.
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

/// The reconnect gave up. The status this projects to makes the call leave.
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

/// The call is over: left, ended, or disconnected by the server, for
/// [reason].
@internal
final class ConnectionDisconnected extends ConnectionPhase {
  const ConnectionDisconnected([this.reason]);

  final DisconnectReason? reason;

  @override
  String toString() => 'ConnectionDisconnected(reason: $reason)';
}
