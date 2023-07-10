import 'dart:io';

import 'package:flutter/foundation.dart';

import 'model/notification_payload.dart';
import 'stream_video_flutter_background_platform_interface.dart';

typedef OnNotificationContentClick = Function(String callCid);

typedef OnNotificationButtonClick = Function(String buttonType, String callCid);

typedef OnPlatformUiLayerDestroyed = Function(String callCid);

class StreamVideoFlutterBackground {
  static Future<bool> startService(NotificationPayload options) async {
    if (!isAndroid) {
      return false;
    }
    return StreamVideoFlutterBackgroundPlatform.instance.startService(options);
  }

  static Future<bool> updateService(NotificationPayload options) async {
    if (!isAndroid) {
      return false;
    }
    return StreamVideoFlutterBackgroundPlatform.instance.updateService(options);
  }

  static Future<bool> stopService() async {
    if (!isAndroid) {
      return false;
    }
    return StreamVideoFlutterBackgroundPlatform.instance.stopService();
  }

  static Future<bool> get isServiceRunning async {
    if (!isAndroid) {
      return false;
    }
    return StreamVideoFlutterBackgroundPlatform.instance.isServiceRunning;
  }

  static void setOnNotificationContentClick(
    OnNotificationContentClick? onContentClick,
  ) {
    if (!isAndroid) {
      return;
    }
    StreamVideoFlutterBackgroundPlatform.instance.onContentClick =
        onContentClick;
  }

  static void setOnNotificationButtonClick(
    OnNotificationButtonClick? onButtonClick,
  ) {
    if (!isAndroid) {
      return;
    }
    StreamVideoFlutterBackgroundPlatform.instance.onButtonClick = onButtonClick;
  }

  static void setOnPlatformUiLayerDestroyed(
    OnPlatformUiLayerDestroyed? onUiLayerDestroyed,
  ) {
    if (!isAndroid) {
      return;
    }
    StreamVideoFlutterBackgroundPlatform.instance.onUiLayerDestroyed =
        onUiLayerDestroyed;
  }

  static bool get isAndroid {
    if (kIsWeb) {
      return false;
    }
    return Platform.isAndroid;
  }
}
