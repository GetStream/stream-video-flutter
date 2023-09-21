import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as chat
    hide Success;
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../env/env.dart';
import '../src/model/user_credentials.dart';
import 'app_repository.dart';
import 'token_service.dart';
import 'user_repository.dart';

class AuthRepository {
  AuthRepository({
    required this.tokenService,
    required this.streamChat,
    required this.googleSignIn,
  });

  final TokenService tokenService;
  final chat.StreamChatClient streamChat;
  final GoogleSignIn googleSignIn;

  late StreamVideo streamVideo;

  final _logger = taggedLogger(tag: 'SV:LoginViewState');

  UserToken? _userToken;

  Future<GoogleSignInAccount?> signInWithGoogle() {
    return googleSignIn.signIn();
  }

  Future<void> loginAsGuest() async {
    if (StreamVideo.isInitialized()) {
      _logger.w(
        () => '[loginAsGuest] rejected (StreamVideo has '
            'already been initialised.)',
      );
      return;
    }
    final guestId = randomString(6);
    const imageUrl =
        'https://vignette.wikia.nocookie.net/starwars/images/2/20/LukeTLJ.jpg';
    _logger.d(() => '[loginAsGuest] guestId: $guestId');

    final guest = User.guest(guestId, image: imageUrl);
    streamVideo = await AppRepository.ensureVideoInitialized(
      user: guest,
      onTokenUpdated: (token) async {
        _logger.v(() => '[loginAsGuest] #onTokenUpdated; token: $token');
        _userToken = token;
        final userCredentials = UserCredentials(
          user: streamVideo.currentUser!,
          token: token,
        );
        await UserRepository.instance.saveUserCredentials(userCredentials);
      },
    );

    await streamVideo.connect();
    final finalUser = streamVideo.currentUser!;
    _logger.v(() => '[loginAsGuest] finalUser: $finalUser');

    final chatUID = md5.convert(utf8.encode(finalUser.id)).toString();

    final chatUser = chat.User(
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
    if (StreamVideo.isInitialized()) {
      _logger.w(
        () => '[loginWithUserInfo] rejected (StreamVideo has '
            'already been initialised.)',
      );
      return;
    }
    _logger.d(() => '[loginWithUserInfo] user.id: ${user.id}');
    streamVideo = await AppRepository.ensureVideoInitialized(
      user: User(info: user),
      tokenLoader: _tokenLoader,
      onTokenUpdated: (token) async {
        _logger.v(() => '[loginWithUserInfo] #onTokenUpdated; token: $token');
        _userToken = token;
        final userCredentials = UserCredentials(
          user: streamVideo.currentUser!,
          token: token,
        );
        await UserRepository.instance.saveUserCredentials(userCredentials);
      },
    );
    final result = await streamVideo.connect();

    final chatUID = md5.convert(utf8.encode(user.id)).toString();

    final chatUser = chat.User(
      id: chatUID,
      extraData: {
        'name': user.name,
        'image': user.image,
      },
    );

    if (_userToken != null) {
      await streamChat.connectUser(chatUser, _userToken!.rawValue);
    } else {
      await streamChat.connectUserWithProvider(chatUser, _tokenLoader);
    }

    _logger.v(() => '[loginWithUserInfo] result: $result');

    if (result is! Success<String>) {
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
