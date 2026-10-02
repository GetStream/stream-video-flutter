import 'package:collection/collection.dart';

/// Whether two values returned by a partial state selector are the same, as
/// `Call.partialState` compares them: equal by `==`, or collections with
/// equal contents.
///
/// Collections are compared deeply, so a map of lists counts as unchanged
/// when only its instances are new. Maps and sets are compared regardless of
/// order. A record compares its fields with `==`, so a list inside a record is
/// compared by identity.
bool isSameCallStateSelection(Object? previous, Object? current) {
  if (identical(previous, current) || previous == current) return true;
  if ((previous is Iterable && current is Iterable) ||
      (previous is Map && current is Map)) {
    return const DeepCollectionEquality().equals(previous, current);
  }
  return false;
}
