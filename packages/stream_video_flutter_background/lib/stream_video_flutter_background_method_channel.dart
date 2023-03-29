import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'model/notification_options.dart';
import 'stream_video_flutter_background_platform_interface.dart';

/// An implementation of [StreamVideoFlutterBackgroundPlatform] that uses method channels.
class MethodChannelStreamVideoFlutterBackground
    extends StreamVideoFlutterBackgroundPlatform {
  MethodChannelStreamVideoFlutterBackground() {
    methodChannel.setMethodCallHandler(methodHandler);
  }

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  late final methodChannel =
      const MethodChannel('stream_video_flutter_background');

  @override
  Function(String callCid)? onContentClick;

  @override
  Function(String buttonType, String callCid)? onButtonClick;

  @override
  Function(String callCid)? onUiLayerDestroyed;

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
  Future<bool> startService(NotificationOptions options) async {
    if (await isServiceRunning == false) {
      return await methodChannel.invokeMethod('startService', options.toJson());
    }
    return false;
  }

  @override
  Future<bool> updateService(NotificationOptions options) async {
    if (await isServiceRunning == true) {
      return await methodChannel.invokeMethod(
        'updateService',
        options.toJson(),
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
