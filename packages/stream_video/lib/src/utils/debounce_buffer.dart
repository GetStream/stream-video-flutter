import 'dart:async';

typedef Consumer<T, R> = Future<R> Function(T items);

class DebounceBuffer<T, R> {
  DebounceBuffer({
    required this.duration,
    required this.consumer,
  });

  final Duration duration;
  final Consumer<List<T>, R> consumer;
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
      final result = await consumer([..._items]);
      completer.complete(result);
      _items.clear();
    });
    return completer.future;
  }
}
