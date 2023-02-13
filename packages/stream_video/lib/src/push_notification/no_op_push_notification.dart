import 'package:stream_video/src/push_notification/push_notification_manager.dart';

import '../call/call.dart';

class NoOpPushNotificationManager implements PushNotificationManager {
  @override
  Future<Call?> consumeIncomingCall() => Future.value();

  @override
  Future<bool> handlePushNotification(Map<String, dynamic> payload) =>
      Future.value(false);

  @override
  Future<void> onUserLoggedIn() => Future.value();
}
