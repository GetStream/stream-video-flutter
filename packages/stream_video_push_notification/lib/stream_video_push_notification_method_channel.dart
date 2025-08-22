import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/src/entities/call_event.dart';
import 'package:stream_video_push_notification/src/stream_video_push_params.dart';
import 'stream_video_push_notification_platform_interface.dart';

/// An implementation of [StreamVideoPushNotificationPlatform] that uses method channels.
class MethodChannelStreamVideoPushNotification
    extends StreamVideoPushNotificationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('stream_video_push_notification');
  final eventChannel =
      const EventChannel('stream_video_push_notification_events');

  MethodChannelStreamVideoPushNotification() {
    methodChannel.setMethodCallHandler((call) async {
      // TODO: remove?
    });
  }

  @override
  Future<void> init(
    Map<String, dynamic> pushConfiguration,
  ) async {
    if (!CurrentPlatform.isIos) return;
    await methodChannel.invokeMethod<String>('initData', pushConfiguration);
  }

  /// Only Android: show request permission for ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT
  @override
  Future<void> ensureFullScreenIntentPermission() async {
    if (!CurrentPlatform.isAndroid) return;

    await methodChannel.invokeMethod<void>('ensureFullScreenIntentPermission');
  }

  @override
  Stream<CallKitEvent?> get onEvent =>
      eventChannel.receiveBroadcastStream().map(_receiveCallEvent);

  /// Show Callkit Incoming.
  /// On iOS, using Callkit. On Android, using a custom UI.
  @override
  Future showIncomingCall(StreamVideoPushParams params) async {
    await methodChannel.invokeMethod("showIncomingCall", params.toJson());
  }

  /// Show Miss Call Notification.
  /// Only Android
  @override
  Future showMissCallNotification(StreamVideoPushParams params) async {
    if (!CurrentPlatform.isAndroid) {
      return;
    }

    await methodChannel.invokeMethod(
        "showMissCallNotification", params.toJson());
  }

  /// Hide notification call for Android.
  /// Only Android
  @override
  Future hideIncomingCall(StreamVideoPushParams params) async {
    if (!CurrentPlatform.isAndroid) {
      return;
    }

    await methodChannel.invokeMethod("hideIncomingCall", params.toJson());
  }

  /// Start an Outgoing call.
  /// On iOS, using Callkit(create a history into the Phone app).
  /// On Android, Nothing(only callback event listener).
  @override
  Future startCall(StreamVideoPushParams params) async {
    await methodChannel.invokeMethod("startCall", params.toJson());
  }

  /// Muting an Ongoing call.
  /// On iOS, using Callkit(update the ongoing call ui).
  /// On Android, Nothing(only callback event listener).
  @override
  Future muteCall(String id, {bool isMuted = true}) async {
    await methodChannel
        .invokeMethod("muteCall", {'id': id, 'isMuted': isMuted});
  }

  /// Get Callkit Mic Status (muted/unmuted).
  /// On iOS, using Callkit(update call ui).
  /// On Android, Nothing(only callback event listener).
  @override
  Future<bool> isMuted(String id) async {
    return (await methodChannel.invokeMethod("isMuted", {'id': id})) as bool? ??
        false;
  }

  /// Hold an Ongoing call.
  /// On iOS, using Callkit(update the ongoing call ui).
  /// On Android, Nothing(only callback event listener).
  @override
  Future holdCall(String id, {bool isOnHold = true}) async {
    await methodChannel
        .invokeMethod("holdCall", {'id': id, 'isOnHold': isOnHold});
  }

  /// End an Incoming/Outgoing call.
  /// On iOS, using Callkit(update a history into the Phone app).
  /// On Android, Nothing(only callback event listener).
  @override
  Future endCall(String id) async {
    await methodChannel.invokeMethod("endCall", {'id': id});
  }

  /// Set call has been connected successfully.
  /// On iOS, using Callkit(update a history into the Phone app).
  /// On Android, Nothing(only callback event listener).
  @override
  Future setCallConnected(String id) async {
    await methodChannel.invokeMethod("callConnected", {'id': id});
  }

  /// End all calls.
  @override
  Future endAllCalls() async {
    await methodChannel.invokeMethod("endAllCalls");
  }

  /// Get active calls.
  /// On iOS: return active calls from Callkit.
  /// On Android: only return last call
  @override
  Future<dynamic> activeCalls() async {
    return await methodChannel.invokeMethod("activeCalls");
  }

  /// Get device push token VoIP.
  /// On iOS: return deviceToken for VoIP.
  /// On Android: return Empty
  @override
  Future getDevicePushTokenVoIP() async {
    return await methodChannel.invokeMethod("getDevicePushTokenVoIP");
  }

  /// Silence CallKit events
  @override
  Future silenceEvents() async {
    return await methodChannel.invokeMethod("silenceEvents", true);
  }

  /// Unsilence CallKit events
  @override
  Future unsilenceEvents() async {
    return await methodChannel.invokeMethod("silenceEvents", false);
  }

  /// Request permission show notification for Android(13)
  /// Only Android: show request permission post notification for Android 13+
  @override
  Future requestNotificationPermission(dynamic data) async {
    if (!CurrentPlatform.isAndroid) {
      throw UnimplementedError(
          'requestNotificationPermission() is only implemented for Android.');
    }

    return await methodChannel.invokeMethod(
        "requestNotificationPermission", data);
  }

  /// Check can use full screen intent for Android(14)+
  /// Only Android: canUseFullScreenIntent permission for ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT
  @override
  Future canUseFullScreenIntent() async {
    if (!CurrentPlatform.isAndroid) {
      throw UnimplementedError(
          'canUseFullScreenIntent() is only implemented for Android.');
    }

    return await methodChannel.invokeMethod("canUseFullScreenIntent");
  }

  CallData _callDataFromJson(Map<String, dynamic> json) {
    final extraData = json['extra']?.cast<String, dynamic>();
    return CallData(
      uuid: json['id'] as String?,
      callCid: extraData?['callCid'] as String?,
      handle: json['handle'] as String?,
      callerName: json['callerName'] as String?,
      hasVideo: json['type'] == 1,
      extraData: extraData,
    );
  }

  CallKitEvent? _receiveCallEvent(dynamic data) {
    if (data is Map) {
      final event = Event.values.firstWhere((e) => e.name == data['event']);
      final body = Map<String, dynamic>.from(data['body']);
      final callData = _callDataFromJson(body);

      return switch (event) {
        Event.actionCallIncoming => ActionCallIncoming(data: callData),
        Event.actionCallStart => ActionCallStart(data: callData),
        Event.actionCallAccept => ActionCallAccept(data: callData),
        Event.actionCallDecline => ActionCallDecline(data: callData),
        Event.actionCallEnded => ActionCallEnded(data: callData),
        Event.actionCallTimeout => ActionCallTimeout(data: callData),
        Event.actionCallCallback => ActionCallCallback(data: callData),
        Event.actionCallConnected => ActionCallConnected(data: callData),
        Event.actionDidUpdateDevicePushTokenVoip =>
          ActionDidUpdateDevicePushTokenVoip(
            token: body['deviceTokenVoIP'] as String,
          ),
        Event.actionCallToggleHold => ActionCallToggleHold(
            uuid: body['id'] as String,
            isOnHold: body['isOnHold'] as bool,
          ),
        Event.actionCallToggleMute => ActionCallToggleMute(
            uuid: body['id'] as String,
            isMuted: body['isMuted'] as bool,
          ),
        Event.actionCallToggleDmtf => ActionCallToggleDmtf(
            uuid: body['id'] as String,
            digits: body['digits'] as String,
          ),
        Event.actionCallToggleGroup => ActionCallToggleGroup(
            uuid: body['id'] as String,
            callUUIDToGroupWith: body['callUUIDToGroupWith'] as String,
          ),
        Event.actionCallToggleAudioSession => ActionCallToggleAudioSession(
            isActivate: body['isActivate'] as bool,
          ),
        Event.actionCallCustom => ActionCallCustom(body),
      };
    }

    return null;
  }
}
