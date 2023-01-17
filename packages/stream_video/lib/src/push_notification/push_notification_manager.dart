import 'package:collection/collection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../stream_video.dart';
import 'call_notification_wrapper.dart';

class PushNotificationManager {
  PushNotificationManager({
    required this.client,
    this.callNotification = const CallNotificationWrapper(),
  });

  final StreamVideo client;
  final CallNotificationWrapper callNotification;

  void onUserLoggedIn() {
    if (_isFirebaseInitialized()) {
      FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
        await client.createDevice(token: token);
      });
    }
  }

  Future<bool> handlePushNotification(RemoteMessage remoteMessage) async {
    if (_isValid(remoteMessage)) {
      final cid = remoteMessage.data['call_cid'] as String;
      final type = cid.substring(0, cid.indexOf(':'));
      final id = cid.substring(cid.indexOf(':') + 1);
      final call = await client.getOrCreateCall(type: type, id: id);
      await callNotification.showCallNotification(
        callId: cid,
        callers: call.users.values.map((e) => e.name).join(', '),
        isVideoCall: true,
        avatarUrl: call.users.values.firstOrNull?.imageUrl,
        onCallAccepted: onCallAccepted,
        onCallRejected: onCallRejected,
      );
      return true;
    }
    return false;
  }

  Future<void> onCallAccepted(String cid) async {
    await client.acceptCall(
      type: cid.substring(0, cid.indexOf(':')),
      id: cid.substring(cid.indexOf(':') + 1),
    );
  }

  Future<void> onCallRejected(String cid) async {
    await client.rejectCall(callCid: cid);
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
