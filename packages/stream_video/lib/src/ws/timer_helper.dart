import 'dart:async';
import 'package:uuid/uuid.dart';

/// A utility class to manage [Timer].
class TimerHelper {
  late final _uuid = const Uuid();
  late final _timers = <String, Timer>{};

  /// Returns true if there are any timers.
  bool get hasTimers => _timers.isNotEmpty;

  /// Return true if there is a timer with [id].
  bool containsTimer(String id, {bool? isRunning}) {
    final timer = _timers[id];
    if (timer == null) return false;
    if (isRunning == null) return true;
    return timer.isActive == isRunning;
  }

  /// Sets a timer and returns the id of the timer.
  ///
  /// If [immediate] is true, the [callback] is called immediately.
  ///
  /// The timer is cancelled when [cancelTimer] is called with the id or by
  /// calling [cancelAllTimers].
  String setTimer(
    Duration duration,
    void Function() callback, {
    String? timerId,
    bool immediate = false,
  }) {
    final id = timerId ?? _uuid.v1();
    final timer = Timer(duration, callback);
    if (immediate) callback();
    _timers[id] = timer;
    return id;
  }

  /// Sets a periodic timer and returns the id of the timer.
  ///
  /// If [immediate] is true, the [callback] is called immediately.
  ///
  /// The timer is cancelled when [cancelTimer] is called with the id or by
  /// calling [cancelAllTimers].
  String setPeriodicTimer(
    Duration duration,
    void Function(Timer) callback, {
    String? timerId,
    bool immediate = false,
  }) {
    final id = timerId ?? _uuid.v1();
    final timer = Timer.periodic(duration, callback);
    if (immediate) callback.call(timer);
    _timers[id] = timer;
    return id;
  }

  /// Cancels the timer with the given [id].
  void cancelTimer(String id) {
    final timer = _timers.remove(id);
    return timer?.cancel();
  }

  /// Cancels all timers.
  void cancelAllTimers() {
    for (final t in _timers.values) {
      t.cancel();
    }
    _timers.clear();
  }
}
