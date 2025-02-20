import 'dart:math';

/// Extensions on [String].
extension StringExtension on String {
  /// Returns initials for a string
  String initials() {
    var parts = split(' ')..removeWhere((e) => e == '');

    if (parts.length > 2) {
      parts = parts.take(2).toList();
    }

    final resultBuffer = StringBuffer();

    for (var i = 0; i < parts.length; i++) {
      resultBuffer.write(parts[i][0].toUpperCase());
    }

    return resultBuffer.toString();
  }

  bool equalsIgnoreCase(String other) => toUpperCase() == other.toUpperCase();
}

/// Extensions on [List].
extension ListAt<T extends Object> on List<T> {
  /// Returns an element at the specified [index] or null.
  T? at(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }
}

/// Extensions on [Iterable].
extension IterableExtension<T> on Iterable<T> {
  /// Insert any [item] inBetween the list items
  List<T> insertBetween(T item) => expand((e) sync* {
        yield item;
        yield e;
      }).skip(1).toList(growable: false);
}

/// Extensions on [double].
extension DoubleExtension on double {
  /// Ensures that this value lies in the specified range.
  double coerceIn(double minimumValue, double maximumValue) {
    return max(minimumValue, min(this, maximumValue));
  }
}
