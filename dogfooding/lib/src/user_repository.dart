import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'model/user_credentials.dart';

const keyUserId = 'user_id';
const keyUserName = 'user_name';
const keyUserRole = 'user_role';
const keyUserImage = 'user_image';
const keyToken = 'token';

class UserRepository {
  UserRepository._singleton();

  static final UserRepository _instance = UserRepository._singleton();

  static UserRepository get instance => _instance;

  static final Future<SharedPreferences> _sharedPreferences =
      SharedPreferences.getInstance();

  Future<void> saveUserCredentials(UserCredentials userCredentials) async {
    final prefs = await _sharedPreferences;
    final user = userCredentials.user;
    final token = userCredentials.token;
    await prefs.setString(keyUserId, user.id);
    await prefs.setString(keyUserName, user.name);
    await prefs.setString(keyUserRole, user.role);
    await prefs.setString(keyUserImage, user.imageUrl ?? '');
    await prefs.setString(keyToken, token);
  }

  Future<UserCredentials?> getUserCredentials() async {
    final prefs = await _sharedPreferences;
    final id = prefs.getString(keyUserId);
    final name = prefs.getString(keyUserName);
    final role = prefs.getString(keyUserRole);
    final image = prefs.getString(keyUserImage);
    final token = prefs.getString(keyToken);

    if (id != null && name != null && role != null && token != null) {
      return UserCredentials(
        user: UserInfo(
          id: id,
          name: name,
          role: role,
          imageUrl: image,
        ),
        token: token,
      );
    } else {
      return null;
    }
  }

  Future<void> clear() async {
    final prefs = await _sharedPreferences;
    await prefs.remove(keyUserId);
    await prefs.remove(keyUserName);
    await prefs.remove(keyUserRole);
    await prefs.remove(keyUserImage);
    await prefs.remove(keyToken);
  }
}
