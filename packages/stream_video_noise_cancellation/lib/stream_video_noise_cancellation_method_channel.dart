import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'stream_video_noise_cancellation_platform_interface.dart';

/// An implementation of [StreamVideoNoiseCancellationPlatform] that uses method channels.
class MethodChannelStreamVideoNoiseCancellation
    extends StreamVideoNoiseCancellationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('stream_video_noise_cancellation');

  @override
  Future<void> registerProcessor() async {
    await methodChannel.invokeMethod<void>('registerProcessor');
  }

  @override
  Future<bool?> isEnabled() {
    return methodChannel.invokeMethod<bool>('isEnabled');
  }

  @override
  Future<void> setEnabled(bool enabled) {
    return methodChannel.invokeMethod<void>('setEnabled', {'enabled': enabled});
  }

  @override
  Future<bool?> deviceSupportsAdvancedAudioProcessing() {
    return methodChannel
        .invokeMethod<bool>('deviceSupportsAdvancedAudioProcessing');
  }
}
