import 'dart:async';

class Subscriptions {
  final _subscriptions = <int, StreamSubscription<dynamic>>{};

  void add(int id, StreamSubscription<dynamic> subscription) {
    _subscriptions[id]?.cancel();
    _subscriptions[id] = subscription;
  }

  bool contains(int id) {
    return _subscriptions.containsKey(id);
  }
  
  void addIfAbsent(int id, StreamSubscription<dynamic> Function() ifAbsent) {
    if (_subscriptions.containsKey(id)) return;

    _subscriptions[id] = ifAbsent();
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
