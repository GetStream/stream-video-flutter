import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stream_video/stream_video.dart';

import 'screen/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  StreamLog()
    ..logger = ConsoleStreamLogger()
    ..validator = (priority, tag) => true;

  StreamVideo.init(
    'w6yaq5388uym',
    coordinatorRpcUrl:
        'https://video-edge-frankfurt-ce1.stream-io-api.com/video',
    coordinatorWsUrl:
        'wss://video-edge-frankfurt-ce1.stream-io-api.com/video/connect',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
