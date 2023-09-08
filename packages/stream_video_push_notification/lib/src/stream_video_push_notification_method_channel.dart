import 'package:flutter/services.dart';

class StreamVideoPushNotificationMethodChannel {
  const StreamVideoPushNotificationMethodChannel({
    MethodChannel methodChannel =
        const MethodChannel('stream_video_push_notification'),
  }) : _methodChannel = methodChannel;

  /// The method channel used to interact with the native platform.
  final MethodChannel _methodChannel;

  // TODO: Verify if this is needed anymore?
  // We already have FlutterCallkitIncoming.getDevicePushTokenVoIP();
  /// Obtain the Device Push Token VoIp.
  Future<String?> getDevicePushTokenVoIP() async {
    return await _methodChannel.invokeMethod<String>('getDevicePushTokenVoIP');
  }
}
