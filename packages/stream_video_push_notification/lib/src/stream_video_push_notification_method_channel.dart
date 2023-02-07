import 'package:flutter/services.dart';

class StreamVideoPushNotificationMethodChannel {
  const StreamVideoPushNotificationMethodChannel({
    MethodChannel methodChannel =
        const MethodChannel('stream_video_push_notification'),
  }) : _methodChannel = methodChannel;

  /// The method channel used to interact with the native platform.
  final MethodChannel _methodChannel;

  /// Obtain the Device Push Token VoIp.
  @override
  Future<String?> getDevicePushTokenVoIP() async {
    return await _methodChannel.invokeMethod<String>('getDevicePushTokenVoIP');
  }
}
