import 'package:collection/collection.dart';

/// Returns null when [next] has the same contents as [current], and [next]
/// otherwise.
///
/// Passed to `CallState.copyWith`, a null keeps the current collection, so an
/// update that doesn't change a collection keeps its instance. A partial state
/// selector that returns the collection, or a record that holds it, then sees
/// no change.
C? changedOrNull<C extends Object>(C current, C? next) {
  if (next == null || const DeepCollectionEquality().equals(current, next)) {
    return null;
  }
  return next;
}
