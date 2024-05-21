/// Extensions on [String].
extension StringExtension on String {
  bool equalsIgnoreCase(String other) => toUpperCase() == other.toUpperCase();
  String capitalizeFirstLetter() => '${this[0].toUpperCase()}${substring(1)}';
}
