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

  /// The `liveEndedAt` the live duration was last frozen at.
  DateTime? _frozenLiveEndedAt;

  /// Time since `startedAt`, once a second until `liveEndedAt` is set.
  Stream<Duration> get durationStream => _durationController.stream.distinct();

  /// How long the call has been live, as described on
  /// `Call.liveDurationStream`.
  Stream<Duration> get liveDurationStream async* {
    final current = _liveDuration(_state);
    if (current != null) yield current;
    yield* _liveDurationController.stream;
  }

  /// Takes the times of [state], starting or stopping the ticks as they say.
  void update(CallState state) {
    _state = state;
    _freezeLiveDuration();

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

  /// Emits the length of a live that has just ended, once.
  void _freezeLiveDuration() {
    final liveEndedAt = _state.liveEndedAt;
    if (liveEndedAt == _frozenLiveEndedAt) return;
    _frozenLiveEndedAt = liveEndedAt;

    final duration = _liveDuration(_state);
    if (liveEndedAt != null && duration != null) {
      _liveDurationController.add(duration);
    }
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
