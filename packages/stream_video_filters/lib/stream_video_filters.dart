/// Stream Video video filters: background blur, virtual backgrounds and
/// custom effects, as `VideoFilter` values for `Call.setVideoFilter`.
library;

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import 'stream_video_filters_platform_interface.dart';

export 'src/native_video_filter.dart';
export 'src/video_filters.dart';

class StreamVideoFilters {
  /// Bumped by [unregisterAllFilters], so a filter registers its processor
  /// again the next time it is applied.
  @internal
  static int registryGeneration = 0;

  /// Whether this device can run the filters of this package.
  Future<bool> isSupported() async {
    if (!rtc.webRtcCapabilities.supportsVideoEffects) return false;
    try {
      return await isBackgroundEffectSupported() ?? false;
    } on MissingPluginException {
      return false;
    }
  }

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

  Future<void> registerFullFrameBlurEffectProcessor() {
    return StreamVideoFiltersPlatform.instance
        .registerFullFrameBlurEffectProcessor();
  }

  /// Removes every effect processor this plugin registered natively so they
  /// can be deallocated. A filter registers its processor again the next time
  /// it is applied.
  ///
  /// Call it once no call uses the filters any more: a processor still
  /// attached to a track stays alive until that track is released.
  Future<void> unregisterAllFilters() {
    registryGeneration++;
    return StreamVideoFiltersPlatform.instance.unregisterAllFilters();
  }
}
