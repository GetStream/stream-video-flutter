import 'package:stream_video_flutter/stream_video_flutter.dart';

class UserCredentials {
  const UserCredentials({
    required this.user,
    required this.token,
  });

  final UserInfo user;
  final String token;
}
