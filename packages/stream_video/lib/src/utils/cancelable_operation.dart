import 'package:async/async.dart' as async;

import 'cancelables.dart';

extension CancelableOperationX<T> on async.CancelableOperation<T> {
  Future<T> valueOrDefault(T cancellationValue) {
    return valueOrCancellation(cancellationValue).then((value) => value!);
  }

  async.CancelableOperation<T> storeIn(int id, Cancelables cancelables) {
    cancelables.add(id, this);
    return this;
  }
}