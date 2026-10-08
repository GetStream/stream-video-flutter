import 'package:meta/meta.dart';
import 'package:synchronized/synchronized.dart';

import '../../sfu/data/models/sfu_error.dart';
import '../session/call_session.dart';
import 'reconnect_trigger.dart';

/// A reconnect asked for while other connection work was running.
@internal
final class ReconnectRequest {
  const ReconnectRequest(
    this.strategy, {
    required this.trigger,
    this.reason,
    this.session,
  });

  final SfuReconnectionStrategy strategy;

  /// What asked for it.
  final ReconnectTrigger trigger;

  final String? reason;

  /// The session the reconnect was asked for. Once another session has
  /// replaced it, the request no longer applies.
  final CallSession? session;

  /// Whether [strategy] asks for more than [other]: rejoin over migrate over
  /// fast.
  bool isStrongerThan(SfuReconnectionStrategy other) =>
      _rank(strategy) > _rank(other);

  /// The request with the strongest strategy among [requests], the later one
  /// on a tie, or null when there are none.
  static ReconnectRequest? strongest(Iterable<ReconnectRequest> requests) {
    ReconnectRequest? strongest;
    for (final request in requests) {
      if (strongest == null || !strongest.isStrongerThan(request.strategy)) {
        strongest = request;
      }
    }
    return strongest;
  }

  static int _rank(SfuReconnectionStrategy strategy) => switch (strategy) {
    SfuReconnectionStrategy.unspecified => 0,
    SfuReconnectionStrategy.disconnect => 0,
    SfuReconnectionStrategy.fast => 1,
    SfuReconnectionStrategy.migrate => 2,
    SfuReconnectionStrategy.rejoin => 3,
  };

  @override
  String toString() =>
      'ReconnectRequest(strategy: ${strategy.name}, trigger: $trigger, '
      'reason: $reason)';
}

/// Runs a call's join and reconnect work one task at a time, in the order it
/// was asked for.
///
/// A reconnect asked for while a task runs is not queued behind it: [hold]
/// keeps it, alongside the other held requests for the same session, for the
/// running task or the one after it to take.
@internal
final class ConnectionExecutor {
  final _lock = Lock();
  final _held = <ReconnectRequest>[];

  /// Whether a task is running or queued.
  bool get isBusy => _lock.locked;

  /// Runs [task] once every task queued before it has finished.
  Future<T> run<T>(Future<T> Function() task) => _lock.synchronized(task);

  /// Keeps [request] for the running work to take. Requests held for another
  /// session are dropped, since sessions only move forward, and returned.
  List<ReconnectRequest> hold(ReconnectRequest request) {
    final replaced = _held
        .where((held) => !identical(held.session, request.session))
        .toList();
    _held
      ..removeWhere(replaced.contains)
      ..add(request);
    return replaced;
  }

  /// Returns the held requests, oldest first, and stops holding them.
  List<ReconnectRequest> takeHeld() {
    final held = List.of(_held);
    _held.clear();
    return held;
  }
}
