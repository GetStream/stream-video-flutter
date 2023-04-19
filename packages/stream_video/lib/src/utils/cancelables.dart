import 'package:async/async.dart';

class Cancelables {
  final _cancelables = <int, CancelableOperation<dynamic>>{};

  void add(int id, CancelableOperation<dynamic> cancelable) {
    _cancelables[id]?.cancel();
    _cancelables[id] = cancelable;
  }

  void cancel(int id) {
    _cancelables[id]?.cancel();
    _cancelables.remove(id);
  }

  void cancelAll() {
    for (final cancelable in _cancelables.values) {
      cancelable.cancel();
    }
    _cancelables.clear();
  }
}
