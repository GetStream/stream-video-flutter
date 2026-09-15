import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';

import '../core/repos/app_preferences.dart';
import '../core/repos/token_service.dart';
import '../di/injector.dart';
import '../firebase_options.dart';

// On Android this runs in a separate isolate, which never ran main(), so the
// app has to be set up again from scratch. The SDK owns the client's lifecycle
// from there: observing the ringing events a background isolate can act on,
// and disposing once the user has answered, declined, or let the call time
// out.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final ownsInjector = !locator.isRegistered<AppPreferences>();

  await StreamVideoPushHandler.handleBackgroundMessage(
    message,
    createStreamVideo: () =>
        _createStreamVideo(initialiseInjector: ownsInjector),
    onDispose: ownsInjector ? AppInjector.reset : null,
  );
}

/// Builds the client for the background isolate, or nothing when nobody is
/// logged in.
Future<StreamVideo?> _createStreamVideo({
  required bool initialiseInjector,
}) async {
  if (initialiseInjector) await AppInjector.init();

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
