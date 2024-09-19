import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'app.dart';
import 'core/auth_repository.dart';
import 'core/token_service.dart';
import 'firebase_options.dart';
import 'log_config.dart';
import 'model/credentials.dart';
import 'stream_video_options.dart';
import 'stream_video_sdk.dart';

const _tag = 'MyApp';

Future<void> main() async {
  //useProxy('192.168.1.73:8888');

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await _setupLogger();

  runApp(
    const MyApp(
      connectUser: _connectUser,
    ),
  );
}

Future<Result<None>> _connectUser(UserInfo user) async {
  streamLog.i(_tag, () => '[connectUser] user: $user');

  final tokenResponse = await const TokenService().loadToken(
    environment: Environment.prontoStaging,
    userId: user.id,
  );

  final apiKey = tokenResponse.apiKey;
  final token = UserToken.jwt(tokenResponse.token);

  streamLog.i(_tag, () => '[connectUser] api_key: ${tokenResponse.apiKey}');
  final client = await StreamVideoSdk.initialize(
    apiKey: apiKey,
    user: user,
    userToken: token,
    options: DefaultVideoOptions.remote,
  );

  final authRepository = await AuthRepository.getInstance();
  await authRepository.setCredentials(
    AuthCredentials(
      apiKey: apiKey,
      token: token,
      userInfo: user,
    ),
  );

  await client.connect();
  return const Result.success(none);
}

Future<void> _setupLogger() async {
  const consoleLogger = ConsoleStreamLogger();
  final children = <StreamLogger>[consoleLogger];
  FileStreamLogger? fileLogger;
  if (!kIsWeb) {
    fileLogger = FileStreamLogger(
      AppFileLogConfig('1.0.0'),
      sender: (logFile) async {
        consoleLogger.log(
          Priority.debug,
          'Stream ExampleApp',
          () => '[send] logFile: $logFile(${logFile.existsSync()})',
        );
        await Share.shareXFiles(
          [XFile(logFile.path)],
          subject: 'Share Logs',
          text: 'Stream Flutter Example Logs',
        );
      },
      console: consoleLogger,
    );
    children.add(fileLogger);
  }
  StreamLog().validator = (priority, _) => true;
  StreamLog().logger = CompositeStreamLogger(children);
}
