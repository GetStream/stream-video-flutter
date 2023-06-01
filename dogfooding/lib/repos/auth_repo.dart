import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' hide Success;
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../env/env.dart';
import '../src/model/user_credentials.dart';
import 'user_repository.dart';

class AuthRepository {
  AuthRepository({
    required this.tokenService,
    required this.streamVideo,
    required this.streamChat,
    required this.googleSignIn,
  });

  final TokenService tokenService;
  final StreamVideo streamVideo;
  final StreamChatClient streamChat;
  final GoogleSignIn googleSignIn;

  final _logger = taggedLogger(tag: 'SV:LoginViewState');
  // late final _googleSignIn = GoogleSignIn(hostedDomain: 'getstream.io');

  String? _userToken;

  Future<GoogleSignInAccount?> signInWithGoogle() {
    return googleSignIn.signIn();
  }

  Future<void> loginWithUserInfo(UserInfo user) async {
    final tokenResult = await streamVideo.connectUserWithProvider(
      user,
      tokenProvider: TokenProvider.dynamic(_tokenLoader, (token) async {
        _logger.d(() => '[onTokenUpdated] token: $token');
        final userCredentials = UserCredentials(
          user: user,
          token: token,
        );
        _userToken = token;
        await UserRepository.instance.saveUserCredentials(userCredentials);
      }),
    );

    final chatUID = md5.convert(utf8.encode(user.id)).toString();

    final chatUser = User(
      id: chatUID,
      extraData: {
        'name': user.name,
        'image': user.image,
      },
    );

    if (_userToken != null) {
      await streamChat.connectUserWithProvider(chatUser, _tokenLoader);
    } else {
      await streamChat.connectUserWithProvider(chatUser, _tokenLoader);
    }

    _logger.d(() => '[onLoginSuccess] tokenResult: $tokenResult');

    if (tokenResult is! Success<String>) {
      // TODO show error
      return;
    }

    return;
  }

  Future<String> _tokenLoader(String userId) async {
    final token = await tokenService.loadToken(
      apiKey: Env.apiKey,
      userId: userId,
    );
    _logger.d(() => '[_tokenLoader] loading...: $token');
    return token;
  }
}
