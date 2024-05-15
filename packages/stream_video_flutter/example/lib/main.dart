import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';

import 'app.dart';
import 'core/token_service.dart';
import 'firebase_options.dart';
import 'log_config.dart';

const _tag = 'MyApp';

Future<void> main() async {
  //useProxy('192.168.1.73:8888');

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await _setupLogger();

  runApp(const MyApp(connectUser: _connectUser));
}

Future<Result<None>> _connectUser(UserInfo user) async {
  streamLog.i(_tag, () => '[connectUser] user: $user');

  final tokenResponse = await const TokenService().loadToken(
    environment: Environment.pronto,
    userId: user.id,
  );

  final client = StreamVideo(
    tokenResponse.apiKey,
    user: User(info: user),
    userToken: tokenResponse.token,
    pushNotificationManagerProvider: StreamVideoPushNotificationManager.create(
      iosPushProvider: const StreamVideoPushProvider.apn(
        name: 'flutter-apn',
      ),
      androidPushProvider: const StreamVideoPushProvider.firebase(
        name: 'flutter-firebase',
      ),
      pushParams: const StreamVideoPushParams(
        appName: 'Stream Dogfooding',
        ios: IOSParams(iconName: 'IconMask'),
      ),
    ),
  );
  await client.connect();

  StreamBackgroundService.init(
    StreamVideo.instance,
    onNotificationClick: (call) async {
      streamLog.i(_tag, () => '[onNotificationClick] call: $call');
      // TODO navigate to call
    },
    onPlatformUiLayerDestroyed: (call) async {
      streamLog.i(_tag, () => '[onPlatformUiLayerDestroyed] call: $call');
      // TODO
    },
  );

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
          'DogFoodingApp',
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
