import 'package:stream_video_flutter_background/model/notification_options.dart';

import 'stream_video_flutter_background_platform_interface.dart';

class StreamVideoFlutterBackground {
  static Future<String?> getPlatformVersion() {
    return StreamVideoFlutterBackgroundPlatform.instance.getPlatformVersion();
  }

  static Future<bool> startService(NotificationOptions options) {
    return StreamVideoFlutterBackgroundPlatform.instance.startService(options);
  }

  static Future<bool> stopService() {
    return StreamVideoFlutterBackgroundPlatform.instance.stopService();
  }

  static void setOnButtonClick(
    Function(String buttonType, String callCid)? onButtonClick,
  ) {
    StreamVideoFlutterBackgroundPlatform.instance.onButtonClick = onButtonClick;
  }
}
