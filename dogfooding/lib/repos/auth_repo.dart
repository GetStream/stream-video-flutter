import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' hide Success;
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../env/env.dart';
import '../src/model/user_credentials.dart';
import 'token_service.dart';
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

  UserToken? _userToken;

  Future<GoogleSignInAccount?> signInWithGoogle() {
    return googleSignIn.signIn();
  }

  Future<void> loginAsGuest() async {
    final guestId = randomString(6);
    const imageUrl =
        'https://vignette.wikia.nocookie.net/starwars/images/2/20/LukeTLJ.jpg';

    final guest = await streamVideo.createGuest(
      id: guestId,
      name: guestId,
      image: imageUrl,
    );
    final data = guest.getDataOrNull();
    if (data == null) {
      throw Exception();
    }

    final finalUser = UserInfo(
      id: data.user.id,
      image: data.user.image,
      name: data.user.name ?? '',
      teams: data.user.teams,
      role: data.user.role,
    );

    final userCredentials = UserCredentials(
      user: finalUser,
      token: UserToken.jwt(data.accessToken),
    );

    await streamVideo.connectUser(finalUser, data.accessToken);
    _userToken = UserToken.jwt(data.accessToken);
    await UserRepository.instance.saveUserCredentials(userCredentials);

    final chatUID = md5.convert(utf8.encode(finalUser.id)).toString();

    final chatUser = User(
      id: chatUID,
      extraData: {
        'name': finalUser.name,
        'image': finalUser.image,
      },
    );

    if (_userToken != null) {
      await streamChat.connectUserWithProvider(chatUser, _tokenLoader);
    } else {
      await streamChat.connectUserWithProvider(chatUser, _tokenLoader);
    }

    return;
  }

  Future<void> loginWithUserInfo(UserInfo user) async {
    final tokenResult = await streamVideo.connectUserWithProvider(
      user,
      tokenProvider: TokenProvider.dynamic(
        _tokenLoader,
        onTokenUpdated: (token) async {
          _logger.d(() => '[onTokenUpdated] token: $token');
          final userCredentials = UserCredentials(
            user: user,
            token: token,
          );
          _userToken = token;
          await UserRepository.instance.saveUserCredentials(userCredentials);
        },
      ),
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

  String randomString(int length) {
    final rand = Random();
    const letters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(length, (l) {
      return letters[rand.nextInt(letters.length)];
    }).fold('', (previousValue, element) => previousValue + element);
  }
}
