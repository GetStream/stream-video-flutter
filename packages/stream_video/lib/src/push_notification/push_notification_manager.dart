import 'dart:async';

import '../../stream_video.dart';

abstract class PushNotificationManager {
  Future<void> onUserLoggedIn();

  Future<bool> handlePushNotification(Map<String, dynamic> payload);

  Future<CallCreatedData?> consumeIncomingCall();

  Future<void> endAllCalls();

  @override
  Future<void> showCallIncoming({
    required StreamCallCid cid,
    required String callers,
    required void Function(StreamCallCid streamCallCid) onCallAccepted,
    required void Function(StreamCallCid streamCallCid) onCallRejected,
    bool isVideoCall = true,
  });
}

typedef PushNotificationManagerFactory = Future<PushNotificationManager>
    Function(CoordinatorClient client);
