import 'stream_video_flutter_background_platform_interface.dart';

class StreamVideoFlutterBackground {
  Future<String?> getPlatformVersion() {
    return StreamVideoFlutterBackgroundPlatform.instance.getPlatformVersion();
  }

  void setOnButtonClick(Function(String) onButtonClick) {
    StreamVideoFlutterBackgroundPlatform.instance.onButtonClick = onButtonClick;
  }
}
