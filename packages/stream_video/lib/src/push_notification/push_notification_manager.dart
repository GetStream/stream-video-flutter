import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../stream_video.dart';

class PushNotificationManager {
  PushNotificationManager({required this.client});

  final StreamVideo client;

  void onUserLoggedIn() {
    if (_isFirebaseInitialized()) {
      FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
        await client.createDevice(token: token);
      });
    }
  }

  bool _isFirebaseInitialized() {
    return Firebase.apps.isNotEmpty;
  }
}
