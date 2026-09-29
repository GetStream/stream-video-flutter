import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';

import '../core/repos/app_preferences.dart';
import '../core/repos/token_service.dart';
import '../di/injector.dart';
import '../firebase_options.dart';

// Firebase only spins up a background isolate on Android. There it never ran
// main(), so the app has to be set up from scratch and the SDK owns the
// client's lifecycle: observing the ringing events a background isolate can act
// on, and disposing once the user has answered, declined, or let the call time
// out. On Apple platforms this is called on the app's own isolate, where the
// SDK builds nothing and leaves the ringing flow to PushKit and CallKit.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await StreamVideoPushHandler.handleBackgroundMessage(
    message,
    createStreamVideo: _createStreamVideo,
    onDispose: AppInjector.reset,
  );
}

/// Builds the client for the background isolate, or nothing when nobody is
/// logged in.
Future<StreamVideo?> _createStreamVideo() async {
  // A second push can land in an isolate an earlier one already set up, so this
  // has to be able to run more than once.
  if (!locator.isRegistered<AppPreferences>()) await AppInjector.init();

  final prefs = locator.get<AppPreferences>();
  final credentials = prefs.userCredentials;
  if (credentials == null) return null;

  final tokenResponse = await locator.get<TokenService>().loadToken(
    userId: credentials.userInfo.id,
    environment: prefs.environment,
  );

  return AppInjector.registerStreamVideo(
    tokenResponse,
    credentials.userInfo.toUser(),
    prefs.environment,
  );
}
