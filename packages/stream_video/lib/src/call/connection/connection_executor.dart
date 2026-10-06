import 'package:meta/meta.dart';
import 'package:synchronized/synchronized.dart';

import '../../sfu/data/models/sfu_error.dart';
import '../session/call_session.dart';

/// A reconnect asked for while other connection work was running.
@internal
final class ReconnectRequest {
  const ReconnectRequest(
    this.strategy, {
    this.reason,
    this.triggeredByNetwork = false,
    this.session,
  });

  final SfuReconnectionStrategy strategy;
  final String? reason;
  final bool triggeredByNetwork;

  /// The session the reconnect was asked for. Once another session has
  /// replaced it, the request no longer applies.
  final CallSession? session;

  /// Whether [strategy] asks for more than [other]: rejoin over migrate over
  /// fast.
  bool isStrongerThan(SfuReconnectionStrategy other) =>
      _rank(strategy) > _rank(other);

  /// This request combined with [next], which was asked for later. A request
  /// for another session replaces this one; for the same session the stronger
  /// strategy wins.
  ReconnectRequest mergedWith(ReconnectRequest next) {
    if (!identical(next.session, session)) return next;
    return isStrongerThan(next.strategy) ? this : next;
  }

  static int _rank(SfuReconnectionStrategy strategy) => switch (strategy) {
    SfuReconnectionStrategy.fast => 1,
    SfuReconnectionStrategy.migrate => 2,
    SfuReconnectionStrategy.rejoin => 3,
    _ => 0,
  };

  @override
  String toString() =>
      'ReconnectRequest(strategy: ${strategy.name}, reason: $reason)';
}

/// Runs a call's join and reconnect work one task at a time, in the order it
/// was asked for.
///
/// A reconnect asked for while a task runs is not queued behind it: [hold]
/// keeps it, merged with any other held request, for the running task or the
/// one after it to take.
@internal
class ConnectionExecutor {
  final _lock = Lock();
  ReconnectRequest? _held;

  /// Whether a task is running or queued.
  bool get isBusy => _lock.locked;

  /// Runs [task] once every task queued before it has finished.
  Future<T> run<T>(Future<T> Function() task) => _lock.synchronized(task);

  /// Keeps [request] for the running work to take.
  void hold(ReconnectRequest request) {
    _held = _held?.mergedWith(request) ?? request;
  }

  /// Returns the held request, if there is one, and stops holding it.
  ReconnectRequest? takeHeld() {
    final held = _held;
    _held = null;
    return held;
  }
}
