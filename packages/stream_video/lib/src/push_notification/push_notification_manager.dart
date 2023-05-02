import 'dart:async';

import '../../stream_video.dart';

abstract class PushNotificationManager {
  Future<void> onUserLoggedIn();

  Future<bool> handlePushNotification(Map<String, dynamic> payload);

  Future<CallCreatedData?> consumeIncomingCall();
}

typedef PushNotificationManagerFactory = Future<PushNotificationManager>
    Function(CoordinatorClient client);
