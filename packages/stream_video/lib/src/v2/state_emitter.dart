import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

abstract class StateEmitter<T> {
  T get value;
  StreamSubscription<T> listen(
    void Function(T value)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  });
}

abstract class MutableStateEmitter<T> extends StateEmitter<T> {
  set value(T newValue);
  Future<dynamic> close();
}

/// TODO
class MutableStateEmitterImpl<T> extends MutableStateEmitter<T> {
  /// Creates a new instance with given [initialValue].
  MutableStateEmitterImpl(T initialValue)
      : _state = BehaviorSubject.seeded(initialValue);

  final BehaviorSubject<T> _state;

  /// Get the latest value.
  @override
  T get value => _state.value;

  /// Set and emit the new value.
  @override
  set value(T newValue) => _state.value = newValue;

  @override
  Future<dynamic> close() {
    return _state.close();
  }

  /// Adds a subscription to this emitter.
  StreamSubscription<T> listen(
    void onData(T value)?, {
    Function? onError,
    void onDone()?,
    bool? cancelOnError,
  }) {
    return _state.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}
