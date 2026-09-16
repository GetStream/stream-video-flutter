import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../models/participants_throttle.dart';

extension AdaptiveCollectionThrottleX<T> on Stream<List<T>> {
  /// Rate-limits this stream to one value per window, where [interval] decides
  /// how long that window is from the size of the list that opened it.
  ///
  /// The value emitted is the most recent one to arrive during the window, so
  /// a change is never dropped — only collapsed with the ones around it. The
  /// window opens on the first value after an idle period and that value is
  /// held until it closes, which means the first emission to a new listener is
  /// delayed by up to one interval. Read `CallState.callParticipants` for a
  /// value to start from.
  ///
  /// [interval] is evaluated once per window, when it opens. A value arriving
  /// mid-window does not restart or re-measure it, so a change in list size
  /// takes effect on the next window.
  Stream<List<T>> throttleByCollectionSize({
    required ParticipantsThrottleInterval interval,
  }) {
    return throttle(
      (value) => TimerStream<void>(null, interval(value.length)),
      // Leading emissions would double the rate: `eventAfterLastWindow` closes
      // a window before the next value reopens it, so a continuous source gets
      // both the trailing value and the next value as the new window's leading
      // one. Trailing alone makes the interval mean what it says.
      leading: false,
      trailing: true,
    ).distinct(identical);
  }
}
