import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

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
  Function(String)? onButtonClick;

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  Future<void> methodHandler(MethodCall call) async {
    print('[methodHandler] method: ${call.method}, args: ${call.arguments}');
    switch (call.method) {
      case "onButtonClick": // this method name needs to be the same from invokeMethod in Android
        onButtonClick?.call(call.arguments as String);
        break;
      default:
        print('no method handler for method ${call.method}');
    }
  }

  @override
  Future<bool> startService() async {
    if (await isRunningService == false) {
      /*if (callback != null) {
        options.addAll(foregroundTaskOptions.toJson());
        options['callbackHandle'] =
            PluginUtilities.getCallbackHandle(callback)?.toRawHandle();
      }*/
      return await methodChannel.invokeMethod('startService');
    }
    return false;
  }

  @override
  Future<bool> stopService() async {
    return await methodChannel.invokeMethod('stopService');
  }

  @override
  Future<bool> get isRunningService async {
    return await methodChannel.invokeMethod('isRunningService');
  }
}
