import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

/// TODO
class SharedEmitter<T> {
  /// Creates a new instance.
  SharedEmitter() : _shared = PublishSubject();

  final PublishSubject<T> _shared;

  /// Set and emit the new value.
  @internal
  set emit(T newValue) {
    _shared.add(newValue);
  }

  /// Adds a subscription to this emitter.
  StreamSubscription<T> listen(
    void onData(T value)?, {
    Function? onError,
    void onDone()?,
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
