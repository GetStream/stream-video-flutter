import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:stream_video_flutter_background/model/notification_payload.dart';

import 'stream_video_flutter_platform_interface.dart';

/// An implementation of [StreamVideoFlutterPlatform] that uses method channels.
class MethodChannelStreamVideoFlutter extends StreamVideoFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('stream_video_flutter');

  
  Future<void> methodHandler(MethodCall call) async {
    switch (call.method) {
      case "onNotificationContentClick":
        final callCid = call.arguments;
        onContentClick?.call(callCid);
        break;
      case "onNotificationButtonClick":
        final buttonType = call.arguments[0];
        final callCid = call.arguments[1];
        onButtonClick?.call(buttonType, callCid);
        break;
      case "onPlatformUiLayerDestroyed":
        final callCid = call.arguments;
        onUiLayerDestroyed?.call(callCid);
        break;
    }
  }

  @override
  Future<bool> startService(NotificationPayload payload) async {
    if (await isServiceRunning == false) {
      return await methodChannel.invokeMethod('startService', payload.toJson());
    }
    return false;
  }

  @override
  Future<bool> updateService(NotificationPayload payload) async {
    if (await isServiceRunning == true) {
      return await methodChannel.invokeMethod(
        'updateService',
        payload.toJson(),
      );
    }
    return false;
  }

  @override
  Future<bool> stopService() async {
    if (await isServiceRunning == true) {
      return await methodChannel.invokeMethod('stopService');
    }
    return false;
  }

  @override
  Future<bool> get isServiceRunning async {
    return await methodChannel.invokeMethod('isServiceRunning');
  }
}
