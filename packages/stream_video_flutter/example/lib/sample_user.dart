import 'package:stream_video/stream_video.dart';

/// Class that defines a user for this sample app.
class SampleUser {
  /// Creates a new instance of [SampleUser].
  SampleUser(this.userInfo, this.token);

  /// Contains information about the user.
  final UserInfo userInfo;

  /// Stream Video API token.
  final String token;
}
