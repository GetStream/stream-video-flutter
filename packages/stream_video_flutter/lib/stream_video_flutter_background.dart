import 'dart:io';

import 'package:flutter/foundation.dart';

import '../src/call_background/model/notification_payload.dart';
import 'stream_video_flutter_platform_interface.dart';

typedef OnNotificationContentClick = void Function(String callCid);

typedef OnNotificationButtonClick = void Function(
    String buttonType, String callCid);

typedef OnPlatformUiLayerDestroyed = void Function(String callCid);

mixin StreamVideoFlutterBackground {
  static Future<bool> startService(NotificationPayload options) async {
    if (!isAndroid) {
      return false;
    }
    return StreamVideoFlutterPlatform.instance.startBackgroundService(options);
  }

  static Future<bool> updateService(NotificationPayload options) async {
    if (!isAndroid) {
      return false;
    }
    return StreamVideoFlutterPlatform.instance.updateBackgroundService(options);
  }

  static Future<bool> stopService() async {
    if (!isAndroid) {
      return false;
    }
    return StreamVideoFlutterPlatform.instance.stopBackgroundService();
  }

  static Future<bool> get isServiceRunning async {
    if (!isAndroid) {
      return false;
    }
    return StreamVideoFlutterPlatform.instance.isBackgroundServiceRunning;
  }

  static void setOnNotificationContentClick(
    OnNotificationContentClick? onContentClick,
  ) {
    if (!isAndroid) {
      return;
    }
    StreamVideoFlutterPlatform.instance.onBackgroundNotificationContentClick =
        onContentClick;
  }

  static void setOnNotificationButtonClick(
    OnNotificationButtonClick? onButtonClick,
  ) {
    if (!isAndroid) {
      return;
    }
    StreamVideoFlutterPlatform.instance.onBackgroundNotificationButtonClick =
        onButtonClick;
  }

  static void setOnPlatformUiLayerDestroyed(
    OnPlatformUiLayerDestroyed? onUiLayerDestroyed,
  ) {
    if (!isAndroid) {
      return;
    }
    StreamVideoFlutterPlatform
        .instance.onBackgroundNotificationUiLayerDestroyed = onUiLayerDestroyed;
  }

  static bool get isAndroid {
    if (kIsWeb) {
      return false;
    }
    return Platform.isAndroid;
  }
}
