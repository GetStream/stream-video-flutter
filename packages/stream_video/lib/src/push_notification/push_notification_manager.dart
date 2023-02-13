import 'dart:async';

import 'package:stream_video/stream_video.dart';

import '../call/call.dart';

abstract class PushNotificationManager {
  Future<void> onUserLoggedIn();
  Future<bool> handlePushNotification(Map<String, dynamic> payload);
  Future<Call?> consumeIncomingCall();
}
