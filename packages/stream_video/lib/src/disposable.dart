import 'dart:async';

import 'package:meta/meta.dart';

/// A convenience class to represent a disposable object.
class Disposable {
  /// Returns `true` if this object has been disposed.
  bool get isDisposed => _disposed;
  bool _disposed = false;

  /// Disposes of this object.
  @mustCallSuper
  FutureOr<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
  }
}
