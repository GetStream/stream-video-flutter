import 'dart:async';

import 'package:rxdart/rxdart.dart';

/// Emission intervals for [AdaptiveCollectionThrottleX], keyed on how large the
/// collection currently is.
///
/// The tiers mirror the ones used by the iOS and Android SDKs, so a livestream
/// updates at a comparable rate on every platform.
Duration defaultCollectionThrottleInterval(int size) {
  if (size < 16) return const Duration(milliseconds: 16);
  if (size < 50) return const Duration(milliseconds: 250);
  if (size < 100) return const Duration(milliseconds: 500);
  return const Duration(seconds: 1);
}

extension AdaptiveCollectionThrottleX<T> on Stream<List<T>> {
  /// Rate-limits this stream, emitting at most once per interval, where the
  /// interval grows with the size of the most recent list.
  ///
  /// The first value of each window is emitted immediately and the last one is
  /// emitted when the window closes, so a change is never dropped — only
  /// collapsed with the ones around it. A window that saw a single value closes
  /// without repeating it.
  ///
  /// Use it for participant lists feeding the UI. Don't use it for values a
  /// caller acts on rather than renders, such as the call status, where a delay
  /// of up to a second would be visible as lag.
  Stream<List<T>> throttleByCollectionSize({
    Duration Function(int size) interval = defaultCollectionThrottleInterval,
  }) {
    return throttle(
      (value) => TimerStream<void>(null, interval(value.length)),
      trailing: true,
    ).distinct(identical);
  }
}
