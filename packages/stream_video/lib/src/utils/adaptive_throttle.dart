import 'dart:async';

/// How long a window lasts, given the size of the collection that opened it.
typedef CollectionThrottleInterval = Duration Function(int size);

extension AdaptiveCollectionThrottleX<T> on Stream<List<T>> {
  /// Rate-limits this stream to one value per window, where [interval] decides
  /// how long that window is from the size of the list that opened it.
  ///
  /// Intermediate values are collapsed: only the most recent value to arrive
  /// during a window is emitted, so a listener never sees a stale list but does
  /// not see every list that passed through either. The window opens on the
  /// first value after an idle period and that value is held until it closes,
  /// which means a listener's first value is delayed by one interval.
  ///
  /// [interval] is evaluated once per window, when it opens. A value arriving
  /// mid-window does not restart or re-measure it, so a change in list size
  /// takes effect on the next window. A negative result is treated as zero, and
  /// one that throws is forwarded as an error on this stream.
  ///
  /// When the source closes, anything still held is emitted before this stream
  /// closes, whether or not a window was open.
  Stream<List<T>> throttleByCollectionSize({
    required CollectionThrottleInterval interval,
  }) {
    return transform(_CollectionThrottle<T>(interval));
  }
}

/// Emits at most one value per window, measured from the list that opened it.
class _CollectionThrottle<T> extends StreamTransformerBase<List<T>, List<T>> {
  const _CollectionThrottle(this._interval);

  final CollectionThrottleInterval _interval;

  @override
  Stream<List<T>> bind(Stream<List<T>> stream) {
    late final StreamController<List<T>> controller;
    // Cancelled in the controller's onCancel below.
    // ignore: cancel_subscriptions
    StreamSubscription<List<T>>? subscription;
    Timer? window;
    List<T>? held;

    void emitHeld() {
      final value = held;
      held = null;
      if (value != null) controller.add(value);
    }

    void onData(List<T> value) {
      held = value;
      if (window != null) return;

      final Duration delay;
      try {
        delay = _interval(value.length);
      } catch (e, stk) {
        // Supplied by the integrator, so a throw here would otherwise reach the
        // zone and leave this stream silently stalled with no window armed.
        controller.addError(e, stk);
        return;
      }

      window = Timer(delay.isNegative ? Duration.zero : delay, () {
        window = null;
        emitHeld();
      });
    }

    void onDone() {
      window?.cancel();
      window = null;
      // Nothing more can arrive to collapse the held value with, so it goes
      // out now instead of waiting for a window that no longer matters.
      emitHeld();
      controller.close();
    }

    controller = StreamController<List<T>>(
      onListen: () => subscription = stream.listen(
        onData,
        onError: controller.addError,
        onDone: onDone,
      ),
      onPause: () => subscription?.pause(),
      onResume: () => subscription?.resume(),
      onCancel: () {
        window?.cancel();
        window = null;
        held = null;
        final sub = subscription;
        subscription = null;
        return sub?.cancel();
      },
    );

    return controller.stream;
  }
}
