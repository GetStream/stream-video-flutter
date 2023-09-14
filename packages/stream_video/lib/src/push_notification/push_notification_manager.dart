import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../stream_video.dart';

part 'call_kit_events.dart';

/// Signature for a function which provides a new instance of
/// [PushNotificationManager].
typedef PNManagerProvider = PushNotificationManager Function(
  CoordinatorClient client,
);

abstract interface class PushNotificationManager {
  Stream<CallKitEvent> get onCallEvent;

  @internal
  void registerDevice();

  @internal
  void unregisterDevice();

  Future<void> showIncomingCall({
    required String uuid,
    required StreamCallCid callCid,
    String? avatar,
    String? nameCaller,
    bool hasVideo = true,
  });

  Future<void> showMissedCall({
    required String uuid,
    required StreamCallCid callCid,
    String? avatar,
    String? nameCaller,
    bool hasVideo = true,
  });

  Future<void> startOutgoingCall({
    required String uuid,
    required StreamCallCid callCid,
    String? avatar,
    String? nameCaller,
    bool hasVideo = true,
  });

  Future<void> muteCall(String uuid, {bool isMuted = true});

  Future<void> holdCall(String uuid, {bool isOnHold = true});

  Future<void> endCall(String uuid);

  Future<void> endAllCalls();

  Future<void> setCallConnected(String uuid);

  Future<void> activeCalls();

  /// Obtain the Device Push Token for VoIp.
  Future<String?> getDevicePushTokenVoIP();

  /// Dispose of the notification manager.
  Future<void> dispose();
}

extension NotificationManagerExtension on PushNotificationManager {
  StreamSubscription<T> on<T extends CallKitEvent>(
    void Function(T event)? onEvent,
  ) {
    return onCallEvent.whereType<T>().listen(onEvent);
  }
}
