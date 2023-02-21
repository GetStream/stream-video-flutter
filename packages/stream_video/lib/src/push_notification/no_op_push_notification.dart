import '../../stream_video.dart';

class NoOpPushNotificationManager implements PushNotificationManager {
  @override
  Future<CallCreated?> consumeIncomingCall() => Future.value();

  @override
  Future<bool> handlePushNotification(Map<String, dynamic> payload) =>
      Future.value(false);

  @override
  Future<void> onUserLoggedIn() => Future.value();
}

Future<PushNotificationManager> defaultPushNotificationManager(
  StreamVideo streamVideo,
) =>
    Future.value(NoOpPushNotificationManager());
