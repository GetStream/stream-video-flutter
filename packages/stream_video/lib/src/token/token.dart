import '../models/user_info.dart';

/// A function which can be used to request a Stream Video API token from your
/// own backend server
typedef GuestTokenProvider = Future<String> Function(UserInfo user);

/// Token designed to store the JWT and the user it is related to.
class Token {
  Token(this.rawValue);
  final String rawValue;
}
