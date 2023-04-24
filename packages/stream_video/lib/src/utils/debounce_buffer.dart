import 'dart:async';

import 'completer.dart';
import 'future.dart';

typedef OnBuffered<T, R> = Future<R> Function(List<T> items);
typedef OnCancel<R> = R Function();

class DebounceBuffer<T, R> {
  DebounceBuffer({
    required this.duration,
    required this.onBuffered,
    required this.onCancel,
  });

  final Duration duration;
  final OnBuffered<T, R> onBuffered;
  final OnCancel<R> onCancel;
  Completer<R> _completer = Completer<R>();
  Timer? _timer;
  StreamSubscription<R>? _subscription;

  final _items = <T>[];

  Future<R> post(T item) async {
    if (_completer.isCompleted) {
      _completer = Completer<R>();
    }
    _items.add(item);
    _timer?.cancel();
    _timer = Timer(duration, () async {
      await _complete();
    });
    return _completer.future;
  }

  Future<void> cancel() async {
    _timer?.cancel();
    await _subscription?.cancel();
    try {
      _completer.completeSafely(onCancel());
    } catch (e, stk) {
      _completer.completeErrorSafely(e, stk);
    }
  }

  Future<void> _complete() async {
    final isCompleted = _completer.isCompleted;
    if (!isCompleted) {
      await _subscription?.cancel();
      _subscription = onBuffered([..._items]).listenFirst(
        _completer.completeSafely,
        onError: _completer.completeErrorSafely,
      );
      _items.clear();
    }
  }
}
