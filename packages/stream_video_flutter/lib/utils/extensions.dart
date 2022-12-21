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
