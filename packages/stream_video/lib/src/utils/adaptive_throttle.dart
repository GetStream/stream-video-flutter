import 'dart:async';

/// How long a window lasts, given the size of the collection that opened it.
typedef CollectionThrottleInterval = Duration Function(int size);

extension AdaptiveCollectionThrottleX<T> on Stream<List<T>> {
  /// Rate-limits this stream to one value per window, where [interval] decides
  /// how long that window is from the size of the list that opened it.
  ///
  /// The value emitted is the most recent one to arrive during the window, so
  /// a change is never dropped — only collapsed with the ones around it. The
  /// window opens on the first value after an idle period and that value is
  /// held until it closes, which means a listener's first value is delayed by
  /// up to one interval.
  ///
  /// [interval] is evaluated once per window, when it opens. A value arriving
  /// mid-window does not restart or re-measure it, so a change in list size
  /// takes effect on the next window.
  ///
  /// When the source closes, anything still held is emitted before this stream
  /// closes, whether or not a window was open.
  Stream<List<T>> throttleByCollectionSize({
    required CollectionThrottleInterval interval,
  }) {
    return transform(_CollectionThrottle<T>(interval));
  }
}

/// Written by hand rather than with `rxdart`'s `throttle`, whose
/// `eventAfterLastWindow` strategy leaves the sink open when the source closes
/// with no window running, and drops a lone held value when it closes with one.
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
      window ??= Timer(_interval(value.length), () {
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
