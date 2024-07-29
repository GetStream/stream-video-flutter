import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'stream_video_screen_sharing_platform_interface.dart';

/// An implementation of [StreamVideoScreenSharingPlatform] that uses method channels.
class MethodChannelStreamVideoScreenSharing
    extends StreamVideoScreenSharingPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('stream_video_screen_sharing');
}
