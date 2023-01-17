import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../stream_video.dart';

class PushNotificationManager {
  PushNotificationManager({
    required this.client,
  });

  final StreamVideo client;

  void onUserLoggedIn() {
    if (_isFirebaseInitialized()) {
      FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
        await client.createDevice(token: token);
      });
    }
  }

  Future<bool> handlePushNotification(RemoteMessage remoteMessage) async {
    if (_isValid(remoteMessage)) {
      return true;
    }
    return false;
  }

  bool _isValid(RemoteMessage remoteMessage) {
    return _isFromStreamServer(remoteMessage) &&
        _isValidIncomingCall(remoteMessage);
  }

  bool _isFromStreamServer(RemoteMessage remoteMessage) {
    return remoteMessage.data['sender'] == 'stream.video';
  }

  bool _isValidIncomingCall(RemoteMessage remoteMessage) {
    return remoteMessage.data['type'] == 'call_incoming' &&
        ((remoteMessage.data['call_cid'] as String?)?.isNotEmpty ?? false);
  }

  bool _isFirebaseInitialized() {
    return Firebase.apps.isNotEmpty;
  }
}
