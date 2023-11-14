import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'stream_video_push_notification_platform_interface.dart';

/// An implementation of [StreamVideoPushNotificationPlatform] that uses method channels.
class MethodChannelStreamVideoPushNotification
    extends StreamVideoPushNotificationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('stream_video_push_notifications');

  @override
  Future<void> initData(Map<String, dynamic> data) async {
    await methodChannel.invokeMethod<String>('initData', data);
  }
}
