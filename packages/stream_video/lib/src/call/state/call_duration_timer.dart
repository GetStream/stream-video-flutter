import 'dart:async';

import 'package:clock/clock.dart';
import 'package:meta/meta.dart';

import '../../call_state.dart';

/// Counts how long a call has been running and how long it has been live,
/// from the [CallState] it is given through [update].
@internal
class CallDurationTimer {
  CallDurationTimer(CallState initialState) : _state = initialState {
    update(initialState);
  }

  final _durationController = StreamController<Duration>.broadcast();
  final _liveDurationController = StreamController<Duration>.broadcast();

  CallState _state;
  Timer? _timer;

  /// The live times the live duration was last emitted for.
  DateTime? _liveStartedAt;
  DateTime? _liveEndedAt;

  /// Time since `startedAt`, once a second until `liveEndedAt` is set.
  Stream<Duration> get durationStream => _durationController.stream.distinct();

  /// How long the call has been live, as described on
  /// `Call.liveDurationStream`.
  ///
  /// The current value and the subscription to later ones are taken in the
  /// same step, so no update falls between them.
  Stream<Duration> get liveDurationStream {
    return Stream.multi((controller) {
      final current = _liveDuration(_state);
      if (current != null) controller.add(current);
      final subscription = _liveDurationController.stream.listen(
        controller.addSync,
        onDone: controller.closeSync,
      );
      controller
        ..onPause = subscription.pause
        ..onResume = subscription.resume
        // Not awaited: the done event would wait on the cancel.
        ..onCancel = () => unawaited(subscription.cancel());
    });
  }

  /// Takes the times of [state], starting or stopping the ticks as they say.
  void update(CallState state) {
    _state = state;
    _emitLiveChange();

    if (!_isRunning(state) && !_isLive(state)) {
      _timer?.cancel();
      _timer = null;
      return;
    }

    _timer ??= Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final now = clock.now();

    final startedAt = _state.startedAt;
    if (startedAt != null && _isRunning(_state)) {
      _durationController.add(now.difference(startedAt));
    }

    final liveStartedAt = _state.liveStartedAt;
    if (liveStartedAt != null && _isLive(_state)) {
      _liveDurationController.add(now.difference(liveStartedAt));
    }
  }

  /// Emits the live duration at once when the call goes live or the live
  /// ends, rather than at the next tick: zero on going live, the final length
  /// on ending.
  void _emitLiveChange() {
    final liveStartedAt = _state.liveStartedAt;
    final liveEndedAt = _state.liveEndedAt;
    if (liveStartedAt == _liveStartedAt && liveEndedAt == _liveEndedAt) return;
    _liveStartedAt = liveStartedAt;
    _liveEndedAt = liveEndedAt;

    final duration = _liveDuration(_state);
    if (duration != null) _liveDurationController.add(duration);
  }

  static bool _isRunning(CallState state) =>
      state.startedAt != null && state.liveEndedAt == null;

  static bool _isLive(CallState state) =>
      state.liveStartedAt != null && state.liveEndedAt == null;

  /// From `liveStartedAt` to `liveEndedAt`, or to now while live.
  static Duration? _liveDuration(CallState state) {
    final liveStartedAt = state.liveStartedAt;
    if (liveStartedAt == null) return null;

    return (state.liveEndedAt ?? clock.now()).difference(liveStartedAt);
  }

  /// Stops the ticks and completes both streams.
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _durationController.close();
    _liveDurationController.close();
  }
}
