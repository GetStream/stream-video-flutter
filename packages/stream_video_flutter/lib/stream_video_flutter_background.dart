import 'dart:io';

import 'package:flutter/foundation.dart';

import '../src/call_background/model/notification_payload.dart';
import 'src/call_background/model/service_type.dart';
import 'stream_video_flutter_platform_interface.dart';

typedef OnNotificationContentClick = void Function(String callCid);

typedef OnNotificationButtonClick = void Function(
  String buttonType,
  String callCid,
  ServiceType serviceType,
);

typedef OnPlatformUiLayerDestroyed = void Function(String callCid);

mixin StreamVideoFlutterBackground {
  static Future<bool> startService(
    NotificationPayload options,
    ServiceType type,
  ) async {
    if (!isAndroid) {
      return false;
    }
    return StreamVideoFlutterPlatform.instance.startBackgroundService(
      payload: options,
      type: type,
    );
  }

  static Future<bool> updateService(
    NotificationPayload options,
    ServiceType type,
  ) async {
    if (!isAndroid) {
      return false;
    }
    return StreamVideoFlutterPlatform.instance.updateBackgroundService(
      payload: options,
      type: type,
    );
  }

  static Future<bool> stopService(ServiceType type) async {
    if (!isAndroid) {
      return false;
    }
    return StreamVideoFlutterPlatform.instance.stopBackgroundService(type);
  }

  static Future<bool> isServiceRunning(ServiceType type) async {
    if (!isAndroid) {
      return false;
    }
    return StreamVideoFlutterPlatform.instance.isBackgroundServiceRunning(type);
  }

  static Future<void> togglePictureInPicture({required bool enable}) async {
    if (!isAndroid) {
      return;
    }

    return StreamVideoFlutterPlatform.instance
        .togglePictureInPicture(enable: enable);
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
