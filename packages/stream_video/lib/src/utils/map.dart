import 'pair.dart';

/// Returns a new map containing all key-value pairs from the given collection of pairs.
///
/// The returned map preserves the entry iteration order of the original collection.
/// If any of two pairs would have the same key the last one gets added to the map.
extension MapPairUtils<K, V> on Iterable<Pair<K, V>> {
  Map<K, V> toMap() => <K, V>{
        for (final pair in this) pair.first: pair.second,
      };
}
