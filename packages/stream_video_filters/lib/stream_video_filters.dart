/// Stream Video video filters: background blur, virtual backgrounds and
/// custom effects, as `VideoFilter` values for `Call.setVideoFilter`.
library;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

import 'src/video_effect_registry.dart';
import 'src/video_filters.dart';
import 'src/web/browser_filters.dart';
import 'src/web/web_video_filters_options.dart';
import 'stream_video_filters_platform_interface.dart';

export 'src/native_video_filter.dart';
export 'src/video_filters.dart';
export 'src/web/web_video_filters_options.dart';

/// Whether the device runs the filters, the registration of their native
/// processors, and where the web filters load from.
abstract final class StreamVideoFilters {
  /// Where the filters load their browser implementation from, and on which
  /// browsers they run. Read when a filter is applied on web.
  static WebVideoFiltersOptions webOptions = const WebVideoFiltersOptions();

  /// Whether this device can run the filters of this package.
  ///
  /// On web, whether the browser can run [BackgroundBlurFilter],
  /// [VirtualBackgroundFilter] and [FullFrameBlurFilter]; a
  /// [CustomVideoFilter] runs on Android and iOS only. Loads the browser
  /// implementation, and is false when it cannot be loaded.
  static Future<bool> isSupported() async {
    if (kIsWeb) return isBrowserEffectSupported(webOptions);
    if (!rtc.webRtcCapabilities.supportsVideoEffects) return false;
    try {
      return await isBackgroundEffectSupported() ?? false;
    } on MissingPluginException {
      return false;
    }
  }

  static Future<bool?> isBackgroundEffectSupported() {
    return StreamVideoFiltersPlatform.instance.isBackgroundEffectSupported();
  }

  static Future<void> registerBlurEffectProcessors() {
    return StreamVideoFiltersPlatform.instance.registerBlurEffectProcessors();
  }

  static Future<void> registerImageEffectProcessors({
    required String backgroundImageUrl,
  }) {
    return StreamVideoFiltersPlatform.instance.registerImageEffectProcessors(
      backgroundImageUrl: backgroundImageUrl,
    );
  }

  static Future<void> registerFullFrameBlurEffectProcessor() {
    return StreamVideoFiltersPlatform.instance
        .registerFullFrameBlurEffectProcessor();
  }

  /// Removes every effect processor this plugin registered natively so they
  /// can be deallocated. A filter registers its processor again the next time
  /// it is applied.
  ///
  /// Call it once no call uses the filters any more: a processor still
  /// attached to a track stays alive until that track is released. Where
  /// video effects are not supported, nothing is unregistered natively.
  static Future<void> unregisterAllFilters() {
    return VideoEffectRegistry.run(() async {
      VideoEffectRegistry.forgetRegistrations();
      if (!rtc.webRtcCapabilities.supportsVideoEffects) return;
      await StreamVideoFiltersPlatform.instance.unregisterAllFilters();
    });
  }
}
