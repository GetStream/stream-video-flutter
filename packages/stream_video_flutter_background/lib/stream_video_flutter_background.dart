import 'package:stream_video_flutter_background/model/notification_options.dart';

import 'stream_video_flutter_background_platform_interface.dart';

typedef OnNotificationButtonClick = Function(String buttonType, String callCid);

class StreamVideoFlutterBackground {
  static Future<String?> getPlatformVersion() {
    return StreamVideoFlutterBackgroundPlatform.instance.getPlatformVersion();
  }

  static Future<bool> startService(NotificationOptions options) {
    return StreamVideoFlutterBackgroundPlatform.instance.startService(options);
  }

  static Future<bool> updateService(NotificationOptions options) {
    return StreamVideoFlutterBackgroundPlatform.instance.updateService(options);
  }

  static Future<bool> stopService() {
    return StreamVideoFlutterBackgroundPlatform.instance.stopService();
  }

  static void setOnButtonClick(
    OnNotificationButtonClick? onButtonClick,
  ) {
    StreamVideoFlutterBackgroundPlatform.instance.onButtonClick = onButtonClick;
  }
}
