import 'package:stream_video/protobuf/video/coordinator/user_v1/user.pbserver.dart';

/// A function which can be used to request a Stream Video API token from your
/// own backend server
typedef GuestTokenProvider = Future<String> Function(User user);

/// Token designed to store the JWT and the user it is related to.
class Token {
  final String rawValue;
  Token(this.rawValue);
}
