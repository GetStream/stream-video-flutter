// 📦 Package imports:
import 'package:flutter/foundation.dart';
// 🌎 Project imports:
import 'package:flutter_dogfooding/core/repos/app_preferences.dart';
import 'package:flutter_dogfooding/core/repos/user_chat_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' hide User;
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';

import '../app/user_auth_controller.dart';
import '../core/repos/token_service.dart';
import '../core/repos/user_auth_repository.dart';
import '../env/env.dart';
import '../log_config.dart';
import '../utils/consts.dart';

GetIt locator = GetIt.instance;

/// This class is responsible for registering dependencies
/// and injecting them into the app.
class AppInjector {
  // Register dependencies
  static Future<void> init() async {
    // Google sign in
    locator.registerSingleton<GoogleSignIn>(
      GoogleSignIn(hostedDomain: 'getstream.io'),
    );

    // App Preferences
    final prefs = await SharedPreferences.getInstance();
    locator.registerSingleton<AppPreferences>(AppPreferences(prefs: prefs));

    // Stream chat
    locator.registerLazySingleton<StreamChatClient>(_initStreamChat);

    // Repositories
    locator.registerSingleton(const TokenService(apiKey: Env.apiKey));
    locator.registerLazySingleton<UserChatRepository>(
      () => UserChatRepository(
        chatClient: locator(),
        tokenService: locator(),
      ),
    );

    locator.registerFactoryParam<UserAuthRepository, User, void>(
      (user, _) {
        // We need to register the video client here because we need it to
        // initialise the user auth repo.
        registerStreamVideo(user);

        return UserAuthRepository(
          videoClient: locator(),
          tokenService: locator(),
        );
      },
    );

    // App wide Controller
    locator.registerLazySingleton<UserAuthController>(
      dispose: (controller) => controller.dispose(),
      () => UserAuthController(prefs: locator()),
    );
  }

  static StreamVideo registerStreamVideo(User user) {
    _setupLogger();
    return locator.registerSingleton(
      dispose: (_) => StreamVideo.reset(),
      _initStreamVideo(
        user,
        tokenLoader: switch (user.type) {
          UserType.authenticated => (String userId) {
              final tokenService = locator<TokenService>();
              return tokenService.loadToken(userId: userId);
            },
          _ => null,
        },
      ),
    );
  }

  static Future<void> reset() => locator.reset();
}

StreamLog _setupLogger() {
  const consoleLogger = ConsoleStreamLogger();
  final children = <StreamLogger>[consoleLogger];
  FileStreamLogger? fileLogger;
  if (!kIsWeb) {
    fileLogger = FileStreamLogger(
      AppFileLogConfig('1.0.0'),
      sender: (logFile) async {
        consoleLogger.log(
          Priority.debug,
          'DogFoodingApp',
          () => '[send] logFile: $logFile(${logFile.existsSync()})',
        );
        await Share.shareXFiles(
          [XFile(logFile.path)],
          subject: 'Share Logs',
          text: 'Stream Flutter Dogfooding Logs',
        );
      },
      console: consoleLogger,
    );
    children.add(fileLogger);
  }
  return StreamLog()..logger = CompositeStreamLogger(children);
}

StreamChatClient _initStreamChat() {
  final streamChatClient = StreamChatClient(
    Env.apiKey,
    logLevel: Level.INFO,
  );

  return streamChatClient;
}

StreamVideo _initStreamVideo(
  User user, {
  TokenLoader? tokenLoader,
}) {
  final streamVideoClient = StreamVideo(
    Env.apiKey,
    user: user,
    tokenLoader: tokenLoader,
    options: const StreamVideoOptions(
      logPriority: Priority.info,
      muteAudioWhenInBackground: true,
      muteVideoWhenInBackground: true,
    ),
    pushNotificationManagerProvider: StreamVideoPushNotificationManager.create(
      iosPushProvider: const StreamVideoPushProvider.apn(
        name: 'flutter-apn-video',
      ),
      androidPushProvider: const StreamVideoPushProvider.firebase(
        name: 'firebase',
      ),
      pushParams: const StreamVideoPushParams(
        appName: kAppName,
        ios: IOSParams(iconName: 'IconMask'),
      ),
    ),
  );

  return streamVideoClient;
}
