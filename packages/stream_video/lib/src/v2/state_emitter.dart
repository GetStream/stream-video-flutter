import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

/// TODO
class StateEmitter<T> {
  /// Creates a new instance with given [initialValue].
  StateEmitter(T initialValue) : _state = BehaviorSubject.seeded(initialValue);

  final BehaviorSubject<T> _state;

  /// Get the latest value.
  T get value => _state.value;

  /// Set and emit the new value.
  @internal
  set value(T newValue) => _state.value = newValue;

  /// Adds a subscription to this emitter.
  StreamSubscription<T> listen(
    void onData(T value)?, {
    Function? onError,
  }) {
    return _state.listen(onData, onError: onError);
  }
}
