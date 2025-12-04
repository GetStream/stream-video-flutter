import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import '../core/repos/app_preferences.dart';
import '../core/repos/token_service.dart';
import '../di/injector.dart';
import '../firebase_options.dart';

// As this runs in a separate isolate, we need to setup the app again.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialise Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Initialise the app.
  await AppInjector.init();

  try {
    // Return if the user is not logged in.
    final prefs = locator.get<AppPreferences>();
    final credentials = prefs.userCredentials;
    if (credentials == null) return;

    final tokenResponse = await locator.get<TokenService>().loadToken(
      userId: credentials.userInfo.id,
      environment: prefs.environment,
    );

    // Initialise the video client.
    final streamVideo = AppInjector.registerStreamVideo(
      tokenResponse,
      User(info: credentials.userInfo),
      prefs.environment,
    );

    final subscription = streamVideo.observeCoreRingingEventsForBackground();

    streamVideo.disposeAfterResolvingRinging(
      disposingCallback: () {
        subscription.cancel();
        AppInjector.reset();
      },
    );

    // Handle the message.
    await handleRemoteMessage(message);
  } catch (e, stk) {
    debugPrint('Error handling remote message: $e');
    debugPrint(stk.toString());
  }

  // Reset the injector once the message is handled.
  return AppInjector.reset();
}

Future<bool> handleRemoteMessage(RemoteMessage message) async {
  final streamVideo = locator.get<StreamVideo>();
  return streamVideo.handleRingingFlowNotifications(message.data);
}
