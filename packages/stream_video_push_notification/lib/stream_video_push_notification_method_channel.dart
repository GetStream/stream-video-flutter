import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'stream_video_push_notification_platform_interface.dart';

/// An implementation of [StreamVideoPushNotificationPlatform] that uses method channels.
class MethodChannelStreamVideoPushNotification
    extends StreamVideoPushNotificationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('stream_video_push_notifications');

  CallerCustomizationFunction? callerCustomizationCallback;

  MethodChannelStreamVideoPushNotification() {
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == "customizeCaller") {
        final name = call.arguments["created_by_display_name"];
        final handle = call.arguments["created_by_id"];
        final callId = call.arguments["call_cid"];

        final result = callerCustomizationCallback?.call(
          callCid: callId,
          callerName: name,
          callerHandle: handle,
        );

        if (result != null) {
          return result.toJson();
        }

        return null;
      }
    });
  }

  @override
  Future<void> init(
    Map<String, dynamic> pushParams,
    CallerCustomizationFunction? callerCustomizationCallback,
    Function? callback,
  ) async {
    this.callerCustomizationCallback = callerCustomizationCallback;
    if (callback != null) {
      final backgroundCallback = PluginUtilities.getCallbackHandle(callback);
      pushParams['callbackHandler'] = backgroundCallback?.toRawHandle();
    }
    await methodChannel.invokeMethod<String>('initData', pushParams);
  }
}
