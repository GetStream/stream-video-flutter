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

/// [changedOrNull] for capabilities by role, comparing each role's list in
/// order.
Map<String, List<String>>? changedCapabilitiesByRoleOrNull(
  Map<String, List<String>> current,
  Map<String, List<String>>? next,
) {
  if (next == null || identical(current, next)) return null;
  if (current.length != next.length) return next;
  for (final MapEntry(:key, :value) in current.entries) {
    final other = next[key];
    if (other == null || !const ListEquality<String>().equals(value, other)) {
      return next;
    }
  }
  return null;
}
