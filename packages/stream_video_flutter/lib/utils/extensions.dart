/// Useful extension for [String]
extension StringExtension on String {
  /// Returns initials for a string
  String initials() {
    var parts = split(' ')..removeWhere((e) => e == '');

    if (parts.length > 2) {
      parts = parts.take(2).toList();
    }

    var result = '';

    for (var i = 0; i < parts.length; i++) {
      result = result + parts[i][0].toUpperCase();
    }

    return result;
  }
}

/// Useful extension for [List].
extension ListAt<T extends Object> on List<T> {
  /// Returns an element at the specified [index] or null.
  T? at(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }
}
