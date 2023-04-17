import 'dart:async';

typedef Consumer<T, R> = Future<R> Function(List<T> items);

class DebounceBuffer<T, R> {
  DebounceBuffer({
    required this.duration,
    required this.onComplete,
    required this.onCancel,
  });

  final Duration duration;
  final Consumer<T, R> onComplete;
  final Consumer<T, R> onCancel;
  Completer<R> completer = Completer<R>();
  Timer? _timer;

  final _items = <T>[];

  Future<R> post(T item) async {
    if (completer.isCompleted) {
      completer = Completer<R>();
    }
    _items.add(item);
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    _timer = Timer(duration, () async {
      await _complete(onComplete);
    });
    return completer.future;
  }

  Future<void> cancel() async {
    _timer?.cancel();
    await _complete(onCancel);
  }

  Future<void> _complete(Consumer<T, R> consumer) async {
    if (!completer.isCompleted) {
      try {
        final result = await consumer([..._items]);
        completer.complete(result);
      } catch (e, stk) {
        completer.completeError(e, stk);
      }
      _items.clear();
    }
  }
}
