import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import '../coordinator/coordinator_client.dart';
import '../coordinator/open_api/event/event_type.dart';
import '../stream_video.dart';
import '../webrtc/rtc_media_device/rtc_media_device.dart';

part 'call_kit_events.dart';
part 'push_payload.dart';

/// Signature for a function which provides a new instance of
/// [PushNotificationManager].
typedef PNManagerProvider =
    PushNotificationManager Function(
      CoordinatorClient client,
      StreamVideo streamVideo,
    );

/// Interface for managing push notifications related to call events.
abstract class PushNotificationManager {
  /// Stream of [RingingEvent] for call-related events.
  Stream<RingingEvent> get onCallEvent;

  /// Registers the device for push notifications.
  void registerDevice();

  /// Unregisters the device for push notifications.
  Future<void> unregisterDevice();

  /// Displays an incoming call notification.
  ///
  /// [uuid] is the unique identifier for the call.
  /// [callCid] is the call's unique identifier.
  /// [avatar] is the avatar of the caller.
  /// [handle] is the handle of the caller.
  /// [callerName] is the name of the caller.
  /// [hasVideo] indicates whether the call has video (default is true).
  /// [ringTimeout] is how long the call rings before it times out, the call's
  /// `autoRejectTimeout`; the platform's default when null.
  Future<void> showIncomingCall({
    required String uuid,
    required String callCid,
    String? avatar,
    String? handle,
    String? callerName,
    bool hasVideo = true,
    Duration? ringTimeout,
  });

  /// Displays a missed call notification.
  ///
  /// [uuid] is the unique identifier for the call.
  /// [callCid] is the call's unique identifier.
  /// [avatar] is the avatar of the caller.
  /// [handle] is the handle of the caller.
  /// [callerName] is the name of the caller.
  /// [hasVideo] indicates whether the call has video (default is true).
  Future<void> showMissedCall({
    required String uuid,
    required String callCid,
    String? avatar,
    String? handle,
    String? callerName,
    bool hasVideo = true,
  });

  /// Initiates an outgoing call.
  ///
  /// [uuid] is the unique identifier for the call.
  /// [callCid] is the call's unique identifier.
  /// [avatar] is the avatar of the caller.
  /// [handle] is the handle of the caller.
  /// [callerName] is the name of the caller.
  /// [hasVideo] indicates whether the call has video (default is true).
  Future<void> startOutgoingCall({
    required String uuid,
    required String callCid,
    String? avatar,
    String? handle,
    String? callerName,
    bool hasVideo = true,
  });

  /// Mutes or unmutes the call.
  ///
  /// [uuid] is the unique identifier for the call.
  /// [isMuted] indicates whether the call is muted (default is true).
  Future<void> muteCall(String uuid, {bool isMuted = true});

  /// Holds or unholds the call in the system call UI, and reports
  /// [ActionCallToggleHold] once the system has done it.
  ///
  /// [uuid] is the unique identifier for the call.
  /// [isOnHold] indicates whether the call is on hold (default is true).
  Future<void> holdCall(String uuid, {bool isOnHold = true});

  /// Ends the call.
  ///
  /// [uuid] is the unique identifier for the call.
  Future<void> endCall(String uuid);

  /// Ends the call.
  ///
  /// [cid] is the call id for the call.
  /// When [silent] is `true`, the reports that the native calls of [cid]
  /// ended (decline, ended, timeout, dismissed) are suppressed, while events
  /// of other calls still arrive. Use it when the ringing flow is already
  /// resolved and ending the native call must not trigger the decline/ended
  /// handling again.
  Future<void> endCallByCid(String cid, {bool silent = false});

  /// Tells the native call UI that the ring of [cid] is over before the user
  /// answered it on this device: the backend ended the call, the caller
  /// cancelled, the user answered or declined it elsewhere, or the app
  /// rejected or dropped the ring.
  ///
  /// The native ring ends without its end being reported as the user
  /// declining it. A ring the user answered on the native call screen stays,
  /// for the client that takes it over. By default this keeps a ring that
  /// [activeCalls] lists as accepted, and otherwise calls [endCallByCid]
  /// silently.
  Future<void> onRingEnded(String cid) async {
    final calls = await activeCalls();
    if (calls.any((call) => call.callCid == cid && call.isAccepted)) return;

    await endCallByCid(cid, silent: true);
  }

  /// Tells the native call UI that this device is done with [cid], a call
  /// this device joined or accepted. By default this calls [endCallByCid].
  Future<void> onCallLeft(String cid) => endCallByCid(cid);

  /// Tells the native call UI that the user accepted [cid] in the app on
  /// this device. A ring the native side still shows unanswered goes away
  /// while the call goes on. Does nothing by default.
  Future<void> onCallAccepted(String cid) async {}

  /// Ends all ongoing calls.
  Future<void> endAllCalls();

  /// Sets the call status to connected.
  ///
  /// [uuid] is the unique identifier for the call.
  Future<void> setCallConnected(String uuid);

  /// Sets call as muted/unmuted (iOS only).
  Future<void> setCallMutedByCid(String cid, bool isMuted);

  /// Routes the audio of the system call with [cid] to [device], where the
  /// system owns the call's audio route: on Android, while the Telecom
  /// integration holds the call.
  ///
  /// `Call.setAudioOutputDevice` calls it once WebRTC uses [device]. Does
  /// nothing by default.
  Future<void> setCallAudioOutputDeviceByCid(
    String cid,
    RtcMediaDevice device,
  ) async {}

  /// The cids of the calls whose audio focus the system manages: on Android,
  /// the calls the Telecom integration holds. A new listener gets the current
  /// calls, and every change after.
  ///
  /// The client stops WebRTC from managing audio focus while one of its
  /// active calls is among them. None by default.
  Stream<Set<String>> get systemManagedCallCids => Stream.value(const {});

  /// Retrieves a list of active calls.
  Future<List<CallData>> activeCalls();

  /// Obtains the device's push token for VoIP.
  Future<String?> getDevicePushTokenVoIP();

  /// Disposes of the notification manager.
  Future<void> dispose();
}

extension NotificationManagerExtension on PushNotificationManager {
  StreamSubscription<T> on<T extends RingingEvent>(
    void Function(T event)? onEvent,
  ) {
    return onCallEvent.whereType<T>().listen(onEvent);
  }
}
