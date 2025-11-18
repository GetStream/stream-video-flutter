/// Stream Video video filters utilities.
library;

import 'stream_video_filters_platform_interface.dart';

class StreamVideoFilters {
  Future<bool?> isBackgroundEffectSupported() {
    return StreamVideoFiltersPlatform.instance.isBackgroundEffectSupported();
  }

  Future<void> registerBlurEffectProcessors() {
    return StreamVideoFiltersPlatform.instance.registerBlurEffectProcessors();
  }

  Future<void> registerImageEffectProcessors({
    required String backgroundImageUrl,
  }) {
    return StreamVideoFiltersPlatform.instance.registerImageEffectProcessors(
      backgroundImageUrl: backgroundImageUrl,
    );
  }
}
