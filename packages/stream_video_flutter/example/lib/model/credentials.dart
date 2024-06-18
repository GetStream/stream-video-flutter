// ignore_for_file: cast_nullable_to_non_nullable

import 'package:stream_video/stream_video.dart';

class AuthCredentials {
  const AuthCredentials({
    required this.apiKey,
    required this.token,
    required this.userInfo,
  });

  factory AuthCredentials.fromJson(Map<String, Object?> json) {
    return AuthCredentials(
      apiKey: json['apiKey']! as String,
      token: UserToken.jwt(json['token']! as String),
      userInfo: _parseUserInfoFromJson(json['user']! as Map<String, Object?>),
    );
  }

  final String apiKey;
  final UserToken token;
  final UserInfo userInfo;

  Map<String, Object?> toJson() {
    return {
      'apiKey': apiKey,
      'token': token.rawValue,
      'user': userInfo.toJson(),
    };
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
