// 📦 Package imports:
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

// 🌎 Project imports:
import 'package:flutter_dogfooding/core/repos/app_preferences.dart';
import 'package:flutter_dogfooding/core/repos/user_chat_repository.dart';
import '../app/user_auth_controller.dart';
import '../core/repos/token_service.dart';
import '../core/repos/user_auth_repository.dart';
import '../env/env.dart';

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

    // Stream services
    locator.registerLazySingleton<StreamVideo>(_initStreamVideo);
    locator.registerLazySingleton<StreamChatClient>(_initStreamChat);

    // Attach streamVideo logger

    // Repositories
    locator.registerSingleton(
      const TokenService(apiKey: Env.apiKey),
    );
    locator.registerLazySingleton<UserAuthRepository>(
      () => UserAuthRepository(
        videoClient: locator(),
        tokenService: locator(),
      ),
    );

    locator.registerLazySingleton<UserChatRepository>(
      () => UserChatRepository(
        chatClient: locator(),
        tokenService: locator(),
      ),
    );

    // App wide Controllers
    locator.registerLazySingleton<UserAuthController>(
      dispose: (controller) => controller.dispose(),
      () => UserAuthController(
        prefs: locator(),
        authRepo: locator(),
      ),
    );
  }

  static Future<void> reset() => locator.reset();
}

// Future<void> _setupLogger() async {
//   const consoleLogger = ConsoleStreamLogger();
//   final children = <StreamLogger>[consoleLogger];
//   FileStreamLogger? fileLogger;
//   if (!kIsWeb) {
//     fileLogger = FileStreamLogger(
//       AppFileLogConfig('1.0.0'),
//       sender: (logFile) async {
//         consoleLogger.log(
//           Priority.debug,
//           'DogFoodingApp',
//           () => '[send] logFile: $logFile(${logFile.existsSync()})',
//         );
//         await Share.shareXFiles(
//           [XFile(logFile.path)],
//           subject: 'Share Logs',
//           text: 'Stream Flutter Dogfooding Logs',
//         );
//       },
//       console: consoleLogger,
//     );
//     children.add(fileLogger);
//   }
//   StreamLog().logger = CompositeStreamLogger(children);
// }

StreamChatClient _initStreamChat() {
  final streamChatClient = StreamChatClient(
    Env.apiKey,
    logLevel: Level.INFO,
  );

  return streamChatClient;
}

StreamVideo _initStreamVideo() {
  final streamVideoClient = StreamVideo.init(
    Env.apiKey,
    logPriority: Priority.info,
    muteAudioWhenInBackground: true,
    muteVideoWhenInBackground: true,
  );

  return streamVideoClient;
}
