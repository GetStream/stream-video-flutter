
import 'stream_video_screen_sharing_platform_interface.dart';

class StreamVideoScreenSharing {
  Future<String?> getPlatformVersion() {
    return StreamVideoScreenSharingPlatform.instance.getPlatformVersion();
  }
}
