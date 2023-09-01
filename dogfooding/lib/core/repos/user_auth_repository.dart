// 🎯 Dart imports:
import 'dart:math' as math;

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

  final StreamVideo videoClient;
  final TokenService tokenService;

  Future<UserCredentials> guestLogin() async {
    final userData = await _createGuestUser();
    final userInfo = userData.user.toUserInfo();
    final response = await videoClient.connectUser(
      userInfo,
      userData.accessToken,
    );

    final userToken = response.getDataOrNull();
    if (userToken == null) {
      throw Exception('Failed to connect user');
    }

    return UserCredentials(
      userInfo: userInfo,
      token: UserToken.fromRawValue(userToken),
    );
  }

  Future<GuestCreatedData> _createGuestUser() async {
    final guestId = randomId(size: 6);
    final userResponse = await videoClient.createGuest(
      id: guestId,
      name: guestId,
      image:
          'https://vignette.wikia.nocookie.net/starwars/images/2/20/LukeTLJ.jpg',
    );

    final user = userResponse.getDataOrNull();
    if (user == null) {
      throw Exception('Failed to create guest user');
    }

    return user;
  }

  Future<UserCredentials> loginWithInfo(UserInfo info) async {
    final response = await videoClient.connectUserWithProvider(
      info,
      tokenProvider: TokenProvider.dynamic((userId) {
        return tokenService.loadToken(userId: userId);
      }),
    );

    final userToken = response.getDataOrNull();
    if (userToken == null) {
      throw Exception('Failed to connect user');
    }

    return UserCredentials(
      userInfo: info,
      token: UserToken.fromRawValue(userToken),
    );
  }

  UserInfo? get currentUser => videoClient.currentUser;

  Future<void> logout() => videoClient.disconnectUser();
}

extension on UserResponseData {
  /// Converts [UserResponseData] to [UserInfo]
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

// This alphabet uses `A-Za-z0-9_-` symbols. The genetic algorithm helped
// optimize the gzip compression for this alphabet.
const _alphabet =
    'ModuleSymbhasOwnPr-0123456789ABCDEFGHNRVfgctiUvz_KqYTJkLxpZXIjQW';

/// Generates a random String id
/// Adopted from: https://github.com/ai/nanoid/blob/main/non-secure/index.js
String randomId({int size = 21}) {
  var id = '';
  for (var i = 0; i < size; i++) {
    id += _alphabet[(math.Random().nextDouble() * 64).floor() | 0];
  }
  return id;
}
