/// Method channel implementation for Stream Video noise cancellation.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:stream_video/stream_video.dart';

import 'stream_video_noise_cancellation_platform_interface.dart';

/// An implementation of [StreamVideoNoiseCancellationPlatform] that uses method channels.
class MethodChannelStreamVideoNoiseCancellation
    extends StreamVideoNoiseCancellationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('stream_video_noise_cancellation');

  /// Registers the noise cancellation processor with the native platform.
  @override
  Future<void> registerProcessor() async {
    if (!CurrentPlatform.isAndroid && !CurrentPlatform.isIos) {
      throw UnimplementedError(
        'The current platform (${CurrentPlatform.name}) does not support audio processing.',
      );
    }

    await methodChannel.invokeMethod<void>('registerProcessor');
  }

  /// Returns whether noise cancellation is currently enabled.
  @override
  Future<bool?> isEnabled() async {
    if (!CurrentPlatform.isAndroid && !CurrentPlatform.isIos) {
      throw UnimplementedError(
        'The current platform (${CurrentPlatform.name}) does not support audio processing.',
      );
    }

    return methodChannel.invokeMethod<bool>('isEnabled');
  }

  /// Enables or disables noise cancellation.
  @override
  Future<void> setEnabled(bool enabled) {
    if (!CurrentPlatform.isAndroid && !CurrentPlatform.isIos) {
      throw UnimplementedError(
        'The current platform (${CurrentPlatform.name}) does not support audio processing.',
      );
    }

    return methodChannel.invokeMethod<void>('setEnabled', {'enabled': enabled});
  }

  /// Checks if the device supports advanced audio processing.
  @override
  Future<bool?> deviceSupportsAdvancedAudioProcessing() {
    if (!CurrentPlatform.isAndroid && !CurrentPlatform.isIos) {
      throw UnimplementedError(
        'The current platform (${CurrentPlatform.name}) does not support audio processing.',
      );
    }

    return methodChannel.invokeMethod<bool>(
      'deviceSupportsAdvancedAudioProcessing',
    );
  }
}
