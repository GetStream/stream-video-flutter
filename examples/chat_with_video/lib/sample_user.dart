/// Class that defines a user for this sample app.
class SampleUser {
  /// Creates a new sample user.
  const SampleUser({
    required this.id,
    required this.name,
    required this.role,
    required this.image,
    required this.videoToken,
    required this.chatToken,
  });

  /// User id.
  final String id;

  /// User name.
  final String name;

  /// User role.
  final String role;

  /// User avatar.
  final String image;

  /// Stream Video API token.
  final String videoToken;

  /// Stream Chat API token.
  final String chatToken;
}
