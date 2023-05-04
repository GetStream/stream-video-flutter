import 'dart:async';

import 'package:rxdart/rxdart.dart';

abstract class StateEmitter<T> {
  T get value;

  Stream<T> get valueStream;

  bool get hasValue;

  T? get valueOrNull;

  StreamSubscription<T> listen(
    void Function(T value)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  });

  Future<E> waitFor<E extends T>({
    required Duration timeLimit,
  });

  Future<T> firstWhere(
    bool Function(T element) test, {
    T Function()? orElse,
    required Duration timeLimit,
  });

  Stream<T> asStream();
}

abstract class MutableStateEmitter<T> extends StateEmitter<T> {
  set value(T newValue);

  Sink<T> get valueSink;

  Future<dynamic> close();
}

/// TODO
class MutableStateEmitterImpl<T> extends MutableStateEmitter<T> {
  /// Creates a new instance with given [initialValue].
  MutableStateEmitterImpl(
    T? initialValue, {
    bool sync = false,
  }) : _state = initialValue == null
            ? BehaviorSubject(sync: sync)
            : BehaviorSubject.seeded(initialValue, sync: sync);

  final BehaviorSubject<T> _state;

  /// Get the latest value.
  @override
  T get value => _state.value;

  @override
  Stream<T> get valueStream => _state.stream;

  @override
  bool get hasValue => _state.hasValue;

  @override
  T? get valueOrNull => _state.valueOrNull;

  /// Set and emit the new value.
  @override
  set value(T newValue) => _state.value = newValue;

  @override
  Sink<T> get valueSink => _state.sink;

  @override
  Future<E> waitFor<E extends T>({
    required Duration timeLimit,
  }) {
    return firstWhere(
      (it) => it is E,
      timeLimit: timeLimit,
    ).then((it) => it as E);
  }

  @override
  Future<T> firstWhere(
    bool Function(T element) test, {
    T Function()? orElse,
    required Duration timeLimit,
  }) {
    return _state.firstWhere(test, orElse: orElse).timeout(timeLimit);
  }

  @override
  Future<dynamic> close() {
    return _state.close();
  }

  /// Adds a subscription to this emitter.
  @override
  StreamSubscription<T> listen(
    void Function(T value)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _state.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  Stream<T> asStream() => _state;
}
