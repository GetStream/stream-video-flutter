
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';

const streamVideoPrefixKey = 'stream_video_';

const keyUserId = '${streamVideoPrefixKey}user_id';
const keyUserName = '${streamVideoPrefixKey}user_name';
const keyUserRole = '${streamVideoPrefixKey}user_role';
const keyUserImage = '${streamVideoPrefixKey}user_image';
const keyToken = '${streamVideoPrefixKey}token';

class SharedPrefsHelper {
  SharedPrefsHelper({bool init = true}) {
    if(init) {
      initPrefs();
    }
  }

  late SharedPreferences _preferences;

  Future<void> initPrefs() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> saveUserCredentials(UserInfo user) async {
    await _preferences.setString(keyUserId, user.id);
    await _preferences.setString(keyUserName, user.name);
    await _preferences.setString(keyUserRole, user.role);
    await _preferences.setString(keyUserImage, user.image ?? '');
  }

  UserInfo getSavedUser() {
    final userId = _preferences.getString(keyUserId) ?? '';
    final userName = _preferences.getString(keyUserName) ?? '';
    final userRole = _preferences.getString(keyUserRole) ?? '';
    final userImage = _preferences.getString(keyUserImage) ?? '';
    return UserInfo(id: userId, role: userRole, name: userName, image: userImage);
  }
}
