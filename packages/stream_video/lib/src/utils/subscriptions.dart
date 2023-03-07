import 'dart:async';

class Subscriptions {
  final _subscriptions = <int, StreamSubscription<dynamic>>{};

  void add(int id, StreamSubscription<dynamic> subscription) {
    _subscriptions[id]?.cancel();
    _subscriptions[id] = subscription;
  }

  void cancel(int id) {
    _subscriptions[id]?.cancel();
    _subscriptions.remove(id);
  }

  void cancelAll() {
    for (final subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }
}
