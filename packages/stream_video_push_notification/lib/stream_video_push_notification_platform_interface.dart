import 'package:stream_video/stream_video.dart';
import 'package:stream_video_push_notification/src/stream_video_push_params.dart';

import 'stream_video_push_notification_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

typedef BackgroundVoipCallHandler = Future<void> Function();

abstract class StreamVideoPushNotificationPlatform extends PlatformInterface {
  StreamVideoPushNotificationPlatform() : super(token: _token);

  static final Object _token = Object();

  static StreamVideoPushNotificationPlatform _instance =
      MethodChannelStreamVideoPushNotification();

  /// The default instance of [StreamVideoPushNotificationPlatform] to use.
  ///
  /// Defaults to [MethodChannelStreamVideoPushNotification].
  static StreamVideoPushNotificationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [StreamVideoPushNotificationPlatform] when
  /// they register themselves.
  static set instance(StreamVideoPushNotificationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> init(Map<String, dynamic> pushConfiguration) {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future<void> ensureFullScreenIntentPermission() {
    throw UnimplementedError(
      'ensureFullScreenIntentPermission() has not been implemented.',
    );
  }

  /// Listen to event callback from Ringing flow.
  Stream<RingingEvent?> get onEvent {
    throw UnimplementedError('onEvent has not been implemented.');
  }

  /// Show Incoming ringing call.
  /// On iOS, using Callkit. On Android, using a custom UI.
  Future showIncomingCall(StreamVideoPushParams params) {
    throw UnimplementedError('showIncomingCall() has not been implemented.');
  }

  /// Show Miss Call Notification.
  /// Only Android
  Future showMissCallNotification(StreamVideoPushParams params) {
    throw UnimplementedError(
      'showMissCallNotification() has not been implemented.',
    );
  }

  /// Hide notification call for Android.
  /// Only Android
  Future hideIncomingCall(StreamVideoPushParams params) {
    throw UnimplementedError('hideIncomingCall() has not been implemented.');
  }

  /// Start an Outgoing call.
  /// On iOS, using Callkit(create a history into the Phone app).
  /// On Android, Nothing(only callback event listener).
  Future startCall(StreamVideoPushParams params) {
    throw UnimplementedError('startCall() has not been implemented.');
  }

  /// Muting an Ongoing call.
  /// On iOS, using Callkit(update the ongoing call ui).
  /// On Android, Nothing(only callback event listener).
  Future muteCall(String id, {bool isMuted = true}) {
    throw UnimplementedError('muteCall() has not been implemented.');
  }

  /// Get Callkit Mic Status (muted/unmuted).
  /// On iOS, using Callkit(update call ui).
  /// On Android, Nothing(only callback event listener).
  Future<bool> isMuted(String id) {
    throw UnimplementedError('isMuted() has not been implemented.');
  }

  /// Hold an Ongoing call.
  /// On iOS, using Callkit(update the ongoing call ui).
  /// On Android, Nothing(only callback event listener).
  Future holdCall(String id, {bool isOnHold = true}) {
    throw UnimplementedError('holdCall() has not been implemented.');
  }

  /// End an Incoming/Outgoing call.
  /// On iOS, using Callkit(update a history into the Phone app).
  /// On Android, Nothing(only callback event listener).
  Future endCall(String id) {
    throw UnimplementedError('endCall() has not been implemented.');
  }

  /// Set call has been connected successfully.
  /// On iOS, using Callkit(update a history into the Phone app).
  /// On Android, Nothing(only callback event listener).
  Future setCallConnected(String id) {
    throw UnimplementedError('setCallConnected() has not been implemented.');
  }

  /// End all calls.
  Future endAllCalls() {
    throw UnimplementedError('endAllCalls() has not been implemented.');
  }

  /// Get active calls.
  /// On iOS: return active calls from Callkit.
  /// On Android: only return last call
  Future<dynamic> activeCalls() {
    throw UnimplementedError('activeCalls() has not been implemented.');
  }

  /// Get device push token VoIP.
  /// On iOS: return deviceToken for VoIP.
  /// On Android: return Empty
  Future<String> getDevicePushTokenVoIP() {
    throw UnimplementedError(
      'getDevicePushTokenVoIP() has not been implemented.',
    );
  }

  /// Silence CallKit events
  Future silenceEvents() {
    throw UnimplementedError('silenceEvents() has not been implemented.');
  }

  /// Unsilence CallKit events
  Future unsilenceEvents() {
    throw UnimplementedError('unsilenceEvents() has not been implemented.');
  }

  /// Request permission show notification for Android(13)
  /// Only Android: show request permission post notification for Android 13+
  Future requestNotificationPermission(dynamic data) {
    throw UnimplementedError(
      'requestNotificationPermission() has not been implemented.',
    );
  }

  /// Check can use full screen intent for Android(14)+
  /// Only Android: canUseFullScreenIntent permission for ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT
  Future canUseFullScreenIntent() {
    throw UnimplementedError(
      'canUseFullScreenIntent() has not been implemented.',
    );
  }
}
