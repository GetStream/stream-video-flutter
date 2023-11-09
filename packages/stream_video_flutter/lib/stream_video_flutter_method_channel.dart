import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'stream_video_flutter_platform_interface.dart';

/// An implementation of [StreamVideoFlutterPlatform] that uses method channels.
class MethodChannelStreamVideoFlutter extends StreamVideoFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('stream_video_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
