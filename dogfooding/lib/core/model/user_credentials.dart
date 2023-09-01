// 📦 Package imports:
import 'package:stream_video_flutter/stream_video_flutter.dart';

class UserCredentials {
  const UserCredentials({
    required this.token,
    required this.userInfo,
  });

  final UserToken token;
  final UserInfo userInfo;

  factory UserCredentials.fromJson(Map<String, Object?> json) {
    return UserCredentials(
      token: UserToken.fromRawValue(json['token']! as String),
      userInfo: UserInfo.fromJson(json['user']! as Map<String, Object?>),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'token': token.rawValue,
      'user': userInfo.toJson(),
    };
  }
}
