import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'completer.dart';

typedef OnBuffered<T, R> = FutureOr<R> Function(List<T> items);
typedef OnCancel<R> = FutureOr<R> Function();

class DebounceBuffer<T, R> {
  DebounceBuffer({
    required this.duration,
    required this.onBuffered,
    required this.onCancel,
  }) {
    _subscription = _eventsSubject
        .buffer(_eventsSubject.debounceTime(duration))
        .asyncMap(onBuffered)
        .listen(
          _completer.completeSafely,
          onError: _completer.completeErrorSafely,
        );
  }

  final Duration duration;
  final OnBuffered<T, R> onBuffered;
  final OnCancel<R> onCancel;

  final _eventsSubject = BehaviorSubject<T>();
  late final StreamSubscription<R> _subscription;

  late Completer<R> _completer = Completer<R>();

  Future<R> post(T item) async {
    if (_completer.isCompleted) {
      _completer = Completer<R>();
    }
    _eventsSubject.add(item);
    return _completer.future;
  }

  Future<void> cancel() async {
    await _subscription.cancel();
    await _eventsSubject.close();
    try {
      final cancelResult = await onCancel();
      _completer.completeSafely(cancelResult);
    } catch (e, stk) {
      _completer.completeErrorSafely(e, stk);
    }
  }
}
