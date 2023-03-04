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
  final methodChannel = const MethodChannel('stream_video_flutter_background');

  @override
  Function(String buttonType, String callCid)? onButtonClick;

  Future<void> methodHandler(MethodCall call) async {
    print('[methodHandler] method: ${call.method}, args: ${call.arguments}');
    switch (call.method) {
      case "onButtonClick":
        final buttonType = call.arguments[0];
        final callCid = call.arguments[1];
        print('[methodHandler] buttonType: $buttonType, callCid: $callCid');
        onButtonClick?.call(buttonType, callCid);
        break;
      default:
        print('no method handler for method ${call.method}');
    }
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
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
