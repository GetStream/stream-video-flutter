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

  StreamVideo.init(
    Env.streamVideoApiKey,
  );

  await _setupLogger();

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

  runApp(const MyApp());
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final activeCall = StreamVideo.instance.activeCall;
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
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
