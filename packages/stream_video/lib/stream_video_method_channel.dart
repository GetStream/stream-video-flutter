import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'stream_video_platform_interface.dart';

/// An implementation of [StreamVideoPlatform] that uses method channels.
class MethodChannelStreamVideo extends StreamVideoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('stream_video');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> getDevicePushTokenVoIP() async {
    return await methodChannel.invokeMethod<String>('getDevicePushTokenVoIP');
  }
}
