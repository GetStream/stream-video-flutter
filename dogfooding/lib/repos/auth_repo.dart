import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' hide Success;
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../env/env.dart';
import '../src/model/user_credentials.dart';
import 'app_repository.dart';
import 'user_repository.dart';

class AuthRepository {
  AuthRepository._singleton();

  static final AuthRepository _instance = AuthRepository._singleton();

  static AuthRepository get instance => _instance;

  final _logger = taggedLogger(tag: 'SV:LoginViewState');

  late final _googleSignIn = GoogleSignIn(hostedDomain: 'getstream.io');

  late final _tokenService = TokenService();

  Future<GoogleSignInAccount?> signInWithGoogle() {
    return _googleSignIn.signIn();
  }

  Future<void> loginWithUserInfo(UserInfo user) async {
    final chatClient = AppRepository.instance.streamChatClient;

    final tokenResult = await StreamVideo.instance.connectUserWithProvider(
      user,
      tokenProvider: TokenProvider.dynamic(_tokenLoader, (token) async {
        _logger.d(() => '[onTokenUpdated] token: $token');
        final userCredentials = UserCredentials(
          user: user,
          token: token,
        );
        await UserRepository.instance.saveUserCredentials(userCredentials);
        final chatUID = md5.convert(utf8.encode(user.id)).toString();
        await chatClient?.connectUser(User(id: chatUID), token);
      }),
    );
    _logger.d(() => '[onLoginSuccess] tokenResult: $tokenResult');
    if (tokenResult is! Success<String>) {
      // TODO show error
      return;
    }
  }

  Future<String> _tokenLoader(String userId) async {
    return _tokenService.loadToken(
      apiKey: Env.apiKey,
      userId: userId,
    );
  }
}
