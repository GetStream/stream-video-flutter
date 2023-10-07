import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../stream_video.dart';

part 'call_kit_events.dart';

/// Signature for a function which provides a new instance of
/// [PushNotificationManager].
typedef PNManagerProvider = PushNotificationManager Function(
  CoordinatorClient client,
);

/// Interface for managing push notifications related to call events.
abstract class PushNotificationManager {
  /// Stream of [CallKitEvent] for call-related events.
  Stream<CallKitEvent> get onCallEvent;

  /// Registers the device for push notifications. Internal use only.
  @internal
  void registerDevice();

  /// Unregisters the device for push notifications. Internal use only.
  @internal
  void unregisterDevice();

  /// Displays an incoming call notification.
  ///
  /// [uuid] is the unique identifier for the call.
  /// [callCid] is the call's unique identifier.
  /// [avatar] is the avatar of the caller.
  /// [handle] is the handle of the caller.
  /// [nameCaller] is the name of the caller.
  /// [hasVideo] indicates whether the call has video (default is true).
  Future<void> showIncomingCall({
    required String uuid,
    required String callCid,
    String? avatar,
    String? handle,
    String? nameCaller,
    bool hasVideo = true,
  });

  /// Displays a missed call notification.
  ///
  /// [uuid] is the unique identifier for the call.
  /// [callCid] is the call's unique identifier.
  /// [avatar] is the avatar of the caller.
  /// [handle] is the handle of the caller.
  /// [nameCaller] is the name of the caller.
  /// [hasVideo] indicates whether the call has video (default is true).
  Future<void> showMissedCall({
    required String uuid,
    required String callCid,
    String? avatar,
    String? handle,
    String? nameCaller,
    bool hasVideo = true,
  });

  /// Initiates an outgoing call.
  ///
  /// [uuid] is the unique identifier for the call.
  /// [callCid] is the call's unique identifier.
  /// [avatar] is the avatar of the caller.
  /// [handle] is the handle of the caller.
  /// [nameCaller] is the name of the caller.
  /// [hasVideo] indicates whether the call has video (default is true).
  Future<void> startOutgoingCall({
    required String uuid,
    required String callCid,
    String? avatar,
    String? handle,
    String? nameCaller,
    bool hasVideo = true,
  });

  /// Mutes or unmutes the call.
  ///
  /// [uuid] is the unique identifier for the call.
  /// [isMuted] indicates whether the call is muted (default is true).
  Future<void> muteCall(String uuid, {bool isMuted = true});

  /// Holds or unholds the call.
  ///
  /// [uuid] is the unique identifier for the call.
  /// [isOnHold] indicates whether the call is on hold (default is true).
  Future<void> holdCall(String uuid, {bool isOnHold = true});

  /// Ends the call.
  ///
  /// [uuid] is the unique identifier for the call.
  Future<void> endCall(String uuid);

  /// Ends all ongoing calls.
  Future<void> endAllCalls();

  /// Sets the call status to connected.
  ///
  /// [uuid] is the unique identifier for the call.
  Future<void> setCallConnected(String uuid);

  /// Retrieves a list of active calls.
  Future<List<CallData>> activeCalls();

  /// Obtains the device's push token for VoIP.
  Future<String?> getDevicePushTokenVoIP();

  /// Disposes of the notification manager.
  Future<void> dispose();
}

extension NotificationManagerExtension on PushNotificationManager {
  StreamSubscription<T> on<T extends CallKitEvent>(
    void Function(T event)? onEvent,
  ) {
    return onCallEvent.whereType<T>().listen(onEvent);
  }
}
