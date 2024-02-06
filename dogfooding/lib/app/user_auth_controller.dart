// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter_dogfooding/core/repos/token_service.dart';
import 'package:flutter_dogfooding/core/repos/user_chat_repository.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' hide User;

// 📦 Package imports:
import 'package:stream_video_flutter/stream_video_flutter.dart';

// 🌎 Project imports:
import 'package:flutter_dogfooding/core/model/user_credentials.dart';
import 'package:flutter_dogfooding/core/repos/user_auth_repository.dart';
import '../core/repos/app_preferences.dart';
import '../di/injector.dart';

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
    required TokenService tokenService,
  })  : _prefs = prefs,
        _tokenService = tokenService;

  final AppPreferences _prefs;
  final TokenService _tokenService;

  UserAuthRepository? _authRepo;

  /// Returns the current user if they are logged in, or null if they are not.
  UserInfo? get currentUser => _currentUser;
  UserInfo? _currentUser;

  /// Logs in the given [user] and returns the user credentials.
  Future<UserCredentials> login(User user) async {
    final tokenResponse = await _tokenService.loadToken(userId: user.id);
    await _prefs.setApiKey(tokenResponse.apiKey);

    _authRepo ??=
        locator.get<UserAuthRepository>(param1: user, param2: tokenResponse);
    final credentials = await _authRepo!.login();
    _currentUser = credentials.userInfo;

    // Store the user credentials if the user is not anonymous.
    if (_authRepo!.currentUserType != UserType.anonymous) {
      await _prefs.setUserCredentials(credentials);
    }

    notifyListeners();
    return credentials;
  }

  /// Logs out the current user.
  Future<void> logout() async {
    _currentUser = null;

    if (_authRepo != null) {
      await _authRepo!.logout();
      _authRepo = null;

      // Unregister the video client.
      locator.unregister<StreamVideo>(
        disposingFunction: (_) => StreamVideo.reset(),
      );

      locator.unregister<StreamChatClient>();
      locator.unregister<UserChatRepository>();
    }

    await _prefs.clearUserCredentials();
    notifyListeners();
  }
}
