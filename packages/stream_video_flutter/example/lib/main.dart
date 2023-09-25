import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'env/env.dart';
import 'log_config.dart';
import 'screen/login_screen.dart';

const _tag = 'MyApp';

Future<void> main() async {
  //useProxy('192.168.1.73:8888');

  WidgetsFlutterBinding.ensureInitialized();

  await _setupLogger();

  runApp(const MyApp(connectUser: _connectUser));
}

Future<Result<None>> _connectUser(UserInfo user, String token) async {
  streamLog.i(_tag, () => '[connectUser] user: $user, token: $token');
  final client = StreamVideo(
    Env.streamVideoApiKey,
    user: User(info: user),
    userToken: token,
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

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.connectUser,
  });

  final ConnectUser connectUser;

  @override
  Widget build(BuildContext context) {
    Call? activeCall;
    if (StreamVideo.isInitialized()) {
      activeCall = StreamVideo.instance.activeCall;
    }
    streamLog.i(_tag, () => '[build] activeCall: $activeCall');

    final darkAppTheme = StreamVideoTheme.dark();
    final lightAppTheme = StreamVideoTheme.light();

    return MaterialApp(
      title: 'Stream Video UI Example',
      theme: ThemeData(
        textTheme: GoogleFonts.robotoMonoTextTheme(),
        extensions: <ThemeExtension<dynamic>>[lightAppTheme],
      ),
      darkTheme: ThemeData(
        textTheme: GoogleFonts.robotoMonoTextTheme(),
        extensions: <ThemeExtension<dynamic>>[darkAppTheme],
      ),
      themeMode: ThemeMode.dark,
      home: LoginScreen(connectUser: connectUser),
      debugShowCheckedModeBanner: false,
    );
  }
}
