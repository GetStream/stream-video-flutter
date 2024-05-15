import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'firebase_options.dart';
import 'screen/login_screen.dart';

// As this runs in a separate isolate, we need to setup the app again.
@pragma('vm:entry-point')
Future<void> _onFirebaseBackgroundMessage(RemoteMessage message) async {
  debugPrint('[onFirebaseBackgroundMessage] message: ${message.toMap()}');
  // Initialise Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialise Stream Video

  try {
    // Handle the message
  } catch (e, stk) {
    debugPrint('Error handling remote message: $e');
    debugPrint(stk.toString());
  }
}

const _tag = 'MyApp';

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.connectUser,
  });

  final ConnectUser connectUser;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    _observeFcmMessages();
  }

  @override
  dispose() {
    _fcmSubscription?.cancel();
    super.dispose();
  }

  StreamSubscription<RemoteMessage>? _fcmSubscription;

  void _observeFcmMessages() {
    FirebaseMessaging.onBackgroundMessage(_onFirebaseBackgroundMessage);
    _fcmSubscription =
        FirebaseMessaging.onMessage.listen(_onFirebaseForegroundMessage);
  }

  Future<bool> _onFirebaseForegroundMessage(RemoteMessage message) async {
    debugPrint('[onFirebaseForegroundMessage] message: ${message.toMap()}');
    return StreamVideo.instance.handleVoipPushNotification(message.data);
  }

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
      home: LoginScreen(connectUser: widget.connectUser),
      debugShowCheckedModeBanner: false,
    );
  }
}
