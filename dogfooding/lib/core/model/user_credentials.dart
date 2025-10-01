// 📦 Package imports:
// ignore_for_file: cast_nullable_to_non_nullable

import 'package:stream_video_flutter/stream_video_flutter.dart';

class UserCredentials {
  const UserCredentials({required this.token, required this.userInfo});

  factory UserCredentials.fromJson(Map<String, Object?> json) {
    return UserCredentials(
      token: UserToken.jwt(json['token']! as String),
      userInfo: _parseUserInfoFromJson(json['user']! as Map<String, Object?>),
    );
  }

  final UserToken token;
  final UserInfo userInfo;

  Map<String, Object?> toJson() {
    return {'token': token.rawValue, 'user': userInfo.toJson()};
  }
}

UserInfo _parseUserInfoFromJson(Map<String, Object?> json) {
  return UserInfo(
    id: json['id'] as String,
    name: json['name'] as String,
    role: json['role'] as String,
    image: json['image'] as String?,
    teams: (json['teams'] as List<dynamic>).cast(),
    extraData: json['extra_data'] as Map<String, Object?>,
  );
}
