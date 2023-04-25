import 'dart:async';

import 'package:async/async.dart' as async;

import 'stream.dart';

extension FutureX<T> on Future<T> {
  async.CancelableOperation<T> asCancelable() {
    return async.CancelableOperation.fromFuture(this);
  }

  StreamSubscription<T> listenFirst(
    void Function(T event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return asStream().listenFirst(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}
