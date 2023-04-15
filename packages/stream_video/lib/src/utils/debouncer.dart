import 'dart:async';

typedef Consumer<T, R> = Future<R> Function(T items);

class Debouncer<T, R> {
  Debouncer({
    required this.duration,
    required this.consumer,
  });

  final Duration duration;
  final Consumer<List<T>, R> consumer;
  Completer<R> completer = Completer<R>();
  Timer? _timer;

  final items = <T>[];

  Future<R> post(T item) async {
    if (completer.isCompleted) {
      completer = Completer<R>();
    }
    items.add(item);
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    _timer = Timer(duration, () async {
      final result = await consumer([...items]);
      completer.complete(result);
      items.clear();
    });
    return completer.future;
  }
}
