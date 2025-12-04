// ignore_for_file: unreachable_from_main

import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as ln;
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';
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

  final authRepository = await AuthRepository.getInstance();
  final credentials = authRepository.getCredentials();
  if (credentials == null) return;

  final client = await StreamVideoSdk.initialize(
    apiKey: credentials.apiKey,
    user: credentials.userInfo,
    userToken: credentials.token,
  );

  final subscription = client.observeCoreRingingEventsForBackground();

  client.disposeAfterResolvingRinging(
    disposingCallback: subscription.cancel,
  );

  await client.handleRingingFlowNotifications(message.data);
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
  const initializationSettingsAndroid = ln.AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );

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
  const platformChannelSpecifics = ln.NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

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
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _compositeSubscription.clear();
    super.dispose();
  }

  final _compositeSubscription = CompositeSubscription();

  void _observeRingingEvents() {
    _compositeSubscription.clear();

    // On mobile we depend on call kit notifications.
    // On desktop and web they are (currently) not available, so we depend on a
    // websocket which can receive a call when the app is open.
    if (CurrentPlatform.isMobile) {
      _compositeSubscription.add(
        StreamVideo.instance.observeCoreRingingEvents(
          onCallAccepted: _navigateToCall,
        ),
      );
    } else {
      _compositeSubscription.add(
        StreamVideo.instance.state.incomingCall.listen((call) {
          if (call == null) return;

          // Navigate to the call screen.
          _navigateToCall(call);
        }),
      );
    }
  }

  void _observeFcmMessages() {
    FirebaseMessaging.onBackgroundMessage(_onFirebaseBackgroundMessage);
  }

  void _navigateToCall(Call call) {
    navigatorKey.currentState?.push(
      MaterialPageRoute<dynamic>(
        builder: (context) => StreamCallContainer(
          call: call,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final darkAppTheme = StreamVideoTheme.dark();
    final lightAppTheme = StreamVideoTheme.light();

    return MaterialApp(
      title: 'Stream Video Example',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        textTheme: GoogleFonts.robotoMonoTextTheme(),
        extensions: <ThemeExtension<dynamic>>[lightAppTheme],
      ),
      darkTheme: ThemeData(
        textTheme: GoogleFonts.robotoMonoTextTheme(),
        extensions: <ThemeExtension<dynamic>>[darkAppTheme],
      ),
      themeMode: ThemeMode.dark,
      home: LoginScreen(
        connectUser: (user) async {
          await widget.connectUser(user);

          _observeRingingEvents();
          _observeFcmMessages();

          return const Result.success(none);
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
