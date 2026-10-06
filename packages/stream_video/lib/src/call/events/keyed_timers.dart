import 'dart:async';

import 'package:meta/meta.dart';

/// One-shot timers, at most one per key.
@internal
class KeyedTimers {
  final Map<String, Timer> _timers = {};

  /// Runs [onFire] after [duration], replacing any timer pending for [key].
  void start(String key, Duration duration, void Function() onFire) {
    _timers[key]?.cancel();

    late final Timer timer;
    timer = Timer(duration, () {
      if (identical(_timers[key], timer)) _timers.remove(key);
      onFire();
    });
    _timers[key] = timer;
  }

  /// Cancels the timer pending for [key], if any.
  void cancel(String key) => _timers.remove(key)?.cancel();

  /// Cancels every pending timer.
  void cancelAll() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
  }
}
