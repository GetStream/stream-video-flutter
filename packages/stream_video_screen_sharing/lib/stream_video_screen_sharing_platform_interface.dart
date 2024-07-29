import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'stream_video_screen_sharing_method_channel.dart';

abstract class StreamVideoScreenSharingPlatform extends PlatformInterface {
  /// Constructs a StreamVideoScreenSharingPlatform.
  StreamVideoScreenSharingPlatform() : super(token: _token);

  static final Object _token = Object();

  static StreamVideoScreenSharingPlatform _instance =
      MethodChannelStreamVideoScreenSharing();

  /// The default instance of [StreamVideoScreenSharingPlatform] to use.
  ///
  /// Defaults to [MethodChannelStreamVideoScreenSharing].
  static StreamVideoScreenSharingPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [StreamVideoScreenSharingPlatform] when
  /// they register themselves.
  static set instance(StreamVideoScreenSharingPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}
