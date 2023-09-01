// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';

// 📦 Package imports:
import 'package:stream_video_flutter/stream_video_flutter.dart';

// 🌎 Project imports:
import 'package:flutter_dogfooding/core/model/user_credentials.dart';
import 'package:flutter_dogfooding/core/repos/user_auth_repository.dart';
import '../core/repos/app_preferences.dart';

/// A controller that handles user authentication.
///
/// This controller is used to handle user authentication. It is used to login
/// users, logout users, and get the current user.
///
/// This controller is also used to keep track of the current user. It will
/// notify listeners when the current user changes.
///
/// see also:
///
///  * [UserAuthRepository], which is used to handle the actual authentication
///  logic.
///  * [AppPreferences], which is used to store the user credentials.
class UserAuthController extends ChangeNotifier {
  UserAuthController({
    required AppPreferences prefs,
    required UserAuthRepository authRepo,
  })  : _prefs = prefs,
        _authRepo = authRepo;

  final AppPreferences _prefs;
  final UserAuthRepository _authRepo;

  /// Returns the current user if they are logged in, or null if they are not.
  UserInfo? get currentUser => _currentUser;
  UserInfo? _currentUser;

  /// Creates a guest user and logs them in.
  Future<UserCredentials> guestLogin() async {
    final credentials = await _authRepo.guestLogin();
    _currentUser = credentials.userInfo;
    notifyListeners();
    return credentials;
  }

  /// Logs in with the given user info.
  Future<UserCredentials> loginWithInfo(UserInfo info) async {
    final credentials = await _authRepo.loginWithInfo(info);
    _currentUser = credentials.userInfo;
    await _prefs.setUserCredentials(credentials);
    notifyListeners();
    return credentials;
  }

  /// Logs out the current user.
  Future<void> logout() async {
    _currentUser = null;
    await _authRepo.logout();
    await _prefs.clearUserCredentials();
    notifyListeners();
  }
}
