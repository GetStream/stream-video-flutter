// ignore_for_file: unreachable_from_main

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'core/auth_repository.dart';
import 'screen/login_screen.dart';
import 'stream_video_sdk.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.connectUser});

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

  void _navigateToCall(Call call) {
    navigatorKey.currentState?.push(
      MaterialPageRoute<dynamic>(
        builder: (context) => StreamCallContainer(call: call),
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
          
          return const Result.success(none);
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
