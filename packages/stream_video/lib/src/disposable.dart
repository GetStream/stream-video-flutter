import 'package:flutter/cupertino.dart';

/// A convenience class to represent a disposable object.
class Disposable {
  /// Returns `true` if this object has been disposed.
  bool get isDisposed => _disposed;
  bool _disposed = false;

  /// Disposes of this object.
  @mustCallSuper
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
  }
}