import 'dart:collection';

import 'package:clock/clock.dart';
import 'package:meta/meta.dart';

/// Allows at most [maxAttempts] attempts within any rolling [window].
@internal
class RejoinRateLimiter {
  RejoinRateLimiter({
    this.maxAttempts = 10,
    this.window = const Duration(seconds: 120),
  });

  final int maxAttempts;
  final Duration window;

  final _attempts = Queue<DateTime>();

  /// Records an attempt and returns true, or returns false without recording
  /// it when [maxAttempts] attempts already fall within the last [window].
  bool tryRegister() {
    final now = clock.now();
    while (_attempts.isNotEmpty && now.difference(_attempts.first) >= window) {
      _attempts.removeFirst();
    }

    if (_attempts.length >= maxAttempts) return false;

    _attempts.addLast(now);
    return true;
  }
}
