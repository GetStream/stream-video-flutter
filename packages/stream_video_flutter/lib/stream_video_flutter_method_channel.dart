import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../src/call_background/model/notification_payload.dart';
import 'stream_video_flutter_platform_interface.dart';

/// An implementation of [StreamVideoFlutterPlatform] that uses method channels.
class MethodChannelStreamVideoFlutter extends StreamVideoFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('stream_video_flutter');

  Future<void> methodHandler(MethodCall call) async {
    switch (call.method) {
      case 'onBackgroundNotificationContentClick':
        final callCid = call.arguments;
        onBackgroundNotificationContentClick?.call(callCid);
        break;
      case 'onBackgroundNotificationButtonClick':
        final buttonType = call.arguments[0];
        final callCid = call.arguments[1];
        onBackgroundNotificationButtonClick?.call(buttonType, callCid);
        break;
      case 'onPlatformUiLayerDestroyed':
        final callCid = call.arguments;
        onBackgroundNotificationUiLayerDestroyed?.call(callCid);
        break;
    }
  }

  @override
  Future<bool> startBackgroundService(NotificationPayload payload) async {
    if (await isBackgroundServiceRunning == false) {
      return await methodChannel.invokeMethod(
          'startBackgroundService', payload.toJson());
    }
    return false;
  }

  @override
  Future<bool> updateBackgroundService(NotificationPayload payload) async {
    if (await isBackgroundServiceRunning == true) {
      return await methodChannel.invokeMethod(
        'updateBackgroundService',
        payload.toJson(),
      );
    }
    return false;
  }

  @override
  Future<bool> stopBackgroundService() async {
    if (await isBackgroundServiceRunning == true) {
      return await methodChannel.invokeMethod('stopBackgroundService');
    }
    return false;
  }

  @override
  Future<bool> get isBackgroundServiceRunning async {
    return await methodChannel.invokeMethod('isBackgroundServiceRunning');
  }
}
