import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'env/env.dart';
import 'screen/login_screen.dart';

const _tag = 'MyApp';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  StreamVideo.init(
    Env.streamVideoApiKey,
    coordinatorRpcUrl: Env.streamCoordinatorRpcUrl,
    coordinatorWsUrl: Env.streamCoordinatorWSUrl,
    logLevel: LogLevel.all,
  );

  StreamBackgroundService.init(
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    streamLog.i(_tag, () => '[build] activeCall: ${Call.activeCall}');

    return MaterialApp(
      title: 'Stream Video UI Example',
      theme: ThemeData(
        textTheme: GoogleFonts.robotoMonoTextTheme(),
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
