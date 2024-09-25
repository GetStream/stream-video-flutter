// ignore_for_file: unreachable_from_main

import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as ln;
import 'package:google_fonts/google_fonts.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'core/auth_repository.dart';
import 'firebase_options.dart';
import 'screen/login_screen.dart';
import 'stream_video_sdk.dart';

// As this runs in a separate isolate, we need to setup the app again.
@pragma('vm:entry-point')
Future<void> _onFirebaseBackgroundMessage(RemoteMessage message) async {
  debugPrint(
    '[onFirebaseBackgroundMessage] message: ${jsonEncode(message.toMap())}',
  );
  // Initialise Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initNotifications();

  // Initialise Stream Video

  final authRepository = await AuthRepository.getInstance();
  final credentials = authRepository.getCredentials();
  if (credentials == null) return;

  final client = await StreamVideoSdk.initialize(
    apiKey: credentials.apiKey,
    user: credentials.userInfo,
    userToken: credentials.token,
  );

  client.observeCallDeclinedCallKitEvent();

  await _handlePushNotification(message);

  await StreamVideo.reset(disconnect: true);
}

Future<bool> _handlePushNotification(RemoteMessage message) async {
  try {
    final payload = message.data;
    // Only handle messages from stream.video
    final sender = payload['sender'] as String?;
    if (sender != 'stream.video') {
      debugPrint('Not a stream.video message');
      return false;
    }

    // Only handle ringing calls.
    final type = payload['type'] as String?;
    if (type != 'call.ring' && type != 'call.missed') {
      debugPrint('Not a call.ring or call.missed message');
      return false;
    }

    // Return if the payload does not contain a call cid.
    final callCid = payload['call_cid'] as String?;
    if (callCid == null) {
      debugPrint('No call cid in payload');
      return false;
    }

    final createdByDisplayName = payload['created_by_display_name'] as String?;
    if (createdByDisplayName == null) {
      debugPrint('No created_by_display_name in payload');
      return false;
    }

    await showNotification(callCid, type, createdByDisplayName);
    return true;
  } catch (e, stk) {
    debugPrint('Error handling remote message: $e');
    debugPrint(stk.toString());

    return false;
  }
}

final ln.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    ln.FlutterLocalNotificationsPlugin();

const androidPlatformChannelSpecifics = ln.AndroidNotificationDetails(
  'stream_calls',
  'Stream Calls',
  channelDescription: 'Stream Calls Channel',
  importance: ln.Importance.max,
  priority: ln.Priority.max,
  ticker: 'ticker',
);

Future<void> initNotifications() async {
  const initializationSettingsAndroid =
      ln.AndroidInitializationSettings('@mipmap/ic_launcher');

  const initializationSettings = ln.InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> showNotification(
  String? callCid,
  String? type,
  String? fromUser,
) async {
  const platformChannelSpecifics =
      ln.NotificationDetails(android: androidPlatformChannelSpecifics);

  final notificationId = Object.hash(callCid, type);

  final body = 'Call "$callCid"';
  final String title;
  if (type == 'call.ring') {
    title = 'Incoming call from $fromUser';
  } else if (type == 'call.missed') {
    title = 'Missed call from $fromUser';
  } else {
    title = 'Unknown call from $fromUser';
  }

  await flutterLocalNotificationsPlugin.show(
    notificationId,
    title,
    body,
    platformChannelSpecifics,
  );
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
  void dispose() {
    _fcmSubscription?.cancel();
    super.dispose();
  }

  StreamSubscription<RemoteMessage>? _fcmSubscription;

  Future<void> _observeFcmMessages() async {
    // Requests notification permission.
    await FirebaseMessaging.instance.requestPermission();

    FirebaseMessaging.onBackgroundMessage(_onFirebaseBackgroundMessage);
    _fcmSubscription =
        FirebaseMessaging.onMessage.listen(_onFirebaseForegroundMessage);
  }

  Future<bool> _onFirebaseForegroundMessage(RemoteMessage message) async {
    debugPrint('[onFirebaseForegroundMessage] message: ${message.toMap()}');
    return _handlePushNotification(message);
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
      title: 'Stream Video Example',
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
