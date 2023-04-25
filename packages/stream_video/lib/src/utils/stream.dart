import 'dart:async';

const _one = 1;

extension StreamX<T> on Stream<T> {
  StreamSubscription<T> listenFirst(
    void Function(T event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return take(_one).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}
