import 'dart:async';

class Subscriptions {
  final _subscriptions = <int, StreamSubscription<dynamic>>{};

  void add(int id, StreamSubscription<dynamic> subscription) {
    _subscriptions[id] = subscription;
  }

  Future<void> cancel(int id) async {
    await _subscriptions[id]?.cancel();
  }

  Future<void> cancelAll() async {
    for (final subscription in _subscriptions.values) {
      await subscription.cancel();
    }
    _subscriptions.clear();
  }
}
