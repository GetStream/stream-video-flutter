// 📦 Package imports:
import 'package:stream_video_flutter/stream_video_flutter.dart';

// 🌎 Project imports:
import '../model/user_credentials.dart';
import 'token_service.dart';

class UserAuthRepository {
  const UserAuthRepository({
    required this.videoClient,
    required this.tokenService,
  });

  final TokenService tokenService;
  final StreamVideo videoClient;

  Future<UserCredentials> login() async {
    final response = await videoClient.connect();

    return response.fold(success: (success) {
      return UserCredentials(
        token: success.data,
        userInfo: currentUser,
      );
    }, failure: (failure) {
      throw failure.error;
    });
  }

  UserInfo get currentUser => videoClient.currentUser;

  UserType get currentUserType => videoClient.currentUserType;

  Future<void> logout() => videoClient.disconnect();
}

extension on UserResponseData {
  /// Converts [UserResponseData] to [UserInfo]
  // ignore: unused_element
  UserInfo toUserInfo() {
    return UserInfo(
      id: id,
      role: role,
      name: name ?? '',
      image: image,
      teams: teams,
    );
  }
}
