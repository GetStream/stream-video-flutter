import 'dart:async';

import 'package:rxdart/rxdart.dart';

abstract class SharedEmitter<T> {
  Future<E> waitFor<E extends T>({
    required Duration timeLimit,
  });

  StreamSubscription<E> on<E extends T>(void Function(T event) onEvent);

  Future<T> firstWhere(
    bool Function(T element) test, {
    required Duration timeLimit,
  });

  /// Adds a subscription to this emitter.
  StreamSubscription<T> listen(
    void Function(T value)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  });
}

abstract class MutableSharedEmitter<T> extends SharedEmitter<T> {
  void emit(T value);
  Future<dynamic> close();
}

/// TODO
class MutableSharedEmitterImpl<T> extends MutableSharedEmitter<T> {
  /// Creates a new instance.
  MutableSharedEmitterImpl() : _shared = PublishSubject();

  final PublishSubject<T> _shared;

  @override
  Future<dynamic> close() {
    return _shared.close();
  }

  /// Emit the new value.
  @override
  void emit(T value) {
    _shared.add(value);
  }

  Future<E> waitFor<E extends T>({
    required Duration timeLimit,
  }) {
    return _shared
        .takeWhile((it) => it is E)
        .cast<E>()
        .first
        .timeout(timeLimit);
  }

  StreamSubscription<E> on<E extends T>(void Function(T event) onEvent) {
    return _shared.where((it) => it is E).cast<E>().listen(onEvent);
  }

  Future<T> firstWhere(
    bool Function(T element) test, {
    required Duration timeLimit,
  }) {
    return _shared.firstWhere(test).timeout(timeLimit);
  }

  /// Adds a subscription to this emitter.
  StreamSubscription<T> listen(
    void Function(T value)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _shared.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}
