import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'stream_video_filters_platform_interface.dart';

/// An implementation of [StreamVideoFiltersPlatform] that uses method channels.
class MethodChannelStreamVideoFilters extends StreamVideoFiltersPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('stream_video_filters');

  @override
  Future<bool?> isBackgroundEffectSupported() async {
    return methodChannel.invokeMethod<bool>(
      'isBackgroundEffectSupported',
    );
  }

  @override
  Future<void> registerBlurEffectProcessors() {
    return methodChannel.invokeMethod(
      'registerBlurEffectProcessors',
    );
  }

  @override
  Future<void> registerImageEffectProcessors({
    required String backgroundImageUrl,
  }) {
    return methodChannel.invokeMethod('registerImageEffectProcessors', {
      'backgroundImageUrl': backgroundImageUrl,
    });
  }
}
