import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stream_video/stream_video.dart';

import 'env/env.dart';
import 'screen/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  StreamLog()
    ..logger = ConsoleStreamLogger()
    ..validator = (priority, tag) => true;

  StreamVideo.init(
    Env.streamVideoApiKey,
    coordinatorRpcUrl: Env.streamCoordinatorRpcUrl,
    coordinatorWsUrl: Env.streamCoordinatorWSUrl,
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
