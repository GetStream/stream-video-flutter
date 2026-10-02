import 'package:collection/collection.dart';

/// Returns null when [next] has the same contents as [current], and [next]
/// otherwise.
///
/// Passed to `CallState.copyWith`, a null keeps the current instance.
C? changedOrNull<C extends Object>(C current, C? next) {
  if (next == null || const DeepCollectionEquality().equals(current, next)) {
    return null;
  }
  return next;
}
